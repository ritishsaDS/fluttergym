import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

export 'auth_state.dart';

class AuthCubit extends HydratedCubit<DetailState<Account>> {
  AuthCubit({
    required this.repository,
  }) : super(DetailInitial<Account>());

  final AuthRepository repository;

  @override
  DetailState<Account>? fromJson(Map<String, dynamic> json) {
    var state = serializers.deserialize(json)! as DetailState;
    var account = state.data as Account?;
    if (state is DetailInitial) {
      return DetailInitial(data: account);
    }
    if (state is DetailSuccess) {
      return DetailSuccess(data: account!);
    }
    if (state is DetailFailure) {
      return DetailFailure<Account>();
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(DetailState<Account> state) {
    var json = serializers.serialize(state);
    return json as Map<String, dynamic>?;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(DetailWaiting(state: state));
    try {
      var account = await repository.login(
        LoginOption(
          (b) => b
            ..email = email
            ..password = password,
        ),
      );
      emit(DetailSuccess(data: account));
    } on HttpException catch (e) {
      emit(DetailFailure(message: e.message));
    }
  }

  Future<void> logOut() async {
    emit(DetailInitial());
  }

  Future<void> register({
    required String role,
    required String name,
    required String userName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    await repository.register(
      RegisterOption(
        (b) => b
          ..role = role
          ..name = name
          ..email = email
          ..userName = userName
          ..phone = phone
          ..password = password
          ..confirmPassword = confirmPassword,
      ),
    );

    // if (success) {
    //   Account? account;
    //   if (role == 'trainer') {
    //     account = Trainer(
    //       (b) => b
    //         ..firstName = name
    //         ..email = email
    //         ..phone = phone,
    //     );
    //   }
    //   if (role == 'subscriber') {
    //     account = Subscriber(
    //       (b) => b
    //         ..firstName = name
    //         ..email = email
    //         ..phone = phone,
    //     );
    //   }
    //   if (account != null) {
    //     emit(DetailSuccess(data: account));
    //   }
    // }
  }

  Future<bool> update({
    required String firstName,
    required String lastName,
    required String gender,
    required String mobile,
    required DateTime dob,
    int? weight,
    double? height,
    String? image,
  }) async {
    emit(DetailWaiting(state: state));
    var oldAccount = state.data;
    if (oldAccount != null) {
      var account = await repository.update(
        UpdateAccountOption(
          (b) => b
            ..userId = oldAccount.id
            ..firstName = firstName
            ..lastName = lastName
            // TODO(backend): Date times returned by API are not in parsable formst.
            ..dateOfBirth = '${dob.year}-${dob.month}-${dob.day}'
            ..gender = Gender.valueOf(gender)
            ..mobile = mobile
            ..weight = weight
            ..height = height
            ..image = image,
        ),
      );
      emit(DetailSuccess(data: account));
      return true;
    }
    return false;
  }
}
