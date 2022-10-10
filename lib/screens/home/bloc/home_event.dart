part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class StoreImage extends HomeEvent {
  const StoreImage();

  @override
  List<Object> get props => [];
}

class UploadImage extends HomeEvent {
  final String name;
  final String description;
  final String type;
  final String quantity;
  const UploadImage(
    this.name,
    this.description,
    this.type,
    this.quantity,
  );

  @override
  List<Object> get props => [name, description, type, quantity];
}

class StoreMetadata extends HomeEvent {
  const StoreMetadata();

  @override
  List<Object> get props => [];
}

class UploadMetadata extends HomeEvent {
  final String quantity;
  const UploadMetadata(this.quantity);

  @override
  List<Object> get props => [];
}
