import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
    this.onImageSelected,
  });

  final Function(XFile image)? onImageSelected;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  XFile? selectedImage;

  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() {
        selectedImage = image;
      });

      widget.onImageSelected?.call(image);
    } catch (e) {
      debugPrint("Gallery Error: $e");
    }
  }

  Future<void> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() {
        selectedImage = image;
      });

      widget.onImageSelected?.call(image);
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  void showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xffEEF2FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: selectedImage == null
              ? const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 70,
                    color: Color(0xff4F46E5),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    selectedImage!.path,
                    fit: BoxFit.cover,
                  ),
                ),
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          onPressed: showPickerOptions,
          icon: const Icon(Icons.add_a_photo),
          label: const Text("Select Image"),
        ),

        if (selectedImage != null)
          TextButton.icon(
            onPressed: () {
              setState(() {
                selectedImage = null;
              });
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text("Remove Image"),
          ),
      ],
    );
  }
}