// README 1: State del provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../shared/shared.dart';

class LoginFormState{

  final bool isPosting;
  final bool isFromPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false, 
    this.isFromPosted = false, 
    this.isValid = false, 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFromPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFromPosted: isFromPosted ?? this.isFromPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password
  );

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting : $isPosting
    isFromPosted : $isFromPosted
    isValid : $isValid
    email : $email
    password : $password
  ''';
  }
}


// README 2: Como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier(): super( LoginFormState() );

  onEmailChange( String value ){
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.password ])
    );
  }

    onPasswordChange( String value ){
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ newPassword, state.password ])
    );
  }

  onFormSubmit(){
    _touchEveryField();

    if( !state.isValid ) return;

    print(state);
  }

  _touchEveryField(){

    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFromPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([ email, password ])
    );
  }
}

// README 3: StateNotifierProvider - conusme afuera
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});