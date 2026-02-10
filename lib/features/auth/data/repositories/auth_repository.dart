import '../datasources/auth_remote_datasource.dart';

class AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepository(this.remote);

  Future<Map<String, dynamic>> loginWithOtp(String mobile) {
    return remote.loginWithOtp(mobile);
  }

  Future<Map<String, dynamic>> verifyUser(String mobile) {
    return remote.verifyUser(mobile);
  }
}
