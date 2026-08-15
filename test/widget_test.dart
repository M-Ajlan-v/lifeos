// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/account_service.dart';
import 'package:lifeos/services/category_service.dart';
import 'package:lifeos/services/contact_service.dart';
import 'package:lifeos/services/transaction_service.dart';

void main() {
  test('rejects expense when it exceeds account balance', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final now = DateTime.now().toUtc();

    final userId = await db.into(db.users).insert(
      UsersCompanion.insert(
        username: 'user-${DateTime.now().millisecondsSinceEpoch}',
        password: 'pass',
        displayName: Value('Tester'),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final accountId = await db.into(db.accounts).insert(
      AccountsCompanion.insert(
        userId: userId,
        name: 'Main Account',
        type: 'BANK',
        openingBalance: 1000,
        isActive: const Value(1),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final categoryId = await db.into(db.categories).insert(
      CategoriesCompanion.insert(
        userId: userId,
        name: 'Food',
        type: 'EXPENSE',
        isActive: const Value(1),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final service = TransactionService(
      db,
      ContactService(db),
      AccountService(db),
      CategoryService(db),
    );

    expect(
      () => service.createTransaction(
        userId: userId,
        type: 'EXPENSE',
        amount: 1500,
        accountId: accountId,
        categoryId: categoryId,
        transactionDate: now,
      ),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Cannot add expense'),
        ),
      ),
    );
  });
}
