import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Cache metadata for tracking expiration
class CacheMetadata {
  final DateTime cachedAt;
  final Duration? ttl;

  CacheMetadata({
    required this.cachedAt,
    this.ttl,
  });

  bool get isExpired {
    if (ttl == null) return false;
    return DateTime.now().difference(cachedAt) > ttl!;
  }

  Map<String, dynamic> toJson() => {
        'cachedAt': cachedAt.toIso8601String(),
        'ttl': ttl?.inSeconds,
      };

  factory CacheMetadata.fromJson(Map<String, dynamic> json) {
    return CacheMetadata(
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      ttl: json['ttl'] != null
          ? Duration(seconds: json['ttl'] as int)
          : null,
    );
  }
}

/// Abstract cache service interface
abstract class CacheService {
  Future<void> init();
  Future<void> put<T>(String key, T value, {Duration? ttl});
  Future<T?> get<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
}

/// Hive-based cache implementation
class HiveCacheService implements CacheService {
  static const String _cacheBoxName = 'app_cache';
  static const String _metadataBoxName = 'cache_metadata';

  Box<dynamic>? _cacheBox;
  Box<String>? _metadataBox;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox<dynamic>(_cacheBoxName);
    _metadataBox = await Hive.openBox<String>(_metadataBoxName);
  }

  @override
  Future<void> put<T>(String key, T value, {Duration? ttl}) async {
    try {
      await _cacheBox?.put(key, value);

      // Store metadata
      final metadata = CacheMetadata(
        cachedAt: DateTime.now(),
        ttl: ttl,
      );
      await _metadataBox?.put(key, jsonEncode(metadata.toJson()));
    } catch (e) {
      // Silently fail cache writes, don't block app
      print('Cache write error: $e');
    }
  }

  @override
  Future<T?> get<T>(String key) async {
    try {
      // Check if cache exists
      if (!(_cacheBox?.containsKey(key) ?? false)) {
        return null;
      }

      // Check metadata for expiration
      final metadataJson = _metadataBox?.get(key);
      if (metadataJson != null) {
        try {
          final metadata = CacheMetadata.fromJson(
            jsonDecode(metadataJson) as Map<String, dynamic>,
          );
          if (metadata.isExpired) {
            await delete(key);
            return null;
          }
        } catch (e) {
          // If metadata is corrupted, delete and return null
          print('Cache metadata error: $e');
          await delete(key);
          return null;
        }
      }

      return _cacheBox?.get(key) as T?;
    } catch (e) {
      // On any cache read error, return null to trigger network fetch
      print('Cache read error: $e');
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _cacheBox?.delete(key);
      await _metadataBox?.delete(key);
    } catch (e) {
      print('Cache delete error: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _cacheBox?.clear();
      await _metadataBox?.clear();
    } catch (e) {
      print('Cache clear error: $e');
    }
  }
}
