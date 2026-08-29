import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mdiscover/core/constants/app_colors.dart';
import 'package:mdiscover/core/constants/app_typography.dart';
import 'package:mdiscover/core/constants/mock_data.dart';
import 'package:mdiscover/core/widgets/custom_cached_image.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';

class WatchlistScreen extends StatefulWidget {
  final Function(MovieEntity) onMovieSelected;

  const WatchlistScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<MovieEntity> _watchlist;
  late List<Map<String, dynamic>> _downloads;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _watchlist = List.from(MockData.sampleMovies.take(4));
    _downloads = [
      {'movie': MockData.sampleMovies[0], 'size': '1.8 GB', 'quality': '4K UHD'},
      {'movie': MockData.sampleMovies[1], 'size': '1.2 GB', 'quality': '1080p HD'},
      {'movie': MockData.sampleMovies[2], 'size': '950 MB', 'quality': '720p HD'},
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Watchlist & Downloads', style: AppTypography.heading2),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: AppTypography.titleLarge.copyWith(fontSize: 14.sp),
          tabs: const [
            Tab(text: 'My Watchlist'),
            Tab(text: 'Offline Downloads'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWatchlistTab(),
          _buildDownloadsTab(),
        ],
      ),
    );
  }

  Widget _buildWatchlistTab() {
    if (_watchlist.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 64.w, color: AppColors.textMuted),
            SizedBox(height: 16.h),
            Text('Your Watchlist is Empty', style: AppTypography.heading3),
            SizedBox(height: 8.h),
            Text('Save movies here to watch them later.', style: AppTypography.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: _watchlist.length,
      itemBuilder: (context, index) {
        final movie = _watchlist[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              CustomCachedImage(
                imageUrl: movie.posterPath,
                width: 70.w,
                height: 100.h,
                borderRadius: 12.r,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: AppTypography.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      movie.genres.join(' • '),
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: AppColors.starRating, size: 16.w),
                        SizedBox(width: 4.w),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: AppTypography.caption.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => widget.onMovieSelected(movie),
                icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 36),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _watchlist.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Removed "${movie.title}" from Watchlist')),
                  );
                },
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDownloadsTab() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Device Storage', style: AppTypography.titleLarge),
                  Text('3.95 GB Used', style: AppTypography.bodySmall.copyWith(color: AppColors.primary)),
                ],
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: 0.35,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6.h,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _downloads.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_for_offline_outlined, size: 64.w, color: AppColors.textMuted),
                      SizedBox(height: 16.h),
                      Text('No Offline Downloads', style: AppTypography.heading3),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: _downloads.length,
                  itemBuilder: (context, index) {
                    final item = _downloads[index];
                    final MovieEntity movie = item['movie'];

                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          CustomCachedImage(
                            imageUrl: movie.posterPath,
                            width: 65.w,
                            height: 90.h,
                            borderRadius: 12.r,
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.title, style: AppTypography.titleLarge, maxLines: 1),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: Text(item['quality'], style: AppTypography.caption),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(item['size'], style: AppTypography.bodySmall),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => widget.onMovieSelected(movie),
                            icon: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 32),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _downloads.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
