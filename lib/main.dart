import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

import 'globals.dart' as globals;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignUpSection(), routes: {
      LandingScreen.id: (context) => LandingScreen(),
      LoginSection.id: (context) => LoginSection(),
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
class SignUpSection extends StatelessWidget {
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
                  Navigator.pushNamed(context, LoginSection.id);
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

class LoginSection extends StatelessWidget {
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
                      globals.selectedPageIndex = 0;
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

class LandingScreen extends StatelessWidget {
  static const String id = "LandingScreen";
  List<int> top = <int>[];
  List<int> bottom = <int>[0];

  @override
  List _buildList(int count) {
    List<Widget> listItems = List();
    for (int i = 0; i < count; i++) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            child: Card(
              color: Colors.grey.shade800,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Category ${i.toString()}',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue.shade200,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Categories'),
      ),
      body: CustomScrollView(
        slivers: [
          // Have to find a way to populate the list from DB
          SliverList(
            delegate: SliverChildListDelegate(_buildList(10)),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class _BottomNav extends StatefulWidget {
  const _BottomNav({Key key}) : super(key: key);

  @override
  __BottomNavState createState() => __BottomNavState();
}

/// This is the private State class that goes with _BottomNav.
class __BottomNavState extends State<_BottomNav> {
  void _onItemTapped(int index) {
    setState(() {
      globals.selectedPageIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, LandingScreen.id);
      }
      if (index == 1) {
        Navigator.pushNamed(context, ItemScreen.id);
      }
      if (index == 2) {
        Navigator.pushNamed(context, LogoutScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Items',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      currentIndex: globals.selectedPageIndex,
      selectedItemColor: Colors.blue[800],
      onTap: _onItemTapped,
    );
  }
}

class LogoutScreen extends StatelessWidget {
  static const String id = "LogoutScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Logout")),
          TextButton.icon(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', '');
                Navigator.pushNamed(context, LoginSection.id);
              },
              icon: Icon(Icons.send),
              label: Text("Logout"))
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
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
      bottomNavigationBar: _BottomNav(),
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

  upload(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://10.0.2.2:5000/upload");
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('myFile', stream, length,
        filename: path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    // print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      Navigator.pushNamed(context, ItemScreen.id);
    });
  }

  bool isloaded = false;
  var result;
  fetch() async {
    var response = await http.get(Uri.parse("http://10.0.2.2:5000/image"));
    result = jsonDecode(response.body);
    print(result[0]['image']);
    setState(() {
      isloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
          TextButton.icon(
              onPressed: () async => await getImage(),
              icon: Icon(Icons.upload_file),
              label: Text("Browse")),
          SizedBox(
            height: 20,
          ),

          /////////////// PICTURE DETAILS /////////////////////
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

          SizedBox(
            height: 20,
          ),

          TextButton.icon(
              onPressed: () => upload(_image),
              icon: Icon(Icons.upload_rounded),
              label: Text("Upload now")),
          isloaded
              ? Image.network('http://10.0.2.2:5000/${result[0]['image']}')
              : CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class ItemScreen extends StatelessWidget {
  static const String id = "ItemScreen";
  List _buildList(int count) {
    List<Widget> listItems = List();
    for (int i = 0; i < count; i++) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            child: Card(
              color: Colors.grey.shade800,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Item ${i.toString()}',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue.shade200,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Items'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              tooltip: 'Add Photo',
              onPressed: () => Navigator.pushNamed(context, Uploader.id),
            )
          ]),
      body: CustomScrollView(
        slivers: [
          // Have to find a way to populate the list from DB
          SliverList(
            delegate: SliverChildListDelegate(_buildList(10)),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  static const String id = "ItemDetailScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Items'),
      ),
      body: CustomScrollView(
        slivers: [
          // Going to use on the item page later
          SliverAppBar(
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'images/bg1.jpg',
                fit: BoxFit.cover,
              ),
              stretchModes: [
                StretchMode.zoomBackground,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}
