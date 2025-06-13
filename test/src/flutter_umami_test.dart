import "dart:ui";

import "package:flutter_test/flutter_test.dart";
import "package:flutter_umami/flutter_umami.dart";

void main() {
  group("FlutterUmami", () {
    test("can be instantiated", () async {
      expect(
        await FlutterUmami.create(
          url: "https://my.analytics.server",
          id: "1234567890",
          hostname: "com.my.app",
          locale: "en-US",
          screenSize: const Size(100, 100),
        ),
        isNotNull,
      );
    });
  });
}
