import 'car_model.dart';

class Filter {
  String searchWords;
  List<String> category;
  List<String> fuel;
  int kmSince;
  int kmUntil;
  int powerSince;
  int powerUntil;
  int priceSince;
  int priceUntil;
  List<CarModel> filteredCars;

  Filter(
      {this.searchWords = '',
      this.category,
      this.fuel,
      this.kmSince = 0,
      this.kmUntil = 0,
      this.powerSince = 0,
      this.powerUntil = 0,
      this.priceSince = 0,
      this.priceUntil = 0,
      this.filteredCars});

  /// Comprueba si existe un filtro de búsqueda por texto.
  bool searchWordFilterExist() => searchWords.isNotEmpty;

  /// Comprueba si existe un filtro de búsqueda por categoría.
  bool categoryFilterExist() => category.length > 0 ? true : false;

  /// Comprueba si existe un filtro de búsqueda por combustible.
  bool fuelFilterExist() => fuel.length > 0 ? true : false;

  /// Comprueba si existe un filtro de búsqueda por kilómetros.
  bool kmFilterExist() => kmSince != 0 || kmUntil != 0 ? true : false;

  /// Comprueba si existe un filtro de búsqueda por potencia.
  bool powerFilterExist() => powerSince != 0 || powerUntil != 0 ? true : false;

  /// Comprueba si existe un filtro de búsqueda por precio.
  bool priceFilterExist() => priceSince != 0 || priceUntil != 0 ? true : false;

  /// Filtra los coches de la lista por marca o modelo.
  List<CarModel> filterBySearchWords() =>
      filteredCars = filteredCars.where((car) {
        return car.brand.toLowerCase().contains(searchWords.toLowerCase()) ||
            car.model.toLowerCase().contains(searchWords.toLowerCase());
      }).toList();

  /// Filtra los coches de la lista por categoría (homologación).
  List<CarModel> filterByCategory() {
    List<CarModel> tempCars = [];
    for (var car in filteredCars) {
      for (var category in category) {
        if (car.category.compareTo(category) == 0) tempCars.add(car);
      }
    }
    if (tempCars.length > 0) filteredCars = tempCars;
    return filteredCars;
  }

  /// Filtra los coches de la lista por tipo de combustible.
  List<CarModel> filterByFuel() {
    List<CarModel> tempCars = [];
    for (var car in filteredCars) {
      for (var fuel in fuel) {
        if (car.fuel.compareTo(fuel) == 0) tempCars.add(car);
      }
    }
    if (tempCars.length > 0) filteredCars = tempCars;
    return filteredCars;
  }

  /// Filtra los coches de la lista por kilómetros. Si los kilometros máximos son 0, no hay máximo
  /// y si los kilómetros mínimos son mayores que los máximos, no hay mímino.
  List<CarModel> filterByKm() => filteredCars = filteredCars.where((car) {
        if (kmUntil == 0) return car.km >= kmSince;
        if (kmSince > kmUntil) kmSince = 0;
        return car.km >= kmSince && car.km <= kmUntil;
      }).toList();

  /// Filtra los coches de la lista por potencia. Si la potencia máxima es 0, no hay máximo
  /// y si la potencia mínima es mayor que el máximo, no hay mímino.
  List<CarModel> filterByPower() => filteredCars = filteredCars.where((car) {
        if (powerUntil == 0) return car.power >= powerSince;
        if (powerSince > powerUntil) powerSince = 0;
        return car.power >= powerSince && car.power <= powerUntil;
      }).toList();

  /// Filtra los coches de la lista por precio. Si el precio máximo es 0, no hay máximo
  /// y si el precio mínimo es mayor que el máximo, no hay mímino.
  List<CarModel> filterByPrice() => filteredCars = filteredCars.where((car) {
        if (priceUntil == 0) return car.price >= priceSince;
        if (priceSince > priceUntil) priceSince = 0;
        return car.price >= priceSince && car.price <= priceUntil;
      }).toList();
}
