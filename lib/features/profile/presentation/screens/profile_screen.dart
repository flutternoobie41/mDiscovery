import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // Profiles Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileItem('Emenalo', 'assets/images/rectangle1.jpg'),
                    _buildProfileItem('Onyeka', 'assets/images/rectangle2.jpg'),
                    _buildProfileItem('Thelma', 'assets/images/rectangle3.jpg'),
                    _buildProfileItem('Kids', 'assets/images/kids_rectangle.jpg'),
                    _buildAddProfileItem(),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              // Manage Profiles
              Center(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Manage Profiles tapped')),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/edit_pencil.svg',
                        width: 12.w,
                        height: 12.h,
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Manage Profiles',
                        style: AppStyle.tss12W400.copyWith(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              
              // Tell Friends about Netflix section
              Container(
                width: double.infinity,
                color: const Color(0xFF1A1A1A),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/tell_friend.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Tell friends about Netflix.',
                            style: AppStyle.tss20W700.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit quam dui, vivamus bibendum ut. A morbi mi tortor ut felis non accumsan accumsan quis. Massa,',
                      style: AppStyle.tss18W500.copyWith(color: Colors.white, height: 1.3),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terms & Conditions tapped')),
                        );
                      },
                      child: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40.h,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: 'https://netflix.com/share'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Link copied to clipboard!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                          child: Text(
                            'Copy Link',
                            style: AppStyle.tss34W600.copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Share to WhatsApp')),
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/whatsapp_icon.svg',
                                width: 36.w,
                                height: 36.h,
                              ),
                            ),
                          ),
                        ),
                        _buildVerticalDivider(),
                        Expanded(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Share to Facebook')),
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/facebook_icon.svg',
                                width: 36.w,
                                height: 36.h,
                              ),
                            ),
                          ),
                        ),
                        _buildVerticalDivider(),
                        Expanded(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Share to Gmail')),
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/gmail_icon.svg',
                                width: 36.w,
                                height: 36.h,
                              ),
                            ),
                          ),
                        ),
                        _buildVerticalDivider(),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('More share options')),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/vertical_more.svg',
                                  width: 36.w,
                                  height: 36.h,
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'More',
                                  style: AppStyle.tss12W400.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Bottom List Items
              Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('My List tapped')),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/tick_icon.svg',
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'My List',
                              style: AppStyle.tss30W500.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Divider(color: Colors.grey.shade800, thickness: 1.h, height: 1.h),
                    SizedBox(height: 12.h),
                    _buildBottomListItem('App Settings'),
                    _buildBottomListItem('Account'),
                    _buildBottomListItem('Help'),
                    _buildBottomListItem('Sign Out'),
                  ],
                ),
              ),
              SizedBox(height: 60.h), // Spacing at bottom to ensure no cut off
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String name, String imageAsset) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Switched to profile $name')),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Image.asset(
              imageAsset,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: AppStyle.tss12W400.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProfileItem() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add profile tapped')),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.grey.shade800, width: 1.5.w),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/plus_plane.svg',
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '',
            style: AppStyle.tss12W400.copyWith(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.w,
      height: 36.h,
      color: Colors.grey.shade800,
    );
  }

  Widget _buildBottomListItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$text tapped')),
          );
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: AppStyle.tss30W500.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
