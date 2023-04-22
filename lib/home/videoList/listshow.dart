import 'package:flutter/material.dart';
import 'package:postvibs/home/videoList/videoProvider.dart';
import 'package:postvibs/home/addingVideo/videoPage.dart';
import 'package:postvibs/home/addingVideo/addVideo.dart';
import 'package:provider/provider.dart';
import 'package:postvibs/home/videoList/searchlist.dart';

class listShow extends StatefulWidget {
  const listShow({super.key});

  @override
  State<listShow> createState() => _listShowState();
}

class _listShowState extends State<listShow> {
  @override
  void initState() {
    super.initState();
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 46, 58),
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchList()));
            },
            child: const Icon(Icons.search_outlined),
          ),
          title: const Text('Videos'),
          backgroundColor: Colors.transparent,
          elevation: 222,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              // pass the adding video screen here
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddVideos()));
              },
            ),
          ]),
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, _) {
          if (videoProvider.list.isEmpty) {
            return Center(
                child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'No is video available',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'click add button in appBar',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ));
          } else {
            return ListView.builder(
              // itemCount: videoProvider.searchResult.length,
              itemCount: videoProvider.list.length,
              itemBuilder: (context, index) {
                final video = videoProvider.list[index];
                // final video = videoProvider.searchResult[index];
                return Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    // color: Color.fromARGB(255, 56, 54, 54),
                    color: Color.fromARGB(255, 43, 49, 63),
                    borderRadius: BorderRadius.circular(11.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          Text(
                            video.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(video.location,
                                      style: const TextStyle(
                                          color: Colors.white)))),
                        ],
                      ),
                    ),
                    subtitle: Text(video.description,
                        style: const TextStyle(color: Colors.white)),
                    trailing: Text(video.category,
                        style: const TextStyle(color: Colors.white)),

                    //onTap: show preview there,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VideoPage(filePath: video.path)));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
