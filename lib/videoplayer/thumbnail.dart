import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getThumbnail(String tumbnail) async {
  final fileName = await VideoThumbnail.thumbnailFile(
    video: tumbnail,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.PNG,
    quality: 100,
  );
  // print(fileName.runtimeType);
  return fileName!;
}
