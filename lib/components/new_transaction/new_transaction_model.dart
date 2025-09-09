import '/flutter_flow/flutterflow_ui.dart';
import 'package:moqred/backend/db_requests/db_service.dart';
import 'package:moqred/backend/schema/enums/enums.dart';
import 'package:moqred/backend/schema/structs/person_overview_struct.dart';
import 'package:moqred/utils/app_state.dart';
import 'new_transaction_widget.dart' show NewTransactionWidget;
import 'package:flutter/material.dart';

class NewTransactionModel extends FlutterFlowModel<NewTransactionWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for transactionAmount widget.
  FocusNode? transactionAmountFocusNode;
  TextEditingController? transactionAmountTextController;
  String? Function(BuildContext, String?)?
      transactionAmountTextControllerValidator;
  String? _transactionAmountTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'يجب ادخال المبلغ';
    }

    return null;
  }

  // State field(s) for transactionType widget.
  String? transactionTypeValue;
  FormFieldController<String>? transactionTypeValueController;
  // State field(s) for transactionPerson widget.
  String? transactionPersonValue;
  FormFieldController<String>? transactionPersonValueController;
  // State field(s) for transactionPersonNotes widget.
  FocusNode? transactionPersonNotesFocusNode;
  TextEditingController? transactionPersonNotesTextController;
  String? Function(BuildContext, String?)?
      transactionPersonNotesTextControllerValidator;

  String? errorMessage;

  @override
  void initState(BuildContext context) {
    transactionAmountTextControllerValidator =
        _transactionAmountTextControllerValidator;
  }

  @override
  void dispose() {
    transactionAmountFocusNode?.dispose();
    transactionAmountTextController?.dispose();

    transactionPersonNotesFocusNode?.dispose();
    transactionPersonNotesTextController?.dispose();
  }

  Future<void> verifyAmount() async {
    var balance = AppState().balance;
    var amount = int.parse(transactionAmountTextController?.text ?? '0');
    var tType = TransactionType.fromValue(transactionTypeValue ?? '');
    var personId = transactionPersonValue ?? '';

    switch (tType) {
      case TransactionType.loan: // loan i.e. '-1'
        if (balance.TotalIn < amount)
          throw Exception("المبلغ المتوفر غير كافي لعمل قرض");
        break;
      case TransactionType.payment: // payment i.e. to Old loan
        var personLoanRemainder = await DbReader(
                // in negative ex. '-100'
                fromMap: (map) => PersonOverviewStruct.fromMap(map),
                tableName: PersonOverviewStruct.TABLE_NAME)
            .getById(personId)
            .then((value) => value?.remainder);

        if (personLoanRemainder == null)
          throw Exception("لا يوجد قروض مستحقة للشخص حتى يتم سدادها");

        personLoanRemainder = personLoanRemainder.abs();
        if (personLoanRemainder < amount)
          throw Exception(
              "هذا المبلغ اكبر من باقي القروض المستحقة على الشخص بقيمة: $personLoanRemainder");
        break;
      case TransactionType.filling:
        break;
      default:
        break;
    }
  }
}
