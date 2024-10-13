import 'package:flutter/material.dart';
import 'medications.dart';
import 'medicationmanager.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool isEmailValid = true;
  bool isPasswordValid = true;

  //validate input for email field
  void validateEmail(String value) {
    setState(() {
      email = value;
      isEmailValid = value.isNotEmpty;
    });
  }

  //validate input for password field
  void validatePassword(String value) {
    setState(() {
      password = value;
      isPasswordValid = value.isNotEmpty;
    });
  }

  //navigate to homescreen if every input meet requirements
  void handleLogin() {
    if (isEmailValid && isPasswordValid && email.isNotEmpty && password.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        isEmailValid = email.isNotEmpty;
        isPasswordValid = password.isNotEmpty;
      });
    }
  }

  //Display top banner,input email, password field and login button
  //perform validation of every inputs and home screen navigator
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('LOGIN SCREEN'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter Email",
                  prefixIcon: Icon(Icons.email),
                  errorText: !isEmailValid ? 'Please enter email' : null,
                ),
                onChanged: validateEmail,
              ),
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter Password",
                  prefixIcon: Icon(Icons.password),
                  errorText: !isPasswordValid ? 'Please enter password' : null,
                ),
                onChanged: validatePassword,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleLogin,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //List of medicines
  MedicationManager manager = MedicationManager();

  //predeclare variable, dose, time, Medication might be null
  String name='';
  int? dose;
  int? time;

  bool isNameValid = true;
  bool isTimeValid = true;
  bool isDoseValid = true;
  Medication? editingMedication;

  //construct default 3 medicines and store in manager(medicine lists)
  @override
  void initState() {
    super.initState();
    manager.addMedication(Medication(1, 'Medicine 1', 2, 1));
    manager.addMedication(Medication(2, 'Medicine 2', 3, 2));
    manager.addMedication(Medication(3, 'Medicine 3', 4, 3));
  }

  void addOrUpdateMedication() {
  setState(() {
    // Validate name, time, and dose fields
    isNameValid = name.isNotEmpty;
    isTimeValid = time != null && time! > 0;
    isDoseValid = dose != null && dose! > 0;

    //put a ! to assume it is not null value to not get error
    if (isNameValid && isTimeValid && isDoseValid) {
      int timeValue = time!;
      int doseValue = dose!;

    
      //edit medicine if trigger editingMedicine else add medicine
      if (editingMedication == null) {
        int id = manager.getAllMedications().length + 1;
        manager.addMedication(Medication(id, name, timeValue, doseValue));
      } else {
        manager.updateMedication(editingMedication!.id, name, timeValue, doseValue);
        editingMedication = null;
      }



    }
  });
}

  //when we click on edit icon, it will trigger this function
  void loadMedicationForEditing(Medication medication) {
    setState(() {
      name = medication.name;
      time = medication.time;
      dose = medication.dose;
      editingMedication = medication;
    });
  }


  //get all medications and display it as list first
  @override
  Widget build(BuildContext context) {
    List<Medication> items = manager.getAllMedications();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Home Screen'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  //Text Field for 3 variables
                  //change data type for time and dose since they are integer
                  TextField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      errorText: !isNameValid ? 'Please enter Name' : null,
                    ),
                    onChanged: (value) => setState(() {
                      name = value;
                    }),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      errorText: !isTimeValid ? 'Please enter Time (must be an integer)' : null,
                    ),
                    onChanged: (value) => setState(() {
                      time = int.tryParse(value);
                    }),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Dose',
                      errorText: !isDoseValid ? 'Please enter Dose (must be an integer)' : null,
                    ),
                    onChanged: (value) => setState(() {
                      dose = int.tryParse(value);
                    }),
                  ),
                  SizedBox(height: 10),
                  //display as add or update button based on the value of editingMedication(null or there is selected medication)
                  ElevatedButton(
                    onPressed: addOrUpdateMedication,
                    child: Text(
                      editingMedication == null ? 'Add Medication' : 'Update Medication',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Medication medication = items[index];
                  return ListTile(
                    //List of medications and their time and dose as description
                    title: Text(medication.name),
                    subtitle: Text('Time: ${medication.time}, Dose: ${medication.dose}'),
                    tileColor: Colors.green.withOpacity(0.3),
                    leading: Icon(Icons.medication),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          //trigger load loadMedicationForEditing function when user click on edit icon
                          icon: Icon(Icons.edit),
                          onPressed: () => loadMedicationForEditing(medication),
                        ),
                        IconButton(
                          //delete the medication from the list by their id
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            manager.removeMedication(medication.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
