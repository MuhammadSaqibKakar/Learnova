part of 'package:learnova/main.dart';

const String _syncMetadataStorageKey = 'learnova.sync.metadata';
const String _syncApiBaseUrlOverrideKey = 'learnova.sync.api_base_url';
const String _syncApiBaseUrl = String.fromEnvironment('LEARNOVA_API_BASE_URL');
DateTime? _sharedSyncBlockedUntilUtc;
const Set<String> _localOnlySyncKeys = <String>{
  'learnova.remember_me',
  'learnova.remembered_identifier',
  'learnova.remembered_password',
  'learnova.visual_style',
  _syncMetadataStorageKey,
  _syncApiBaseUrlOverrideKey,
};

Future<SharedPreferences> _sharedPrefs({bool syncFirst = false}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (syncFirst) {
    await _synchronizeSharedState(prefs: prefs);
  }
  return prefs;
}

bool _shouldSyncKey(String key) {
  if (!key.startsWith('learnova.')) {
    return false;
  }
  if (_localOnlySyncKeys.contains(key)) {
    return false;
  }
  return !key.startsWith('learnova.sync.');
}

bool _sharedSyncTemporarilyBlocked() {
  final DateTime? blockedUntil = _sharedSyncBlockedUntilUtc;
  return blockedUntil != null && DateTime.now().toUtc().isBefore(blockedUntil);
}

void _markSharedSyncFailure() {
  _sharedSyncBlockedUntilUtc = DateTime.now().toUtc().add(
    const Duration(seconds: 20),
  );
}

void _markSharedSyncSuccess() {
  _sharedSyncBlockedUntilUtc = null;
}

String _normalizedApiBaseUrl(String value) {
  return value.trim().replaceFirst(RegExp(r'\/+$'), '');
}

String _sharedApiBaseUrl(SharedPreferences prefs) {
  final String override =
      prefs.getString(_syncApiBaseUrlOverrideKey)?.trim() ?? '';
  if (override.isNotEmpty) {
    return _normalizedApiBaseUrl(override);
  }
  if (_syncApiBaseUrl.trim().isNotEmpty) {
    return _normalizedApiBaseUrl(_syncApiBaseUrl);
  }
  return _normalizedApiBaseUrl('http://127.0.0.1:8787');
}

Uri _sharedStateUri(String baseUrl) {
  return Uri.parse('$baseUrl/api/shared-state');
}

Map<String, int> _syncMetadata(SharedPreferences prefs) {
  final String raw = prefs.getString(_syncMetadataStorageKey) ?? '{}';
  try {
    final dynamic decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return <String, int>{};
    }
    final Map<String, int> metadata = <String, int>{};
    decoded.forEach((String key, dynamic value) {
      final int? updatedAt = value is int ? value : int.tryParse('$value');
      if (updatedAt != null && updatedAt > 0) {
        metadata[key] = updatedAt;
      }
    });
    return metadata;
  } catch (_) {
    return <String, int>{};
  }
}

Future<void> _saveSyncMetadata(
  SharedPreferences prefs,
  Map<String, int> metadata,
) async {
  await prefs.setString(_syncMetadataStorageKey, jsonEncode(metadata));
}

Map<String, dynamic>? _sharedEntryFromPrefs(
  SharedPreferences prefs,
  String key,
  int updatedAt,
) {
  bool? readBool() {
    try {
      return prefs.getBool(key);
    } catch (_) {
      return null;
    }
  }

  int? readInt() {
    try {
      return prefs.getInt(key);
    } catch (_) {
      return null;
    }
  }

  double? readDouble() {
    try {
      return prefs.getDouble(key);
    } catch (_) {
      return null;
    }
  }

  List<String>? readStringList() {
    try {
      return prefs.getStringList(key);
    } catch (_) {
      return null;
    }
  }

  String? readString() {
    try {
      return prefs.getString(key);
    } catch (_) {
      return null;
    }
  }

  final bool? boolValue = readBool();
  if (boolValue != null) {
    return <String, dynamic>{
      'type': 'bool',
      'value': boolValue,
      'updatedAt': updatedAt,
    };
  }

  final int? intValue = readInt();
  if (intValue != null) {
    return <String, dynamic>{
      'type': 'int',
      'value': intValue,
      'updatedAt': updatedAt,
    };
  }

  final double? doubleValue = readDouble();
  if (doubleValue != null) {
    return <String, dynamic>{
      'type': 'double',
      'value': doubleValue,
      'updatedAt': updatedAt,
    };
  }

  final List<String>? listValue = readStringList();
  if (listValue != null) {
    return <String, dynamic>{
      'type': 'stringList',
      'value': listValue,
      'updatedAt': updatedAt,
    };
  }

  final String? stringValue = readString();
  if (stringValue != null) {
    return <String, dynamic>{
      'type': 'string',
      'value': stringValue,
      'updatedAt': updatedAt,
    };
  }

  return null;
}

Future<void> _applyRemoteEntry(
  SharedPreferences prefs,
  String key,
  Map<String, dynamic> entry,
) async {
  if (entry['deleted'] == true) {
    await prefs.remove(key);
    return;
  }

  final String type = '${entry['type'] ?? ''}'.trim();
  final dynamic value = entry['value'];
  switch (type) {
    case 'bool':
      if (value is bool) {
        await prefs.setBool(key, value);
      }
      return;
    case 'int':
      final int? intValue = value is int ? value : int.tryParse('$value');
      if (intValue != null) {
        await prefs.setInt(key, intValue);
      }
      return;
    case 'double':
      final double? doubleValue = value is double
          ? value
          : double.tryParse('$value');
      if (doubleValue != null) {
        await prefs.setDouble(key, doubleValue);
      }
      return;
    case 'stringList':
      if (value is List<dynamic>) {
        await prefs.setStringList(
          key,
          value.map((dynamic item) => '$item').toList(),
        );
      }
      return;
    case 'string':
      await prefs.setString(key, '${value ?? ''}');
      return;
  }
}

Future<void> _postSharedEntries(
  String baseUrl,
  Map<String, Map<String, dynamic>> entries,
) async {
  if (entries.isEmpty || baseUrl.isEmpty || _sharedSyncTemporarilyBlocked()) {
    return;
  }

  final http.Response response = await http
      .post(
        _sharedStateUri(baseUrl),
        headers: const <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{'entries': entries}),
      )
      .timeout(const Duration(seconds: 3));
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Shared sync push failed with ${response.statusCode}.');
  }
  _markSharedSyncSuccess();
}

Future<void> _syncSharedKeysToRemote(
  SharedPreferences prefs,
  Iterable<String> keys,
) async {
  final String baseUrl = _sharedApiBaseUrl(prefs);
  if (baseUrl.isEmpty) {
    return;
  }

  final Map<String, int> metadata = _syncMetadata(prefs);
  final int now = DateTime.now().toUtc().millisecondsSinceEpoch;
  final Map<String, Map<String, dynamic>> entries =
      <String, Map<String, dynamic>>{};

  for (final String key in keys.toSet()) {
    if (!_shouldSyncKey(key)) {
      continue;
    }
    metadata[key] = now;
    final Map<String, dynamic>? entry = _sharedEntryFromPrefs(prefs, key, now);
    if (entry != null) {
      entries[key] = entry;
    }
  }

  if (entries.isEmpty) {
    return;
  }

  await _saveSyncMetadata(prefs, metadata);
  try {
    await _postSharedEntries(baseUrl, entries);
  } catch (_) {
    _markSharedSyncFailure();
  }
}

Future<void> _syncRemovedSharedKeys(
  SharedPreferences prefs,
  Iterable<String> keys,
) async {
  final String baseUrl = _sharedApiBaseUrl(prefs);
  if (baseUrl.isEmpty) {
    return;
  }

  final Map<String, int> metadata = _syncMetadata(prefs);
  final int now = DateTime.now().toUtc().millisecondsSinceEpoch;
  final Map<String, Map<String, dynamic>> entries =
      <String, Map<String, dynamic>>{};

  for (final String key in keys.toSet()) {
    if (!_shouldSyncKey(key)) {
      continue;
    }
    metadata[key] = now;
    entries[key] = <String, dynamic>{'deleted': true, 'updatedAt': now};
  }

  if (entries.isEmpty) {
    return;
  }

  await _saveSyncMetadata(prefs, metadata);
  try {
    await _postSharedEntries(baseUrl, entries);
  } catch (_) {
    _markSharedSyncFailure();
  }
}

Future<void> _synchronizeSharedState({SharedPreferences? prefs}) async {
  final SharedPreferences storage =
      prefs ?? await SharedPreferences.getInstance();
  final String baseUrl = _sharedApiBaseUrl(storage);
  if (baseUrl.isEmpty || _sharedSyncTemporarilyBlocked()) {
    return;
  }

  try {
    final http.Response response = await http
        .get(_sharedStateUri(baseUrl))
        .timeout(const Duration(seconds: 3));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _markSharedSyncFailure();
      return;
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return;
    }

    final dynamic rawEntries = decoded['entries'];
    if (rawEntries is! Map<String, dynamic>) {
      return;
    }

    final Map<String, dynamic> remoteEntries = rawEntries;
    final Map<String, int> metadata = _syncMetadata(storage);
    final Set<String> localKeys = storage
        .getKeys()
        .where(_shouldSyncKey)
        .toSet();
    final Map<String, Map<String, dynamic>> entriesToPush =
        <String, Map<String, dynamic>>{};

    for (final MapEntry<String, dynamic> item in remoteEntries.entries) {
      if (!_shouldSyncKey(item.key) || item.value is! Map<String, dynamic>) {
        continue;
      }
      final Map<String, dynamic> entry = item.value as Map<String, dynamic>;
      final int remoteUpdatedAt = entry['updatedAt'] is int
          ? entry['updatedAt'] as int
          : int.tryParse('${entry['updatedAt']}') ?? 0;
      final int localUpdatedAt = metadata[item.key] ?? 0;
      if (remoteUpdatedAt > localUpdatedAt) {
        await _applyRemoteEntry(storage, item.key, entry);
        metadata[item.key] = remoteUpdatedAt;
      }
    }

    for (final String key in localKeys) {
      final Map<String, dynamic>? remoteEntry =
          remoteEntries[key] is Map<String, dynamic>
          ? remoteEntries[key] as Map<String, dynamic>
          : null;
      final int remoteUpdatedAt = remoteEntry?['updatedAt'] is int
          ? remoteEntry!['updatedAt'] as int
          : int.tryParse('${remoteEntry?['updatedAt']}') ?? 0;
      final int localUpdatedAt =
          metadata[key] ?? DateTime.now().toUtc().millisecondsSinceEpoch;
      metadata[key] = localUpdatedAt;
      if (remoteEntry == null || localUpdatedAt > remoteUpdatedAt) {
        final Map<String, dynamic>? entry = _sharedEntryFromPrefs(
          storage,
          key,
          localUpdatedAt,
        );
        if (entry != null) {
          entriesToPush[key] = entry;
        }
      }
    }

    final Iterable<String> removedKeys = metadata.keys.where((String key) {
      return _shouldSyncKey(key) && !localKeys.contains(key);
    });
    for (final String key in removedKeys) {
      final Map<String, dynamic>? remoteEntry =
          remoteEntries[key] is Map<String, dynamic>
          ? remoteEntries[key] as Map<String, dynamic>
          : null;
      final int remoteUpdatedAt = remoteEntry?['updatedAt'] is int
          ? remoteEntry!['updatedAt'] as int
          : int.tryParse('${remoteEntry?['updatedAt']}') ?? 0;
      final int localUpdatedAt = metadata[key] ?? 0;
      if (localUpdatedAt > remoteUpdatedAt) {
        entriesToPush[key] = <String, dynamic>{
          'deleted': true,
          'updatedAt': localUpdatedAt,
        };
      }
    }

    await _saveSyncMetadata(storage, metadata);
    if (entriesToPush.isNotEmpty) {
      try {
        await _postSharedEntries(baseUrl, entriesToPush);
      } catch (_) {
        _markSharedSyncFailure();
      }
    }
    _markSharedSyncSuccess();
  } catch (_) {
    _markSharedSyncFailure();
  }
}
