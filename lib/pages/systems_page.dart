import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '../pages/delete_page.dart';
import '../utils/custom_icons.dart';
import '../utils/custom_themes.dart';
import '../utils/widgets_size.dart';
import '../utils/custom_search.dart';
import '../utils/custom_snackbar.dart';
import '../utils/preferences_requests.dart';
import 'roms_page.dart';

class SystemsPage extends StatefulWidget {
  final List<String>? data;
  final String? soft;
  final num? width;
  const SystemsPage({super.key, this.data, this.soft, this.width});

  @override
  State<SystemsPage> createState() => _SystemsPageState();
}

class _SystemsPageState extends State<SystemsPage> {
  String? _favSystemsKey = "";

  bool _isLoading = true;

  num? _widthScreen = 0;
  List<String>? _systemsList = [];
  List<String>? _systemsFilter = [];
  List<String>? _favSystemsList = [];
  List<String>? _favSystemsFilter = [];

  Size _objectSize = const Size(0, 0);

  final PreferencesRequests _prefsRequests = PreferencesRequests();
  final CustomThemes _customTheme = CustomThemes();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollViewController = ScrollController();
  final GlobalKey<FormState> _searchKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _globalScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final FocusNode _searchNode = FocusNode();

  void _loadFavSystems() async {
    _favSystemsList = await _prefsRequests.loadListPreferences(_favSystemsKey!);
    setState(() {
      _favSystemsList ??= [];
      _favSystemsFilter = _favSystemsList;
    });
    _updateFilterWithFav();
  }

  void _setFavSystems() {
    _prefsRequests.setListPreferences(_favSystemsKey!, _favSystemsList!);
  }

  Color? _searchPrefixIconColor() {
    return _searchNode.hasFocus ? Colors.deepPurple : null;
  }

  void _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _favSystemsKey = widget.soft;
    _systemsList = widget.data;
    _widthScreen = widget.width;
    _systemsFilter = _systemsList;
    _loadFavSystems();
    _searchNode.addListener(_onOnFocusNodeEvent);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _scrollViewController.dispose();
    _searchNode.removeListener(_onOnFocusNodeEvent);
    _searchNode.dispose();
  }

  void _applyFilter(String filter) {
    setState(() {
      _systemsFilter = CustomSearch.defineSearch(filter, _systemsList)
          .where((result) => !(_favSystemsList!.contains(result.item)))
          .map((result) => result.item)
          .toList();

      _favSystemsFilter = CustomSearch.defineSearch(
        filter,
        _favSystemsList,
      ).map((result) => result.item).toList();
    });
  }

  void _updateFilterWithFav() {
    setState(() {
      _systemsFilter = _systemsList!
          .where((string) => !(_favSystemsList!.contains(string)))
          .toList();
    });
  }

  String _softChoiceImage() {
    switch (_favSystemsKey!) {
      case "Batocera":
        return "assets/batocera.png";
      case "Recalbox":
        return _customTheme.isDarkTheme(context)
            ? "assets/recalbox_dark.png"
            : "assets/recalbox_light.png";
      case "RetroPie":
        return "assets/retropie.png";
      case "Lakka":
        return "assets/lakka.png";
      default:
        return "assets/recalbox_light.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _globalScaffoldKey,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
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
                actions: [
                  _systemsList!.contains("55,35fZ_gv~*DFBgP6x;")
                      ? const IconButton(
                          onPressed: null,
                          icon: Icon(Icons.add_box, color: Colors.transparent),
                        )
                      : AbsorbPointer(
                          absorbing: !_isLoading,
                          child: IconButton(
                            tooltip: "binTooltip".i18n(),
                            splashRadius: 16.0,
                            color: Colors.white,
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              num size =
                                  (MediaQuery.of(context).size.width / 10) ~/ 3;
                              setState(() {
                                _isLoading = false;
                              });

                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeletePage(width: size),
                                  ),
                                ).then((value) => didChangeDependencies());
                                _globalScaffoldKey.currentState!
                                    .removeCurrentSnackBar();
                              }
                            },
                          ),
                        ),
                ],
                floating: _customTheme.isBarPinned(
                  _systemsFilter!.length,
                  _widthScreen!,
                  _searchNode.hasFocus,
                ),
                pinned: _customTheme.isBarPinned(
                  _systemsFilter!.length,
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
                      focusNode: _searchNode,
                      key: _searchKey,
                      controller: _searchController,
                      onChanged: _applyFilter,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: _searchPrefixIconColor(),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? Material(
                                shape: const CircleBorder(),
                                child: IconButton(
                                  tooltip: "clearTooltip".i18n(),
                                  splashRadius: 16.0,
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  onPressed: () {
                                    _searchController.clear();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    _applyFilter(_searchController.text);
                                  },
                                  icon: const Icon(Icons.clear),
                                ),
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
          body: ListView(
            padding: const EdgeInsets.only(top: 35, bottom: 5),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image.asset(_softChoiceImage(), scale: 5.0),
                    ),
                    Text(
                      _favSystemsKey!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              _favSystemsFilter!.isNotEmpty
                  ? Column(
                      children: [
                        Text("favoriteSystemsLabel".i18n()),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25, top: 5),
                          child: Text(
                            "(${_favSystemsList!.length})",
                            style: const TextStyle(fontSize: 8.5),
                          ),
                        ),
                        SizedBox(
                          height: _objectSize.height,
                          child: GridView.count(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            physics: const BouncingScrollPhysics(),
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: _favSystemsFilter!.map((f) {
                              return Material(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                elevation: 6.0,
                                child: AbsorbPointer(
                                  absorbing: !_isLoading,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(6.0),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RomsPage(
                                              fav: true,
                                              width: _widthScreen,
                                              name: f,
                                            ),
                                          ),
                                        ).then(
                                          (value) => didChangeDependencies(),
                                        );
                                        _globalScaffoldKey.currentState!
                                            .removeCurrentSnackBar();
                                      }
                                    },
                                    enableFeedback: true,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Icon(
                                                CustomIcons.imageMap
                                                        .containsKey(f)
                                                    ? CustomIcons.imageMap[f]!
                                                    : CustomIcons.misc,
                                                color:
                                                    _customTheme.isDarkTheme(
                                                      context,
                                                    )
                                                    ? Colors.white
                                                    : Colors.deepPurple[900],
                                                size: 48,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.0,
                                              child: Ink(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                              6.0,
                                                            ),
                                                        bottomRight:
                                                            Radius.circular(
                                                              6.0,
                                                            ),
                                                      ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
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
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                        ),
                                                    child: Text(
                                                      f.toUpperCase(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          right: -7,
                                          top: -7,
                                          child: IconButton(
                                            tooltip: "favSystemsTooltip".i18n(),
                                            splashRadius: 16.0,
                                            onPressed: () {
                                              setState(() {
                                                _favSystemsList!.remove(f);
                                              });
                                              _applyFilter(
                                                _searchController.text,
                                              );
                                              _setFavSystems();

                                              CustomSnackbar.showSnackBar(
                                                _globalScaffoldKey,
                                                "removeFavoriteSnackBar".i18n(),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 50,
                            right: 50,
                            top: 25,
                          ),
                          child: Container(
                            height: 0.4,
                            color: _customTheme.isDarkTheme(context)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              _systemsFilter!.isNotEmpty
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: _favSystemsFilter!.isNotEmpty ? 25 : 0,
                          ),
                          child: Text("systemsLabel".i18n()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25, top: 5),
                          child: Text(
                            "(${_systemsList!.length})",
                            style: const TextStyle(fontSize: 8.5),
                          ),
                        ),
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: (_widthScreen!.toInt() ~/ 4),
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          padding: const EdgeInsets.all(10),
                          shrinkWrap: true,
                          children: _systemsFilter!.map((f) {
                            return WidgetsSize(
                              onChange: (Size size) {
                                setState(() {
                                  _objectSize = size;
                                });
                              },
                              child: Material(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                elevation: 6.0,
                                child: AbsorbPointer(
                                  absorbing: !_isLoading,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(6.0),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RomsPage(
                                              width: _widthScreen,
                                              name: f,
                                            ),
                                          ),
                                        ).then(
                                          (value) => didChangeDependencies(),
                                        );
                                        _globalScaffoldKey.currentState!
                                            .removeCurrentSnackBar();
                                      }
                                    },
                                    enableFeedback: true,
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Expanded(
                                              child: Icon(
                                                CustomIcons.imageMap
                                                        .containsKey(f)
                                                    ? CustomIcons.imageMap[f]!
                                                    : CustomIcons.misc,
                                                color:
                                                    _customTheme.isDarkTheme(
                                                      context,
                                                    )
                                                    ? Colors.white
                                                    : Colors.deepPurple[900],
                                                size: 46,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.0,
                                              child: Ink(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                              6.0,
                                                            ),
                                                        bottomRight:
                                                            Radius.circular(
                                                              6.0,
                                                            ),
                                                      ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
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
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                        ),
                                                    child: Text(
                                                      f.toUpperCase(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          right: -7,
                                          top: -7,
                                          child: IconButton(
                                            tooltip: "systemsTooltip".i18n(),
                                            splashRadius: 16.0,
                                            onPressed: () {
                                              setState(() {
                                                _favSystemsList!.add(f);
                                                _favSystemsList!.sort();
                                              });
                                              _applyFilter(
                                                _searchController.text,
                                              );
                                              _setFavSystems();

                                              CustomSnackbar.showSnackBar(
                                                _globalScaffoldKey,
                                                "addFavoriteSnackBar".i18n(),
                                              );
                                            },
                                            icon: const Icon(Icons.star_border),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
