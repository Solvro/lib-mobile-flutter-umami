/// A collector for Umami Analytics.
abstract class UmamiCollector {
  /// The first referrer of the website to collect data for.
  String? firstReferrer;

  /// Whether the collector is enabled.
  late bool isEnabled;

  /// Send a pageview using the [screenName]. If [referrer] is provided
  /// it will be used overriding any permanent value.
  Future<void> trackScreenView(String screenName, {String? referrer});

  /// Send an event with the specified [eventType]. You can optionally provide
  /// an [eventValue] and/or a [screenName] to attach to the event.
  Future<void> trackEvent({required String eventType, String? eventValue, String? screenName});
}
