import 'package:edit_photo/data/repository_response.dart';
import 'package:equatable/equatable.dart';


class RepositoryState extends Equatable{
  @override
  List<Object?> get props => [];
}

class RepositoryLoadImageLoading extends RepositoryState{}

class RepositoryImageLoaded extends RepositoryState{
  final List<ImageResponse> listPhoto;
  RepositoryImageLoaded({required this.listPhoto});
}

class RepositoryImageEmpty extends RepositoryState{}

class RepositoryFailedLoadedImage extends RepositoryState{}

