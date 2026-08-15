import 'package:drift/drift.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/constants/contact_balance_type.dart';

class ContactService {
  final AppDatabase db;

  ContactService(this.db);

  // -------------------------------------------------------
  // Watch active contacts (for list screen)
  // -------------------------------------------------------
  Stream<List<Contact>> watchActiveContacts({
    required int userId,
    String searchQuery = '',
    String? filterType, // null = ALL
  }) {
    final query = db.select(db.contacts)
      ..where((c) => c.userId.equals(userId) & c.isActive.equals(1));

    if (searchQuery.trim().isNotEmpty) {
      final term = '%${searchQuery.trim()}%';
      query.where((c) => c.name.like(term) | c.phone.like(term));
    }

    if (filterType != null && filterType.isNotEmpty) {
      query.where((c) => c.currentType.equals(filterType));
    }

    query.orderBy([(c) => OrderingTerm.desc(c.updatedAt)]);

    return query.watch();
  }

  // -------------------------------------------------------
  // Get one contact (with ownership check)
  // -------------------------------------------------------
  Future<Contact?> getContactById({
    required int userId,
    required int contactId,
  }) {
    return (db.select(db.contacts)
          ..where((c) =>
              c.id.equals(contactId) & c.userId.equals(userId)))
        .getSingleOrNull();
  }

  // -------------------------------------------------------
  // Watch one contact
  // -------------------------------------------------------
  Stream<Contact?> watchContact({
    required int userId,
    required int contactId,
  }) {
    return (db.select(db.contacts)
          ..where((c) =>
              c.id.equals(contactId) & c.userId.equals(userId)))
        .watchSingleOrNull();
  }

  // -------------------------------------------------------
  // Check if phone already exists as active contact
  // -------------------------------------------------------
  Future<Contact?> findActiveContactByPhone({
    required int userId,
    required String phone,
  }) {
    return (db.select(db.contacts)
          ..where((c) =>
              c.userId.equals(userId) &
              c.phone.equals(phone) &
              c.isActive.equals(1)))
        .getSingleOrNull();
  }

  // -------------------------------------------------------
  // Create new contact
  // -------------------------------------------------------
  Future<int> createContact({
    required int userId,
    required String name,
    required String phone,
    required int openingAmount,
    required String openingType,
    String? description,
  }) async {
    // Final protection against duplicate active phone
    final existing = await findActiveContactByPhone(
      userId: userId,
      phone: phone,
    );
    if (existing != null) {
      throw Exception('Phone number already exists');
    }

    final now = DateTime.now().toUtc();

    // For a brand-new contact, current = opening
    return db.into(db.contacts).insert(
          ContactsCompanion.insert(
            userId: userId,
            name: name.trim(),
            phone: phone,
            openingAmount: Value(openingAmount),
            openingType: openingType,
            currentAmount: Value(openingAmount),
            currentType: Value(openingType),
            description: Value(description),
            isActive: const Value(1),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  // -------------------------------------------------------
  // Soft delete (deactivate)
  // -------------------------------------------------------
  Future<void> deactivateContact({
    required int userId,
    required int contactId,
  }) async {
    final contact = await getContactById(userId: userId, contactId: contactId);
    if (contact == null) {
      throw Exception('Contact not found');
    }
    if (contact.isActive == 0) {
      throw Exception('Contact is already inactive');
    }

    await (db.update(db.contacts)
          ..where((c) =>
              c.id.equals(contactId) & c.userId.equals(userId)))
        .write(const ContactsCompanion(isActive: Value(0)));
  }

  // -------------------------------------------------------
  // Recalculate and save current balance for one contact
  // This is the single source of truth calculation
  // -------------------------------------------------------
  Future<void> recalculateContactBalance({
    required int userId,
    required int contactId,
  }) async {
    final contact = await getContactById(userId: userId, contactId: contactId);
    if (contact == null) return;

    // Get all active GAVE / GOT for this contact
    final txs = await (db.select(db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.contactId.equals(contactId) &
              t.isActive.equals(1) &
              (t.type.equals('GAVE') | t.type.equals('GOT'))))
        .get();

    // Start from opening
    int signed = 0;
    if (contact.openingType == ContactBalanceType.willGet) {
      signed = contact.openingAmount;
    } else if (contact.openingType == ContactBalanceType.willGive) {
      signed = -contact.openingAmount;
    }

    // Apply transactions
    for (final tx in txs) {
      if (tx.type == 'GAVE') {
        signed += tx.amount;
      } else if (tx.type == 'GOT') {
        signed -= tx.amount;
      }
    }

    // Convert signed → currentAmount + currentType
    final int currentAmount;
    final String currentType;

    if (signed > 0) {
      currentAmount = signed;
      currentType = ContactBalanceType.willGet;
    } else if (signed < 0) {
      currentAmount = -signed;
      currentType = ContactBalanceType.willGive;
    } else {
      currentAmount = 0;
      currentType = ContactBalanceType.settled;
    }

    // Save
    await (db.update(db.contacts)..where((c) => c.id.equals(contactId))).write(
      ContactsCompanion(
        currentAmount: Value(currentAmount),
        currentType: Value(currentType),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

    // -------------------------------------------------------
  // Get all GAVE/GOT transactions for a contact
  // -------------------------------------------------------
  Future<List<Transaction>> getContactTransactions({
    required int userId,
    required int contactId,
  }) {
    return (db.select(db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.contactId.equals(contactId) &
              t.isActive.equals(1) &
              (t.type.equals('GAVE') | t.type.equals('GOT')))
          ..orderBy([
            (t) => OrderingTerm.desc(t.transactionDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  // -------------------------------------------------------
  // Watch all GAVE/GOT transactions for a contact (stream)
  // -------------------------------------------------------
  Stream<List<Transaction>> watchContactTransactions({
    required int userId,
    required int contactId,
  }) {
    return (db.select(db.transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.contactId.equals(contactId) &
              t.isActive.equals(1) &
              (t.type.equals('GAVE') | t.type.equals('GOT')))
          ..orderBy([
            (t) => OrderingTerm.desc(t.transactionDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  // -------------------------------------------------------
  // Update contact profile (name, phone, description only)
  // -------------------------------------------------------
  Future<void> updateContactProfile({
    required int userId,
    required int contactId,
    required String name,
    required String phone,
    String? description,
  }) async {
    // Check ownership + exists
    final existing = await getContactById(userId: userId, contactId: contactId);
    if (existing == null) {
      throw Exception('Contact not found');
    }

    // If phone changed → check duplicate
    if (phone != existing.phone) {
      final duplicate = await findActiveContactByPhone(
        userId: userId,
        phone: phone,
      );
      if (duplicate != null) {
        throw Exception('Phone number already exists');
      }
    }

    await (db.update(db.contacts)
          ..where((c) => c.id.equals(contactId) & c.userId.equals(userId)))
        .write(
      ContactsCompanion(
        name: Value(name),
        phone: Value(phone),
        description: Value(description),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}