import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/providers/category_provider.dart';

class CashbookCategoryField extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final String type;
  final TextEditingController controller;
  final String? selectedCategoryName;
  final Color accentColor;
  final ValueChanged<String> onSelected;

  const CashbookCategoryField({
    super.key,
    required this.categoryProvider,
    required this.type,
    required this.controller,
    required this.selectedCategoryName,
    required this.accentColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Category>>(
      stream: categoryProvider.categoriesStream(type),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? [];

        return Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            final query =
                textEditingValue.text.trim().toLowerCase();

            final filtered = categories.where((c) {
              final name = c.name.toLowerCase();

              if (query.isEmpty) return true;

              return name.contains(query);
            }).toList();

            filtered.sort((a, b) {
              final aName = a.name.toLowerCase();
              final bName = b.name.toLowerCase();

              if (query.isEmpty) {
                return aName.compareTo(bName);
              }

              final aRank = aName.startsWith(query)
                  ? 0
                  : (aName.contains(query) ? 1 : 2);

              final bRank = bName.startsWith(query)
                  ? 0
                  : (bName.contains(query) ? 1 : 2);

              if (aRank != bRank) {
                return aRank.compareTo(bRank);
              }

              final aIndex = aName.indexOf(query);
              final bIndex = bName.indexOf(query);

              if (aIndex != bIndex) {
                final aPos = aIndex == -1 ? 999 : aIndex;
                final bPos = bIndex == -1 ? 999 : bIndex;

                return aPos.compareTo(bPos);
              }

              final aLen = aName.length;
              final bLen = bName.length;

              if (aLen != bLen) {
                return aLen.compareTo(bLen);
              }

              return aName.compareTo(bName);
            });

            return filtered.map((c) => c.name).toList();
          },
          onSelected: onSelected,
          optionsViewBuilder: (
            context,
            onSelected,
            options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: AppTheme.cardElevated,
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.glassBorderStrong,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 220,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option =
                          options.elementAt(index);

                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.10),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.category_outlined,
                                  color: accentColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    color:
                                        AppTheme.textPrimary,
                                    fontFamily: 'Outfit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.north_west_rounded,
                                color: AppTheme.textMuted,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          fieldViewBuilder: (
            context,
            autocompleteController,
            focusNode,
            onFieldSubmitted,
          ) {
            autocompleteController.text = controller.text;
            autocompleteController.selection =
                controller.selection;

            return TextFormField(
              controller: autocompleteController,
              focusNode: focusNode,
              cursorColor: accentColor,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontFamily: 'Outfit',
                fontSize: 14,
              ),
              decoration: InputDecoration(
                labelText: 'Category *',
                labelStyle: const TextStyle(
                  color: AppTheme.textSecondary,
                ),
                floatingLabelStyle: TextStyle(
                  color: accentColor,
                ),
                hintText:
                    'Type a category or select one',
                hintStyle: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: accentColor,
                ),
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.textSecondary,
                ),
                filled: true,
                fillColor: AppTheme.cardElevated,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                  borderSide: const BorderSide(
                    color: AppTheme.glassBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                  borderSide: const BorderSide(
                    color: AppTheme.glassBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                  borderSide: BorderSide(
                    color: accentColor,
                    width: 1.2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                  borderSide: const BorderSide(
                    color: AppTheme.expense,
                  ),
                ),
                focusedErrorBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                  borderSide: const BorderSide(
                    color: AppTheme.expense,
                  ),
                ),
              ),
              textCapitalization:
                  TextCapitalization.words,
              onChanged: (value) {
                controller.text = value;
                controller.selection =
                    TextSelection.collapsed(
                  offset: value.length,
                );
              },
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Category is required';
                }

                return null;
              },
            );
          },
        );
      },
    );
  }
}