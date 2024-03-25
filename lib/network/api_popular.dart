import 'package:dio/dio.dart';
import 'package:pmsn2024/model/actor_model.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/model/trailer_model.dart';

class ApiPopular {
  final dio = Dio();
  final Url = "https://api.themoviedb.org/3";
  // "https://api.themoviedb.org/3/movie/popular?api_key=ffd8be5351749ce48cc2865081436b30&language=es-MX&page=1";
  final ApiKey = "ffd8be5351749ce48cc2865081436b30";
  final accountID = "21116835";

  Future<List<PopularModel>?> getPopularMovie() async {
    //Todo lo que involucre cosas asincronas se debe de usar future.
    final url = "$Url/movie/popular?api_key=$ApiKey&language=es-MX&page=1";
    Response response =
        await dio.get(url); //Si fuera con una uri se tendria que parsear
    if (response.statusCode == 200) {
      final listMovies = response.data['results']
          as List; //Con este parseo se obtiene los elementos de la respuesta ya que no esta directo en el data
      return listMovies.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }

  Future<List<ActorModel>?> getAllActors(int movieId) async {
    final url = '$Url/movie/${movieId.toString()}/credits?api_key=$ApiKey';
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final listActors = response.data['cast'] as List;
      return listActors.map((actor) => ActorModel.fromMap(actor)).toList();
    }
    return null;
  }

  Future<List<TrailerModel>?> getTrailer(int movieId) async {
    final url = '$Url/movie/${movieId.toString()}/videos?api_key=$ApiKey';
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final listTrailers = response.data['results'] as List;
      return listTrailers
          .map((trailer) => TrailerModel.fromMap(trailer))
          .toList();
    }
    return null;
  }

  Future<void> addToFavorites(int movieId, String sessionId) async {
    final url =
        "$Url/account/$accountID/favorite?api_key=$ApiKey&session_id=$sessionId";

    try {
      final response = await dio.post(
        url,
        data: {
          "media_type": "movie",
          "media_id": movieId.toString(),
          "favorite": true,
        },
      );

      if (response.statusCode == 201) {
        print("Película agregada a favoritos exitosamente");
      } else {
        print("Error al agregar película a favoritos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //Para remover una pelicula de favoritos
  Future<void> removeFromFavorites(int movieId, String sessionId) async {
    final url =
        "$Url/account/$accountID/favorite?api_key=$ApiKey&session_id=$sessionId";

    try {
      final response = await dio.post(
        url,
        data: {
          "media_type": "movie",
          "media_id": movieId.toString(),
          "favorite": false, // Eliminar de favoritos
        },
      );

      if (response.statusCode == 200) {
        print("Película eliminada de favoritos exitosamente");
      } else {
        print(
            "Error al eliminar película de favoritos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //Para mostrar las peliculas de favoritos
  Future<List<PopularModel>?> getFavoriteMovies(String sessionId) async {
    final url =
        "$Url/account/$accountID/favorite/movies?api_key=$ApiKey&session_id=$sessionId";

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        return data.map((json) => PopularModel.fromMap(json)).toList();
      } else {
        print(
            "Error al obtener las películas favoritas: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error al obtener las películas favoritas: $e");
      return null;
    }
  }
}
