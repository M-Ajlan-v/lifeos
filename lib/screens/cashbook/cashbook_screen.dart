import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/providers/transaction_provider.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/screens/transactions/transaction_detail_screen.dart';
import 'add_income_expense_screen.dart';
import 'widget/cashbook_transaction_tile.dart';
import 'widget/cashbook_add_option.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class CashbookScreen extends StatefulWidget {
  const CashbookScreen({super.key});

  @override
  State<CashbookScreen> createState() => _CashbookScreenState();
}

class _CashbookScreenState extends State<CashbookScreen> {
  int _refreshKey = 0;

  void _forceRefresh() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider?>();

    if (txProvider == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Text(
            'Please login first',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontFamily: 'Outfit',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: RefreshIndicator(
        color: AppTheme.violetBright,
        backgroundColor: AppTheme.cardElevated,
        onRefresh: () async {
          _forceRefresh();
          await Future.delayed(
            const Duration(milliseconds: 400),
          );
        },
        child: StreamBuilder<List<Transaction>>(
          key: ValueKey(_refreshKey),
          stream: txProvider.cashbookStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.violetBright,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.expense,
                      fontFamily: 'Outfit',
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            final transactions = snapshot.data ?? [];

            if (transactions.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _EmptyCashbookIcon(),
                            SizedBox(height: 18),
                            Text(
                              'No income or expense yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Tap + to add one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontFamily: 'Outfit',
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 100),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];

                return CashbookTransactionTile(
                  transaction: tx,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        backgroundColor: AppTheme.violet,
        foregroundColor: AppTheme.textPrimary,
        elevation: 8,
        child: const Icon(
          Icons.add_rounded,
          size: 26,
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.65),
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
            decoration: BoxDecoration(
              color: AppTheme.cardElevated,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppTheme.glassBorderStrong,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(14, 2, 14, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add to Cashbook',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                CashbookAddOption(
                  icon: Icons.arrow_downward_rounded,
                  title: 'Add Income',
                  subtitle: 'Record money received',
                  color: AppTheme.income,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AddIncomeExpenseScreen(
                          type: 'INCOME',
                        ),
                      ),
                    );
                  },
                ),
                CashbookAddOption(
                  icon: Icons.arrow_upward_rounded,
                  title: 'Add Expense',
                  subtitle: 'Record money spent',
                  color: AppTheme.expense,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AddIncomeExpenseScreen(
                          type: 'EXPENSE',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyCashbookIcon extends StatelessWidget {
  const _EmptyCashbookIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: AppTheme.violetGlowGradient,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.violetBright.withOpacity(0.18),
        ),
      ),
      child: const Icon(
        Icons.receipt_long_rounded,
        color: AppTheme.violetBright,
        size: 32,
      ),
    );
  }
}