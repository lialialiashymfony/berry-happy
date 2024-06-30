import 'dart:io';
import 'package:berry_happy/cubit/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:berry_happy/endpoints/endpoints.dart';

class AddMenu extends StatefulWidget {
  // ignore: use_super_parameters
  const AddMenu({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _title = "";
  String _description = "";
  // ignore: unused_field
  int _price = 0;

  File? galleryFile;
  final picker = ImagePicker();

  String? _selectedCategory;

  // Function to display the bottom sheet for choosing an image source
  void _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to get an image from the specified source
  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    setState(() {
      if (pickedFile != null) {
        galleryFile = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')),
        );
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Function to save data (for debugging purposes)
  void saveData() {
    debugPrint(_title);
    debugPrint(_description);
  }

  // Function to post menu data along with the selected image
  Future<void> _postDataWithImage(
      BuildContext context, String accessToken) async {
    // Check if an image is selected
    if (galleryFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Check if a category is selected
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    try {
      // Create a multipart request
      var request =
          http.MultipartRequest('POST', Uri.parse(Endpoints.menuCreate));
      // Set authorization header
      request.headers['Authorization'] = 'Bearer $accessToken';
      // Add form fields
      request.fields['nama_menu'] = _titleController.text;
      request.fields['desc_menu'] = _descriptionController.text;
      request.fields['harga_menu'] = _priceController.text;
      request.fields['kategori'] = _selectedCategory!;

      // Add image file
      var multipartFile = await http.MultipartFile.fromPath(
        'img',
        galleryFile!.path,
      );
      request.files.add(multipartFile);

      // Send request and get response
      var response = await request.send();
      // Check response status
      if (response.statusCode == 201) {
        debugPrint('Menu posted successfully!');
        // Navigate to dashboard after successful posting
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/dashboard-owner');
      } else {
        debugPrint('Error posting issue: ${response.statusCode}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting menu: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Exception: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  // Function to validate input fields
  bool _validateInputs() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory == null ||
        galleryFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields and select an image'),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 204, 229),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title of the page
                  Text(
                    "Add Menu",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: const Color.fromARGB(225, 223, 6, 112),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Description of the page
                  Text(
                    "Fill the form below to add menu!",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Container for displaying selected image or prompting to pick one
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              // Gesture detector to trigger image selection
                              GestureDetector(
                                onTap: () {
                                  _showPicker(context: context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 150,
                                  child: galleryFile == null
                                      ? Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                color: Colors.grey,
                                                size: 50,
                                              ),
                                              Text(
                                                'Pick your Image here',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    124,
                                                    122,
                                                    122,
                                                  ),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: Image.file(galleryFile!),
                                        ),
                                ),
                              ),
                              // Text field for menu title
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    hintText: "Title",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _title = value;
                                    });
                                  },
                                ),
                              ),
                              // Text field for menu description
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    hintText: "Description",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _description = value;
                                    });
                                  },
                                ),
                              ),
                              // Text field for menu price
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                    hintText: "Price",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      _price = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                              // Dropdown for selecting menu category
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  items: ["FOOD", "BEVERAGE"]
                                      .map(
                                        (category) => DropdownMenuItem(
                                          value: category,
                                          child: Text(category),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Category",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  hint: const Text("Select a Category"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 250),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating action button for saving menu data
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(225, 223, 6, 112),
        tooltip: 'Save',
        onPressed: () {
          if (_validateInputs()) {
            // Get access token from AuthCubit using Flutter Bloc
            final accessToken = context.read<AuthCubit>().state.accessToken;
            // Post menu data with selected image
            _postDataWithImage(context, accessToken);
          }
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
