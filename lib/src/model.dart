import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  String? itemId;
  String? itemName;
  int? itemQuantity;

  InventoryItem({this.itemId, this.itemName, this.itemQuantity});

  Map<String, dynamic> toMap() {
    return {
      'name': itemName,
      'quantity': itemQuantity,
    };
  }

  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InventoryItem(
      itemId: doc.id,
      itemName: data['name'],
      itemQuantity: data['quantity'],
    );
  }
}

class InventorySubItem {
  String subItemId;
  String subItemName;
  int subItemQuantity;

  InventorySubItem({
    required this.subItemId,
    required this.subItemName,
    required this.subItemQuantity,
  });

  factory InventorySubItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InventorySubItem(
      subItemId: doc.id,
      subItemName: data['name'] ?? '',
      subItemQuantity: data['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': subItemName,
      'quantity': subItemQuantity,
    };
  }
}
