import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '../utils/custom_icons.dart';
import '../utils/custom_snackbar.dart';
import '../utils/sftp_requests.dart';
import '../utils/preferences_requests.dart';
import 'systems_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _softChoice = "Recalbox";

  bool _isHidden = true;
  bool _isLoading = true;
  bool _isIpValide = true;
  bool _isPortValide = true;
  bool _isUserValide = true;
  bool _isPswdValide = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PreferencesRequests _prefsRequests = PreferencesRequests();
  final SFTPRequests _requests = SFTPRequests();
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
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Color? _sysPrefixIconColor() {
    return _sysNode.hasFocus ? Colors.deepPurple : null;
  }

  Color? _ipPrefixIconColor() {
    return _ipNode.hasFocus ? Colors.deepPurple : null;
  }

  Color? _portPrefixIconColor() {
    return _portNode.hasFocus ? Colors.deepPurple : null;
  }

  Color? _userPrefixIconColor() {
    return _userNode.hasFocus ? Colors.deepPurple : null;
  }

  Color? _pswdPrefixIconColor() {
    return _pswdNode.hasFocus ? Colors.deepPurple : null;
  }

  IconData _systIconChoice() {
    switch (_softChoice) {
      case "Batocera":
        return CustomIcons.batocera;
      case "Recalbox":
        return CustomIcons.recalbox;
      case "RetroPie":
        return CustomIcons.retropie;
      case "Lakka":
        return CustomIcons.lakka;
      default:
        return CustomIcons.recalbox;
    }
  }

  IconData _systIcons(String sysChoice) {
    switch (sysChoice) {
      case "Batocera":
        return CustomIcons.batocera;
      case "Recalbox":
        return CustomIcons.recalbox;
      case "RetroPie":
        return CustomIcons.retropie;
      case "Lakka":
        return CustomIcons.lakka;
      default:
        return CustomIcons.recalbox;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadIdentifiers();
    _sysNode.addListener(_onOnFocusNodeEvent);
    _ipNode.addListener(_onOnFocusNodeEvent);
    _portNode.addListener(_onOnFocusNodeEvent);
    _userNode.addListener(_onOnFocusNodeEvent);
    _pswdNode.addListener(_onOnFocusNodeEvent);
  }

  @override
  void dispose() {
    super.dispose();
    _ipController.dispose();
    _portController.dispose();
    _userController.dispose();
    _pswdController.dispose();
    _ipNode.removeListener(_onOnFocusNodeEvent);
    _ipNode.dispose();
    _portNode.removeListener(_onOnFocusNodeEvent);
    _portNode.dispose();
    _userNode.removeListener(_onOnFocusNodeEvent);
    _userNode.dispose();
    _portNode.removeListener(_onOnFocusNodeEvent);
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
        backgroundColor: Colors.black.withValues(alpha: 0.6),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            onPressed: () {
              _globalScaffoldKey.currentState!.removeCurrentSnackBar();
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 20.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Material(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            color: Colors.transparent,
                            elevation: 6.0,
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).inputDecorationTheme.fillColor,
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                              ),
                              child: Focus(
                                focusNode: _sysNode,
                                child: PopupMenuButton<String>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      "Batocera",
                                      "Lakka",
                                      "Recalbox",
                                      "RetroPie",
                                    ].map((str) {
                                      return PopupMenuItem(
                                        value: str,
                                        child: Row(
                                          children: [
                                            Icon(_systIcons(str)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12.0,
                                              ),
                                              child: Text(str),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 12.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Icon(
                                              _systIconChoice(),
                                              color: _sysPrefixIconColor(),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                              ),
                                              child: Text(
                                                _softChoice ?? "Recalbox",
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                  onSelected: (v) {
                                    _sysNode.requestFocus();
                                    setState(() {
                                      _softChoice = v;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 20.0,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Material(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                color: Colors.transparent,
                                elevation: 6.0,
                                child: TextFormField(
                                  onChanged: (value) {
                                    if (_ipController.text.isNotEmpty) {
                                      setState(() {
                                        _isIpValide = true;
                                      });
                                    }
                                  },
                                  onFieldSubmitted: (value) {
                                    _fieldFocusChange(
                                      context,
                                      _ipNode,
                                      _portNode,
                                    );
                                  },
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  focusNode: _ipNode,
                                  controller: _ipController,
                                  decoration: InputDecoration(
                                    hintText: '192.168.1.12',
                                    filled: true,
                                    prefixIcon: Icon(
                                      color:
                                          _isIpValide == false &&
                                              _ipController.text.isEmpty
                                          ? Colors.red
                                          : _ipPrefixIconColor(),
                                      CustomIcons.ip,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Flexible(
                              flex: 1,
                              child: Material(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                color: Colors.transparent,
                                elevation: 6.0,
                                child: TextFormField(
                                  onChanged: (value) {
                                    if (_portController.text.isNotEmpty) {
                                      setState(() {
                                        _isPortValide = true;
                                      });
                                    }
                                  },
                                  onFieldSubmitted: (value) {
                                    _fieldFocusChange(
                                      context,
                                      _portNode,
                                      _userNode,
                                    );
                                  },
                                  textInputAction: TextInputAction.next,
                                  focusNode: _portNode,
                                  controller: _portController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '80',
                                    filled: true,
                                    prefixIcon: Icon(
                                      color:
                                          _isPortValide == false &&
                                              _portController.text.isEmpty
                                          ? Colors.red
                                          : _portPrefixIconColor(),
                                      CustomIcons.port,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 20,
                        ),
                        child: Material(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          color: Colors.transparent,
                          elevation: 6.0,
                          child: TextFormField(
                            onChanged: (value) {
                              if (_userController.text.isNotEmpty) {
                                setState(() {
                                  _isUserValide = true;
                                });
                              }
                            },
                            onFieldSubmitted: (value) {
                              _fieldFocusChange(context, _userNode, _pswdNode);
                            },
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            enableSuggestions: false,
                            focusNode: _userNode,
                            controller: _userController,
                            decoration: InputDecoration(
                              hintText: 'root',
                              filled: true,
                              prefixIcon: Icon(
                                color:
                                    _isUserValide == false &&
                                        _userController.text.isEmpty
                                    ? Colors.red
                                    : _userPrefixIconColor(),
                                Icons.person,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 20.0,
                          bottom: 20.0,
                        ),
                        child: Material(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          color: Colors.transparent,
                          elevation: 6.0,
                          child: TextFormField(
                            onChanged: (value) {
                              if (_pswdController.text.isNotEmpty) {
                                setState(() {
                                  _isPswdValide = true;
                                });
                              }
                            },
                            onFieldSubmitted: (value) {
                              _pswdNode.unfocus();
                            },
                            textInputAction: TextInputAction.done,
                            focusNode: _pswdNode,
                            controller: _pswdController,
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              hintText: '••••••••••',
                              filled: true,
                              prefixIcon: Icon(
                                color:
                                    _isPswdValide == false &&
                                        _pswdController.text.isEmpty
                                    ? Colors.red
                                    : _pswdPrefixIconColor(),
                                Icons.lock,
                              ),
                              suffixIcon: Material(
                                shape: const CircleBorder(),
                                child: IconButton(
                                  tooltip: _isHidden == false
                                      ? "showTooltip".i18n()
                                      : "hideTooltip".i18n(),
                                  splashRadius: 16.0,
                                  onPressed: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                  icon: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    elevation: 6.0,
                    child: Ink(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(15, 12, 41, 1.0),
                            Color.fromRGBO(48, 43, 99, 1.0),
                            Color.fromRGBO(36, 36, 62, 1.0),
                          ],
                        ),
                      ),
                      child: AbsorbPointer(
                        absorbing: !_isLoading,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          onTap: () async {
                            num size =
                                (MediaQuery.of(context).size.width / 10) ~/ 3;
                            setState(() {
                              _isLoading = false;
                            });
                            if (_userController.text == "Bf_*6F35g,gP;5DvxZ5" &&
                                _pswdController.text == "7pWLS/88Gt6.=Sdp3d{") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SystemsPage(
                                    data: const ["55,35fZ_gv~*DFBgP6x;"],
                                    soft: _softChoice,
                                    width: size,
                                  ),
                                ),
                              );
                            }
                            if (_ipController.text.isNotEmpty &&
                                _portController.text.isNotEmpty &&
                                _userController.text.isNotEmpty &&
                                _pswdController.text.isNotEmpty) {
                              _prefsRequests.setUserPreferences([
                                _softChoice!,
                                _ipController.text,
                                _portController.text,
                                _userController.text,
                                _pswdController.text,
                              ]);
                              List<String>? systemsList = await _requests
                                  .loadSystems();
                              if (systemsList != null) {
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SystemsPage(
                                        data: systemsList,
                                        soft: _softChoice,
                                        width: size,
                                      ),
                                    ),
                                  ).then((value) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                  });
                                }
                                _globalScaffoldKey.currentState!
                                    .removeCurrentSnackBar();
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                CustomSnackbar.showErrorSnackBar(
                                  _globalScaffoldKey,
                                );
                              }
                            } else {
                              setState(() {
                                _isIpValide = false;
                                _isPortValide = false;
                                _isUserValide = false;
                                _isPswdValide = false;
                              });

                              CustomSnackbar.showErrorSnackBar(
                                _globalScaffoldKey,
                              );
                            }
                            setState(() {
                              _isLoading = true;
                            });
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              child: Text(
                                "loginButton".i18n(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
