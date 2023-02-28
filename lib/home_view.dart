import 'package:ai_image_generator/api_services.dart';
import 'package:ai_image_generator/app_colors.dart';
import 'package:flutter/material.dart';

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
              onPressed: () {},
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
                              content: Text(
                                  'Please enter a description and select the size'),
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
                          child: Image.network(
                            image,
                            fit: BoxFit.contain,
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
                                onPressed: () {},
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
                                onPressed: () {},
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
