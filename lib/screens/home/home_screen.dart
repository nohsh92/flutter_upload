import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loginpage/widgets/bottom_nav_widget.dart';

class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  List _buildList(int count) {
    List<Widget> listItems = [];
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
        title: const Text('Home Screen'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FutureBuilder(
                future: http.read((Uri.http(dotenv.env['NODESERVER'], "/data")),
                    headers: {"Authorization": jwt}),
                builder: (context, snapshot) => snapshot.hasData
                    ? Column(
                        children: <Widget>[
                          Text("${payload['email']}, here's the data:"),
                          Text(snapshot.data,
                              style: Theme.of(context).textTheme.headline4)
                        ],
                      )
                    : snapshot.hasError
                        ? Text("An error occurred")
                        : CircularProgressIndicator()),
          ),
          // Have to find a way to populate the list from DB
          SliverList(
            delegate: SliverChildListDelegate(_buildList(10)),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(),
    );
  }

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       appBar: AppBar(title: Text("Secret Data Screen")),
  //       body: Center(
  //         child: FutureBuilder(
  //             future: http.read((Uri.http(dotenv.env['NODESERVER'], "/data")),
  //                 headers: {"Authorization": jwt}),
  //             builder: (context, snapshot) => snapshot.hasData
  //                 ? Column(
  //                     children: <Widget>[
  //                       Text("${payload['email']}, here's the data:"),
  //                       Text(snapshot.data,
  //                           style: Theme.of(context).textTheme.headline4)
  //                     ],
  //                   )
  //                 : snapshot.hasError
  //                     ? Text("An error occurred")
  //                     : CircularProgressIndicator()),
  //       ),
  //     );
}
