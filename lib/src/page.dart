import 'package:crud/src/sub_item_page.dart';
import 'package:flutter/material.dart';
import 'service.dart';
import 'model.dart';

class InventoryItemsPage extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  InventoryItemsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD'),
      ),
      body: StreamBuilder<List<InventoryItem>>(
        stream: firebaseService.getInventoryItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          List<InventoryItem> items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index].itemName ?? ''),
                subtitle: Text('Quantity: ${items[index].itemQuantity ?? 0}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editItemDialog(context, items[index]);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteItemDialog(context, items[index]);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  _navigateToSubitemsPage(context, items[index]);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addItemDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
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
                InventoryItem newItem = InventoryItem(
                  itemName: nameController.text,
                  itemQuantity: int.parse(quantityController.text),
                );
                firebaseService.addInventoryItem(newItem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editItemDialog(BuildContext context, InventoryItem item) {
    TextEditingController nameController =
        TextEditingController(text: item.itemName);
    TextEditingController quantityController =
        TextEditingController(text: item.itemQuantity.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
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
                item.itemName = nameController.text;
                item.itemQuantity = int.parse(quantityController.text);
                firebaseService.updateInventoryItem(item);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteItemDialog(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
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
                firebaseService.deleteInventoryItem(item.itemId!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSubitemsPage(BuildContext context, InventoryItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InventorySubItemsPage(
          item: item,
          firebaseService: firebaseService,
        ),
      ),
    );
  }
}
