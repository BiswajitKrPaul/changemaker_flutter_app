import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:form_validator/form_validator.dart';

extension CustomValidationExtension on ValidationBuilder {
  ValidationBuilder confirmPassword(String password) {
    return add((value) {
      if (value != password) {
        return t.register.passwordNotMatch;
      }
      return null;
    });
  }
}
