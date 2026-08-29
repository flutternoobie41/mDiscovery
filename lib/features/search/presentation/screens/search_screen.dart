import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mdiscover/core/constants/app_colors.dart';
import 'package:mdiscover/core/constants/app_style.dart';
import 'package:mdiscover/core/widgets/custom_shimmer_loader.dart';
import 'package:mdiscover/core/widgets/error_retry_widget.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_movie_list_item.dart';
import '../../../main_navigation/presentation/cubit/navigation_cubit.dart';

class SearchScreen extends StatefulWidget {
  final Function(MovieEntity) onMovieSelected;

  const SearchScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchTextChanged);
    context.read<SearchBloc>().add(const LoadTrendingMoviesEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {}); // Rebuilds to show/hide the clear and mic icons
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchBloc>().add(const LoadMoreSearchMoviesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listener: (context, state) {
        if (state == 1) {
          context.read<SearchBloc>().add(const LoadTrendingMoviesEvent());
        } else {
          _searchController.clear();
          context.read<SearchBloc>().add(const ClearSearchEvent());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // Full-screen width search bar with no horizontal padding
            SafeArea(
              bottom: false,
              child: Container(
                color: AppColors.searchBarBg,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<SearchBloc>().add(SearchQueryChangedEvent(query));
                  },
                  style: AppStyle.tss15W400.copyWith(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search for a show, movie, genre, e.t.c.',
                    hintStyle: AppStyle.tss15W400.copyWith(color: AppColors.inactiveBottomIconColor),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 12.w),
                      child: SvgPicture.asset(
                        'assets/svgs/search_bar_search_icon.svg',
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 20.h,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                              context.read<SearchBloc>().add(const ClearSearchEvent());
                            },
                          )
                        : Padding(
                            padding: EdgeInsets.only(right: 16.w, left: 12.w),
                            child: SvgPicture.asset(
                              'assets/svgs/mic_icon.svg',
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 20.h,
                    ),
                    filled: true,
                    fillColor: AppColors.searchBarBg,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitialState) {
                    return _buildTopSearches(state);
                  } else if (state is SearchLoadingState) {
                    return _buildLoadingList();
                  } else if (state is SearchEmptyState) {
                    return _buildEmptyResults(state.query);
                  } else if (state is SearchErrorState) {
                    return ErrorRetryWidget(
                      errorMessage: state.message,
                      onRetry: () {
                        context.read<SearchBloc>().add(SearchQueryChangedEvent(_searchController.text));
                      },
                    );
                  } else if (state is SearchLoadedState) {
                    return _buildSearchResults(state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSearches(SearchInitialState state) {
    if (state.isLoading) {
      return _buildLoadingList();
    }

    if (state.error != null) {
      return ErrorRetryWidget(
        errorMessage: state.error!,
        onRetry: () {
          context.read<SearchBloc>().add(const LoadTrendingMoviesEvent());
        },
      );
    }

    final trendingMovies = state.trendingMovies;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
            child: Text(
              'Top Searches',
              style: AppStyle.tss20W700.copyWith(color: Colors.white),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final movie = trendingMovies[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: SearchMovieListItem(
                  movie: movie,
                  onTap: () => widget.onMovieSelected(movie),
                ),
              );
            },
            childCount: trendingMovies.length,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(SearchLoadedState state) {
    final movies = state.movies;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final movie = movies[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: SearchMovieListItem(
                  movie: movie,
                  onTap: () => widget.onMovieSelected(movie),
                ),
              );
            },
            childCount: movies.length,
          ),
        ),
        if (state.isLoadMoreActive)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 3.h),
        child: Container(
          color: AppColors.searchBarBg,
          height: 76.h,
          child: Row(
            children: [
              CustomShimmerLoader(
                width: 140.w,
                height: 76.h,
                borderRadius: 0,
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmerLoader(width: 120.w, height: 14.h),
                    SizedBox(height: 6.h),
                    CustomShimmerLoader(width: 80.w, height: 14.h),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomShimmerLoader(
                  width: 28.w,
                  height: 28.h,
                  borderRadius: 14.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResults(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64.w, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text('No Movies Found', style: AppStyle.tss20W700.copyWith(color: Colors.white)),
          SizedBox(height: 8.h),
          Text(
            'We couldn\'t find any results for "$query"',
            style: AppStyle.tss15W400.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
