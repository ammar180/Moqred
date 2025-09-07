import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_person_widget.dart' show AddPersonWidget;
import 'package:flutter/material.dart';

class AddPersonModel extends FlutterFlowModel<AddPersonWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for transactionType widget.
  String? transactionTypeValue;
  FormFieldController<String>? transactionTypeValueController;
  // State field(s) for transactionPerson widget.
  String? transactionPersonValue;
  FormFieldController<String>? transactionPersonValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
