import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Artist extends StatefulWidget {
  const Artist({Key? key}) : super(key: key);

  @override
  _ArtistState createState() => _ArtistState();
}

class _ArtistState extends State<Artist> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
        title: const Text(
          "Artist",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 5,
      ),
      body: FutureBuilder<List>(
        // Default values:
        future: _audioQuery.queryArtists(
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: ArtistSortType.ARTIST,
          uriType: UriType.EXTERNAL,
        ),
        builder: (context, item) {
          if (item.data == null) return const CircularProgressIndicator();

          if (item.data!.isEmpty) return const Text("Nothing found!");

          return ListView.builder(
            itemCount: item.data!.length,
            // gridDelegate:
            //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.all(2.5),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  height: 160,
                  decoration:
                      BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  child: Text(
                    item.data![index].artist.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
