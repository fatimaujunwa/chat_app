
import 'package:firebase_auth/firebase_auth.dart';

import 'database_services.dart';

class AuthServices{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  Future registerUserWithEmailAndPassword(String email, String password, String firstname,String groupName,String lastname)async{
    try{
      User user=(await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        await DatabaseServices(uid: user.uid).updateUserData(firstname, email,groupName,lastname);
        return true;
      }
    }on FirebaseAuthException catch(e){
      print(e);
    }
  }
  Future loginUserWithEmailAndPassword(String email, String password)async{
    try{
      User user=(await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        // await DatabaseServices(uid: user.uid).updateUserData(firstName, email,groupName,lastname);
        return true;
      }
    }on FirebaseAuthException catch(e){
      print(e);
    }
  }


}