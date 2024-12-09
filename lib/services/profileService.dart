import 'dart:convert';

import 'package:projeto_mobile/constant/constant.dart';
import 'package:projeto_mobile/model/userModel.dart';


class ProfileService {
  static Future<UserModel> fetchUserData() async {
    try {
      final snapshot = await realTimeDatabaseRef
          .child('Users/${auth.currentUser!.uid}')
          .get();

      if (snapshot.exists) {
        UserModel userData = UserModel.fromMap(
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
        return userData;
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      print('Erro: $e');
      throw Exception(e);
    }
  }
}

