
import 'package:myassistantv2/core/global/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveActive() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt("activeBudget", activeBudget);
}

Future saveInitVal() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setDouble("initialVal",
      double.parse(selectedBudget['initial_budget']) - totalExpense);
}

Future savePref(email, pass) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('acc_email', email);
  prefs.setString('acc_pass', pass);
}

savePin() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("pin", pin);
  prefs.setBool('pinActive', true);
}

saveFinger() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('fingerActive', true);
}

clearFinger() async {
  fingerActive = false;
  fActive = null;
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("fingerActive");
}

clearPin() async {
  pActive = null;
  pinActive = false;
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("pinActive");
}

fingerAvailability() async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("fingerAvailability", true);
}

timeIncomeAdded(date) async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("timeIncome", date);
}


  clearPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

saveFb(bool val)async{
   final prefs = await SharedPreferences.getInstance();
  prefs.setBool('fbIn', val);
}
saveGoogle(bool val)async{
   final prefs = await SharedPreferences.getInstance();
  prefs.setBool('googleIn', val);
}







