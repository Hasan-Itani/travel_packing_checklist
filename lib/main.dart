import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Packing Checklist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserInfoPage(),
    );
  }
}

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController travelDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void proceedToChecklist() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackingChecklistPage(
            name: nameController.text,
            lastName: lastNameController.text,
            travelDate: travelDateController.text,
            location: locationController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traveler Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: travelDateController,
                decoration: const InputDecoration(
                  labelText: 'Travel Date',
                  hintText: 'YYYY-MM-DD',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your travel date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Travel Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your travel location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: proceedToChecklist,
                child: Text('Continue to Checklist'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PackingChecklistPage extends StatefulWidget {
  final String name;
  final String lastName;
  final String travelDate;
  final String location;

  PackingChecklistPage({
    required this.name,
    required this.lastName,
    required this.travelDate,
    required this.location,
  });

  @override
  _PackingChecklistPageState createState() => _PackingChecklistPageState();
}

class _PackingChecklistPageState extends State<PackingChecklistPage> {
  final Map<String, List<Map<String, dynamic>>> categories = {
    "Clothing": [
      {"name": "Shirts", "isPacked": false},
      {"name": "Pants", "isPacked": false},
      {"name": "Socks", "isPacked": false},
    ],
    "Toiletries": [
      {"name": "Toothbrush", "isPacked": false},
      {"name": "Shampoo", "isPacked": false},
      {"name": "Soap", "isPacked": false},
    ],
    "Gadgets": [
      {"name": "Phone Charger", "isPacked": false},
      {"name": "Headphones", "isPacked": false},
      {"name": "Power Bank", "isPacked": false},
    ],
    "Pet": [
      {"name": "Pet Carrier", "isPacked": false},
      {"name": "Food and Water Bowls", "isPacked": false},
      {"name": "Pet Medications", "isPacked": false},
    ],
  };

  void toggleItem(String category, int index) {
    setState(() {
      categories[category]![index]['isPacked'] =
      !categories[category]![index]['isPacked'];
    });
  }

  void resetChecklist() {
    setState(() {
      for (var category in categories.keys) {
        for (var item in categories[category]!) {
          item['isPacked'] = false;
        }
      }
    });
  }

  List<String> getCheckedItems() {
    List<String> checkedItems = [];
    categories.forEach((category, items) {
      items.forEach((item) {
        if (item['isPacked']) {
          checkedItems.add("${item['name']} (${category})");
        }
      });
    });
    return checkedItems;
  }

  void showCheckedItems() {
    List<String> checkedItems = getCheckedItems();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Checked Items"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Traveler: ${widget.name} ${widget.lastName}"),
                Text("Travel Date: ${widget.travelDate}"),
                Text("Location: ${widget.location}"),
                Divider(),
                checkedItems.isEmpty
                    ? Text("No items checked.")
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: checkedItems.map((item) => Text("- $item")).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.card_travel, size: 28, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Packing Checklist',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: resetChecklist,
            tooltip: 'Reset Checklist',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: categories.keys.map((category) {
                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Divider(),
                        Column(
                          children: categories[category]!
                              .map((item) => CheckboxListTile(
                            title: Text(item['name']),
                            value: item['isPacked'],
                            onChanged: (value) {
                              toggleItem(
                                  category, categories[category]!.indexOf(item));
                            },
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: showCheckedItems,
            child: Text("Show Checked Items"),
          ),
        ],
      ),
    );
  }
}
