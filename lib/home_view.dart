import 'package:ai_image_generator/app_colors.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AI Image Gen',
          style: TextStyle(
            fontFamily: 'poppins_bold',
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
