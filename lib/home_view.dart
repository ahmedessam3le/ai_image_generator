import 'dart:developer';
import 'dart:io';

import 'package:ai_image_generator/api_services.dart';
import 'package:ai_image_generator/app_colors.dart';
import 'package:ai_image_generator/my_arts_view.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var sizes = ['Small', 'Medium', 'Large'];
  var values = ['256x256', '512x512', '1024x1024'];
  String? selectedValue;
  var textController = TextEditingController();
  String image = '';
  var isImageLoaded = false;

  ScreenshotController screenshotController = ScreenshotController();

  shareImage() async {
    var photo = await screenshotController.capture(
      delay: const Duration(milliseconds: 100),
      pixelRatio: 1.0,
    );

    if (photo != null) {
      final directory = (await getApplicationDocumentsDirectory()).path;
      const fileName = 'share.png';
      final imagePath = await File('$directory/$fileName').create();

      await imagePath.writeAsBytes(photo);

      Share.shareXFiles([imagePath as XFile], text: 'AI Image Gen.');
    } else {
      log('----------------- shareImage ERROR ----------------\nFailed to take screenshot');
    }
  }

  downloadImage() async {
    var permissionResult = await Permission.storage.request();
    var manageStoragePermissionResult =
        await Permission.manageExternalStorage.request();

    if (permissionResult.isGranted && manageStoragePermissionResult.isGranted) {
      const folderName = 'AI Image Gen';
      final path = Directory('storage/emulated/0/$folderName');
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.png';

      if (await path.exists()) {
        await screenshotController.captureAndSave(
          path.path,
          delay: const Duration(milliseconds: 100),
          fileName: fileName,
          pixelRatio: 1.0,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            backgroundColor: Colors.green,
            content: SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  'Image Downloaded to ${path.path}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        );
      } else {
        await path.create();

        await screenshotController.captureAndSave(
          path.path,
          delay: const Duration(milliseconds: 100),
          fileName: fileName,
          pixelRatio: 1.0,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            backgroundColor: Colors.green,
            content: SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  'Image Downloaded to ${path.path}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          backgroundColor: Colors.red,
          content: SizedBox(
            height: 30,
            child: Center(
              child: Text(
                'Permission Denied',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      );
    }
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(8),
                backgroundColor: AppColors.buttonColor,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyArtsView(),
                  ),
                );
              },
              child: const Text('My Arts'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: 'eg: A monkey on the moon',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: const Text('Select Size'),
                            value: selectedValue,
                            icon: const Icon(
                              Icons.expand_more,
                              color: AppColors.buttonColor,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            items: List.generate(
                              sizes.length,
                              (index) {
                                return DropdownMenuItem(
                                  value: values[index],
                                  child: Text(
                                    sizes[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        if (textController.text.trim().isNotEmpty &&
                            selectedValue != null &&
                            selectedValue!.trim().isNotEmpty) {
                          setState(() {
                            isImageLoaded = false;
                          });
                          image = await ApiServices.generateImage(
                            description: textController.text,
                            size: selectedValue!,
                          );
                          setState(() {
                            isImageLoaded = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                              backgroundColor: Colors.red,
                              content: SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text(
                                    'Please enter a description and select the size',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Generate'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: isImageLoaded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Screenshot(
                            controller: screenshotController,
                            child: Image.network(
                              image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                  backgroundColor: AppColors.buttonColor,
                                ),
                                onPressed: () async {
                                  await downloadImage();
                                },
                                icon: const Icon(
                                    Icons.download_for_offline_rounded),
                                label: const Text('Download'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                  backgroundColor: AppColors.buttonColor,
                                ),
                                onPressed: () async {
                                  await shareImage();
                                },
                                icon: const Icon(Icons.share),
                                label: const Text('Share'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/loader.gif'),
                          const SizedBox(height: 16),
                          const Text(
                            'Waiting for image to be generated ...',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Developed by Ahmed Essam',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
