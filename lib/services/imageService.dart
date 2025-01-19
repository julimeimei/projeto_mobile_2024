import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageService {
  static final ImagePicker imagePicker = ImagePicker();

  // Método para selecionar ou capturar uma imagem
  static Future<String?> pickImageAndSaveLocally(BuildContext context) async {
    final String? choice = await _showImageSourceDialog(context);

    if (choice == null) return null; // Usuário cancelou

    ImageSource source;
    if (choice == 'gallery') {
      source = ImageSource.gallery;
    } else if (choice == 'camera') {
      source = ImageSource.camera;
    } else {
      return null; // Caso inesperado
    }

    final XFile? pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String localPath = '${appDir.path}/${pickedFile.name}';

      // Salva a imagem no caminho local
      final File localImage = await File(pickedFile.path).copy(localPath);
      return localImage.path; // Retorna o caminho para salvar no model
    }
    return null; // Caso o usuário não selecione ou capture uma imagem
  }

  // Exibe o diálogo para o usuário escolher a origem da imagem
  static Future<String?> _showImageSourceDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher Imagem'),
          content: const Text('De onde você gostaria de obter a imagem?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop('gallery'),
              child: Text(
                'Galeria',
                style: TextStyle(color: Colors.blue[600]),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('camera'),
              child: Text(
                'Câmera',
                style: TextStyle(color: Colors.blue[600]),
              ),
            ),
          ],
        );
      },
    );
  }
}
