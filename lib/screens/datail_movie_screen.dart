import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:pmsn2024/model/actor_model.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/model/session_tmdb_model.dart';
import 'package:pmsn2024/model/trailer_model.dart';
import 'package:pmsn2024/network/api_popular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  ApiPopular? apiPopular;
  String trailerKey = '';
  late Color iconColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Inicializa antes de todo
    apiPopular = ApiPopular();
    iconColor = Colors.white;
  }

  Color _getIconColor(bool favorites) {
    return favorites ? Colors.red : const Color.fromARGB(255, 179, 179, 179);
  }

  @override
  Widget build(BuildContext context) {
    // final popularModel =
    //     ModalRoute.of(context)!.settings.arguments as PopularModel;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    final PopularModel popularModel = args['popularMovies'] as PopularModel;
    final List<TrailerModel> trailers = args['trailers'];
    final List<TrailerModel> filteredTrailers = trailers
        .where((trailer) =>
            trailer.type == 'Trailer' && trailer.name == 'Official Trailer')
        .toList();
    final List<ActorModel> actors = args['actors'];
    final GlobalKey<LikeButtonState> _key = GlobalKey<LikeButtonState>();
    late bool favorites = args['favorites'];
    String? sessionId = SessionManager().getSessionId();

    final Poster = BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
          "https://image.tmdb.org/t/p/w500${popularModel.posterPath}",
        ),
        fit: BoxFit.cover,
        // colorFilter: ColorFilter.mode(
        //   Colors.black
        //       .withOpacity(0.6), // Aquí puedes ajustar el valor de opacidad
        //   BlendMode.srcOver,
        // ),
        opacity: 0.2,
      ),
    );

    final PosterMain = Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Image(
        height: 200,
        image: NetworkImage(
          "https://image.tmdb.org/t/p/w500${popularModel.posterPath}",
        ),
      ),
    );

    final Starts = Positioned(
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: RatingBar(
          initialRating: popularModel.voteAverage! / 2,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 30,
          ratingWidget: RatingWidget(
            full: const Icon(
              Icons.star,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            half: const Icon(
              Icons.star_half,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            empty: const Icon(
              Icons.star_outline,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          ignoreGestures: true,
          onRatingUpdate: (value) {},
        ),
      ),
    );

    final PuntuacionStarts = Container(
      width: 40,
      height: 30,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          '${popularModel.voteAverage?.toStringAsFixed(1)}',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

    final Titulo = Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        '${popularModel.title}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    final DescripcionMovie = Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        '${popularModel.overview}',
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 18.0,
          fontStyle: FontStyle.normal,
        ),
      ),
    );

    final spaceHorizontal = SizedBox(
      height: 20,
    );

    const StyleText = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 0, 0, 0),
    );

    final FechaLanzamiento = Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        'Fecha de lanzamiento \n${popularModel.releaseDate}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    final Actores = SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          ActorModel actor = actors[index];
          return Center(
            child: Column(
              children: <Widget>[
                Text(
                  actor.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ClipRRect(
                  child: Image.network(
                    actor.profilePath.isNotEmpty
                        ? 'https://image.tmdb.org/t/p/original${actor.profilePath}'
                        : "https://static.vecteezy.com/system/resources/previews/008/442/086/non_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg",
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 100,
                        height: 120,
                        child: Icon(
                          Icons.person,
                          size: 100,
                        ),
                      );
                    },
                    height: 120,
                    width: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    actor.character,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final Trailer = filteredTrailers.isNotEmpty
        ? SizedBox(
            height: 400,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 1, // Mostrar solo un resultado
              itemBuilder: (context, index) {
                TrailerModel trailer = filteredTrailers
                    .first; // Obtener el primer elemento de la lista

                final YoutubePlayerController _controller =
                    YoutubePlayerController(
                  initialVideoId: trailer.key,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                  ),
                );
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            trailer.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.amber,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : const Center(
            child: Text(
              'No se encontraron trailers.',
              style: StyleText,
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text('${popularModel.title}'),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                iconColor =
                    iconColor == const Color.fromARGB(255, 179, 179, 179)
                        ? Colors.red
                        : const Color.fromARGB(255, 179, 179, 179);
                favorites ? print('true') : print('false');
              });
              favorites
                  ? ApiPopular()
                      .removeFromFavorites(popularModel.id!, sessionId!)
                  : ApiPopular().addToFavorites(popularModel.id!, sessionId!);
              // Mostrar un SnackBar
              final snackBar = SnackBar(
                content: Text(
                  favorites ? 'Eliminado de favoritos' : 'Agregado a favoritos',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 179, 179, 179)),
                ),
                backgroundColor: favorites ? Colors.red : Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Icon(
              Ionicons.heart,
              color: _getIconColor(favorites),
              size: 40,
            ),
          )
        ],
      ),
      body: Hero(
        tag: popularModel.id!,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: Poster,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Titulo,
                      spaceHorizontal,
                      SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Utiliza el ancho de la pantalla
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Starts,
                                PuntuacionStarts,
                                FechaLanzamiento,
                              ],
                            ),
                            PosterMain,
                          ],
                        ),
                      ),
                      spaceHorizontal,
                      spaceHorizontal,
                      const Text(
                        'Sinopsis',
                        style: StyleText,
                      ),
                      DescripcionMovie,
                      const Text(
                        'Actores',
                        style: StyleText,
                      ),
                      const SizedBox(height: 20),
                      Actores,
                      spaceHorizontal,
                      const Divider(
                        thickness: 5,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black,
                      ),
                      Trailer,
                      const Divider(
                        thickness: 5,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black,
                      ),
                      spaceHorizontal,
                      spaceHorizontal,
                      spaceHorizontal,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
