import "package:dio/dio.dart";
import "package:flutter/foundation.dart";

enum _UmamiCollectType {
  pageview("pageview"),
  event("event");

  final String value;

  const _UmamiCollectType(this.value);
}

/// A collector for Umami Analytics.
class UmamiCollector {
  /// The Dio instance used to make the network requests.
  final Dio dio;

  /// The ID of the website to collect data for.
  final String id;

  /// The hostname of the website to collect data for.
  final String hostname;

  /// The language of the website to collect data for.
  final String language;

  /// The screen size of the website to collect data for.
  final String screenSize;

  /// The user agent of the website to collect data for.
  final String userAgent;

  /// The first referrer of the website to collect data for.
  String? firstReferrer;

  /// Whether the collector is enabled.
  late bool isEnabled;

  /// Creates a new Umami collector.
  UmamiCollector({
    required this.dio,
    required this.id,
    required this.hostname,
    required this.language,
    required this.screenSize,
    required this.userAgent,
    this.firstReferrer,
    this.isEnabled = true,
  });

  /// Send a pageview using the [screenName]. If [referrer] is provided
  /// it will be used overriding any permanent value.
  Future<void> trackScreenView(String screenName, {String? referrer}) async {
    if (isEnabled) {
      await _collectPageView(path: screenName, referrer: referrer);
    }
  }

  /// Send an event with the specified [eventType]. You can optionally provide
  /// an [eventValue] and/or a [screenName] to attach to the event.
  Future<void> trackEvent({required String eventType, String? eventValue, String? screenName}) async {
    if (isEnabled) {
      await _collectEvent(eventType: eventType, eventValue: eventValue, path: screenName);
    }
  }

  /// Creates a payload for a page view and then sends it to the remote
  /// Umami instance.
  Future<void> _collectPageView({String? path, String? referrer}) async {
    final payload = {
      "website": id,
      "url": path ?? "/",
      "referrer": _getReferrer(referrer),
      "hostname": hostname,
      "language": language,
      "screen": screenSize,
    };

    await _collect(payload: payload, type: _UmamiCollectType.pageview);
  }

  /// Creates a payload for an event and then sends it to the remote
  /// Umami instance.
  Future<void> _collectEvent({required String eventType, String? eventValue, String? path}) async {
    final payload = {
      "website": id,
      "url": path ?? "/",
      "event_type": eventType,
      "event_value": eventValue ?? "",
      "hostname": hostname,
      "language": language,
      "screen": screenSize,
    };

    await _collect(payload: payload, type: _UmamiCollectType.event);
  }

  /// Gets the correct referrer value.
  ///
  /// This method will return a URL value of the the [inputRef] if provided,
  /// the [firstReferrer] if any, or an empty string.
  String _getReferrer(String? inputRef) {
    String ref;
    if (inputRef != null) {
      ref = inputRef;
    } else if (firstReferrer != null) {
      ref = firstReferrer!;
      firstReferrer = null;
    } else {
      ref = "";
    }

    if (ref.isNotEmpty) {
      try {
        final uri = Uri.parse(ref);
        if (!uri.isAbsolute) {
          throw Exception();
        }
      } on Exception catch (_) {
        ref = "https://$ref";
      }
    }

    return ref;
  }

  /// Perform a network request against the Umami instance with the
  /// provided [payload] and the provided [type].
  Future<void> _collect({required Map<String, dynamic> payload, required _UmamiCollectType type}) async {
    try {
      await dio.post<dynamic>(
        "/api/collect",
        options: Options(headers: {"User-Agent": userAgent}),
        data: {"payload": payload, "type": type.value},
      );
    } on DioException catch (e) {
      debugPrint("Error while trying to collect data: $e");
    }
  }
}
