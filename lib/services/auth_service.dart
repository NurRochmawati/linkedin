import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Client _client = Client();
  late final Account _account;

  AuthService() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1') // Endpoint Appwrite
        .setProject('67221598002f2126b5e0'); // Ganti dengan ID Proyek Anda
    _account = Account(_client);
  }

  // Fungsi Login
  Future<bool> login(String email, String password) async {
    try {
      // Menggunakan metode createEmailSession untuk login
      await _account.createEmailSession(
        email: email,
        password: password,
      );

      // Simpan status login ke shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      return true; // Kembalikan true jika login berhasil
    } on AppwriteException catch (e) {
      print(
          'Login error: ${e.message}'); // Menangkap kesalahan dan mencetak pesan
      return false; // Kembalikan false jika login gagal
    }
  }

  // Fungsi Registrasi
  Future<bool> register(String email, String password) async {
    try {
      // Gunakan bagian sebelum '@' sebagai userId
      final userId = email.split('@')[0];
      // Buat pengguna baru
      await _account.create(
        userId: userId, // User ID harus unik
        email: email,
        password: password,
        name: email.split('@')[0], // Nama pengguna
      );

      // Simpan status login ke shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      return true; // Kembalikan true jika registrasi berhasil
    } on AppwriteException catch (e) {
      print('Registration error: ${e.message}');
      return false; // Kembalikan false jika registrasi gagal
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current'); // Hapus sesi
      print('Logout successful');

      // Hapus status login dari shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Cek Status Login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Kembalikan status login
  }
}

extension on Account {
  createEmailSession({required String email, required String password}) {}
}
