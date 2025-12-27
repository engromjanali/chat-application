import 'package:chat_application/features/home/data/repositories/home_repositorie_impl.dart';
import 'package:chat_application/features/home/domain/entryes/e_message.dart';
import 'package:chat_application/features/home/domain/repositores/home_repositorie.dart';
import 'package:get/get_connect/http/src/http/io/http_request_io.dart';

class SendMessageUseCase {
  final IHomeRepository iHomeRepository;
  SendMessageUseCase(this.iHomeRepository);

  Future<void> call(EMessage payload) {
    return iHomeRepository.sendMessage(payload);
  }
}
