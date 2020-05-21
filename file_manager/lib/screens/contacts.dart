import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
// import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:contacts_service/contacts_service.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<String> strList = [];
  List<Widget> favouriteList = [];
  List<Widget> normalList = [];
  Iterable<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    getContact();
  }

  getContact() async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(photoHighResolution: false);
    setState(() {
      _contacts = contacts;
      filterList();
    });
  }

  filterList() {
    List<Contact> users = _contacts.toList();
    normalList = [];
    strList = [];
    users.forEach((user) {
      if(user.displayName!=null){
      normalList.add(
         ListTile(
            leading: CircleAvatar(
              backgroundImage: MemoryImage(user.avatar),
            ),
            title:
                Text(user.displayName != null ? (user.displayName) : "No name"),
            subtitle:
                Text(user.company != null ? (user.company) : "No company"),
          ),
      );
      strList.add(user.displayName[0].toUpperCase() +   user.displayName.substring(1));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Container(
        child: AlphabetListScrollView(
          strList: strList,
          highlightTextStyle: TextStyle(
            color: Colors.yellow,
          ),
          showPreview: true,
          itemBuilder: (context, index) {
            return normalList[index];
          },
          indexedHeight: (i) {
            return 80;
          },
        ),
      ),
    ));
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';

// class Contacts extends StatefulWidget{
//   @override
//   _ContactsState createState() => _ContactsState();
// }

// class _ContactsState extends State<Contacts>{
//   Iterable<Contact> _contacts;
//   getContact() async{
//     Iterable<Contact> contacts = await ContactsService.getContacts(photoHighResolution: false);
//     setState(() {
//       _contacts = contacts;
//     });
//   }

//   @override
//   void initState() {
//     getContact();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(title: Text("Contacts"),),
//       body: ListView.builder(
//               itemCount: _contacts?.length ?? 0,
//               itemBuilder: (BuildContext context, int index) {
//                 Contact contact = _contacts?.elementAt(index);
//                 return ListTile(
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
//                   leading: (contact.avatar != null && contact.avatar.isNotEmpty)
//                       ? CircleAvatar(
//                           backgroundImage: MemoryImage(contact.avatar),
//                         )
//                       : CircleAvatar(
//                           child: Text(contact.initials()),
//                           backgroundColor: Theme.of(context).accentColor,
//                         ),
//                   title: Text(contact.displayName ?? ''),
//                   //This can be further expanded to showing contacts detail
//                   // onPressed().
//                 );
//               },
//             )

//     );

//   }
// }
