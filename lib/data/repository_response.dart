import 'package:json_annotation/json_annotation.dart';

part 'repository_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RepositoryResponse{
  late List<String> listRepository;
  List<ImageResponse> listImageResponse;

  RepositoryResponse({required this.listRepository, required this.listImageResponse});

  factory RepositoryResponse.fromJson(Map<String, dynamic> json) => _$RepositoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoryResponseToJson(this);

}

@JsonSerializable()
class ImageResponse{
  String imagePath;
  double? blur;
  double? brightness;
  List<double>? presets;
  ImageResponse(this.imagePath, {this.blur=0, this.brightness, this.presets});

  factory ImageResponse.fromJson(Map<String, dynamic> json) => _$ImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImageResponseToJson(this);
}