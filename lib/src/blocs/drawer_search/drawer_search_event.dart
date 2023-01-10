part of 'drawer_search_bloc.dart';

abstract class DrawerSearchEvent extends Equatable {
  const DrawerSearchEvent();

  @override
  List<Object?> get props => [];
}

class DrawerSearchItems extends DrawerSearchEvent {
  final String? query;
  const DrawerSearchItems(this.query);

  @override
  List<Object?> get props => [];
}
