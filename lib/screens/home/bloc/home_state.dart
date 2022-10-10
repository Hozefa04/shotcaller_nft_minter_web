part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object> get props => [];
}

class ImageStored extends HomeState {
  final PlatformFile image;
  const ImageStored(this.image);

  @override
  List<Object> get props => [image];
}

class ImageUploading extends HomeState {
  const ImageUploading();

  @override
  List<Object> get props => [];
}

class ImageUploaded extends HomeState {
  const ImageUploaded();

  @override
  List<Object> get props => [];
}

class ImageError extends HomeState {
  const ImageError();

  @override
  List<Object> get props => [];
}

class CreatingMetadata extends HomeState {
  const CreatingMetadata();

  @override
  List<Object> get props => [];
}

class MetadataCreated extends HomeState {
  const MetadataCreated();

  @override
  List<Object> get props => [];
}

class MetadataError extends HomeState {
  const MetadataError();

  @override
  List<Object> get props => [];
}

class MintComplete extends HomeState {
  const MintComplete();

  @override
  List<Object> get props => [];
}

class MintError extends HomeState {
  const MintError();

  @override
  List<Object> get props => [];
}

class MetadataStored extends HomeState {
  final String fileName;
  const MetadataStored(this.fileName);

  @override
  List<Object> get props => [fileName];
}

class MetadataUploading extends HomeState {
  const MetadataUploading();

  @override
  List<Object> get props => [];
}
