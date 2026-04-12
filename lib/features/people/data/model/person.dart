import 'package:people_browser_app/core/utils/check_null.dart';

class PeopleModel {
  List<Result> results;
  Info info;

  PeopleModel({
    required this.results,
    required this.info,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) => PeopleModel(
    results: List<Result>.from(CheckNull.list(json["results"]).map((x) => Result.fromJson(x))),
    info: Info.fromJson(CheckNull.map(json["info"])),
  );

}

class Info {
  String seed;
  int results;
  int page;
  String version;

  Info({
    required this.seed,
    required this.results,
    required this.page,
    required this.version,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    seed: CheckNull.string(json["seed"]),
    results: CheckNull.intValue(json["results"]),
    page: CheckNull.intValue(json["page"]),
    version: CheckNull.string(json["version"]),
  );
}

class Result {
  String gender;
  Name name;
  Location location;
  String email;
  Login login;
  Dob dob;
  Dob registered;
  String phone;
  String cell;
  Id id;
  Picture picture;
  String nat;

  Result({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.id,
    required this.picture,
    required this.nat,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    gender: CheckNull.string(json["gender"]),
    name: Name.fromJson(CheckNull.map(json["name"])),
    location: Location.fromJson(CheckNull.map(json["location"])),
    email: CheckNull.string(json["email"]),
    login: Login.fromJson(CheckNull.map(json["login"])),
    dob: Dob.fromJson(CheckNull.map(json["dob"])),
    registered: Dob.fromJson(CheckNull.map(json["registered"])),
    phone: CheckNull.string(json["phone"]),
    cell: CheckNull.string(json["cell"]),
    id: Id.fromJson(CheckNull.map(json["id"])),
    picture: Picture.fromJson(CheckNull.map(json["picture"])),
    nat: CheckNull.string(json["nat"]),
  );

}

class Dob {
  String date;
  int age;

  Dob({
    required this.date,
    required this.age,
  });

  factory Dob.fromJson(Map<String, dynamic> json) => Dob(
    date: CheckNull.string(json["date"]),
    age: CheckNull.intValue(json["age"]),
  );
}

class Id {
  String name;
  String value;

  Id({
    required this.name,
    required this.value,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    name: CheckNull.string(json["name"]),
    value: CheckNull.string(json["value"]),
  );

}

class Location {
  Street street;
  String city;
  String state;
  String country;
  int postcode;
  Coordinates coordinates;
  Timezone timezone;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    street: Street.fromJson(CheckNull.map(json["street"])),
    city: CheckNull.string(json["city"]),
    state: CheckNull.string(json["state"]),
    country: CheckNull.string(json["country"]),
    postcode: CheckNull.intValue(json["postcode"]),
    coordinates: Coordinates.fromJson(CheckNull.map(json["coordinates"])),
    timezone: Timezone.fromJson(CheckNull.map(json["timezone"])),
  );
}

class Coordinates {
  String latitude;
  String longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    latitude: CheckNull.string(json["latitude"]),
    longitude: CheckNull.string(json["longitude"]),
  );

}

class Street {
  int number;
  String name;

  Street({
    required this.number,
    required this.name,
  });

  factory Street.fromJson(Map<String, dynamic> json) => Street(
    number: CheckNull.intValue(json["number"]),
    name: CheckNull.string(json["name"]),
  );
}

class Timezone {
  String offset;
  String description;

  Timezone({
    required this.offset,
    required this.description,
  });

  factory Timezone.fromJson(Map<String, dynamic> json) => Timezone(
    offset: CheckNull.string(json["offset"]),
    description: CheckNull.string(json["description"]),
  );
}

class Login {
  String uuid;
  String username;
  String password;
  String salt;
  String md5;
  String sha1;
  String sha256;

  Login({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    uuid: CheckNull.string(json["uuid"]),
    username: CheckNull.string(json["username"]),
    password: CheckNull.string(json["password"]),
    salt: CheckNull.string(json["salt"]),
    md5: CheckNull.string(json["md5"]),
    sha1: CheckNull.string(json["sha1"]),
    sha256: CheckNull.string(json["sha256"]),
  );
}

class Name {
  String title;
  String first;
  String last;

  Name({
    required this.title,
    required this.first,
    required this.last,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    title: CheckNull.string(json["title"]),
    first: CheckNull.string(json["first"]),
    last: CheckNull.string(json["last"]),
  );
}

class Picture {
  String large;
  String medium;
  String thumbnail;

  Picture({
    required this.large,
    required this.medium,
    required this.thumbnail,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    large: CheckNull.string(json["large"]),
    medium: CheckNull.string(json["medium"]),
    thumbnail: CheckNull.string(json["thumbnail"]),
  );
}

extension ResultPresentation on Result {
  String get heroTag => 'person-avatar-${login.uuid}';

  String get fullName => '${name.first} ${name.last}';
}
