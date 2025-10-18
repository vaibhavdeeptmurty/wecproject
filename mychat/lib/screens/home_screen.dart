import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mychat/api/api.dart';
import 'package:mychat/helper/dialogs.dart';
import 'package:mychat/models/chat_user.dart';
import 'package:mychat/screens/profile_screen.dart';
import 'package:mychat/widgets/chat_user_card.dart';

import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  // FOR STORING ALL THE USERS
  List<ChatUser> _list = [];

  // FOR STORING SEARCHED ITEMS
  final List<ChatUser> _searchList = [];
  //FOR STORING SEARCH STATUS
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;
    return GestureDetector(
      //FOR HIDING KEYBOARD
      onTap: FocusScope.of(context).unfocus,

      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return;
          }
          // PREVENTS BLACK SCREEN IF ALREADY ON HOME
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            final now = DateTime.now();
            // TWO CONSECUTIVE BACK - EXIT APP
            if (lastPressed == null ||
                now.difference(lastPressed!) > const Duration(seconds: 2)) {
              lastPressed = now;
              Dialogs.showSnackBar(context, 'Press again to exit');
            } else {
              // EXIT APP
              SystemNavigator.pop();
            }
          }
        },
        child: Scaffold(
            appBar: AppBar(
              leading: const Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                      autofocus: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name, email ..',
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                      // WHEN SEARCHED TEXT CHANGE UPDATE SEARCH LIST
                      onChanged: (val) {
                        // SEARCH LOGIC
                        _searchList.clear();
                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    )
                  : const Text('MyChat'),
              actions: [
                // search button
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled
                        : Icons.search)),
                // more button
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: APIs.me,
                                  )));
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
            // floating add button to add new user

            floatingActionButton: Padding(
              padding:
                  const EdgeInsets.only(left: 0, top: 0, right: 10, bottom: 15),
              child: FloatingActionButton(
                onPressed: () async {},
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                child: const Icon(Icons.add),
              ),
            ),
            body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  // for loading data
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  //   after loaded data to show
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:
                              _isSearching ? _searchList.length : _list.length,
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index],
                            );
                            // return Text('Name: ${list[0]}');
                          });
                    } else {
                      return const Center(child: Text('No connection found!'));
                    }
                }
              },
            )),
      ),
    );
  }
}
