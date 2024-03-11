import 'dart:async';
import 'package:retailer_app/routes/app_routes.dart';
import 'package:retailer_app/view/login.page.dart';
import 'package:retailer_app/widgets/custom_image_upload.dart';
import 'package:retailer_app/widgets/custom_text.dart';
import 'package:retailer_app/widgets/login_button.dart';
import 'package:retailer_app/widgets/privacy_policy_dialog.dart';
import 'package:retailer_app/widgets/signup_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _image;
  File? _image1;
  File? _image2;
  File? _image3;
  File? _image4;

  bool isLoading = false;
  final nameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCheckboxChecked = false;
  String? checkboxError;
  bool isImageSelected = false;
  bool isImageSelected1 = false;
  bool isImageSelected2 = false;
  bool isImageSelected3 = false;
  bool isImageSelected4 = false;

  final _imageStreamController = StreamController<File?>.broadcast();
  final _imageStreamController1 = StreamController<File?>.broadcast();
  final _imageStreamController2 = StreamController<File?>.broadcast();
  final _imageStreamController3 = StreamController<File?>.broadcast();
  final _imageStreamController4 = StreamController<File?>.broadcast();

  Future<void> _takeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      _imageStreamController.sink.add(imageFile);
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      _imageStreamController.sink.add(imageFile);
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _takeImage1() async {
    final pickedFile1 =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile1 != null) {
      final imageFile1 = File(pickedFile1.path);
      _imageStreamController1.sink.add(imageFile1);
      setState(() {
        _image1 = File(pickedFile1.path);
      });
    }
  }

  Future<void> _pickImage1() async {
    final pickedFile1 =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile1 != null) {
      final imageFile1 = File(pickedFile1.path);
      _imageStreamController1.sink.add(imageFile1);
      setState(() {
        _image1 = File(pickedFile1.path);
      });
    }
  }

  Future<void> _takeImage2() async {
    final pickedFile2 =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile2 != null) {
      final imageFile2 = File(pickedFile2.path);
      _imageStreamController2.sink.add(imageFile2);
      setState(() {
        _image2 = File(pickedFile2.path);
      });
    }
  }

  Future<void> _pickImage2() async {
    final pickedFile2 =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile2 != null) {
      final imageFile2 = File(pickedFile2.path);
      _imageStreamController2.sink.add(imageFile2);
      setState(() {
        _image2 = File(pickedFile2.path);
      });
    }
  }

  Future<void> _takeImage3() async {
    final pickedFile3 =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile3 != null) {
      final imageFile3 = File(pickedFile3.path);
      _imageStreamController3.sink.add(imageFile3);
      setState(() {
        _image3 = File(pickedFile3.path);
      });
    }
  }

  Future<void> _pickImage3() async {
    final pickedFile3 =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile3 != null) {
      final imageFile3 = File(pickedFile3.path);
      _imageStreamController3.sink.add(imageFile3);
      setState(() {
        _image3 = File(pickedFile3.path);
      });
    }
  }

  Future<void> _takeImage4() async {
    final pickedFile4 =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile4 != null) {
      final imageFile4 = File(pickedFile4.path);
      _imageStreamController4.sink.add(imageFile4);
      setState(() {
        _image4 = File(pickedFile4.path);
      });
    }
  }

  Future<void> _pickImage4() async {
    final pickedFile4 =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile4 != null) {
      final imageFile4 = File(pickedFile4.path);
      _imageStreamController4.sink.add(imageFile4);
      setState(() {
        _image4 = File(pickedFile4.path);
      });
    }
  }

  Future<Map<String, dynamic>?> uploadImageToServer(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/upload/image'),
      );

      var fileStream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
      var length = await imageFile.length();

      String fileExtension = imageFile.path.split('.').last.toLowerCase();
      var contentType = MediaType('image', 'png');

      Map<String, String> imageExtensions = {
        'png': 'png',
        'jpg': 'jpeg',
        'jpeg': 'jpeg',
        'gif': 'gif',
      };

      if (imageExtensions.containsKey(fileExtension)) {
        contentType = MediaType('image', imageExtensions[fileExtension]!);
      }

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: 'image.$fileExtension',
        contentType: contentType,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseBody);
        return parsedResponse;
      } else {
        print("Image upload failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload failed with error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadImageToServer1(File imageFile1) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/upload/image'),
      );

      var fileStream = http.ByteStream(Stream.castFrom(imageFile1.openRead()));
      var length = await imageFile1.length();

      String fileExtension = imageFile1.path.split('.').last.toLowerCase();
      var contentType = MediaType('image', 'png');

      Map<String, String> imageExtensions = {
        'png': 'png',
        'jpg': 'jpeg',
        'jpeg': 'jpeg',
        'gif': 'gif',
      };

      if (imageExtensions.containsKey(fileExtension)) {
        contentType = MediaType('image', imageExtensions[fileExtension]!);
      }

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: 'image.$fileExtension',
        contentType: contentType,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseBody);
        return parsedResponse;
      } else {
        print("Image upload failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload failed with error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadImageToServer2(File imageFile2) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/upload/image'),
      );

      var fileStream = http.ByteStream(Stream.castFrom(imageFile2.openRead()));
      var length = await imageFile2.length();

      String fileExtension = imageFile2.path.split('.').last.toLowerCase();
      var contentType = MediaType('image', 'png');

      Map<String, String> imageExtensions = {
        'png': 'png',
        'jpg': 'jpeg',
        'jpeg': 'jpeg',
        'gif': 'gif',
      };

      if (imageExtensions.containsKey(fileExtension)) {
        contentType = MediaType('image', imageExtensions[fileExtension]!);
      }

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: 'image.$fileExtension',
        contentType: contentType,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseBody);
        return parsedResponse;
      } else {
        print("Image upload failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload failed with error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadImageToServer3(File imageFile3) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/upload/image'),
      );

      var fileStream = http.ByteStream(Stream.castFrom(imageFile3.openRead()));
      var length = await imageFile3.length();

      String fileExtension = imageFile3.path.split('.').last.toLowerCase();
      var contentType = MediaType('image', 'png');

      Map<String, String> imageExtensions = {
        'png': 'png',
        'jpg': 'jpeg',
        'jpeg': 'jpeg',
        'gif': 'gif',
      };

      if (imageExtensions.containsKey(fileExtension)) {
        contentType = MediaType('image', imageExtensions[fileExtension]!);
      }

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: 'image.$fileExtension',
        contentType: contentType,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseBody);
        return parsedResponse;
      } else {
        print("Image upload failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload failed with error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadImageToServer4(File imageFile4) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/upload/image'),
      );

      var fileStream = http.ByteStream(Stream.castFrom(imageFile4.openRead()));
      var length = await imageFile4.length();

      String fileExtension = imageFile4.path.split('.').last.toLowerCase();
      var contentType = MediaType('image', 'png');

      Map<String, String> imageExtensions = {
        'png': 'png',
        'jpg': 'jpeg',
        'jpeg': 'jpeg',
        'gif': 'gif',
      };

      if (imageExtensions.containsKey(fileExtension)) {
        contentType = MediaType('image', imageExtensions[fileExtension]!);
      }

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: 'image.$fileExtension',
        contentType: contentType,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseBody);
        return parsedResponse;
      } else {
        print("Image upload failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload failed with error: $e");
      return null;
    }
  }

  Future<void> signup() async {
    setState(() {
      isLoading = true;
    });

    final userData = {
      "name": nameController.text,
      "contactNumber": "0${contactNumberController.text}",
      "address": addressController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "verified": false,
      "__t": "Retailer",
      "image": "",
      "doe": "",
      "businessPermit": "",
      "fireSafetyPermit": "",
      // "agreement": "",
    };

    try {
      if (_image != null) {
        final responseImage = await uploadImageToServer(_image!);

        if (responseImage != null) {
          final imageUrl = responseImage["data"][0]["path"];
          userData["image"] = imageUrl;
        }
      }
      if (_image1 != null) {
        final responseImage1 = await uploadImageToServer1(_image1!);

        if (responseImage1 != null) {
          final imageUrl1 = responseImage1["data"][0]["path"];
          userData["doe"] = imageUrl1;
        }
      }
      if (_image2 != null) {
        final responseImage2 = await uploadImageToServer2(_image2!);

        if (responseImage2 != null) {
          final imageUrl2 = responseImage2["data"][0]["path"];
          userData["businessPermit"] = imageUrl2;
        }
      }
      if (_image3 != null) {
        final responseImage3 = await uploadImageToServer3(_image3!);

        if (responseImage3 != null) {
          final imageUrl3 = responseImage3["data"][0]["path"];
          userData["fireSafetyPermit"] = imageUrl3;
        }
      }
      // if (_image4 != null) {
      //   final responseImage4 = await uploadImageToServer4(_image4!);

      //   if (responseImage4 != null) {
      //     final imageUrl4 = responseImage4["data"][0]["path"];
      //     userData["agreement"] = imageUrl4;
      //   }
      // }

      final userResponse = await http.post(
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/users'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      print(userResponse.body);

      if (userResponse.statusCode == 200) {
        print("User created successfully.");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        print("Response: ${userResponse.body}");
      }
    } catch (error) {
      print("Error during sign-up: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> trapFetch(String data,
      {bool byNumber = true}) async {
    final searchData = byNumber ? '0$data' : data;

    final filter = byNumber
        ? '{"__t":"Retailer","contactNumber":"$searchData"}'
        : '{"__t":"Retailer","email":"$searchData"}';

    final response = await http.get(
      Uri.parse(
        'https://lpg-api-06n8.onrender.com/api/v1/users/?filter=$filter',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['data'] != null && responseData['data'].isNotEmpty) {
        final userData = responseData['data'][0] as Map<String, dynamic>;
        return userData;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  String? emailAddressText;
  String? contactNumberText;
  String? numberWithZero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 0.0),
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50.0),
                      Column(
                        children: <Widget>[
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF050404).withOpacity(0.9),
                            ),
                          ),
                          Text(
                            "Create an account, It's free",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: const Color(0xFF050404).withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          StreamBuilder<File?>(
                            stream: _imageStreamController.stream,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: snapshot.data != null
                                            ? FileImage(snapshot.data!)
                                            : null,
                                        backgroundColor: const Color(0xFF050404)
                                            .withOpacity(0.9),
                                        child: snapshot.data == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 50,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  SignupImageUploadValidator(
                                    takeImage: _takeImage,
                                    pickImage: _pickImage,
                                    buttonText: "Upload Profile Image",
                                    onImageSelected: (isSelected) {
                                      setState(() {
                                        isImageSelected = isSelected;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          SignupTextField(
                            controller: nameController,
                            labelText: 'Full Name',
                            hintText: 'Enter your Full Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter your Full Name";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SignupContactText(
                            controller: contactNumberController,
                            labelText: 'Mobile Number',
                            hintText: 'Enter your Mobile Number',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter your Mobile Number";
                              } else if (value.length != 10) {
                                return "Please Enter the Correct Mobile Number";
                              } else if (!value.startsWith('9')) {
                                return "Please Enter the Correct Mobile Number";
                              } else if (contactNumberText ==
                                  "0${contactNumberController.text}") {
                                return "Mobile Number is Already Registered";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SignupTextField(
                            controller: addressController,
                            labelText: 'Address',
                            hintText: 'Enter your Address',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter your Address";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SignupTextField(
                            controller: emailController,
                            labelText: 'Email Address',
                            hintText: 'Enter your Email Address',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Email Address";
                              } else if (!RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(value)) {
                                return "Please Enter Correct Email Address";
                              } else if (emailAddressText ==
                                  emailController.text.trim()) {
                                return "Email Address is Already Registered";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SignupTextField(
                            controller: passwordController,
                            labelText: 'Password',
                            hintText: 'Enter your Password',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter your Password";
                              } else {
                                return null;
                              }
                            },
                          ),
                          StreamBuilder<File?>(
                            stream: _imageStreamController1.stream,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: snapshot.data != null
                                            ? FileImage(snapshot.data!)
                                            : null,
                                        backgroundColor: const Color(0xFF050404)
                                            .withOpacity(0.9),
                                        child: snapshot.data == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 50,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  SignupImageUploadValidator(
                                    takeImage: _takeImage1,
                                    pickImage: _pickImage1,
                                    buttonText: "Upload DOE",
                                    onImageSelected: (isSelected1) {
                                      setState(() {
                                        isImageSelected1 = isSelected1;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          StreamBuilder<File?>(
                            stream: _imageStreamController2.stream,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: snapshot.data != null
                                            ? FileImage(snapshot.data!)
                                            : null,
                                        backgroundColor: const Color(0xFF050404)
                                            .withOpacity(0.9),
                                        child: snapshot.data == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 50,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  SignupImageUploadValidator(
                                    takeImage: _takeImage2,
                                    pickImage: _pickImage2,
                                    buttonText: "Upload Business Permit",
                                    onImageSelected: (isSelected2) {
                                      setState(() {
                                        isImageSelected2 = isSelected2;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          StreamBuilder<File?>(
                            stream: _imageStreamController3.stream,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: snapshot.data != null
                                            ? FileImage(snapshot.data!)
                                            : null,
                                        backgroundColor: const Color(0xFF050404)
                                            .withOpacity(0.9),
                                        child: snapshot.data == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 50,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  SignupImageUploadValidator(
                                    takeImage: _takeImage3,
                                    pickImage: _pickImage3,
                                    buttonText: "Upload Firesafety Permit",
                                    onImageSelected: (isSelected3) {
                                      setState(() {
                                        isImageSelected3 = isSelected3;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          StreamBuilder<File?>(
                            stream: _imageStreamController4.stream,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  // Stack(
                                  //   alignment: Alignment.topRight,
                                  //   children: [
                                  //     CircleAvatar(
                                  //       radius: 50,
                                  //       backgroundImage: snapshot.data != null
                                  //           ? FileImage(snapshot.data!)
                                  //           : null,
                                  //       backgroundColor: const Color(0xFF050404)
                                  //           .withOpacity(0.9),
                                  //       child: snapshot.data == null
                                  //           ? const Icon(
                                  //               Icons.person,
                                  //               color: Colors.white,
                                  //               size: 50,
                                  //             )
                                  //           : null,
                                  //     ),
                                  //   ],
                                  // ),
                                  // SignupImageUploadValidator(
                                  //   takeImage: _takeImage4,
                                  //   pickImage: _pickImage4,
                                  //   buttonText: "Upload Agreement",
                                  //   onImageSelected: (isSelected4) {
                                  //     setState(() {
                                  //       isImageSelected4 = isSelected4;
                                  //     });
                                  //   },
                                  // ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                    checkboxTheme: CheckboxThemeData(
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return const Color(0xFF050404)
                                                .withOpacity(0.9);
                                          }
                                          return Colors.white;
                                        },
                                      ),
                                    ),
                                  ),
                                  child: Checkbox(
                                    value: isCheckboxChecked,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        isCheckboxChecked = newValue ?? false;
                                        checkboxError = null;
                                      });
                                    },
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return PrivacyPolicyDialog();
                                        },
                                      );
                                    },
                                    child: Text(
                                      "I Accept and Agree to these Terms and Conditions",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: const Color(0xFF050404)
                                            .withOpacity(0.9),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (checkboxError != null)
                            Text(
                              checkboxError!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 15),
                          SignupCreateButton(
                            onPressed: () async {
                              if (!isImageSelected) {
                                showCustomOverlay(
                                    context, 'Please Upload a Profile Image');
                              } else {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  final numberData = await trapFetch(
                                      contactNumberController.text);
                                  final emailData = await trapFetch(
                                      emailController.text,
                                      byNumber: false);

                                  if (numberData != null) {
                                    setState(() {
                                      contactNumberText =
                                          '0${contactNumberController.text}';
                                    });
                                  }

                                  if (emailData != null) {
                                    setState(() {
                                      emailAddressText = emailData['email'];
                                    });
                                  }

                                  if (formKey.currentState!.validate()) {
                                    if (isCheckboxChecked) {
                                      signup();
                                    } else {
                                      setState(() {
                                        checkboxError =
                                            'Please Read and Accept the Terms and Conditions';
                                      });
                                    }
                                  }
                                } catch (e) {
                                  //
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 5),
                          SignupBackButton(
                            onPressed: () {
                              Navigator.pushNamed(context, onboardingRoute);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: const Color(0xFF050404).withOpacity(0.8),
                rightDotColor: const Color(0xFFd41111).withOpacity(0.8),
                size: 40,
              ),
            ),
        ],
      ),
    );
  }
}

void showCustomOverlay(BuildContext context, String message) {
  final overlay = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.5,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  Overlay.of(context)!.insert(overlay);

  Future.delayed(const Duration(seconds: 2), () {
    overlay.remove();
  });
}
