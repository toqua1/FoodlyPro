import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(2);

  void setPage(index)=> emit(index) ;
}
