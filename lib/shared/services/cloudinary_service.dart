import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  static const String _cloudName = 'dfeamnsxo';
  static const String _uploadPreset = 'spota events';

  final _cloudinary = CloudinaryPublic(
    _cloudName,
    _uploadPreset,
    cache: false,
  );

  Future<String?> uploadImage(File file) async {
    try {
      print('DEBUG: Starting Cloudinary upload for ${file.path}');

      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: 'event_images',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      print('DEBUG: Cloudinary upload success: ${response.secureUrl}');
      return response.secureUrl;
    } catch (e) {
      print('DEBUG ERROR: Cloudinary upload failed: $e');
      return null;
    }
  }
}
