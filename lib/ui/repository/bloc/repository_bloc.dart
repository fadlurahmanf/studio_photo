import 'dart:convert';

import 'package:edit_photo/core/setup_locator.dart';
import 'package:edit_photo/core/setup_sp.dart';
import 'package:edit_photo/data/repository_response.dart';
import 'package:edit_photo/ui/repository/bloc/repository_event.dart';
import 'package:edit_photo/ui/repository/bloc/repository_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState>{
  RepositoryBloc() : super(RepositoryLoadImageLoading());

  UtilsSharedPreferences utilsSp = locator<UtilsSharedPreferences>();

  @override
  Stream<RepositoryState> mapEventToState(RepositoryEvent event) async*{
    if(event is RepositoryGetRepositoryImage){
      var data = await utilsSp.getObject("LOCAL_PATH");
      if(data==null){
        yield RepositoryImageEmpty();
      }else{
        String jsonDecodeValue = json.decode(data);
        print(jsonDecodeValue);
        RepositoryResponse repositoryResponse = RepositoryResponse.fromJson(jsonDecode(jsonDecodeValue));
        yield RepositoryImageLoaded(listPhoto: repositoryResponse.listImageResponse);
      }
    }else{
      yield RepositoryFailedLoadedImage();
    }
  }
}