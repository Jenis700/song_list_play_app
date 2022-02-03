import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CreateRemove extends StatefulWidget {
  const CreateRemove({Key? key}) : super(key: key);

  @override
  _CreateRemoveState createState() => _CreateRemoveState();
}

class _CreateRemoveState extends State<CreateRemove> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  TextEditingController _textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
        title: const Text(
          "Playlist",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: FutureBuilder<List<PlaylistModel>>(
                future: _audioQuery.queryPlaylists(
                  sortType: PlaylistSortType.DATE_ADDED,
                  orderType: OrderType.DESC_OR_GREATER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  if (item.data == null)
                    return const CircularProgressIndicator();

                  if (item.data!.isEmpty)
                    return Center(
                      child: const Text(
                        "Create your playlist!",
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    );

                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 80,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                          color: Colors.grey.shade200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.playlist_play_rounded, size: 36),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 220,
                                    child: Text(
                                      item.data![index].playlist,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Text(item.data![index].numOfSongs.toString()),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.amber.shade900,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _audioQuery
                                        .removePlaylist(item.data![index].id);
                                  });
                                },
                                highlightColor: Colors.black87.withOpacity(0.4),
                                splashColor: Colors.black87.withOpacity(0.4),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => Padding(
                    padding: const EdgeInsets.only(bottom: 200),
                    child: CupertinoActionSheet(
                      title: const Text('Choose Options'),
                      message: const Text('Your options are '),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: SizedBox(
                            width: 250,
                            // height: 50,
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: CupertinoTextFormFieldRow(
                                placeholder: "New PlayList",
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return "\nEnter your playlist name";
                                },
                                controller: _textEditingController,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                        CupertinoActionSheetAction(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _audioQuery.createPlaylist(
                                      "${_textEditingController.text}");
                                  print(
                                      "PlayList Create by Name  ::: ${_textEditingController.text} ");
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Create",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.amber.shade700),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Cancel'),
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                      ),
                    ),
                  ),
                );
              },
              child: Text("+ Create New PlayList"),
            ),
          ],
        ),
      ),
    );
  }
}
