class Workplace {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String whatsappNumber;

  Workplace({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.whatsappNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'whatsappNumber': whatsappNumber,
    };
  }

  factory Workplace.fromMap(Map<String, dynamic> map) {
    return Workplace(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      whatsappNumber: map['whatsappNumber'],
    );
  }
}
