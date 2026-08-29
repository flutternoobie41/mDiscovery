import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/custom_shimmer_loader.dart';
import '../../../../core/widgets/error_retry_widget.dart';
import '../../../dashboard/domain/entities/movie_entity.dart';
import '../bloc/coming_soon_bloc.dart';
import '../bloc/coming_soon_event.dart';
import '../bloc/coming_soon_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Coming Soon', style: AppTypography.heading2),
      ),
      body: BlocBuilder<ComingSoonBloc, ComingSoonState>(
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
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  final isReminded = _remindedMovieIds.contains(movie.id);

                  return Container(
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CustomCachedImage(
                              imageUrl: movie.backdropPath,
                              width: double.infinity,
                              height: 190.h,
                              borderRadius: 20.r,
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.6),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12.h,
                              left: 12.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'Release: ${movie.releaseDate}',
                                  style: AppTypography.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 70.h),
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () => widget.onMovieSelected(movie),
                                  icon: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 48),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      movie.title,
                                      style: AppTypography.heading3,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        if (isReminded) {
                                          _remindedMovieIds.remove(movie.id);
                                        } else {
                                          _remindedMovieIds.add(movie.id);
                                        }
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isReminded
                                                ? 'Reminder removed for "${movie.title}"'
                                                : 'Reminder set for "${movie.title}"!',
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: isReminded ? AppColors.success : AppColors.primary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                    ),
                                    icon: Icon(
                                      isReminded ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                                      color: isReminded ? AppColors.success : AppColors.primary,
                                      size: 18.w,
                                    ),
                                    label: Text(
                                      isReminded ? 'Reminded' : 'Remind Me',
                                      style: AppTypography.button.copyWith(
                                        fontSize: 12.sp,
                                        color: isReminded ? AppColors.success : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                movie.overview,
                                style: AppTypography.bodyMedium,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
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
