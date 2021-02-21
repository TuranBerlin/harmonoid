import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:harmonoid/scripts/collection.dart';
import 'package:harmonoid/scripts/playback.dart';
import 'package:harmonoid/scripts/states.dart';
import 'package:harmonoid/language/constants.dart';


class CollectionTrackTile extends StatelessWidget {
  final Track track;
  final int index;
  CollectionTrackTile({Key key, @required this.track, this.index});

  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: () => this.index != null ? Playback.play(
          index: this.index,
          tracks: collection.tracks,
        ) : Playback.play(
          index: this.index,
          tracks: <Track>[this.track],
        ),
        dense: false,
        isThreeLine: true,
        leading: CircleAvatar(
          child: Text('${this.track.trackNumber ?? 1}'),
          backgroundImage: FileImage(collection.getAlbumArt(this.track)),
        ),
        title: Text(this.track.trackName),
        subtitle: Text(
          this.track.albumName + '\n' + 
          (this.track.trackArtistNames.length < 2 ? 
          this.track.trackArtistNames.join(', ') : 
          this.track.trackArtistNames.sublist(0, 2).join(', ')),
        ),
        trailing: PopupMenuButton(
          elevation: 2,
          color: Theme.of(context).appBarTheme.color,
          onSelected: (index) {
            switch(index) {
              case 0: {
                showDialog(
                  context: context,
                  builder: (subContext) => AlertDialog(
                    title: Text(
                      Constants.STRING_LOCAL_ALBUM_VIEW_TRACK_DELETE_DIALOG_HEADER,
                      style: Theme.of(subContext).textTheme.headline1,
                    ),
                    content: Text(
                      Constants.STRING_LOCAL_ALBUM_VIEW_TRACK_DELETE_DIALOG_BODY,
                      style: Theme.of(subContext).textTheme.headline5,
                    ),
                    actions: [
                      MaterialButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () async {
                          await collection.delete(this.track);
                          States.refreshCollectionMusic?.call();
                          States.refreshCollectionSearch?.call();
                          Navigator.of(subContext).pop();
                        },
                        child: Text(Constants.STRING_YES),
                      ),
                      MaterialButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: Navigator.of(subContext).pop,
                        child: Text(Constants.STRING_NO),
                      ),
                    ],
                  ),
                );
              }
              break;
              case 1: {
                Share.shareFiles(
                  [track.filePath],
                  subject: '${track.trackName} - ${track.albumName}. Shared using Harmonoid!',
                );
              }
              break;
              case 2: {
                showDialog(
                  context: context,
                  builder: (subContext) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    actionsPadding: EdgeInsets.zero,
                    title: Text(
                      Constants.STRING_PLAYLIST_ADD_DIALOG_TITLE,
                      style: Theme.of(subContext).textTheme.headline1,
                    ),
                    content: Container(
                      height: 280,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 24, top: 8, bottom: 16),
                            child: Text(
                              Constants.STRING_PLAYLIST_ADD_DIALOG_BODY,
                              style: Theme.of(subContext).textTheme.headline5,
                            ),
                          ),
                          Container(
                            height: 236,
                            width: 280,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
                                bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
                              )
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: collection.playlists.length,
                              itemBuilder: (BuildContext context, int playlistIndex) => ListTile(
                                title: Text(collection.playlists[playlistIndex].playlistName, style: Theme.of(context).textTheme.headline2),
                                leading: Icon(
                                  Icons.queue_music,
                                  size: Theme.of(context).iconTheme.size,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onTap: () async {
                                  await collection.playlistAddTrack(
                                  collection.playlists[playlistIndex],
                                  track,
                                  );
                                  Navigator.of(subContext).pop();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      MaterialButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: Navigator.of(subContext).pop,
                        child: Text(Constants.STRING_CANCEL),
                      ),
                    ],
                  ),
                );
              }
              break;
            }
          },
          icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color, size: Theme.of(context).iconTheme.size),
          tooltip: Constants.STRING_OPTIONS,
          itemBuilder: (_) => <PopupMenuEntry>[
            PopupMenuItem(
              value: 0,
              child: Text(Constants.STRING_DELETE),
            ),
            PopupMenuItem(
              value: 1,
              child: Text(Constants.STRING_SHARE),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(Constants.STRING_ADD_TO_PLAYLIST),
            ),
          ],
        ),
      ),
    );
  }
}


class LeadingCollectionTrackTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 16.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.file(
              collection.getAlbumArt(collection.lastTrack),
              fit: BoxFit.fitWidth,
              filterQuality: FilterQuality.low,
              alignment: Alignment.topCenter,
              height: 156.0,
              width: MediaQuery.of(context).size.width - 16.0,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async => await Playback.play(
                  index: collection.tracks.length - 1,
                  tracks: collection.tracks
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          child: Text('${collection.lastTrack.trackNumber ?? 1}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundImage: FileImage(collection.getAlbumArt(collection.lastTrack)),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Divider(
                              color: Colors.transparent,
                              height: 8.0,
                            ),
                            Text(
                              collection.lastTrack.trackName,
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                            ),
                            Text(
                              collection.lastTrack.albumName,
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                            ),
                            Text(
                              collection.lastTrack.trackArtistNames.length < 2 ? 
                              collection.lastTrack.trackArtistNames.join(', ') : 
                              collection.lastTrack.trackArtistNames.sublist(0, 2).join(', '),
                              style: Theme.of(context).textTheme.headline5,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 0.0, right: 16.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow_outlined,
                            color: Theme.of(context).accentColor,
                            size: 28.0,
                          ),
                          onPressed: null
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}