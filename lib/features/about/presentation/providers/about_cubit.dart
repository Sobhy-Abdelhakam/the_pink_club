import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/about_repository.dart';
import 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  final AboutRepository _repository;

  AboutCubit(this._repository) : super(AboutInitial());

  Future<void> fetchAbout() async {
    emit(AboutLoading());
    try {
      final about = await _repository.fetchAbout();
      emit(AboutLoaded(about));
    } catch (e) {
      emit(AboutError(e.toString()));
    }
  }
}
