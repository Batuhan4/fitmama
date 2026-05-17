enum UserRole { mom, partner }

UserRole? userRoleFromString(String? s) {
  if (s == null) return null;
  for (final r in UserRole.values) {
    if (r.name == s) return r;
  }
  return null;
}
