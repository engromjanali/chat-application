import 'package:chat_application/features/home/data/data_source/home_data_source.dart';
import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/data/model/m_query.dart';
import 'package:chat_application/features/home/domain/repositores/home_repositorie.dart';

class HomeRepositoryImpl extends IHomeRepository {
  final IHomeDataSource _iHomeDataSource;
  HomeRepositoryImpl(this._iHomeDataSource);

  // @override
  // Future<void> addHomeNote(MFriend payload) async {
  //   return _iHomeDataSource.addHomeNote(payload);
  // }

  @override
  Future<void> deteteHomeNote(String id) async {
    return _iHomeDataSource.deteteHomeNote(id);
  }

  @override
  Future<List<MFriend>> fetchHomeNote(MQuery payload) async {
    return _iHomeDataSource.fetchHomeNote(payload);
  }

  // @override
  // Future<void> updateHomeNote(MFriend payload) async {
  //   return _iHomeDataSource.updateHomeNote(payload);
  // }
}
