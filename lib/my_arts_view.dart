import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'app_colors.dart';

class MyArtsView extends StatefulWidget {
  const MyArtsView({Key? key}) : super(key: key);

  @override
  State<MyArtsView> createState() => _MyArtsViewState();
}

class _MyArtsViewState extends State<MyArtsView> {
  List imagesList = [];

  getImagesList() {
    final directory = Directory('storage/emulated/0/AI Image Gen');
    imagesList = directory.listSync();

    log('-------------------- getImagesList ----------------\n${imagesList.length}');
  }

  popImage(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: StadiumBorder(),
        child: Container(
          width: 300,
          height: 300,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getImagesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Art Gallery',
          style: TextStyle(
            fontFamily: 'poppins_bold',
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 200,
          ),
          itemCount: imagesList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => popImage(imagesList[index]),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: Image.file(
                  imagesList[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
