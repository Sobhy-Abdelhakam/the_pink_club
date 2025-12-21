import '../../../core/network/api_client.dart';

class ContactRepository {
  final ApiClient api;

  ContactRepository(this.api);

  Future<void> sendContact(Map<String, dynamic> body) async {
    await api.post('send_contact', body);
  }
}
