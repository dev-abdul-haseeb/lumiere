import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumiere/src/data/models/application_model.dart';
import '../../core/constants/constants.dart';

class ApplicationRemoteDatasource {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ApplicationModel> getApplicationData() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.applicationCollection)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("Application not found");
      }

      final doc = querySnapshot.docs.first;
      return ApplicationModel.fromMap(doc.data()).copyWith(id: doc.id);

    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<ApplicationModel> updateApplicationData(ApplicationModel application) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.applicationCollection)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // No document — create one
        final docRef = await _firestore
            .collection(AppConstants.applicationCollection)
            .add(application.toMap());

        return application.copyWith(id: docRef.id);
      } else {
        // Document exists — update it
        final docId = querySnapshot.docs.first.id;
        await _firestore
            .collection(AppConstants.applicationCollection)
            .doc(docId)
            .update(application.toMap());

        return application.copyWith(id: docId);
      }

    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}