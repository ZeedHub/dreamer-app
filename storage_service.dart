import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing local storage using Hive and SharedPreferences
/// Handles caching, user preferences, and offline data
class StorageService {
  static const String _userBox = 'user_box';
  static const String _dreamsBox = 'dreams_box';
  static const String _cacheBox = 'cache_box';
  static const String _settingsBox = 'settings_box';

  // SharedPreferences keys
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyLastSyncTime = 'last_sync_time';
  static const String _keyOnboardingComplete = 'onboarding_complete';

  static SharedPreferences? _prefs;
  static Box? _userBoxInstance;
  static Box? _dreamsBoxInstance;
  static Box? _cacheBoxInstance;
  static Box? _settingsBoxInstance;

  /// Initialize storage service
  static Future<void> init() async {
    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Register Hive adapters here if you have custom models
      // Example: Hive.registerAdapter(DreamModelAdapter());

      // Open boxes
      _userBoxInstance = await Hive.openBox(_userBox);
      _dreamsBoxInstance = await Hive.openBox(_dreamsBox);
      _cacheBoxInstance = await Hive.openBox(_cacheBox);
      _settingsBoxInstance = await Hive.openBox(_settingsBox);

      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      debugPrint('Storage service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing storage service: $e');
      rethrow;
    }
  }

  // ============================================================================
  // SHARED PREFERENCES METHODS
  // ============================================================================

  /// Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  /// Check if this is the first app launch
  static bool get isFirstLaunch {
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Mark first launch as complete
  static Future<void> setFirstLaunchComplete() async {
    await prefs.setBool(_keyFirstLaunch, false);
  }

  /// Check if onboarding is complete
  static bool get isOnboardingComplete {
    return prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  /// Mark onboarding as complete
  static Future<void> setOnboardingComplete(bool complete) async {
    await prefs.setBool(_keyOnboardingComplete, complete);
  }

  /// Get stored user ID
  static String? get userId {
    return prefs.getString(_keyUserId);
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    await prefs.setString(_keyUserId, userId);
  }

  /// Get stored user email
  static String? get userEmail {
    return prefs.getString(_keyUserEmail);
  }

  /// Save user email
  static Future<void> saveUserEmail(String email) async {
    await prefs.setString(_keyUserEmail, email);
  }

  /// Get theme mode (light/dark/system)
  static String get themeMode {
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  /// Save theme mode
  static Future<void> saveThemeMode(String mode) async {
    await prefs.setString(_keyThemeMode, mode);
  }

  /// Get notifications enabled status
  static bool get notificationsEnabled {
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  /// Save notifications enabled status
  static Future<void> saveNotificationsEnabled(bool enabled) async {
    await prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  /// Get last sync time
  static DateTime? get lastSyncTime {
    final timestamp = prefs.getInt(_keyLastSyncTime);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  /// Save last sync time
  static Future<void> saveLastSyncTime(DateTime time) async {
    await prefs.setInt(_keyLastSyncTime, time.millisecondsSinceEpoch);
  }

  // ============================================================================
  // HIVE BOX METHODS
  // ============================================================================

  /// Get user box instance
  static Box get userBox {
    if (_userBoxInstance == null) {
      throw Exception('User box not initialized');
    }
    return _userBoxInstance!;
  }

  /// Get dreams box instance
  static Box get dreamsBox {
    if (_dreamsBoxInstance == null) {
      throw Exception('Dreams box not initialized');
    }
    return _dreamsBoxInstance!;
  }

  /// Get cache box instance
  static Box get cacheBox {
    if (_cacheBoxInstance == null) {
      throw Exception('Cache box not initialized');
    }
    return _cacheBoxInstance!;
  }

  /// Get settings box instance
  static Box get settingsBox {
    if (_settingsBoxInstance == null) {
      throw Exception('Settings box not initialized');
    }
    return _settingsBoxInstance!;
  }

  // ============================================================================
  // USER DATA METHODS
  // ============================================================================

  /// Save user profile data
  static Future<void> saveUserProfile(Map<String, dynamic> userData) async {
    await userBox.put('profile', userData);
    debugPrint('User profile saved to local storage');
  }

  /// Get user profile data
  static Map<String, dynamic>? getUserProfile() {
    final data = userBox.get('profile');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Clear user profile data
  static Future<void> clearUserProfile() async {
    await userBox.delete('profile');
  }

  /// Save user astrological profile
  static Future<void> saveAstroProfile(Map<String, dynamic> astroData) async {
    await userBox.put('astro_profile', astroData);
    debugPrint('Astro profile saved to local storage');
  }

  /// Get user astrological profile
  static Map<String, dynamic>? getAstroProfile() {
    final data = userBox.get('astro_profile');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  // ============================================================================
  // DREAMS DATA METHODS
  // ============================================================================

  /// Save a dream to local storage
  static Future<void> saveDream(String dreamId, Map<String, dynamic> dreamData) async {
    await dreamsBox.put(dreamId, dreamData);
    debugPrint('Dream $dreamId saved to local storage');
  }

  /// Get a dream from local storage
  static Map<String, dynamic>? getDream(String dreamId) {
    final data = dreamsBox.get(dreamId);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Get all dreams from local storage
  static List<Map<String, dynamic>> getAllDreams() {
    return dreamsBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Delete a dream from local storage
  static Future<void> deleteDream(String dreamId) async {
    await dreamsBox.delete(dreamId);
    debugPrint('Dream $dreamId deleted from local storage');
  }

  /// Save multiple dreams
  static Future<void> saveDreams(Map<String, Map<String, dynamic>> dreams) async {
    await dreamsBox.putAll(dreams);
    debugPrint('${dreams.length} dreams saved to local storage');
  }

  /// Clear all dreams
  static Future<void> clearAllDreams() async {
    await dreamsBox.clear();
    debugPrint('All dreams cleared from local storage');
  }

  /// Get dreams count
  static int getDreamsCount() {
    return dreamsBox.length;
  }

  // ============================================================================
  // CACHE METHODS
  // ============================================================================

  /// Save data to cache with expiration
  static Future<void> saveToCache(
    String key,
    dynamic value, {
    Duration? expiration,
  }) async {
    final data = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds,
    };
    await cacheBox.put(key, data);
  }

  /// Get data from cache (returns null if expired)
  static dynamic getFromCache(String key) {
    final data = cacheBox.get(key);
    if (data == null) return null;

    final Map<String, dynamic> cacheData = Map<String, dynamic>.from(data);
    final timestamp = cacheData['timestamp'] as int;
    final expiration = cacheData['expiration'] as int?;

    if (expiration != null) {
      final expirationTime = timestamp + expiration;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      if (now > expirationTime) {
        // Cache expired
        cacheBox.delete(key);
        return null;
      }
    }

    return cacheData['value'];
  }

  /// Clear specific cache entry
  static Future<void> clearCache(String key) async {
    await cacheBox.delete(key);
  }

  /// Clear all cache
  static Future<void> clearAllCache() async {
    await cacheBox.clear();
    debugPrint('All cache cleared');
  }

  /// Clear expired cache entries
  static Future<void> clearExpiredCache() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final keysToDelete = <String>[];

    for (final key in cacheBox.keys) {
      final data = cacheBox.get(key);
      if (data != null) {
        final Map<String, dynamic> cacheData = Map<String, dynamic>.from(data);
        final timestamp = cacheData['timestamp'] as int;
        final expiration = cacheData['expiration'] as int?;

        if (expiration != null) {
          final expirationTime = timestamp + expiration;
          if (now > expirationTime) {
            keysToDelete.add(key as String);
          }
        }
      }
    }

    for (final key in keysToDelete) {
      await cacheBox.delete(key);
    }

    if (keysToDelete.isNotEmpty) {
      debugPrint('Cleared ${keysToDelete.length} expired cache entries');
    }
  }

  // ============================================================================
  // SETTINGS METHODS
  // ============================================================================

  /// Save app setting
  static Future<void> saveSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  /// Get app setting
  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }

  /// Delete app setting
  static Future<void> deleteSetting(String key) async {
    await settingsBox.delete(key);
  }

  /// Get all settings
  static Map<String, dynamic> getAllSettings() {
    return Map<String, dynamic>.from(settingsBox.toMap());
  }

  // ============================================================================
  // DRAFT MANAGEMENT
  // ============================================================================

  /// Save dream draft
  static Future<void> saveDreamDraft(Map<String, dynamic> draftData) async {
    await settingsBox.put('dream_draft', draftData);
    debugPrint('Dream draft saved');
  }

  /// Get dream draft
  static Map<String, dynamic>? getDreamDraft() {
    final data = settingsBox.get('dream_draft');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Clear dream draft
  static Future<void> clearDreamDraft() async {
    await settingsBox.delete('dream_draft');
    debugPrint('Dream draft cleared');
  }

  /// Check if dream draft exists
  static bool hasDreamDraft() {
    return settingsBox.containsKey('dream_draft');
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Clear all user data (logout)
  static Future<void> clearAllUserData() async {
    await userBox.clear();
    await dreamsBox.clear();
    await cacheBox.clear();
    await settingsBox.clear();
    
    // Clear SharedPreferences except first launch
    final firstLaunch = isFirstLaunch;
    await prefs.clear();
    await prefs.setBool(_keyFirstLaunch, firstLaunch);
    
    debugPrint('All user data cleared');
  }

  /// Get storage size information
  static Map<String, int> getStorageInfo() {
    return {
      'user_box': userBox.length,
      'dreams_box': dreamsBox.length,
      'cache_box': cacheBox.length,
      'settings_box': settingsBox.length,
    };
  }

  /// Compact all boxes (optimize storage)
  static Future<void> compactStorage() async {
    await userBox.compact();
    await dreamsBox.compact();
    await cacheBox.compact();
    await settingsBox.compact();
    debugPrint('Storage compacted');
  }

  /// Close all boxes
  static Future<void> close() async {
    await userBox.close();
    await dreamsBox.close();
    await cacheBox.close();
    await settingsBox.close();
    debugPrint('All storage boxes closed');
  }

  /// Dispose storage service
  static Future<void> dispose() async {
    await close();
    await Hive.close();
    debugPrint('Storage service disposed');
  }
}
