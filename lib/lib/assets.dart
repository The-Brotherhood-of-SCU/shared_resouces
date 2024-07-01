
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;
String? _account;
String? get myAccount{
  return _account;
}
set myAccount(String? account){
  if(account==null){
    preferences.remove(ACCOUNT_Str);
  }else{
    preferences.setString(ACCOUNT_Str, account);
  }

  _account=account;
}
String ACCOUNT_Str="account";

String INTEREST_Str="interest";
String GRADES_Str="grades";