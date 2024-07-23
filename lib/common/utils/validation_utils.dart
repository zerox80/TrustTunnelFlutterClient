import 'package:flutter/cupertino.dart';
import 'package:vpn/common/error/model/enum/presentation_field_name.dart';
import 'package:vpn/common/error/model/presentation_field.dart';

abstract class ValidationUtils {
  static String? getErrorString(
    BuildContext context,
    List<PresentationField> fieldErrors,
    PresentationFieldName fieldName,
  ) =>
      fieldErrors.where((element) => element.fieldName == fieldName).firstOrNull?.toLocalizedString(context);
}
