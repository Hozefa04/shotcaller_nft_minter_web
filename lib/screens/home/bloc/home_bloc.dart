import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../utils/app_methods.dart';
import '../../../utils/app_strings.dart';

// ignore: avoid_web_libraries_in_flutter, unused_import, library_prefixes
import 'dart:html' as webFile;
import 'package:file_picker/file_picker.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  PlatformFile? image;
  String? imageUrl;
  String? metaUrl;
  FilePickerResult? result;

  HomeBloc() : super(const HomeInitial()) {
    on<StoreImage>((event, emit) async => _storeImage(event, emit));
    on<StoreMetadata>((event, emit) async => _storeMetadata(event, emit));
    on<UploadImage>((event, emit) async => _uploadImage(event, emit));
    on<UploadMetadata>((event, emit) async => _mintNFT(event, emit));
  }

  Future<void> _storeImage(StoreImage event, Emitter<HomeState> emit) async {
    image = await AppMethods.pickImage();
    if (image != null) {
      emit(ImageStored(image!));
    }
  }

  Future<void> _storeMetadata(
      StoreMetadata event, Emitter<HomeState> emit) async {
    result = await FilePicker.platform.pickFiles();
    if (result != null) {
      emit(MetadataStored(result!.files.single.name));
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadImage(UploadImage event, Emitter<HomeState> emit) async {
    emit(const ImageUploading());
    try {
      imageUrl = await AppMethods.uploadImage(image!);
      if (imageUrl != null) {
        try {
          await AppMethods.createMetadata(
            image: image!,
            imageUrl: imageUrl!,
            nftName: event.name,
            nftDescription: event.description,
            type: event.type,
          );
        } catch (e) {
          emit(const MetadataError());
        }
        emit(const ImageUploaded());
      } else {
        emit(const ImageError());
      }
    } catch (e) {
      emit(const ImageError());
    }
  }

  Future<void> _mintNFT(UploadMetadata event, Emitter<HomeState> emit) async {
    try {
      emit(const MetadataUploading());
      metaUrl = await AppMethods.uploadMetadata(
        fileBytes: result!.files.single.bytes!,
        name: result!.files.single.name,
      );
      if (metaUrl != null) {
        var url = AppStrings.flowWebUrl +
            "?metaUrl=$metaUrl&quantity=${event.quantity}";

        AppMethods.openUrl(url);
        emit(const MintComplete());
      }
    } catch (e) {
      emit(const MetadataError());
    }
  }
}
