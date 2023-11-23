import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

// README 3: Instancia de Riverprod
final authProvider = StateNotifierProvider<AuthNotifier,AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(
    authRepository: authRepository
  );
});

// README 2: Lo que voy tomar
class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;

  AuthNotifier({
    required this.authRepository
  }): super( AuthState() );
  

  Future<void> loginUser( String email, String password ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password); //+ Obtener token
      _setLoggedUser( user );

    } on CustomError catch (e) {
      logout( e.message );
    } catch (e){
      logout( 'Error no controlado' );
    }

    // final user = await authRepository.login(email, password);
    // state =state.copyWith(user: user, authStatus: AuthStatus.authenticated)
  }

  void registerUser( String email, String password ) async {
    
  }

  void checkAuthStatus() async {
    
  }

  void _setLoggedUser( User user ) {
    // TODO: necesito guardar el token físicamente
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([ String? errorMessage ]) async {
    // TODO: limpiar token
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage
    );
  }

}

// README 1: Inicializar
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage
  );
}