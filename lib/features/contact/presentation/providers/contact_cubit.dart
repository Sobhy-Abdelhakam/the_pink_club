import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/contact_repository.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository _repository;

  ContactCubit(this._repository) : super(ContactInitial());

  Future<void> sendContact(Map<String, dynamic> body) async {
    emit(ContactLoading());
    try {
      await _repository.sendContact(body);
      emit(ContactSuccess());
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }
}
