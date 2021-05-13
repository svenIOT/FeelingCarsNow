class Filter {
  String searchWords;
  List<String> category = [];
  List<String> fuel = [];
  int kmSince;
  int kmUntil;
  int powerSince;
  int powerUntil;
  int priceSince;
  int priceUntil;

  Filter({
    this.searchWords,
    this.category,
    this.fuel,
    this.kmSince = 0,
    this.kmUntil = 999999,
    this.powerSince = 0,
    this.powerUntil = 9999,
    this.priceSince = 0,
    this.priceUntil = 999999,
  });
}
