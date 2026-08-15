/// Contact balance types (opening and current).
/// Never use raw strings for these values.
class ContactBalanceType {
  static const String willGet = 'WILL_GET';
  static const String willGive = 'WILL_GIVE';
  static const String settled = 'SETTLED';

  static const List<String> all = [willGet, willGive, settled];

  static bool isValid(String value) => all.contains(value);
}