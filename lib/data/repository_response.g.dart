// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepositoryResponse _$RepositoryResponseFromJson(Map<String, dynamic> json) {
  return RepositoryResponse(
    listRepository: (json['listRepository'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    listImageResponse: (json['listImageResponse'] as List<dynamic>)
        .map((e) => ImageResponse.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$RepositoryResponseToJson(RepositoryResponse instance) =>
    <String, dynamic>{
      'listRepository': instance.listRepository,
      'listImageResponse':
          instance.listImageResponse.map((e) => e.toJson()).toList(),
    };

ImageResponse _$ImageResponseFromJson(Map<String, dynamic> json) {
  return ImageResponse(
    json['imagePath'] as String,
    blur: (json['blur'] as num?)?.toDouble(),
    brightness: (json['brightness'] as num?)?.toDouble(),
    presets: (json['presets'] as List<dynamic>?)
        ?.map((e) => (e as num).toDouble())
        .toList(),
  );
}

Map<String, dynamic> _$ImageResponseToJson(ImageResponse instance) =>
    <String, dynamic>{
      'imagePath': instance.imagePath,
      'blur': instance.blur,
      'brightness': instance.brightness,
      'presets': instance.presets,
    };
