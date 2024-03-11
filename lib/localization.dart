localizedField(String field, {String local = "en"}) {
  if (local == "en") {
    return "${field}_en";
  }
  return field;
}
