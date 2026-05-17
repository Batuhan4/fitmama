import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/data/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('reads, writes and removes string values', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final svc = await StorageService.create();
    expect(svc.readString('foo'), isNull);
    await svc.writeString('foo', 'bar');
    expect(svc.readString('foo'), 'bar');
    await svc.remove('foo');
    expect(svc.readString('foo'), isNull);
  });

  test('writeJson/readJson round-trips a typed object', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final svc = await StorageService.create();
    await svc.writeJson('list', [1, 2, 3]);
    final list =
        svc.readJson<List<int>>('list', (raw) => (raw as List).cast<int>());
    expect(list, [1, 2, 3]);
  });

  test('readBool falls back when no value present', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final svc = await StorageService.create();
    expect(svc.readBool('missing'), isFalse);
    expect(svc.readBool('missing', fallback: true), isTrue);
    await svc.writeBool('flag', true);
    expect(svc.readBool('flag'), isTrue);
  });

  test('clearAllAppKeys removes only known keys', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      StorageKeys.profile: '{"name":"x"}',
      'unrelated_key': 'keep',
    });
    final svc = await StorageService.create();
    await svc.clearAllAppKeys();
    expect(svc.readString(StorageKeys.profile), isNull);
    expect(svc.readString('unrelated_key'), 'keep');
  });
}
