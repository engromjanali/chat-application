import 'package:chat_application/features/authentication/data/model/m_token.dart';

abstract class ISocialAuthService {
  Future<MToken> authenticate();
}
