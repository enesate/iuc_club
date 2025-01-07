import 'package:iuc_club/data/repositories/user_repositor.dart';

class FetchUserProfile {
  final UserRepository repository;

  FetchUserProfile(this.repository);

  /* Future<Map<String, dynamic>> execute(String userId) async {
    return await repository.fetchUserProfile(userId);
  } */
}
