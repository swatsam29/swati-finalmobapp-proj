
enum DocKeyUserProfile {
  name,
  department,
  designation,
  phone,
  manager,
  directreport,
  timestamp,
}

class UserProfile {
  String? docId;
  late String name;
  late String department;
  late String manager;
  late String designation;
  late String phone;
  late String directreport;
  DateTime? timestamp;

  UserProfile({
    this.docId,
    this.name = '',
    this.department = '',
    this.manager = '',
    this.designation = '',
    this.phone = '',
    this.directreport = '',
    this.timestamp,
  });

  static UserProfile? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    return UserProfile(
      docId: docId,
      name: doc[DocKeyUserProfile.name.name] ??= 'N/A',
      department: doc[DocKeyUserProfile.department.name] ??= 'N/A',
      manager: doc[DocKeyUserProfile.manager.name] ??= 'N/A',
      designation: doc[DocKeyUserProfile.designation.name] ??= 'N/A',
      phone: doc[DocKeyUserProfile.phone.name] ??= 'N/A',
      directreport: doc[DocKeyUserProfile.directreport.name] ??= 'N/A',

      timestamp: doc[DocKeyUserProfile.timestamp.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyUserProfile.timestamp.name].millisecondsSinceEpoch,
            )
          : DateTime.now(),
    );
  }


}


// rules_version = '2';
// service cloud.firestore {
//   match /databases/{database}/documents {
//     match /photomemo_collection/{doc}{
//     allow create: if request.auth != null;
//     allow update, delete: if request.auth != null &&
//     request.auth.token.email == resource.data.createBy;
//     allow read: if request.auth != null &&
//     (request.auth.token.email == resource.data.createBy ||
//     request.auth.token.email in resource.data.sharedwith 
//     );
//      allow read: if request.auth != null &&
//     (request.auth.token.email == resource.data.createBy ||
//     request.auth.token.email in resource.data.createBy 
//     );
//     }
//   }
// }