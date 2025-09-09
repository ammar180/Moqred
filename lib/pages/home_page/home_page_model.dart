import 'package:moqred/backend/schema/structs/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';
import '/flutter_flow/flutterflow_ui.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  int dtCurrentPage = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - SQLite (FetchPersonsOverviewCall)] action in HomePage widget.
  PaginatedResult<PersonOverviewStruct>? personsOverviewResponse;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<PersonOverviewStruct>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
