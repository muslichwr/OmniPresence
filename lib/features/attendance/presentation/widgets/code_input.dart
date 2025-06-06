import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';

class CodeInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onComplete;

  const CodeInput({
    Key? key,
    required this.controller,
    this.onComplete,
  }) : super(key: key);

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {});

    // Format the code with a dash in the middle (XXX-XXX)
    final text = widget.controller.text.replaceAll('-', '');
    if (text.length > 3) {
      final formattedText =
          '${text.substring(0, 3)}-${text.substring(3, text.length.clamp(3, 6))}';
      if (formattedText != widget.controller.text) {
        widget.controller.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }

    // Call onComplete when the code is fully entered
    if (text.length == 6 && widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _focusNode.requestFocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? AppColors.primary
                    : AppColors.borderLight,
                width: _focusNode.hasFocus ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  widget.controller.text.isEmpty
                      ? 'XXX-XXX'
                      : widget.controller.text,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.w,
                    color: widget.controller.text.isEmpty
                        ? AppColors.textMuted
                        : AppColors.textDark,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter the 6-digit code',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        Opacity(
          opacity: 0,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLength: 7, // Account for the dash
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            ],
            decoration: const InputDecoration(
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }
}
