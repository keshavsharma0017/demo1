
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


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