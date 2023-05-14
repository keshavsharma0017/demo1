import 'package:flutter/material.dart';
import 'classes/info_modal_file.dart';

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
      home:  Homepage(),
      routes: {
        '/addcontact': (context) => const ContactView(),
      },
    );
  }
}


class Homepage extends StatelessWidget {
 Homepage({super.key});

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
            final contacts = value;
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
