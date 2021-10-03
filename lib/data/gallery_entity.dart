import 'package:photo_manager/photo_manager.dart';

class GalleryEntity{
  List<AssetPathEntity>? listAssetPathEntity;
  List<AlbumEntity>? listAlbumEntity;
  GalleryEntity({this.listAssetPathEntity, this.listAlbumEntity});
}

class AlbumEntity{
  final String name;
  List<AssetEntity> listAssetEntity;
  AlbumEntity({required this.name, required this.listAssetEntity});
}