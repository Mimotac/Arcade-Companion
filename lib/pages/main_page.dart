import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:localization/localization.dart';
import 'package:roms_manager/pages/login_page.dart';
import '../utils/custom_snackbar.dart';
import '../utils/preferences_requests.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool? _isNightMode = false;
  final PreferencesRequests _prefsRequests = PreferencesRequests();
  final ValueNotifier<bool> _isDialogActive = ValueNotifier<bool>(false);

  final GlobalKey<ScaffoldMessengerState> _globalScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

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

  @override
  void initState() {
    super.initState();
    _loadTheme();

    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _globalScaffoldKey,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: ValueListenableBuilder<bool>(
            valueListenable: _isDialogActive,
            builder: (context, isDialogActive, child) {
              return AnimatedOpacity(
                opacity: !isDialogActive ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IconButton(
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
                          : "darkThemeEnabled".i18n(),
                    );
                  },
                  color: Colors.amber,
                ),
              );
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: _background, fit: BoxFit.cover),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isDialogActive,
                    builder: (context, isDialogActive, child) {
                      return AnimatedOpacity(
                        opacity: !isDialogActive ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          elevation: 6.0,
                          child: SizedBox(
                            height: 58.0,
                            child: Ink(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                color: Colors.black,
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
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                onTap: () async {
                                  _globalScaffoldKey.currentState!
                                      .removeCurrentSnackBar();
                                  _isDialogActive.value = true;

                                  bool? answer = await Navigator.of(context)
                                      .push(
                                        PageRouteBuilder(
                                          fullscreenDialog: true,
                                          opaque: false,
                                          pageBuilder:
                                              (BuildContext context, _, __) {
                                                return const LoginPage();
                                              },
                                        ),
                                      );

                                  if (answer == null) {
                                    _isDialogActive.value = false;
                                  }
                                },
                                child: Center(
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
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
