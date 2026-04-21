import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rust/src/rust/api/simple.dart';
import 'package:flutter_rust/src/rust/frb_generated.dart';
import 'package:macos_window_utils/widgets/transparent_macos_bottom_bar.dart';
import "package:macos_window_utils/window_manipulator.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RustLib.init();

  await WindowManipulator.initialize();
  WindowManipulator.makeTitlebarTransparent();
  WindowManipulator.enableFullSizeContentView();
  WindowManipulator.makeWindowFullyTransparent();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? asyncResult;
  bool isLoading = false;

  String greetDirect() => greet(name: "Tom");

  Future<void> _getContentFromClipboard() async {
    setState(() => isLoading = true);

    try {
      final result = await getContentFromClipboard();
      setState(() => asyncResult = result);
    } catch (e) {
      setState(() => asyncResult = "Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final directResult = greetDirect();

    return WidgetsApp(
      color: const Color(0x00000000),
      builder: (context, _) {
        return TransparentMacOSBottomBar(
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Greet: `$directResult`',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color:
                        MediaQuery.platformBrightnessOf(context) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: isLoading ? null : _getContentFromClipboard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 49, 80, 238),
                    ),
                    child: const Text(
                      'Get content from clipboard',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(fontSize: 14, height: 1.0),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: SingleChildScrollView(
                    child: Text(
                      asyncResult == null ? '' : 'Async: `$asyncResult`',
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
