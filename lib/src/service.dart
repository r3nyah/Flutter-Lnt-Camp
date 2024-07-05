import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/src/model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = 'inventory_items';

  Stream<List<InventoryItem>> getInventoryItems() {
    return _db.collection(collectionName).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc)).toList());
  }

  Future<void> addInventoryItem(InventoryItem item) {
    return _db.collection(collectionName).add(item.toMap());
  }

  Future<void> updateInventoryItem(InventoryItem item) {
    return _db.collection(collectionName).doc(item.itemId).update(item.toMap());
  }

  Future<void> deleteInventoryItem(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  // Function to add a subcollection within an item document
  Future<void> addInventorySubItem(String itemId, InventorySubItem subitem) {
    return _db
        .collection(collectionName)
        .doc(itemId)
        .collection('subitems')
        .add(subitem.toMap());
  }

  // Function to update a subcollection document
  Future<void> updateInventorySubItem(String itemId, InventorySubItem subitem) {
    return _db
        .collection(collectionName)
        .doc(itemId)
        .collection('subitems')
        .doc(subitem.subItemId)
        .update(subitem.toMap());
  }

  // Function to delete a subcollection document
  Future<void> deleteInventorySubItem(String itemId, String subitemId) {
    return _db
        .collection(collectionName)
        .doc(itemId)
        .collection('subitems')
        .doc(subitemId)
        .delete();
  }

  // Function to get subitems of an item
  Stream<List<InventorySubItem>> getInventorySubItems(String itemId) {
    return _db
        .collection(collectionName)
        .doc(itemId)
        .collection('subitems')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventorySubItem.fromFirestore(doc))
            .toList());
  }
}
