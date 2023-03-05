import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '../pages/delete_page.dart';
import '../utils/custom_snackbar.dart';
import '../utils/custom_themes.dart';
import '../utils/sftp_requests.dart';
import '../utils/custom_search.dart';

class RomsPage extends StatefulWidget {
  final bool? fav;
  final String? name;
  final num? width;
  const RomsPage({Key? key, this.fav, this.name, this.width}) : super(key: key);

  @override
  State<RomsPage> createState() => _RomsPageState();
}

class _RomsPageState extends State<RomsPage> {
  int _itemCount = 0;
  int _currentIndex = 0;

  num? _widthScreen = 0;

  String? _systemName = '';

  bool _isLoading = true;
  bool _isFetching = false;
  bool _isFetchingMore = false;
  bool _isDone = false;
  bool? _isFavorite = false;

  List<String>? _romsList = [];
  List<String>? _romsFilter = [];

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _searchKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _globalScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final FocusNode _searchNode = FocusNode();
  final SFTPRequests _requests = SFTPRequests();
  final CustomThemes _customTheme = CustomThemes();

  void _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  void _loadRoms() async {
    setState(() {
      _isFetching = true;
    });
    List<String>? listTemp = await _requests.loadRoms(_systemName);
    if (listTemp == null) {
      setState(() {
        listTemp = [];
      });

      CustomSnackbar.showErrorSnackBar(_globalScaffoldKey);
    }
    setState(() {
      _romsList = listTemp;
      _romsFilter = _romsList;
    });

    if (_romsFilter!.length > _widthScreen!) {
      setState(() {
        _itemCount = _widthScreen!.toInt();
      });
    } else {
      setState(() {
        _itemCount = _romsFilter!.length;
      });
    }
    setState(() {
      _isFetching = false;
    });
  }

  void _getMoreRoms() {
    setState(() {
      _isFetchingMore = true;
    });

    if (_romsFilter!.length > _romsFilter!.length - _itemCount) {
      if (_romsFilter!.length - _itemCount > _widthScreen!) {
        setState(() {
          _itemCount = _itemCount + _widthScreen!.toInt();
        });
      } else {
        setState(() {
          _itemCount = _itemCount + (_romsFilter!.length - _itemCount);
        });
      }
    }

    setState(() {
      _isFetchingMore = false;
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.extentAfter <= 30 &&
        _itemCount != _romsList!.length) {
      _getMoreRoms();
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _widthScreen = widget.width;
    _systemName = widget.name;
    _isFavorite = widget.fav;
    _loadRoms();
    _searchNode.addListener(_onOnFocusNodeEvent);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _searchNode.removeListener(_onOnFocusNodeEvent);
    _searchNode.dispose();
  }

  void _onItemChanged(String filterValue) {
    _applyFilter(filterValue);

    if (_romsList!.isNotEmpty) {
      if (_searchController.text.isEmpty &&
          _romsList!.length > _widthScreen!.toInt()) {
        setState(() {
          _itemCount = _widthScreen!.toInt();
        });
      } else {
        setState(() {
          _itemCount = _romsFilter!.length;
        });
      }
    } else {
      setState(() {
        _itemCount = 0;
      });
    }
  }

  void _applyFilter(String filterValue) {
    setState(() {
      _romsFilter = CustomSearch.defineSearch(filterValue, _romsList)
          .map((result) => result.item)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _globalScaffoldKey,
        child: Scaffold(
          body: NestedScrollView(
              controller: _scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      leading: IconButton(
                          tooltip: "backTooltip".i18n(),
                          splashRadius: 16.0,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            Navigator.pop(context);
                          }),
                      actions: <Widget>[
                        AbsorbPointer(
                            absorbing: !_isLoading,
                            child: IconButton(
                                tooltip: "binTooltip".i18n(),
                                splashRadius: 16.0,
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DeletePage(width: _widthScreen)),
                                    ).then((value) {
                                      setState(() {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      });
                                    });
                                    _globalScaffoldKey.currentState!
                                        .removeCurrentSnackBar();
                                  }
                                }))
                      ],
                      floating: _customTheme.isBarPinned(_romsFilter!.length,
                          _widthScreen!, _searchNode.hasFocus),
                      pinned: _customTheme.isBarPinned(_romsFilter!.length,
                          _widthScreen!, _searchNode.hasFocus),
                      forceElevated: true,
                      title: SizedBox(
                        height: 40,
                        child: TextField(
                          autocorrect: false,
                          enableSuggestions: false,
                          focusNode: _searchNode,
                          key: _searchKey,
                          controller: _searchController,
                          onChanged: _onItemChanged,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              filled: true,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? Material(
                                      shape: const CircleBorder(),
                                      child: IconButton(
                                        tooltip: "clearTooltip".i18n(),
                                        splashRadius: 16.0,
                                        padding:
                                            const EdgeInsets.only(bottom: 0.0),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _onItemChanged(
                                                _searchController.text);
                                          });
                                        },
                                        icon: const Icon(Icons.clear),
                                      ))
                                  : null,
                              hintText: "searchHint".i18n()),
                        ),
                      )),
                ];
              },
              body: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _isFetching = true;
                    });
                    _romsList = await _requests.loadRoms(_systemName);
                    if (_romsList == null) {
                      setState(() {
                        _romsList = [];
                      });
                      CustomSnackbar.showErrorSnackBar(_globalScaffoldKey);
                    }
                    _onItemChanged(_searchController.text);
                    setState(() {
                      _isFetching = false;
                    });
                  },
                  child: NotificationListener<ScrollNotification>(
                      onNotification: _handleScrollNotification,
                      child: ListView(
                          padding: const EdgeInsets.only(top: 35, bottom: 5),
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      _isFavorite == true
                                          ? const Positioned(
                                              top: 0,
                                              right: 0,
                                              left: 60,
                                              child: Icon(Icons.star,
                                                  color: Colors.amber))
                                          : Container(),
                                      Column(children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Image.asset(
                                              "assets/misc.png",
                                              scale: 6.0,
                                            )),
                                        Text(_systemName!.toUpperCase())
                                      ])
                                    ])),
                            Column(
                              children: [
                                Text(
                                  "romsLabel".i18n(),
                                  style: const TextStyle(fontSize: 8.5),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 25, top: 5),
                                    child: Text("(${_romsList!.length})",
                                        style: const TextStyle(fontSize: 8.5))),
                                !_isFetching
                                    ? _romsFilter!.isNotEmpty
                                        ? Card(
                                            color: _customTheme
                                                    .isDarkTheme(context)
                                                ? const Color(0xFF1A1A1A)
                                                    .withOpacity(0.6)
                                                : const Color(0xFFF2F2F2)
                                                    .withOpacity(0.6),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.all(10),
                                              itemCount: _itemCount,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    child: Dismissible(
                                                      key: UniqueKey(),
                                                      direction:
                                                          DismissDirection
                                                              .endToStart,
                                                      onDismissed: (_) async {
                                                        String? nameRom =
                                                            _romsFilter![index];
                                                        _isDone = await _requests
                                                            .moveToBin(
                                                                _romsFilter![
                                                                    index],
                                                                _systemName);
                                                        if (_isDone == true) {
                                                          setState(() {
                                                            _currentIndex =
                                                                _romsList!.indexOf(
                                                                    _romsFilter![
                                                                        index]);
                                                            _romsList!.remove(
                                                                _romsFilter![
                                                                    index]);

                                                            _itemCount--;
                                                            _isDone = false;
                                                          });
                                                          _applyFilter(
                                                              _searchController
                                                                  .text);
                                                          CustomSnackbar.showSnackBar(
                                                              _globalScaffoldKey,
                                                              "movedToBinSnackBar"
                                                                  .i18n(),
                                                              action:
                                                                  SnackBarAction(
                                                                      label: "undoButton"
                                                                          .i18n(),
                                                                      onPressed:
                                                                          () async {
                                                                        _isDone = await _requests.undo(
                                                                            nameRom,
                                                                            _systemName);
                                                                        if (_isDone ==
                                                                            true) {
                                                                          setState(
                                                                              () {
                                                                            _romsList!.insert(_currentIndex,
                                                                                nameRom);

                                                                            _itemCount++;
                                                                            _isDone =
                                                                                false;
                                                                          });
                                                                          _applyFilter(
                                                                              _searchController.text);
                                                                        } else {
                                                                          _applyFilter(
                                                                              _searchController.text);

                                                                          CustomSnackbar.showErrorSnackBar(
                                                                              _globalScaffoldKey);
                                                                        }
                                                                      }));
                                                        } else {
                                                          _applyFilter(
                                                              _searchController
                                                                  .text);
                                                          CustomSnackbar
                                                              .showErrorSnackBar(
                                                                  _globalScaffoldKey);
                                                        }
                                                      },
                                                      background: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          3.0)),
                                                          color: Colors.red,
                                                          shape: BoxShape
                                                              .rectangle,
                                                        ),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              const Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Text(
                                                                ' ${"deleteDismissible".i18n()}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        8.5),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      child: Material(
                                                        elevation: 6.0,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    3.0)),
                                                        child: ListTile(
                                                          horizontalTitleGap:
                                                              10,
                                                          dense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          leading: Container(
                                                            height:
                                                                double.infinity,
                                                            width: 50,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                3.0),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                3.0)),
                                                                    gradient:
                                                                        LinearGradient(
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                      colors: [
                                                                        Color.fromRGBO(
                                                                            15,
                                                                            12,
                                                                            41,
                                                                            1),
                                                                        Color.fromRGBO(
                                                                            48,
                                                                            43,
                                                                            99,
                                                                            1),
                                                                        Color.fromRGBO(
                                                                            36,
                                                                            36,
                                                                            62,
                                                                            1)
                                                                      ],
                                                                    )),
                                                            child: Center(
                                                                child: Text(
                                                              _romsFilter![
                                                                      index]
                                                                  .substring(
                                                                      (_romsFilter![index].lastIndexOf(
                                                                              ".") +
                                                                          1),
                                                                      _romsFilter![
                                                                              index]
                                                                          .length)
                                                                  .toUpperCase(),
                                                              maxLines: 1,
                                                              style: const TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: 6.5,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                          ),
                                                          title: Text(
                                                            _romsFilter![index]
                                                                .substring(
                                                                    0,
                                                                    _romsFilter![
                                                                            index]
                                                                        .lastIndexOf(
                                                                            ".")),
                                                            maxLines: 3,
                                                            style: const TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                height: 1.5,
                                                                fontSize: 8.5),
                                                          ),
                                                          trailing: Container(
                                                              width: 50,
                                                              height: double
                                                                  .infinity,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      left: BorderSide(
                                                                          width:
                                                                              0.1,
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .color!))),
                                                              child:
                                                                  const Center(
                                                                      child:
                                                                          Icon(
                                                                Icons
                                                                    .arrow_back,
                                                              ))),
                                                        ),
                                                      ),
                                                    ));
                                              },
                                            ))
                                        : Container()
                                    : const Padding(
                                        padding: EdgeInsets.only(top: 25),
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
                                !_isFetchingMore &&
                                        !_isFetching &&
                                        _itemCount != _romsFilter!.length
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: CircularProgressIndicator())
                                    : Container()
                              ],
                            )
                          ])))),
        ));
  }
}
