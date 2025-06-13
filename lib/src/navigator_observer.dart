import "dart:async";

import "package:flutter/widgets.dart";

import "collector.dart";

/// A navigator observer for tracking screen views.
class UmamiNavigationObserver extends NavigatorObserver {
  final UmamiCollector _collector;

  /// Creates a new [UmamiNavigationObserver].
  UmamiNavigationObserver(this._collector);

  /// Called when the top route changes.
  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    super.didChangeTop(topRoute, previousTopRoute);
    final name = topRoute.settings.name;
    if (name is String) {
      unawaited(_collector.trackScreenView(name, referrer: previousTopRoute?.settings.name));
    }
  }
}
