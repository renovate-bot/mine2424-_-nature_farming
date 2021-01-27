import 'package:flamingo/flamingo.dart';
import 'package:flamingo_annotation/flamingo_annotation.dart';
import 'package:nature_farming/models/post/replyMessage.dart';

part 'post.flamingo.dart';

class Post extends Document<Post> {
  Post({
    String id,
    DocumentSnapshot snapshot,
    Map<String, dynamic> values,
  }) : super(id: id, snapshot: snapshot, values: values) {
    replyMessage = Collection(this, PostKey.replyMessage.value);
  }

  @Field()
  String name;

  @Field()
  String userId;

  @Field()
  String content;

  @Field()
  int good;

  @Field()
  Future<String> fmcToken;

  /// プロフィール写真
  @StorageField()
  StorageFile postImage;

  /// 返信のメッセージ
  @SubCollection()
  Collection<ReplyMessage> replyMessage;

  @override
  Map<String, dynamic> toData() => _$toData(this);

  @override
  void fromData(Map<String, dynamic> data) => _$fromData(this, data);
}
