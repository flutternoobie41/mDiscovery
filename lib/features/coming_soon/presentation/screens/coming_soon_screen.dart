import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_style.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/custom_shimmer_loader.dart';
import '../../../../core/widgets/error_retry_widget.dart';
import '../../../dashboard/domain/entities/movie_entity.dart';
import '../bloc/coming_soon_bloc.dart';
import '../bloc/coming_soon_event.dart';
import '../bloc/coming_soon_state.dart';
import '../../../main_navigation/presentation/cubit/navigation_cubit.dart';

class ComingSoonScreen extends StatefulWidget {
  final Function(MovieEntity) onMovieSelected;

  const ComingSoonScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  final Set<int> _remindedMovieIds = {};
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ComingSoonBloc>().add(const LoadMoreUpcomingMoviesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listener: (context, state) {
        if (state == 2) {
          context.read<ComingSoonBloc>().add(const FetchUpcomingMoviesEvent());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black, // Ensures the status bar area is solid black
        body: SafeArea(
          top: true,
          bottom: false,
          child: Container(
            color: AppColors.background, // Applies dark theme background to content area
            child: BlocBuilder<ComingSoonBloc, ComingSoonState>(
              builder: (context, state) {
                if (state is ComingSoonLoadingState || state is ComingSoonInitialState) {
                  return _buildLoadingList();
                } else if (state is ComingSoonErrorState) {
                  return ErrorRetryWidget(
                    errorMessage: state.message,
                    onRetry: () {
                      context.read<ComingSoonBloc>().add(const FetchUpcomingMoviesEvent());
                    },
                  );
                } else if (state is ComingSoonLoadedState) {
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      context.read<ComingSoonBloc>().add(const FetchUpcomingMoviesEvent());
                    },
                    child: _buildMovieContent(state),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieContent(ComingSoonLoadedState state) {
    if (state.movies.isEmpty) {
      return const Center(
        child: Text(
          'No upcoming movies found.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final notificationMovies = state.movies.take(2).toList();
    final listMovies = state.movies.skip(2).toList();

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: 1 + listMovies.length + (state.isLoadMoreActive ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header section containing Notifications text and notification cards
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/circle_notification_icon.svg',
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Notifications',
                      style: AppTypography.heading2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Stacked Notification Cards (No gap between them)
              if (notificationMovies.isNotEmpty)
                Column(
                  children: notificationMovies
                      .map((movie) => NotificationCard(
                            movie: movie,
                            onTap: () => widget.onMovieSelected(movie),
                          ))
                      .toList(),
                ),
              SizedBox(height: 16.h),
            ],
          );
        }

        if (index == 1 + listMovies.length) {
          // Pagination loader
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Main Coming Soon list movies
        final movie = listMovies[index - 1];
        final isReminded = _remindedMovieIds.contains(movie.id);

        return ComingSoonMovieCard(
          movie: movie,
          isReminded: isReminded,
          onRemindToggle: () {
            setState(() {
              if (isReminded) {
                _remindedMovieIds.remove(movie.id);
              } else {
                _remindedMovieIds.add(movie.id);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(
                  isReminded
                      ? 'Reminder removed for "${movie.title}"'
                      : 'Reminder set for "${movie.title}"!',
                ),
              ),
            );
          },
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text('Sharing "${movie.title}"...'),
              ),
            );
          },
          onTap: () => widget.onMovieSelected(movie),
        );
      },
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: CustomShimmerLoader(
          width: double.infinity,
          height: 280.h,
          borderRadius: 20.r,
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatShortDate(movie.releaseDate);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppColors.searchBarBg, // Same background as Search bar color
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            // Thumbnail image with Netflix logo overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: CustomCachedImage(
                    imageUrl: movie.backdropPath,
                    width: 114.w,
                    height: 64.h,
                  ),
                ),
                Positioned(
                  top: 4.h,
                  left: 4.w,
                  child: SvgPicture.asset(
                    'assets/svgs/logos_netflix.svg',
                    height: 12.h,
                    width: 7.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            // Movie details column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'New Arrival',
                    style: AppStyle.tss14W700.copyWith(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    movie.title,
                    style: AppStyle.tss15W400.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    formattedDate,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white54,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatShortDate(String dateStr) {
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed == null) return dateStr;
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[parsed.month - 1]} ${parsed.day}';
    } catch (_) {
      return dateStr;
    }
  }
}

class ComingSoonMovieCard extends StatelessWidget {
  final MovieEntity movie;
  final bool isReminded;
  final VoidCallback onRemindToggle;
  final VoidCallback onShare;
  final VoidCallback onTap;

  const ComingSoonMovieCard({
    super.key,
    required this.movie,
    required this.isReminded,
    required this.onRemindToggle,
    required this.onShare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatLongDate(movie.releaseDate);
    final genresText = movie.genres.isNotEmpty
        ? movie.genres.join('  •  ')
        : 'Drama  •  Action  •  Thriller'; // Fallback standard genres

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie backdrop image
          GestureDetector(
            onTap: onTap,
            child: CustomCachedImage(
              imageUrl: movie.backdropPath,
              width: double.infinity,
              height: 190.h,
              borderRadius: 0, // Edge-to-edge full width
            ),
          ),
          // Action Buttons row (Remind Me, Share)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionButton(
                  iconPath: 'assets/svgs/notification_icon.svg',
                  label: 'Remind Me',
                  iconColor: Colors.white,
                  onTap: onRemindToggle,
                ),
                SizedBox(width: 32.w),
                _ActionButton(
                  iconPath: 'assets/svgs/share_icon.svg',
                  label: 'Share',
                  iconColor: Colors.white,
                  onTap: onShare,
                ),
              ],
            ),
          ),
          // Movie details column
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: AppStyle.tss14W400.copyWith(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  movie.title,
                  style: AppTypography.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  movie.overview,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.grey[400],
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                // Genres list
                Text(
                  genresText,
                  style: AppStyle.tss14W700.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11.5.sp,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLongDate(String dateStr) {
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed == null) return dateStr;
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return 'Coming ${months[parsed.month - 1]} ${parsed.day}';
    } catch (_) {
      return 'Coming $dateStr';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.iconPath,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 22.w,
            height: 22.h,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: AppStyle.tss14W400.copyWith(
              color: Colors.white70,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
