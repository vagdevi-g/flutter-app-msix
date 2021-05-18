import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:moor/moor.dart';

import '../crypto_key_value.dart';
import 'signal_database.dart';
import 'signal_vo_extension.dart';

class IdentityKeyUtil {
  static Future generateIdentityKeyPair(
      SignalDatabase db, List<int> privateKey) async {
    final registrationId = KeyHelper.generateRegistrationId(false);
    CryptoKeyValue.get.setLocalRegistrationId(registrationId);
    final identityKeyPair =
        KeyHelper.generateIdentityKeyPairFromPrivate(privateKey);
    final identity = IdentitiesCompanion.insert(
        address: '-1',
        registrationId: Value(registrationId),
        publicKey: identityKeyPair.getPublicKey().serialize(),
        privateKey: Value(identityKeyPair.getPrivateKey().serialize()),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    await db.identityDao.insert(identity);
  }

  static Future<IdentityKeyPair> getIdentityKeyPair(SignalDatabase db) async =>
      db.identityDao
          .getLocalIdentity()
          .then((value) => value.getIdentityKeyPair());
}