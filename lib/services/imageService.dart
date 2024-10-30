import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:projeto_mobile/constant/constant.dart';

class ImageService {
  // Método para selecionar a imagem da galeria
  static Future<String?> pickImageAndSaveLocally() async {
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String localPath = '${appDir.path}/${pickedFile.name}';

      // Salva a imagem no caminho local
      final File localImage = await File(pickedFile.path).copy(localPath);
      return localImage.path; // Retorna o caminho para salvar no model
    }
    return null; // Caso o usuário não selecione uma imagem
  }
}
