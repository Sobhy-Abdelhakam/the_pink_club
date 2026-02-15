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
    await _cacheBox?.put(key, value);

    // Store metadata
    final metadata = CacheMetadata(
      cachedAt: DateTime.now(),
      ttl: ttl,
    );
    await _metadataBox?.put(key, _encodeMetadata(metadata));
  }

  @override
  Future<T?> get<T>(String key) async {
    // Check if cache exists
    if (!(_cacheBox?.containsKey(key) ?? false)) {
      return null;
    }

    // Check metadata for expiration
    final metadataJson = _metadataBox?.get(key);
    if (metadataJson != null) {
      final metadata = _decodeMetadata(metadataJson);
      if (metadata.isExpired) {
        await delete(key);
        return null;
      }
    }

    return _cacheBox?.get(key) as T?;
  }

  @override
  Future<void> delete(String key) async {
    await _cacheBox?.delete(key);
    await _metadataBox?.delete(key);
  }

  @override
  Future<void> clear() async {
    await _cacheBox?.clear();
    await _metadataBox?.clear();
  }

  String _encodeMetadata(CacheMetadata metadata) {
    return metadata.toJson().toString();
  }

  CacheMetadata _decodeMetadata(String json) {
    // Simple string-to-map parsing for our basic needs
    final parts = json.replaceAll('{', '').replaceAll('}', '').split(',');
    final Map<String, dynamic> map = {};

    for (var part in parts) {
      final keyValue = part.split(':');
      if (keyValue.length == 2) {
        final key = keyValue[0].trim().replaceAll("'", '');
        var value = keyValue[1].trim().replaceAll("'", '');
        
        if (key == 'ttl' && value != 'null') {
          map[key] = int.tryParse(value);
        } else if (key == 'cachedAt') {
          map[key] = value;
        }
      }
    }

    return CacheMetadata.fromJson(map);
  }
}
