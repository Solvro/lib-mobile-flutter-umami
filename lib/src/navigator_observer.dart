import "dart:async";

import "package:flutter/widgets.dart";

import "umami_collector.dart";

/// A navigator observer for tracking screen views.
class UmamiNavigationObserver extends NavigatorObserver {
  final FutureOr<UmamiCollector> _collector;

  /// Creates a new [UmamiNavigationObserver].
  UmamiNavigationObserver(this._collector);

  Future<void> _trackScreenView(String name, Route<dynamic>? previousTopRoute) async {
    final collector = await _collector;
    unawaited(collector.trackScreenView(name, referrer: previousTopRoute?.settings.name));
  }

  /// Called when the top route changes.
  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    super.didChangeTop(topRoute, previousTopRoute);
    final name = topRoute.settings.name;
    if (name is String) {
      Future.microtask(() async => _trackScreenView(name, previousTopRoute));
    }
  }
}
