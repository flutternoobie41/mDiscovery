import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mdiscover/core/constants/app_style.dart';
import 'package:mdiscover/core/constants/mock_data.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import '../widgets/watchlist_movie_list_item.dart';

class WatchlistScreen extends StatelessWidget {
  final Function(MovieEntity) onMovieSelected;

  const WatchlistScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Only list mock data where images are available
    final movies = MockData.sampleMovies
        .where((movie) => movie.backdropPath.isNotEmpty && movie.posterPath.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Smart Downloads Header
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                child: Text(
                  'Smart Downloads',
                  style: AppStyle.tss14W400.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: 24.h),

              // Full-bleed static Movie List (similar to Search screen's list design)
              Column(
                children: movies.map((movie) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: WatchlistMovieListItem(
                      movie: movie,
                      onTap: () => onMovieSelected(movie),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
