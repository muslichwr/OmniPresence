import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? icon;
  final bool disabled;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isFullWidth = false,
    this.isLoading = false,
    this.icon,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton();
      case ButtonType.secondary:
        return _buildSecondaryButton();
      case ButtonType.outlined:
        return _buildOutlinedButton();
    }
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52.h,
      child: ElevatedButton(
        onPressed: disabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 12.h,
          ),
        ),
        child: _buildButtonContent(Colors.white),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52.h,
      child: ElevatedButton(
        onPressed: disabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.secondary.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 12.h,
          ),
        ),
        child: _buildButtonContent(Colors.white),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52.h,
      child: OutlinedButton(
        onPressed: disabled || isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: disabled
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 12.h,
          ),
        ),
        child: _buildButtonContent(AppColors.primary),
      ),
    );
  }

  Widget _buildButtonContent(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 24.h,
        width: 24.h,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.r),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
