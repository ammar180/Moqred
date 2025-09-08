import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/models/transaction.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'transactions_page_widget.dart' show TransactionsPageWidget;

class TransactionsPageModel extends FlutterFlowModel<TransactionsPageWidget> {
  late final PagingController<int, Transaction> pagingController;

  static const _pageSize = 10;

  TransactionsPageModel() {
    pagingController = PagingController<int, Transaction>(
      fetchPage: (pageKey) async =>
          await FetchTransactionsCall.call(page: pageKey, perPage: _pageSize)
              .then((value) => value.items),
      getNextPageKey: (state) {
        if (!state.hasNextPage) return null;
        final lastKey = state.keys?.isEmpty ?? true ? 0 : state.keys?.last ?? 0;
        return lastKey + 1;
      },
    );
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    pagingController.dispose();
  }
}
