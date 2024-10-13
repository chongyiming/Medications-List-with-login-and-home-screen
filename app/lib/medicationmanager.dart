import 'medications.dart';


class MedicationManager {
  List<Medication> _medications = [];

  void addMedication(Medication medication) {
    _medications.add(medication);
  }

  bool removeMedication(int id) {
    final medication = _findMedicationById(id);
    if (medication != null) {
      _medications.remove(medication);
      return true;
    }
    return false;
  }

  bool updateMedication(int id, String name, int time, int dose) {
    final medication = _findMedicationById(id);
    if (medication != null) {
      medication.name = name;
      medication.dose = dose;
      medication.time = time;
      return true;
    }
    return false;
  }

  List<Medication> getAllMedications() => _medications;

  Medication? _findMedicationById(int id) {
    try {
      return _medications.firstWhere((med) => med.id == id);
    } catch (e) {
      return null;
    }
  }
}