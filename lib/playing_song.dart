import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayingNow extends StatelessWidget {
  PlayingNow({
    Key? key,
  }) : super(key: key);

  final OnAudioQuery _audioQuery = OnAudioQuery();
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AlbumModel>>(
        future: _audioQuery.queryAlbums(
          sortType: AlbumSortType.ALBUM,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // Container(
                    //   child: Uri.parse("uri"),
                    // ),
                  ],
                );
              });
        },
      ),
    );
  }
}
