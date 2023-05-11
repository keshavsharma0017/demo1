import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
      routes: {
        '/addcontact': (context) => const ContactView(),
      },
    );
  }
}

class Contact {
  final String id; // for uniquely identifying contact
  final String name;
  Contact({required this.name}) : id = const Uuid().v4();
}

class Contactbook extends ValueNotifier<List<Contact>> {
  // created private instance of class and created an empty list with name value
  Contactbook._sharedInstance() : super([]);

  // created static instance of class
  static final Contactbook _shared = Contactbook._sharedInstance();

  // created factory constructor
  factory Contactbook() => _shared;

  // created getter for length
  int get length => value.length;

  void add({required Contact contact}) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void remove({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

  // Returning contacts at index
  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final contactBook = Contactbook();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("State Management"),
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: contactBook,
          builder: (context, value, child) {
            final contacts = value as List<Contact>;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Dismissible(
                    onDismissed: (direction) {
                      contactBook.remove(contact: contact); // remove contact
                    },
                    key: ValueKey(contact.id),
                    child: Material(
                      color: Colors.grey,
                      elevation: 4.0,
                      child: ListTile(
                        title: Text(contact.name),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/addcontact');
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Ccontact"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          16.0,
          32.0,
          16.0,
          16.0,
        ),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Enter Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                8.0,
                16.0,
                8.0,
                8.0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  final contact = Contact(name: _controller.text);
                  Contactbook().add(contact: contact);
                  Navigator.of(context).pop();
                },
                child: const Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
