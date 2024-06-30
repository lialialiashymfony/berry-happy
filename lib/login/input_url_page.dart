import 'package:berry_happy/endpoints/endpoints.dart';
import 'package:berry_happy/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';

class InputUrlPage extends StatefulWidget {
  // ignore: use_super_parameters
  const InputUrlPage({Key? key}) : super(key: key);

  @override
  State<InputUrlPage> createState() => _InputUrlPageState();
}

class _InputUrlPageState extends State<InputUrlPage> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  // Function to handle saving the input URL to secure storage and initializing endpoints
  void sendUrl() async {
    if (_urlController.text.isNotEmpty) {
      // Save the URL to secure storage
      await SecureStorageUtil.storage
          .write(key: "url_setting", value: _urlController.text);

      // Initialize endpoints with the new URL
      await Endpoints.initialize();

      // Show a SnackBar to confirm the input was saved
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Input saved: ${_urlController.text}')),
      );

      // Clear the text field after submission
      _urlController.clear();

      // Navigate back to the previous screen
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // Show a SnackBar if the input URL is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Input Url',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 65, 158),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text field for entering the API URL
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan URL API', // Placeholder text
                        filled: true,
                        // fillColor: const Color.fromARGB(
                        //     255, 255, 65, 158), // Background color
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons
                            .settings_input_antenna), // Icon before input field
                      ),
                      style: const TextStyle(fontSize: 18), // Text style
                    ),
                    const SizedBox(height: 20), // Spacer

                    // Button to submit the entered URL
                    ElevatedButton(
                      onPressed: () {
                        sendUrl(); // Calls sendUrl function when pressed
                      },
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Submit', // Button text
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
