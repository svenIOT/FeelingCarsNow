class Filter {
  List<String> searchWords = [];
  String category = "";
  String fuel = "";
  int kmSince = 0;
  int kmUntil = 999999;
  int powerSince = 0;
  int powerUntil = 9999;

  Filter({
    this.searchWords,
    this.category,
    this.fuel,
    this.kmSince,
    this.kmUntil,
    this.powerSince,
    this.powerUntil,
  });
}
