import 'package:flutter/material.dart';
import 'package:postvibs/sqllite/dataHelper.dart';
import 'package:postvibs/sqllite/sqlModel.dart';
import 'package:postvibs/home/videoList/videoProvider.dart';
import 'package:postvibs/home/videoList/listshow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDetails extends StatefulWidget {
  final String path;
  AddDetails({required this.path});

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String category;
  final db = SqliteHelper();
  late String location;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    location = position.latitude.toStringAsFixed(4) +
        ',' +
        position.longitude.toStringAsFixed(4);
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = VideoProvider();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Color.fromARGB(255, 30, 51, 99),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                const SizedBox(height: 30.0),
                const Text(
                  'Filled the Details of the Video here',
                  style: TextStyle(color: Color.fromARGB(255, 30, 51, 99)),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                const SizedBox(height: 60.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 30, 51, 99)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'give title to the video' : null,
                  onChanged: (val) {
                    setState(() {
                      title = val;
                    });
                  },
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 30, 51, 99)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'give description to the video' : null,
                  onChanged: (val) {
                    setState(() {
                      description = val;
                    });
                  },
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 30, 51, 99)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'give category to the video' : null,
                  onChanged: (val) {
                    setState(() {
                      category = val;
                    });
                  },
                ),
                const SizedBox(height: 40.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color?>(
                          const Color.fromARGB(255, 30, 51, 99)),
                    ),
                    child: const Text(
                      'save',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        db.insert(SqlModel(
                            id: 1,
                            title: title,
                            description: description,
                            category: category,
                            path: widget.path,
                            location: location));
                        videoProvider.add(SqlModel(
                            id: 1,
                            title: title,
                            description: description,
                            category: category,
                            path: widget.path,
                            location: location));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const listShow()),
                            (route) => false);
                      }
                    },
                  ),
                ),
              ]),
            )),
      ),
    );
  }
}
