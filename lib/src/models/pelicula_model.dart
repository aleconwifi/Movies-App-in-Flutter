class Peliculas {

  List <Pelicula> items = new List(); //nueva lista dinamica, no tiene tamano fijo

  Peliculas();

  //otro constructor, ese nombre yo se lo asigno fromJsonList
  Peliculas.fromJsonList(List<dynamic> jsonList ){
    //si esta vacio el json list, no hace nada
    if(jsonList ==null) return;

    for(var item in jsonList) {
      final pelicula = new Pelicula.fromJsonMap(item);
      items.add(pelicula);
    }

  }

}


class Pelicula {
  String uniqueId;
  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Pelicula({
    this.uniqueId,
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });


  Pelicula.fromJsonMap(Map<String, dynamic> json){
    popularity = json['popularity'] / 1;
    voteCount = json['vote_count'];
    video =json['video'];
    posterPath = json['poster_path'];
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    title = json['title'];
    voteAverage = json['vote_average'] / 1;
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

    getPosterImg(){
      if(posterPath == null){
        return 'https://www.kvplus.ch/directus/thumbnail/300/300/contain/20%D0%A101.2.jpg';
      }else{
        return 'https://image.tmdb.org/t/p/w500/$posterPath';
      }
      
    }



    getBackgroundImg(){
      if(posterPath == null){
        return 'https://www.kvplus.ch/directus/thumbnail/300/300/contain/20%D0%A101.2.jpg';
      }else{
        return 'https://image.tmdb.org/t/p/w500/$backdropPath';
      }
      
    }
}
