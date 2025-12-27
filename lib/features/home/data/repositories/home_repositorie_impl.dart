import 'package:chat_application/features/home/data/data_source/home_data_source.dart';
import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/domain/entryes/e_message.dart';
import 'package:chat_application/features/home/domain/repositores/home_repositorie.dart';
import 'package:chat_application/features/home/domain/entryes/e_query.dart';

class HomeRepositoryImpl extends IHomeRepository {
  final IHomeDataSource _iHomeDataSource;
  HomeRepositoryImpl(this._iHomeDataSource);

  @override
  Future<void> deteteHomeFriend(String id) async {
    return _iHomeDataSource.deteteHomeFriend(id);
  }

  @override
  Future<List<MFriend>> fetchHomeFriend(EQuery payload) async {
    return _iHomeDataSource.fetchHomeFriend(payload);
  }

  @override
  Future<void> sendMessage(EMessage payload) async {
    return _iHomeDataSource.sendMessage(payload);
  }


  // @override
  // Future<void> addHomeFriend(MFriend payload) async {
  //   return _iHomeDataSource.addHomeFriend(payload);
  // }

  // @override
  // Future<void> updateHomeFriend(MFriend payload) async {
  //   return _iHomeDataSource.updateHomeFriend(payload);
  // }
}
