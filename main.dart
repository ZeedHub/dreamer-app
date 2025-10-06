import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Service for tracking analytics events throughout the app
class AnalyticsService {
  static FirebaseAnalytics? _analytics;
  static FirebaseAnalyticsObserver? _observer;
  
  /// Get Firebase Analytics instance
  static FirebaseAnalytics get analytics {
    _analytics ??= FirebaseAnalytics.instance;
    return _analytics!;
  }
  
  /// Get Firebase Analytics Observer for route tracking
  static FirebaseAnalyticsObserver get observer {
    _observer ??= FirebaseAnalyticsObserver(analytics: analytics);
    return _observer!;
  }
  
  /// Initialize analytics service
  static Future<void> init() async {
    try {
      // Set analytics collection enabled
      await analytics.setAnalyticsCollectionEnabled(true);
      
      // Set user properties
      await analytics.setUserProperty(
        name: 'app_version',
        value: '1.0.0',
      );
      
      debugPrint('Analytics initialized successfully');
    } catch (e) {
      debugPrint('Error initializing analytics: $e');
    }
  }
  
  /// Log custom event
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      debugPrint('Analytics event logged: $name');
    } catch (e) {
      debugPrint('Error logging event: $e');
    }
  }
  
  /// Log screen view
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      debugPrint('Screen view logged: $screenName');
    } catch (e) {
      debugPrint('Error logging screen view: $e');
    }
  }
  
  /// Log user login
  static Future<void> logLogin({String? method}) async {
    await logEvent(
      name: 'login',
      parameters: {'method': method ?? 'email'},
    );
  }
  
  /// Log user signup
  static Future<void> logSignup({String? method}) async {
    await logEvent(
      name: 'sign_up',
      parameters: {'method': method ?? 'email'},
    );
  }
  
  /// Log dream creation
  static Future<void> logDreamCreated({
    required String dreamId,
    int? tagCount,
    bool? hasVoiceNote,
    String? mood,
  }) async {
    await logEvent(
      name: 'dream_created',
      parameters: {
        'dream_id': dreamId,
        'tag_count': tagCount,
        'has_voice_note': hasVoiceNote,
        'mood': mood,
      },
    );
  }
  
  /// Log dream interpretation requested
  static Future<void> logInterpretationRequested({
    required String dreamId,
    String? interpretationType,
  }) async {
    await logEvent(
      name: 'interpretation_requested',
      parameters: {
        'dream_id': dreamId,
        'interpretation_type': interpretationType,
      },
    );
  }
  
  /// Log social interaction
  static Future<void> logSocialInteraction({
    required String interactionType, // like, comment, follow
    String? targetId,
  }) async {
    await logEvent(
      name: 'social_interaction',
      parameters: {
        'interaction_type': interactionType,
        'target_id': targetId,
      },
    );
  }
  
  /// Set user ID for analytics
  static Future<void> setUserId(String userId) async {
    try {
      await analytics.setUserId(id: userId);
      debugPrint('Analytics user ID set: $userId');
    } catch (e) {
      debugPrint('Error setting user ID: $e');
    }
  }
  
  /// Set user property
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await analytics.setUserProperty(name: name, value: value);
      debugPrint('User property set: $name = $value');
    } catch (e) {
      debugPrint('Error setting user property: $e');
    }
  }
  
  /// Log app open
  static Future<void> logAppOpen() async {
    await logEvent(name: 'app_open');
  }
  
  /// Reset analytics data
  static Future<void> resetAnalyticsData() async {
    try {
      await analytics.resetAnalyticsData();
      debugPrint('Analytics data reset');
    } catch (e) {
      debugPrint('Error resetting analytics data: $e');
    }
  }
}
