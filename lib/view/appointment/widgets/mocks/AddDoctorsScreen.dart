import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/Doctor.model.dart';
import 'package:projeto_mobile/model/Workplace.model.dart';
import 'package:projeto_mobile/provider/appointment/Doctor.provider.dart';
import 'package:provider/provider.dart';

class AddDoctorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Médicos Mockados'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Adiciona os médicos mockados ao Firebase
            addMockDoctors(context);
          },
          child: Text('Adicionar Médicos Mockados'),
        ),
      ),
    );
  }

  void addMockDoctors(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    List<Doctor> mockDoctors = [
      Doctor(
        id: '1',
        name: 'Dr. João Silva',
        specialty: 'Cardiologista',
        workplace: Workplace(
          id: '1',
          name: 'Clínica Coração Saudável',
          address: 'Rua das Palmeiras, 123, Rio de Janeiro, RJ',
          phoneNumber: '(21) 99999-9999',
          whatsappNumber: '(21) 99999-9999',
        ),
      ),
      Doctor(
        id: '2',
        name: 'Dra. Maria Oliveira',
        specialty: 'Dermatologista',
        workplace: Workplace(
          id: '2',
          name: 'Clínica Pele Perfeita',
          address: 'Avenida Paulista, 456, São Paulo, SP',
          phoneNumber: '(11) 98888-8888',
          whatsappNumber: '(11) 98888-8888',
        ),
      ),
      Doctor(
        id: '3',
        name: 'Dr. Carlos Pereira',
        specialty: 'Neurologista',
        workplace: Workplace(
          id: '3',
          name: 'Hospital Neurológico',
          address: 'Rua das Flores, 789, Belo Horizonte, MG',
          phoneNumber: '(31) 97777-7777',
          whatsappNumber: '(31) 97777-7777',
        ),
      ),
      Doctor(
        id: '4',
        name: 'Dra. Ana Souza',
        specialty: 'Pediatra',
        workplace: Workplace(
          id: '4',
          name: 'Clínica Infantil',
          address: 'Avenida Brasil, 101, Curitiba, PR',
          phoneNumber: '(41) 96666-6666',
          whatsappNumber: '(41) 96666-6666',
        ),
      ),
      Doctor(
        id: '5',
        name: 'Dr. Pedro Santos',
        specialty: 'Ortopedista',
        workplace: Workplace(
          id: '5',
          name: 'Ortopedia Avançada',
          address: 'Rua XV de Novembro, 202, Porto Alegre, RS',
          phoneNumber: '(51) 95555-5555',
          whatsappNumber: '(51) 95555-5555',
        ),
      ),
      Doctor(
        id: '6',
        name: 'Dra. Fernanda Lima',
        specialty: 'Ginecologista',
        workplace: Workplace(
          id: '6',
          name: 'Saúde da Mulher',
          address: 'Avenida Sete de Setembro, 303, Salvador, BA',
          phoneNumber: '(71) 94444-4444',
          whatsappNumber: '(71) 94444-4444',
        ),
      ),
      Doctor(
        id: '7',
        name: 'Dr. Rafael Alves',
        specialty: 'Psiquiatra',
        workplace: Workplace(
          id: '7',
          name: 'Clínica Mentalmente Saudável',
          address: 'Rua das Laranjeiras, 404, Recife, PE',
          phoneNumber: '(81) 93333-3333',
          whatsappNumber: '(81) 93333-3333',
        ),
      ),
      Doctor(
        id: '8',
        name: 'Dra. Juliana Machado',
        specialty: 'Endocrinologista',
        workplace: Workplace(
          id: '8',
          name: 'Clínica Metabólica',
          address: 'Avenida Independência, 505, Fortaleza, CE',
          phoneNumber: '(85) 92222-2222',
          whatsappNumber: '(85) 92222-2222',
        ),
      ),
      Doctor(
        id: '9',
        name: 'Dr. Lucas Fernandes',
        specialty: 'Oftalmologista',
        workplace: Workplace(
          id: '9',
          name: 'Olhar Atento',
          address: 'Rua das Acácias, 606, Manaus, AM',
          phoneNumber: '(92) 91111-1111',
          whatsappNumber: '(92) 91111-1111',
        ),
      ),
      Doctor(
        id: '10',
        name: 'Dra. Patrícia Gomes',
        specialty: 'Nutricionista',
        workplace: Workplace(
          id: '10',
          name: 'Clínica Boa Alimentação',
          address: 'Avenida do Estado, 707, Florianópolis, SC',
          phoneNumber: '(48) 90000-0000',
          whatsappNumber: '(48) 90000-0000',
        ),
      ),
    ];

    for (var doctor in mockDoctors) {
      doctorProvider.addDoctor(doctor);
    }
  }
}
