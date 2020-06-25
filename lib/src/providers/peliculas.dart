import 'dart:async';
import 'dart:convert';

import 'package:app_peliculas/src/models/actores_model.dart';
import 'package:http/http.dart' as http;
import 'package:app_peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apikey = 'c5fee14c5c2ea267600e5a9c96eac253';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';


  int _popularesPage = 0;
  int _similaresPage = 0;

  bool _cargando = false;
    bool _cargando2 = false;

  //el Strem va a ser un listado de peliculas, un flujo de agua
  //se crea para el Stream, privado para esta sola clase
  List<Pelicula> _populares = new List();
  List<Pelicula> _similares = new List();

  //broadcast muchos escuchan

  //este es el stream
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  //defino las funciones getters

  //agrego peliculas al Stream
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  //escucho las peliculas, la idea no es devolver el widget FutureBuilder, sino devolver
  //un StreamBuilder en el home
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;


  final _similaresStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get similaresSink => _similaresStreamController.sink.add;


  Stream<List<Pelicula>> get similaresStream => _similaresStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
    _similaresStreamController?.close();

  }



  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    //print(decodedData['results']);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    //print(peliculas.items[1].title);
    return peliculas.items;
  }

  //la pelicula se importa del modelo
  //es async porque necesita esperar la llamada http
  Future <List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apikey,
      'language' : _language,

    });
    
    return await _procesarRespuesta(url);
  }

  Future <List<Pelicula>> getPopulares() async {
    //si estoy cargando datos, regreso un arreglo vacio, no hizo nada, no cargo la info

    if (_cargando) return [];
  //si no estoy cargando, cargando va a ser a true, y aqui empiezo a hacer la carga de la info
    _cargando = true;
    _popularesPage++;

    //print('Cargando siguientes...');
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apikey,
      'language' : _language,
      'page'    : _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;

  }


  Future <List<Pelicula>> getSimilares(String peliculaId) async {
    //si estoy cargando datos, regreso un arreglo vacio, no hizo nada, no cargo la info

    if (_cargando2) return [];
  //si no estoy cargando, cargando va a ser a true, y aqui empiezo a hacer la carga de la info
    _cargando2 = true;
    _similaresPage++;

    //print('Cargando siguientes...');
    final url = Uri.https(_url, '3/movie/$peliculaId/similar', {
      'api_key' : _apikey,
      'language' : _language,
      'page'    : _similaresPage.toString(),
    });

    final resp = await _procesarRespuesta(url);
    _similares.addAll(resp);
    similaresSink(_similares);

    _cargando2 = false;
    return resp;

  }

  //para los actores se usa un Future y no Stream, porque es poca la data de los actores en finito
  Future <List<Actor>> getActores(String peliculaId) async {
      final url = Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key' : _apikey,
      'language' : _language,
      //'movie_id' : peliculaId,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    //print(decodedData['results']);
    final actores = new Actores.fromJsonList(decodedData['cast']);
    //print(actores.items[1].title);
    return actores.items;


  }


    Future <List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apikey,
      'language' : _language,
      'query' : query

    });
    
    return await _procesarRespuesta(url);
  }


}


