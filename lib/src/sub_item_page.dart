import 'package:crud/src/service.dart';
import 'package:crud/src/model.dart';
import 'package:flutter/material.dart';

class InventorySubItemsPage extends StatelessWidget {
  final InventoryItem item;
  final FirebaseService firebaseService;

  const InventorySubItemsPage({
    Key? key,
    required this.item,
    required this.firebaseService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subitems for ${item.itemName}'),
      ),
      body: StreamBuilder<List<InventorySubItem>>(
        stream: firebaseService.getInventorySubItems(item.itemId!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          List<InventorySubItem> subitems = snapshot.data!;

          return ListView.builder(
            itemCount: subitems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(subitems[index].subItemName),
                subtitle: Text('Quantity: ${subitems[index].subItemQuantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editSubItemDialog(context, item, subitems[index]);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteSubItemDialog(context, item, subitems[index]);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addSubItemDialog(context, item);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addSubItemDialog(BuildContext context, InventoryItem item) {
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Subitem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                InventorySubItem newSubitem = InventorySubItem(
                  subItemId: '',
                  subItemName: nameController.text,
                  subItemQuantity: int.parse(quantityController.text),
                );
                firebaseService.addInventorySubItem(item.itemId!, newSubitem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editSubItemDialog(BuildContext context, InventoryItem item, InventorySubItem subitem) {
    TextEditingController nameController =
        TextEditingController(text: subitem.subItemName);
    TextEditingController quantityController =
        TextEditingController(text: subitem.subItemQuantity.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Subitem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                subitem.subItemName = nameController.text;
                subitem.subItemQuantity = int.parse(quantityController.text);
                firebaseService.updateInventorySubItem(item.itemId!, subitem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSubItemDialog(BuildContext context, InventoryItem item, InventorySubItem subitem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subitem'),
          content: const Text('Are you sure you want to delete this subitem?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                firebaseService.deleteInventorySubItem(item.itemId!, subitem.subItemId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
