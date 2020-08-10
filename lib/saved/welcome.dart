import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:harmonoid/saved/savedalbumresults.dart';
import 'package:harmonoid/searchbar.dart';


class Welcome extends StatefulWidget {
  Welcome({Key key}) : super(key: key);
  _Welcome createState() => _Welcome();
}


class _Welcome extends State<Welcome> {

  GlobalKey<SearchState> _search = new GlobalKey<SearchState>();
  GlobalKey<SavedAlbumResultsState> _savedAlbumResultsKey = new GlobalKey<SavedAlbumResultsState>();
  ScrollController _albumsScrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    this._albumsScrollController..addListener(() {

      ScrollDirection currentScrollDirection;

      if (this._albumsScrollController.position.userScrollDirection == ScrollDirection.reverse && this._albumsScrollController.position.userScrollDirection != currentScrollDirection) {
        currentScrollDirection = ScrollDirection.reverse;
        _search.currentState.hideSearchBar();
      }
      else if (this._albumsScrollController.position.userScrollDirection == ScrollDirection.forward && this._albumsScrollController.position.userScrollDirection != currentScrollDirection) {
        currentScrollDirection = ScrollDirection.forward;
        _search.currentState.showSearchBar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => this._savedAlbumResultsKey.currentState.refresh(),
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SavedAlbumResults(scrollController : _albumsScrollController, key: _savedAlbumResultsKey,),
            Search(key: this._search),
          ],
        ),
      )
    );
  }
}