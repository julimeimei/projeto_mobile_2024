import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:projeto_mobile/provider/appointment/Doctor.provider.dart';
import 'package:provider/provider.dart';
import 'package:projeto_mobile/model/Doctor.model.dart';
import 'package:projeto_mobile/model/Workplace.model.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _workplaceNameController = TextEditingController();
  final _workplaceAddressController = TextEditingController();
  final _workplacePhoneController = TextEditingController();
  final _workplaceWhatsappController = TextEditingController();

  final String _googleApiKey = 'AIzaSyAQJpKbMw1KwgeNl38WimhBrb_OSmPQrCc';

  Future<void> _getAddressFromName() async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(_workplaceNameController.text)}&key=$_googleApiKey';

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final address = data['results'][0]['formatted_address'];
        setState(() {
          _workplaceAddressController.text = address;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Endereço não encontrado.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar endereço: $error')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    loc.PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) return;
    }

    loc.LocationData _locationData = await location.getLocation();

    if (_locationData.latitude != null && _locationData.longitude != null) {
      try {
        final url =
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_locationData.latitude},${_locationData.longitude}&key=$_googleApiKey';

        final response = await http.get(Uri.parse(url));
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final address = data['results'][0]['formatted_address'];
          setState(() {
            _workplaceAddressController.text = address;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Endereço não encontrado.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar endereço: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível obter a localização.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Doutor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specialtyController,
                decoration: InputDecoration(labelText: 'Especialidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a especialidade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _workplaceNameController,
                decoration: InputDecoration(labelText: 'Nome do Local de Trabalho'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do local de trabalho';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _getAddressFromName,
                child: Text('Buscar Endereço pelo Nome do Local de Trabalho'),
              ),
              TextFormField(
                controller: _workplaceAddressController,
                decoration: InputDecoration(labelText: 'Endereço do Local de Trabalho'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço do local de trabalho';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: Text('Usar Localização Atual'),
              ),
              TextFormField(
                controller: _workplacePhoneController,
                decoration: InputDecoration(labelText: 'Telefone do Local de Trabalho'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone do local de trabalho';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _workplaceWhatsappController,
                decoration: InputDecoration(labelText: 'WhatsApp do Local de Trabalho'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o WhatsApp do local de trabalho';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newDoctor = Doctor(
                      id: DateTime.now().toString(),
                      name: _nameController.text,
                      specialty: _specialtyController.text,
                      workplace: Workplace(
                        id: DateTime.now().toString(),
                        name: _workplaceNameController.text,
                        address: _workplaceAddressController.text,
                        phoneNumber: _workplacePhoneController.text,
                        whatsappNumber: _workplaceWhatsappController.text,
                      ),
                    );

                    Provider.of<DoctorProvider>(context, listen: false).addDoctor(newDoctor);

                    Navigator.pop(context);
                  }
                },
                child: Text('Adicionar Doutor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
