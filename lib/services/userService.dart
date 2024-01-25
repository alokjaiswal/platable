import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platableapp/models/PlatableUser.dart';

class UserService {

  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference userCollectionRef;

  UserService(){
    userCollectionRef = _firestore.collection('user')
        .withConverter<PlatableUser>(
      fromFirestore: (snapshots, _) =>  PlatableUser.fromJson(snapshots.data()),
      toFirestore: (PlatableUser user, _) => user.toJson(),
    );
  }

  Stream<QuerySnapshot> getUsers() {
    return userCollectionRef.snapshots();
  }

  void addUser(PlatableUser platableUser) async {
    userCollectionRef.add(platableUser);
  }
  
  Future<PlatableUser?> searchUser(String userId) async {
    PlatableUser? platableUser = null;
    try {
      final querySnapshot = await userCollectionRef.where(
          'userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // platableUser = PlatableUser.fromJson(querySnapshot.docs.elementAt(0).data())
        QueryDocumentSnapshot snapshot = querySnapshot.docs.elementAt(0);
        platableUser = snapshot.data() as PlatableUser?;
        // querySnapshot.docs.elementAt(0).data() as PlatableUser?;
      }
    }catch(errr){
      print("error searching user $errr");
    }
    return platableUser;
  }
}