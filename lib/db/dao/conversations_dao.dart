import 'package:flutter_app/db/mixin_database.dart';
import 'package:moor/moor.dart';

part 'conversations_dao.g.dart';

@UseDao(tables: [Conversations])
class ConversationsDao extends DatabaseAccessor<MixinDatabase>
    with _$ConversationsDaoMixin {
  ConversationsDao(MixinDatabase db) : super(db);

  Future<int> insert(Conversation conversation) =>
      into(db.conversations).insertOnConflictUpdate(conversation);

  Future deleteConversation(Conversation conversation) =>
      delete(db.conversations).delete(conversation);

  Stream<List<Conversation>> conversations() =>
      select(db.conversations).watch();

  Future<List<Conversation>> getConversationById(String conversationId) {
    final query = select(db.conversations)
      ..where((tbl) => tbl.conversationId.equals(conversationId));
    return query.get();
  }
}
