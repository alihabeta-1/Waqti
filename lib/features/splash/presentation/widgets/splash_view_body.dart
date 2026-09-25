import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:waqti/core/constants/app_assets.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key, required this.progressAnimation});
  final Animation<double> progressAnimation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5B4FF6), Color(0xFF4338CA)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20.r,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AppAssets.waqtiLogo,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 28.h),

              Text(
                'Waqti | وقتي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                'Smart Time Orchestration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                'Your time, thoughtfully booked.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),

              SizedBox(height: 32.h),

              AnimatedBuilder(
                animation: progressAnimation,
                builder: (context, child) {
                  return Container(
                    width: 150.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      widthFactor: progressAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.35),
                              blurRadius: 8.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
