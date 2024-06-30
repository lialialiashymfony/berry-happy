import 'dart:io';
import 'package:berry_happy/cubit/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:berry_happy/endpoints/endpoints.dart';
import 'package:berry_happy/dto/menu.dart'; // Assuming you have a Menu model defined

// Stateful widget for editing a menu
class EditMenu extends StatefulWidget {
  final Menu menu;
  final String accessToken;
   // Menu object passed from constructor

  // ignore: use_super_parameters
  const EditMenu({required this.menu,required this.accessToken, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditMenuState createState() =>
      _EditMenuState(); // Creates state for EditMenu widget
}

// State class for EditMenu widget
class _EditMenuState extends State<EditMenu> {
  late TextEditingController _titleController; // Controller for title input
  late TextEditingController
      _descriptionController; // Controller for description input
  late TextEditingController _priceController; // Controller for price input
  File? galleryFile; // Variable to store picked image file
  final picker = ImagePicker(); // Image picker instance
  late String _selectedCategory; // State variable for selected category

  @override
  void initState() {
    super.initState();
    // Initialize controllers with menu data passed from widget
    _titleController = TextEditingController(text: widget.menu.menuName);
    _descriptionController = TextEditingController(text: widget.menu.descMenu);
    _priceController =
        TextEditingController(text: widget.menu.menuPrice.toString());
    _selectedCategory =
        widget.menu.kategori; // Initialize category with menu's category
  }

  @override
  void dispose() {
    // Dispose controllers when widget is disposed
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Function to display image picker options (gallery or camera)
  Future<void> _showPicker({required BuildContext context}) async {
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
                  getImage(ImageSource
                      .gallery); // Calls getImage with gallery as source
                  Navigator.of(context).pop(); // Closes bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource
                      .camera); // Calls getImage with camera as source
                  Navigator.of(context).pop(); // Closes bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to pick image from gallery or camera
  Future<void> getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img); // Picks image
    setState(() {
      if (pickedFile != null) {
        galleryFile = File(pickedFile.path); // Sets selected image file
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Nothing is selected')), // Shows snack bar if nothing selected
        );
      }
    });
  }

  // Function to update menu data with image to server
  Future<void> _updateDataWithImage(BuildContext context, String accessToken) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Endpoints.menuUpdate}/${widget.menu.idMenu}')); // Creates HTTP multipart request for updating menu
                  request.headers['Authorization'] = 'Bearer $accessToken';
      request.fields['id_menu'] =
          widget.menu.idMenu.toString(); 
      request.fields['nama_menu'] =
          _titleController.text; 
      request.fields['desc_menu'] =
          _descriptionController.text;
      request.fields['harga_menu'] =
          _priceController.text; 
      request.fields['kategori'] =
          _selectedCategory; 

      if (galleryFile != null) {
        var multipartFile = await http.MultipartFile.fromPath(
            'img', galleryFile!.path); 
        request.files.add(multipartFile);
      }

      // Debug prints to verify request details
      debugPrint('Request URL: ${request.url}');
      debugPrint('Request Fields: ${request.fields}');
      debugPrint('Request Files: ${request.files}');

      var response = await request.send(); // Sends multipart request
      if (response.statusCode == 200) {
        debugPrint(
            'Menu updated successfully!'); // Prints success message on successful update
        Navigator.pushReplacementNamed(
            // ignore: use_build_context_synchronously
            context,
            '/dashboard-owner'); // Navigates to dashboard on success
      } else {
        debugPrint(
            'Error updating menu: ${response.statusCode}'); // Prints error message on failure
        var responseBody = await response.stream.bytesToString();
        debugPrint(
            'Response body: $responseBody'); // Prints response body on failure
      }
    } catch (e) {
      // Handles different types of exceptions
      if (e is http.ClientException) {
        debugPrint(
            'ClientException: ${e.message}'); // Prints ClientException message
      } else if (e is SocketException) {
        debugPrint(
            'SocketException: ${e.message}'); // Prints SocketException message
      } else {
        debugPrint('Exception: ${e.toString()}'); // Prints other exceptions
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 204, 229), 
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
                  Text(
                    "Edit Menu", // Title text
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: const Color.fromARGB(225, 223, 6, 112),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Fill the form below to update the menu!", // Description text
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
                        horizontal: 30, vertical: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showPicker(
                                      context:
                                          context); // Shows image picker options
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 150,
                                  child: galleryFile == null
                                      // Displays selected image or prompt to pick one
                                      // ignore: unnecessary_null_comparison
                                      ? (widget.menu.imageUrl != null &&
                                              widget.menu.imageUrl.isNotEmpty
                                          ? Image.network(
                                              '${Endpoints.baseUAS}/static/storages/${widget.menu.imageUrl}')
                                          : Center(
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              124,
                                                              122,
                                                              122),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                      : Center(
                                          child: Image.file(
                                              galleryFile!)), // Displays selected image
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
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
                                      // _title = value; // This line is not necessary
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
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
                                      // _description = value; // This line is not necessary
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
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
                                      // _price = int.tryParse(value) ?? 0; // This line is not necessary
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  items: ["FOOD", "BAVERAGE"]
                                      .map((category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory =
                                          value!; // Updates selected category state
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Category",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            const Color.fromARGB(225, 223, 6, 112), // Sets FAB background color
        tooltip: 'Save', // Tooltip for FAB
        onPressed: () {
          final accessToken = context.read<AuthCubit>().state.accessToken;
          _updateDataWithImage(
              context, accessToken); // Calls function to update data with image
        },
        child: const Icon(Icons.save,
            color: Colors.white, size: 28), // Icon for FAB
      ),
    );
  }
}
