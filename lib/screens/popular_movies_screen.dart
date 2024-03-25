import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_popular.dart';
import 'package:pmsn2024/screens/favorites_movies_screen.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Inicializa antes de todo
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas Populares'),
        actions: [
          IconButton(
            icon: const Icon(
              Ionicons.heart,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const FavoritesMoviesScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: Duration(
                      milliseconds: 500), // Ajusta la duración de la transición
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: apiPopular!.getPopularMovie(),
        builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .7,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    final trailers =
                        await apiPopular!.getTrailer(snapshot.data![index].id!);
                    final actors = await apiPopular!
                        .getAllActors(snapshot.data![index].id!);

                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: {
                        'popularMovies': snapshot.data![index],
                        'trailers': trailers,
                        'actors': actors,
                        'favorites': false,
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage(
                        placeholder: const AssetImage("images/giphy.gif"),
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}",
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Ocurrio un error..."),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }
}
