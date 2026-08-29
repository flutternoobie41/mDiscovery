import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_style.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_menu_item.dart';

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
                    ProfileAvatarItem(
                      name: 'Emenalo',
                      imageAsset: 'assets/images/rectangle1.jpg',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Switched to profile Emenalo')),
                        );
                      },
                    ),
                    ProfileAvatarItem(
                      name: 'Onyeka',
                      imageAsset: 'assets/images/rectangle2.jpg',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Switched to profile Onyeka')),
                        );
                      },
                    ),
                    ProfileAvatarItem(
                      name: 'Thelma',
                      imageAsset: 'assets/images/rectangle3.jpg',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Switched to profile Thelma')),
                        );
                      },
                    ),
                    ProfileAvatarItem(
                      name: 'Kids',
                      imageAsset: 'assets/images/kids_rectangle.jpg',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Switched to profile Kids')),
                        );
                      },
                    ),
                    AddProfileAvatarItem(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add profile tapped')),
                        );
                      },
                    ),
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
                    ProfileMenuItem(
                      text: 'App Settings',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('App Settings tapped')),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      text: 'Account',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account tapped')),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      text: 'Help',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Help tapped')),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      text: 'Sign Out',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sign Out tapped')),
                        );
                      },
                    ),
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

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.w,
      height: 36.h,
      color: Colors.grey.shade800,
    );
  }
}
