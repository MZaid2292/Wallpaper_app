import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/full_screen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {

  List images = [];
  int page = 1;
  //We will define initState it will define what you want to do when your
//app is loaded.
  void initState(){
    super.initState();
    fetchapi();
  }

////First of all we have to write a function to fetch the Pixel API
  fetchapi() async {
    await http.get(Uri.parse(
        "https://api.pexels.com/v1/curated?per_page=80"
    ),

        headers:{
          "Authorization":"xiRol5OR3QHj6dxBWAOCenwvdax1WDV1q8f9kqbB6qdRzawDoKqSuWxQ"
        }
    ).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result["photos"];
      });
      print(images);
    } );
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
      "xiRol5OR3QHj6dxBWAOCenwvdax1WDV1q8f9kqbB6qdRzawDoKqSuWxQ"
    }
    ).then(
            (value) {
          Map result = jsonDecode(value.body);
          setState(() {
            images.addAll(result['photos']);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column( //I will define column b/c I want 2 things GridView and bottom button.
        children: [
//And in this I will define a expanded container. An Expanded Container fills all available
// space  in a row or column.
        Expanded(child: Container(
//Now here I will define a GridView,Builder.
          child: GridView.builder(
            itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context , index){
              return InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullScreen(
                            imageurl: images[index]['src']['large2x'],
                          ))
                  );
                },
                child: Container(color: Colors.white,
                child: Image.network(images[index]['src']['tiny'],
                fit: BoxFit.cover,
                ),
                ),
              );

              }
              ),
        ),
        ),
          InkWell(
            onTap: (){
              loadmore();
            },
            child: Container(
              height: 60,
               width: double.infinity,
               color: Colors.black,
              child: Center(
                child: Text("Load More",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                ),
              ),
            ),
          ),

        ],

      ),
    );
  }
}
