import 'package:chat_application/features/authentication/data/data_source/auth_data_source.dart';
import 'package:chat_application/features/authentication/data/model/m_auth.dart';
import 'package:chat_application/features/authentication/data/model/m_token.dart';
import 'package:chat_application/features/authentication/data/repository/auth_repository.dart';



class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDataSource _authDataSource;
  AuthRepositoryImpl(IAuthDataSource authDataSource)
    : _authDataSource = authDataSource;

  @override
  Future<MToken> signInWithEmailAndPassword(MAuth payload) async {
    return await _authDataSource.signInWithEmailAndPass(payload);
  }

  @override
  Future<MToken> signUpWithEmailAndPassword(MAuth payload) async {
    return await _authDataSource.registerWithEmailAndPass(payload);
  }

  // @override
  // Future<MToken?> loginWithSocial(MSocialAuth auth) async {
  //   return await _authDataSource.loginWithSocial(auth);
  // }
}
