import 'package:get/get.dart';
import '../../domain/usecases/fetch_user_profile.dart';
import '../../domain/usecases/fetch_user_clubs.dart';

class ProfileController extends GetxController {
  final FetchUserProfile fetchUserProfile;
  final FetchUserClubs fetchUserClubs;

  var profile = {}.obs; // Kullanıcı profil bilgileri
  var clubs = [].obs; // Kullanıcının üye olduğu kulüpler
  var isLoading = true.obs;

  ProfileController(this.fetchUserProfile, this.fetchUserClubs);

  Future<void> loadProfile(String userId) async {
    isLoading.value = true;
    try {
      //mock data for profile
      profile.value = {
        'name': 'John Doe',
        'email': 'johndoe@gmail.com',
      };
      clubs.value = [
        {'name': 'Club 1', 'description': 'Club 1 description'},
        {'name': 'Club 2', 'description': 'Club 2 description'},
      ];

      //profile.value = await fetchUserProfile.execute(userId);
      //clubs.value = await fetchUserClubs.execute(userId);
    } catch (e) {
      Get.snackbar('Hata', 'Profil bilgileri yüklenemedi.');
    } finally {
      isLoading.value = false;
    }
  }
}
