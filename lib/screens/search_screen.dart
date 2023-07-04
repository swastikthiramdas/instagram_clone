import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/colores.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShow = false;
  final TextEditingController _searchController = TextEditingController();

  Widget searchUser() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .where(
            'username',
            isGreaterThanOrEqualTo: _searchController.text,
          )
          .get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ))));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      (snapshot.data! as dynamic).docs[index]['photoUrl'],
                    ),
                  ),
                  title:
                      Text((snapshot.data! as dynamic).docs[index]['username']),
                ),
              );
            });
      },
    );
  }

  Widget SearchPost() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('post').get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return StaggeredGridView.countBuilder(
          crossAxisCount: 3,
          itemCount: (snapshot.data! as dynamic).docs.length,
          itemBuilder: (context, index) => Image.network(
            (snapshot.data! as dynamic).docs[index]['postUrl'],
            fit: BoxFit.cover,
          ),
          staggeredTileBuilder: (index) => StaggeredTile.count(
            (index % 7 == 0) ? 2 : 1,
            (index % 7 == 0) ? 2 : 1,
          ),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (String _) {
            print(_);
            setState(() {
              isShow = !isShow;
            });
          },
        ),
      ),
      body: isShow ? searchUser() : SearchPost(),
    );
  }
}
