import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '../utils/custom_snackbar.dart';
import '../utils/custom_themes.dart';
import '../utils/sftp_requests.dart';
import '../utils/custom_search.dart';

class DeletePage extends StatefulWidget {
  final num? width;
  const DeletePage({super.key, this.width});
  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  int _itemCount = 0;
  num? _widthScreen = 0;

  List<String>? _deleteRomsList = [];
  List<String>? _deleteRomsFilter = [];

  bool _isExtendApp = true;
  bool _isFetching = false;
  bool _isFetchingMore = false;
  bool _isDone = false;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _searchKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _globalScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final FocusNode _searchNode = FocusNode();
  final SFTPRequests _requests = SFTPRequests();
  final CustomThemes _customTheme = CustomThemes();

  Color? _searchPrefixIconColor() {
    return _searchNode.hasFocus ? Colors.deepPurple : null;
  }

  void _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  void _loadRoms() async {
    setState(() {
      _isFetching = true;
    });

    List<String>? listTemp = await _requests.loadBin();
    if (listTemp == null) {
      setState(() {
        listTemp = [];
      });

      CustomSnackbar.showErrorSnackBar(_globalScaffoldKey);
    }
    setState(() {
      _deleteRomsList = listTemp;
      _deleteRomsFilter = _deleteRomsList;
    });
    if (_deleteRomsFilter!.length > _widthScreen!) {
      setState(() {
        _itemCount = _widthScreen!.toInt();
      });
    } else {
      setState(() {
        _itemCount = _deleteRomsFilter!.length;
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

    if (_deleteRomsFilter!.length > _deleteRomsFilter!.length - _itemCount) {
      if (_deleteRomsFilter!.length - _itemCount > _widthScreen!) {
        setState(() {
          _itemCount = _itemCount + _widthScreen!.toInt();
        });
      } else {
        setState(() {
          _itemCount = _itemCount + (_deleteRomsFilter!.length - _itemCount);
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
        _itemCount != _deleteRomsList!.length) {
      _getMoreRoms();
    }
    if (notification.metrics.pixels > 50) {
      setState(() {
        _isExtendApp = false;
      });
    } else {
      setState(() {
        _isExtendApp = true;
      });
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _widthScreen = widget.width;
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

  void _onItemChanged(String value) {
    _applyFilter(value);

    if (_deleteRomsList!.isNotEmpty) {
      if (_searchController.text.isEmpty &&
          _deleteRomsList!.length > _widthScreen!.toInt()) {
        setState(() {
          _itemCount = _widthScreen!.toInt();
        });
      } else {
        setState(() {
          _itemCount = _deleteRomsFilter!.length;
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
      _deleteRomsFilter = CustomSearch.defineSearch(
        filterValue,
        _deleteRomsList,
      ).map((result) => result.item).toList();
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    return ScaffoldMessenger(
      key: _globalScaffoldKey,
      child: Scaffold(
        floatingActionButton: Material(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          elevation: 6.0,
          child: Ink(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(15, 12, 41, 1),
                  Color.fromRGBO(48, 43, 99, 1),
                  Color.fromRGBO(36, 36, 62, 1),
                ],
              ),
            ),
            child: FloatingActionButton.extended(
              extendedPadding: _isExtendApp
                  ? const EdgeInsetsDirectional.only(start: 20.0, end: 20.0)
                  : const EdgeInsetsDirectional.all(0.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("dialogTitle".i18n()),
                    content: Text("dialogContent".i18n()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("cancelButton".i18n()),
                      ),
                      Material(
                        color: Colors.transparent,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        elevation: 3.0,
                        child: Ink(
                          padding: const EdgeInsets.all(0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(15, 12, 41, 1),
                                Color.fromRGBO(48, 43, 99, 1),
                                Color.fromRGBO(36, 36, 62, 1),
                              ],
                            ),
                          ),
                          child: InkWell(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            onTap: () async {
                              _isDone = await _requests.deleteRoms(
                                _deleteRomsList,
                              );
                              if (_isDone == true) {
                                List? toRemove = [];
                                setState(() {
                                  for (var element in _deleteRomsList!) {
                                    toRemove.add(element);
                                  }
                                  _deleteRomsList!.removeWhere(
                                    (e) => toRemove.contains(e),
                                  );

                                  _itemCount = 0;
                                  _isDone = false;
                                });
                                _applyFilter(_searchController.text);

                                CustomSnackbar.showSnackBar(
                                  _globalScaffoldKey,
                                  "deleteAllSnackBar".i18n(),
                                );
                              } else {
                                _applyFilter(_searchController.text);

                                CustomSnackbar.showErrorSnackBar(
                                  _globalScaffoldKey,
                                );
                              }
                              if (context.mounted) {
                                Navigator.of(buildContext).pop();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Text(
                                "confirmButton".i18n(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              label: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            child: child,
                          ),
                        ),
                child: !_isExtendApp
                    ? const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(Icons.delete_forever, color: Colors.white),
                      )
                    : Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "deleteButton".i18n(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: const [
                  IconButton(
                    onPressed: null,
                    icon: Icon(Icons.add_box, color: Colors.transparent),
                  ),
                ],
                leading: IconButton(
                  tooltip: "backTooltip".i18n(),
                  splashRadius: 16.0,
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    Navigator.pop(context);
                  },
                ),
                floating: _customTheme.isBarPinned(
                  _deleteRomsFilter!.length,
                  _widthScreen!,
                  _searchNode.hasFocus,
                ),
                pinned: _customTheme.isBarPinned(
                  _deleteRomsFilter!.length,
                  _widthScreen!,
                  _searchNode.hasFocus,
                ),
                forceElevated: true,
                title: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                  color: Colors.transparent,
                  elevation: 6.0,
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      autocorrect: false,
                      enableSuggestions: false,
                      key: _searchKey,
                      controller: _searchController,
                      focusNode: _searchNode,
                      onChanged: _onItemChanged,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: _searchPrefixIconColor(),
                        ),
                        suffixIcon: !(_searchController.text == "")
                            ? IconButton(
                                splashRadius: 16.0,
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _onItemChanged(_searchController.text);
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        hintText: "searchHint".i18n(),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isFetching = true;
              });
              _deleteRomsList = await _requests.loadBin();
              if (_deleteRomsList == null) {
                setState(() {
                  _deleteRomsList = [];
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Image.asset("assets/bin.png", scale: 5.0),
                        ),
                        Text(
                          "recycleBinTitle".i18n(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "romsLabel".i18n(),
                        style: const TextStyle(fontSize: 12.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25, top: 5),
                        child: Text(
                          "(${_deleteRomsList!.length})",
                          style: const TextStyle(fontSize: 8.5),
                        ),
                      ),
                      !_isFetching
                          ? _deleteRomsFilter!.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(10),
                                    itemCount: _itemCount,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 5,
                                        ),
                                        child: Dismissible(
                                          key: UniqueKey(),
                                          direction:
                                              DismissDirection.horizontal,
                                          onDismissed: (DismissDirection direction) async {
                                            if (direction ==
                                                DismissDirection.startToEnd) {
                                              _isDone = await _requests.saveRom(
                                                _deleteRomsFilter![index],
                                              );

                                              if (_isDone == true) {
                                                setState(() {
                                                  _deleteRomsList!.remove(
                                                    _deleteRomsFilter![index],
                                                  );

                                                  _itemCount--;
                                                  _isDone = false;
                                                });
                                                _applyFilter(
                                                  _searchController.text,
                                                );

                                                CustomSnackbar.showSnackBar(
                                                  _globalScaffoldKey,
                                                  "saveSnackBar".i18n(),
                                                );
                                              } else {
                                                _applyFilter(
                                                  _searchController.text,
                                                );

                                                CustomSnackbar.showErrorSnackBar(
                                                  _globalScaffoldKey,
                                                );
                                              }
                                            } else {
                                              _isDone = await _requests
                                                  .deleteRom(
                                                    _deleteRomsFilter![index],
                                                  );

                                              if (_isDone == true) {
                                                setState(() {
                                                  _deleteRomsList!.remove(
                                                    _deleteRomsFilter![index],
                                                  );

                                                  _itemCount--;
                                                  _isDone = false;
                                                });
                                                _applyFilter(
                                                  _searchController.text,
                                                );

                                                CustomSnackbar.showSnackBar(
                                                  _globalScaffoldKey,
                                                  "deleteSnackBar".i18n(),
                                                );
                                              } else {
                                                _applyFilter(
                                                  _searchController.text,
                                                );

                                                CustomSnackbar.showErrorSnackBar(
                                                  _globalScaffoldKey,
                                                );
                                              }
                                            }
                                          },
                                          secondaryBackground: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.0),
                                              ),
                                              color: Colors.red,
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    ' ${"deleteDismissible".i18n()}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  const SizedBox(width: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                          background: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.0),
                                              ),
                                              color: Colors.lightGreen,
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  const SizedBox(width: 20),
                                                  Text(
                                                    '${"restoreDismissible".i18n()} ',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  const Icon(
                                                    Icons.verified_user,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          child: Material(
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(6.0),
                                                ),
                                            elevation: 6.0,
                                            child: IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    decoration: const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  6.0,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  6.0,
                                                                ),
                                                          ),
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Color.fromRGBO(
                                                            15,
                                                            12,
                                                            41,
                                                            1,
                                                          ),
                                                          Color.fromRGBO(
                                                            48,
                                                            43,
                                                            99,
                                                            1,
                                                          ),
                                                          Color.fromRGBO(
                                                            36,
                                                            36,
                                                            62,
                                                            1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        _deleteRomsFilter![index]
                                                                .contains(".")
                                                            ? _deleteRomsFilter![index]
                                                                      .contains(
                                                                        "libretro",
                                                                      )
                                                                  ? "lib"
                                                                        .toUpperCase()
                                                                  : _deleteRomsFilter![index]
                                                                        .substring(
                                                                          (_deleteRomsFilter![index].lastIndexOf(
                                                                                ".",
                                                                              ) +
                                                                              1),
                                                                          _deleteRomsFilter![index]
                                                                              .length,
                                                                        )
                                                                        .toUpperCase()
                                                            : "",
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          letterSpacing: 1,
                                                          fontSize: 12.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            10.0,
                                                          ),
                                                      child: Text(
                                                        _deleteRomsFilter![index]
                                                                .contains(".")
                                                            ? _deleteRomsFilter![index]
                                                                  .substring(
                                                                    0,
                                                                    _deleteRomsFilter![index]
                                                                        .lastIndexOf(
                                                                          ".",
                                                                        ),
                                                                  )
                                                            : _deleteRomsFilter![index],
                                                        maxLines: 3,
                                                        style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          height: 1.5,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 50,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.swap_horiz,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container()
                          : const Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                      !_isFetchingMore &&
                              !_isFetching &&
                              _itemCount != _deleteRomsFilter!.length
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CircularProgressIndicator(),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
