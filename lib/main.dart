import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:loginpage/screens/home/landing_screen.dart';
import 'package:loginpage/screens/item/item_details_screen.dart';
import 'package:loginpage/screens/item/item_screen.dart';
import 'package:loginpage/screens/logout/logout_screen.dart';
import 'package:loginpage/widgets/bottom_nav_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'globals.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class LoginScreen extends StatelessWidget {
  static const String id = "LoginSection";
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
          child: ListView(
            restorationId: 'text_field_demo_list_view',
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoTextField(
                  restorationId: 'email_address_text_field',
                  placeholder: "Email",
                  keyboardType: TextInputType.emailAddress,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoTextField(
                  restorationId: 'login_password_text_field',
                  placeholder: "Password",
                  clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: true,
                  autocorrect: false,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              TextButton.icon(
                  onPressed: () async {
                    await login(email, password);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String token = prefs.getString('token');
                    if (token != null) {
                      Navigator.pushNamed(context, LandingScreen.id);
                      selectedPageIndex = 0;
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}

login(email, password) async {
  final http.Response response = await http.post(
    Uri.http("10.0.2.2:5000", "/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  print(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);

  await prefs.setString('token', parse["token"]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignupScreen(), routes: {
      LandingScreen.id: (context) => LandingScreen(),
      LoginScreen.id: (context) => LoginScreen(),
      LogoutScreen.id: (context) => LogoutScreen(),
      ImageCapture.id: (context) => ImageCapture(),
      Uploader.id: (context) => Uploader(),
      ItemScreen.id: (context) => ItemScreen(),
      ItemDetailScreen.id: (context) => ItemDetailScreen(),
    });
  }
}

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
class SignupScreen extends StatelessWidget {
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    checkToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      if (token != null) {
        Navigator.pushNamed(context, LandingScreen.id);
      }
    }

    checkToken();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: ListView(
          restorationId: 'text_field_demo_list_view',
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                restorationId: 'email_address_text_field',
                placeholder: "Email",
                keyboardType: TextInputType.emailAddress,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                restorationId: 'login_password_text_field',
                placeholder: "Password",
                clearButtonMode: OverlayVisibilityMode.editing,
                obscureText: true,
                autocorrect: false,
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            TextButton.icon(
                onPressed: () async {
                  await signup(email, password);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString('token');
                  if (token != null) {
                    Navigator.pushNamed(context, LandingScreen.id);
                  }
                },
                icon: Icon(Icons.save),
                label: Text("Sign up")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: Text("login")),
          ],
        ),
      ),
    );
  }
}

signup(email, password) async {
  final http.Response response = await http.post(
    Uri.http("10.0.2.2:5000", "/signup"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  print(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);

  await prefs.setString('token', parse["token"]);
}

class ImageCapture extends StatefulWidget {
  static const String id = "ImageCapture";
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        toolbarColor: Colors.lightBlue,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop');

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            if (_imageFile != null) Image.file(_imageFile),
            Row(
              children: <Widget>[
                TextButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
              ],
            ),
            Uploader(file: _imageFile)
          ]),
      bottomNavigationBar: BottomNavWidget(),
    );
  }
}

class Uploader extends StatefulWidget {
  static const String id = "Uploader";
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  var name;
  var category;
  var keepdrop;
  var location;
  var details;

  File _image;
  final picker = ImagePicker();

  // #region howtouse_initState
  // @override
  // initState() {
  //   fetch();
  //   super.initState();
  // }
  // #endregion howtouse_initState

  Future<void> getImage() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  upload(
    File imageFile,
    String itemName,
    String itemCategory,
  ) async {
    //String itemKeepOrDrop, String itemLocation, String itemDetails) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://10.0.2.2:5000/upload");
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.fields['name'] = itemName.toString();
    request.fields['category'] = itemCategory.toString();
    // request.fields['keepdrop'] = itemKeepOrDrop.toString();
    // request.fields['location'] = itemLocation.toString();
    // request.fields['details'] = itemDetails.toString();

    /////// LATERRRRRRRRR ^^^^^^ /////////

    // multipart that takes file
    var multipartFile = new http.MultipartFile('myFile', stream, length,
        filename: path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      Navigator.pushNamed(context, ItemScreen.id);
    });
  }

  bool isloaded = false;
  var result;

  // #region retreivingImagesFromServer
  // fetch() async {
  //   var response =
  //       await http.get(Uri.parse("localhost:5000/image"));
  //   result = jsonDecode(response.body);
  //   print(result[0]['image']);
  //   setState(() {
  //     isloaded = true;
  //   });
  // }
  // #endregion retreivingImagesFromServer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.center),

            // Text and inputbox for image
            Text(
              "Select an image",
            ),
            SizedBox(
              height: 20,
            ),
            _image != null
                //? Image.network('http://10.0.2.2:5000/${result[0]['image']}')
                ? Image.file(_image)
                : CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),

            TextButton.icon(
                onPressed: () async => await getImage(),
                icon: Icon(Icons.upload_file),
                label: Text("Browse")),
            SizedBox(
              height: 20,
            ),

            /////////////// PICTURE DETAILS /////////////////////
            Text(
              "Item Name",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                restorationId: 'item_name',
                placeholder: "name",
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                onChanged: (value) {
                  name = value;
                },
              ),
            ),

            Text(
              "Item Category",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                restorationId: 'item_category',
                placeholder: "category",
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                onChanged: (value) {
                  category = value;
                },
              ),
            ),

            SizedBox(
              height: 20,
            ),

            TextButton.icon(
                onPressed: () => upload(_image, name, category),
                icon: Icon(Icons.upload_rounded),
                label: Text("Upload now")),
          ],
        ),
      ),
    );
  }
}
