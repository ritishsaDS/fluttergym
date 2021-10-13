import 'package:built_value/built_value.dart';
import 'package:powerdope_models/models.dart';

part 'auth_state.g.dart';

abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  factory AuthState([void Function(AuthStateBuilder) updates]) = _$AuthState;
  AuthState._();

  Account? get account;
}
