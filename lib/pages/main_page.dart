import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:localization/localization.dart';
import '../utils/custom_icons.dart';
import '../utils/custom_snackbar.dart';
import '../utils/sftp_requests.dart';
import '../utils/preferences_requests.dart';
import 'systems_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _softChoice = "Recalbox";

  bool _isHidden = true;
  bool _isLoading = true;
  bool _isIpValide = true;
  bool _isPortValide = true;
  bool _isUserValide = true;
  bool _isPswdValide = true;
  bool? _isNightMode = false;

  final SFTPRequests _requests = SFTPRequests();
  final PreferencesRequests _prefsRequests = PreferencesRequests();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _globalScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();

  final FocusNode _sysNode = FocusNode();
  final FocusNode _ipNode = FocusNode();
  final FocusNode _portNode = FocusNode();
  final FocusNode _userNode = FocusNode();
  final FocusNode _pswdNode = FocusNode();

  final ImageProvider _background = const AssetImage("assets/arcade_room.jpg");

  void _loadTheme() async {
    _isNightMode = await _prefsRequests.loadTheme();

    switch (_isNightMode) {
      case null:
        {
          setState(() {
            _isNightMode = false;
            AdaptiveTheme.of(context).setLight();
          });
        }
        break;
      case true:
        {
          setState(() {
            AdaptiveTheme.of(context).setDark();
          });
        }
        break;
      case false:
        {
          setState(() {
            AdaptiveTheme.of(context).setLight();
          });
        }
        break;
    }
    _prefsRequests.setTheme(_isNightMode);
  }

  void _loadIdentifiers() async {
    List identifiers = await _prefsRequests.loadUserPreferences();

    if (identifiers.isNotEmpty) {
      setState(() {
        _softChoice = identifiers[0];
        _ipController.text = identifiers[1];
        _portController.text = identifiers[2];
        _userController.text = identifiers[3];
        _pswdController.text = identifiers[4];
      });
    }
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Color? _ipPrefixIconColor() {
    return _sysNode.hasFocus ? Colors.deepPurple : null;
  }

  IconData _systIconChoice() {
    switch (_softChoice) {
      case "Batocera":
        return CustomIcons.batocera;
      case "Recalbox":
        return CustomIcons.recalbox;
      case "Retropie":
        return CustomIcons.retropie;
      default:
        return CustomIcons.recalbox;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadIdentifiers();
    _sysNode.addListener(_onOnFocusNodeEvent);
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
    _ipController.dispose();
    _portController.dispose();
    _userController.dispose();
    _pswdController.dispose();
    _ipNode.dispose();
    _portNode.dispose();
    _userNode.dispose();
    _pswdNode.dispose();
    _sysNode.removeListener(_onOnFocusNodeEvent);
    _sysNode.dispose();
  }

  void _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _globalScaffoldKey,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: MediaQuery.of(context).viewInsets.bottom == 0
                ? AppBar(
                    leading: IconButton(
                      tooltip: _isNightMode == false
                          ? "lightThemeEnabled".i18n()
                          : "darkThemeEnabled".i18n(),
                      splashRadius: 16.0,
                      icon: _isNightMode == false
                          ? const Icon(Icons.light_mode)
                          : const Icon(Icons.nightlight),
                      onPressed: () {
                        setState(() {
                          _isNightMode = !_isNightMode!;
                        });
                        if (_isNightMode == false) {
                          AdaptiveTheme.of(context).setLight();
                        } else {
                          AdaptiveTheme.of(context).setDark();
                        }
                        _prefsRequests.setTheme(_isNightMode);
                        CustomSnackbar.showSnackBar(
                            _globalScaffoldKey,
                            _isNightMode == false
                                ? "lightThemeEnabled".i18n()
                                : "darkThemeEnabled".i18n());
                      },
                      color: Colors.amber,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0)
                : AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
            body: Stack(children: [
              Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _background,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                          child: Stack(children: [
                        Card(
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          margin: const EdgeInsets.all(25),
                          child: Form(
                              key: _formKey,
                              child: Column(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Material(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3.0)),
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      child: SizedBox(
                                          height: 40,
                                          child: DropdownButtonFormField<
                                                  String>(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              focusNode: _sysNode,
                                              iconSize: 36,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  prefixIcon: Icon(
                                                    _systIconChoice(),
                                                    color: _ipPrefixIconColor(),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.all(0)),
                                              value: _softChoice,
                                              items: [
                                                "Batocera",
                                                "Recalbox",
                                                "Retropie"
                                              ]
                                                  .map((label) =>
                                                      DropdownMenuItem(
                                                        value: label,
                                                        child: Text(label),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                _sysNode.requestFocus();
                                                setState(() {
                                                  _softChoice = value;
                                                });
                                              }))),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
                                    child: SizedBox(
                                        height: 40,
                                        child: Row(
                                          children: [
                                            Flexible(
                                                flex: 2,
                                                child: Material(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                3.0)),
                                                    color: Colors.transparent,
                                                    elevation: 1.0,
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        if (_ipController
                                                            .text.isNotEmpty) {
                                                          setState(() {
                                                            _isIpValide = true;
                                                          });
                                                        }
                                                      },
                                                      onFieldSubmitted:
                                                          (value) {
                                                        _fieldFocusChange(
                                                            context,
                                                            _ipNode,
                                                            _portNode);
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autocorrect: false,
                                                      enableSuggestions: false,
                                                      focusNode: _ipNode,
                                                      controller: _ipController,
                                                      decoration:
                                                          InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              hintText:
                                                                  '192.168.1.12',
                                                              filled: true,
                                                              prefixIcon: Icon(
                                                                color: _isIpValide ==
                                                                            false &&
                                                                        _ipController
                                                                            .text
                                                                            .isEmpty
                                                                    ? Colors.red
                                                                    : null,
                                                                CustomIcons.ip,
                                                              )),
                                                    ))),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                                flex: 1,
                                                child: Material(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                3.0)),
                                                    color: Colors.transparent,
                                                    elevation: 1.0,
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        if (_portController
                                                            .text.isNotEmpty) {
                                                          setState(() {
                                                            _isPortValide =
                                                                true;
                                                          });
                                                        }
                                                      },
                                                      onFieldSubmitted:
                                                          (value) {
                                                        _fieldFocusChange(
                                                            context,
                                                            _portNode,
                                                            _userNode);
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      focusNode: _portNode,
                                                      controller:
                                                          _portController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              hintText: '80',
                                                              filled: true,
                                                              prefixIcon: Icon(
                                                                color: _isPortValide ==
                                                                            false &&
                                                                        _portController
                                                                            .text
                                                                            .isEmpty
                                                                    ? Colors.red
                                                                    : null,
                                                                CustomIcons
                                                                    .port,
                                                              )),
                                                    ))),
                                          ],
                                        ))),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
                                    child: Material(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(3.0)),
                                        color: Colors.transparent,
                                        elevation: 1.0,
                                        child: SizedBox(
                                            height: 40,
                                            child: TextFormField(
                                              onChanged: (value) {
                                                if (_userController
                                                    .text.isNotEmpty) {
                                                  setState(() {
                                                    _isUserValide = true;
                                                  });
                                                }
                                              },
                                              onFieldSubmitted: (value) {
                                                _fieldFocusChange(context,
                                                    _userNode, _pswdNode);
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              autocorrect: false,
                                              enableSuggestions: false,
                                              focusNode: _userNode,
                                              controller: _userController,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  hintText: 'root',
                                                  filled: true,
                                                  prefixIcon: Icon(
                                                    color: _isUserValide ==
                                                                false &&
                                                            _userController
                                                                .text.isEmpty
                                                        ? Colors.red
                                                        : null,
                                                    Icons.person,
                                                  )),
                                            )))),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 10,
                                        bottom: 30),
                                    child: Material(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(3.0)),
                                        color: Colors.transparent,
                                        elevation: 1.0,
                                        child: SizedBox(
                                            height: 40,
                                            child: TextFormField(
                                              onChanged: (value) {
                                                if (_pswdController
                                                    .text.isNotEmpty) {
                                                  setState(() {
                                                    _isPswdValide = true;
                                                  });
                                                }
                                              },
                                              onFieldSubmitted: (value) {
                                                _pswdNode.unfocus();
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              focusNode: _pswdNode,
                                              controller: _pswdController,
                                              obscureText: _isHidden,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                hintText: '••••••••••',
                                                filled: true,
                                                prefixIcon: Icon(
                                                  color:
                                                      _isPswdValide == false &&
                                                              _pswdController
                                                                  .text.isEmpty
                                                          ? Colors.red
                                                          : null,
                                                  Icons.lock,
                                                ),
                                                suffixIcon: Material(
                                                    shape: const CircleBorder(),
                                                    child: IconButton(
                                                      tooltip: _isHidden ==
                                                              false
                                                          ? "showTooltip".i18n()
                                                          : "hideTooltip"
                                                              .i18n(),
                                                      splashRadius: 16.0,
                                                      onPressed: () {
                                                        setState(() {
                                                          _isHidden =
                                                              !_isHidden;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        _isHidden
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                      ),
                                                    )),
                                              ),
                                            )))),
                              ])),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 0,
                          left: 0,
                          child: Center(
                              child: Material(
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(3.0)),
                                  elevation: 1.0,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      height: 40,
                                      child: Ink(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3.0)),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color.fromRGBO(15, 12, 41, 1),
                                                  Color.fromRGBO(48, 43, 99, 1),
                                                  Color.fromRGBO(36, 36, 62, 1),
                                                ],
                                              )),
                                          child: AbsorbPointer(
                                              absorbing: !_isLoading,
                                              child: InkWell(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(3.0)),
                                                onTap: () async {
                                                  num size =
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              10) ~/
                                                          3;
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  if (_ipController
                                                          .text.isNotEmpty &&
                                                      _portController
                                                          .text.isNotEmpty &&
                                                      _userController
                                                          .text.isNotEmpty &&
                                                      _pswdController
                                                          .text.isNotEmpty) {
                                                    _prefsRequests
                                                        .setUserPreferences([
                                                      _softChoice!,
                                                      _ipController.text,
                                                      _portController.text,
                                                      _userController.text,
                                                      _pswdController.text
                                                    ]);
                                                    List<String>? systemsList =
                                                        await _requests
                                                            .loadSystems();
                                                    if (systemsList != null) {
                                                      if (context.mounted) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SystemsPage(
                                                                        data:
                                                                            systemsList,
                                                                        soft:
                                                                            _softChoice,
                                                                        width:
                                                                            size,
                                                                      )),
                                                        ).then((value) {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                        });
                                                      }
                                                      _globalScaffoldKey
                                                          .currentState!
                                                          .removeCurrentSnackBar();
                                                    } else {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      CustomSnackbar
                                                          .showErrorSnackBar(
                                                              _globalScaffoldKey);
                                                    }
                                                  } else {
                                                    setState(() {
                                                      _isIpValide = false;
                                                      _isPortValide = false;
                                                      _isUserValide = false;
                                                      _isPswdValide = false;
                                                    });

                                                    CustomSnackbar
                                                        .showErrorSnackBar(
                                                            _globalScaffoldKey);
                                                  }
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                },
                                                child: Center(
                                                    child: Text(
                                                  "loginButton".i18n(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )),
                                              )))))),
                        )
                      ])))),
            ])));
  }
}
