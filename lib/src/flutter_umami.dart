import "package:device_user_agent/device_user_agent.dart" show DeviceUserAgent;
import "package:dio/dio.dart";

import "package:flutter/widgets.dart";

import "collector_impl.dart";
import "umami_collector.dart";

/// A class for creating Umami collectors.
class FlutterUmami {
  /// Constructs a new [UmamiCollector] to start tracking pageviews and events.
  ///
  ///
  /// This function will fetch the language of the user's device and the
  /// size of the screen. Also it will call [FkUserAgent.init()] which is
  /// needed for obtaining the user agent. Then it will return a [UmamiCollector]
  /// with all the values provided.
  ///
  ///
  /// Required parameters:
  /// - [url]: Remote server address of the Umami instance,
  /// example: https://my.analytics.server
  /// - [id]: Id of the configured site. You can found it within the
  /// tracking code. Example: 9f65dd3f-f2be-4b27-8b58-d76f83510beb
  /// - [hostname]: The name of the configured host. You should use the value
  /// that you set when configuring the site in the Umami dashboard.
  /// Example: com.my.app
  /// - [locale]: The locale of the website to collect data for.
  /// - [firstReferrer]: Optionally provide a first referrer value that will be
  /// attached to the first pageview without an explicit referrer. After that,
  /// this value won't be used again. This could be useful to track the app store
  /// or source from where the app was obtained, without sending the value
  /// multiple times throughout the lifespan of the session.
  /// - [isEnabled]: Set if this tracker is enabled or not. When disabled,
  /// calling trackScreenView() or trackEvent() won't have any effect. Defaults
  /// to true.
  static Future<UmamiCollector> create({
    required String url,
    required String id,
    required String hostname,
    required String locale,
    String? firstReferrer,
    bool isEnabled = true,
  }) async {
    final userAgent = await DeviceUserAgent.instance.build();
    final dio = Dio()..options.baseUrl = url;
    // First get the FlutterView.
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    // Dimensions in physical pixels (px)
    final size = view.physicalSize;
    return UmamiCollectorImpl(
      dio: dio,
      id: id,
      hostname: hostname,
      language: locale,
      screenSize: "${size.width.toInt()}x${size.height.toInt()}",
      userAgent: userAgent,
      firstReferrer: firstReferrer,
      isEnabled: isEnabled,
    );
  }
}
