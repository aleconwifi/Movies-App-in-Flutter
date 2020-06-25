import 'package:app_peliculas/src/models/actores_model.dart';
import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:app_peliculas/src/providers/peliculas.dart';
import 'package:app_peliculas/src/widgets/movie_horizontal.dart';
import 'package:flutter/material.dart';


class PeliculaDetalle extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();


  @override
  Widget build(BuildContext context) {
    //asi se recibe la pagina de home
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    peliculasProvider.getSimilares(pelicula.id.toString());

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10,),
                _posterTitulo(pelicula, context),
                _descripcion(pelicula),
                _tituloTexto('Reparto'),
                _crearCasting(pelicula),

                _tituloTexto('Similares'),
                //_peliculasSimilares(),


              ]
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.red,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color:Colors.white, fontSize: 16),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/imgs/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child:  Row(
        children: <Widget>[
          Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
                child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 200,

              ),
            ),
          ),
          SizedBox(width: 20,),
          Flexible(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis),
                Text(pelicula.title, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),

                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
        ),
    );

  }

  Widget _crearCasting(Pelicula pelicula) {

      final peliculasProvider = new PeliculasProvider();
    return FutureBuilder(
      future: peliculasProvider.getActores(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        //si no hay data colocar un Loading 
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
                  }else{
                    return Container(
                      child: Center(
                      child: CircularProgressIndicator()
                      )
                    );
                  }
                
                },
          
              );
            }
          
    Widget _crearActoresPageView(List<Actor> actores) {
      return SizedBox(
        height: 200,
        child: PageView.builder(
          pageSnapping: false,
          itemCount: actores.length,
          controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
          ),
          itemBuilder: (context, index) =>  _actorTarjeta(actores[index]),
        ),

      );
    }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/imgs/noimage.jpg'),
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
          Text(actor.name,
          overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }

  // Widget _peliculasSimilares() {
  //   return  StreamBuilder(
  //           //future: peliculasProvider.getPopulares(),
  //           stream: peliculasProvider.similaresStream,
  //           builder: (BuildContext context, AsyncSnapshot snapshot) {
  //             //print(snapshot.data);
  //             //Como imprime solo las instancias se puede hacer un forEach
  //             //snapshot.data?.forEach((peli)=>print(peli.title));
  //             if(snapshot.hasData){
  //               return MovieHorizontal(
  //                 peliculas: snapshot.data,
  //                 //esto hace que se active getPopulares cuando llegue al final
  //                 siguientePagina: peliculasProvider.getSimilares,
  //                 );
  //             }else{
  //               //loading
  //               return Center(child: CircularProgressIndicator());
  //             }
              
  //           },
  //         );


  // }

  _tituloTexto(String titulo) {

    return  Container(
              padding: EdgeInsets.only(left: 15, bottom: 15, top: 10),
              child: Text(titulo, 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),  
              ),
              );    
  }

  
}