import 'package:app_peliculas/src/providers/peliculas.dart';
import 'package:app_peliculas/src/search/search_delegate.dart';
import 'package:app_peliculas/src/widgets/card_swiper.dart';
import 'package:app_peliculas/src/widgets/movie_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false, //en Android no centra, en Iphone si
        title: Text('Peliculas en cine'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){ 
              showSearch(
                context: context, 
                delegate: DataSearch(),
                );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      ),
        );
      
    
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        //si tiene informacion retorno la tarjeta 
        if(snapshot.hasData){
        
        return CardSwiper(
          peliculas: snapshot.data,
       );
        } else {
          //se muestra el loading cuando no hay informacion o lo de arriba esta cargando 
          return Container(
            height:400,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }

      },
    );
    // peliculasProvider.getEnCines();
    // return CardSwiper(
    //   peliculas: [1,2,3,4,5],
    // );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Text('Populares', 
            style: Theme.of(context).textTheme.subhead  ),
          ),
          SizedBox(height: 10,),

            //me interesa es escuchar el Sink aqui del provider, este se
            //ejecuta cada vez que se emita un valor en el Stream,
          StreamBuilder(
            //future: peliculasProvider.getPopulares(),
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //print(snapshot.data);
              //Como imprime solo las instancias se puede hacer un forEach
              //snapshot.data?.forEach((peli)=>print(peli.title));
              if(snapshot.hasData){
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  //esto hace que se active getPopulares cuando llegue al final
                  siguientePagina: peliculasProvider.getPopulares,
                  );
              }else{
                //loading
                return Center(child: CircularProgressIndicator());
              }
              
            },
          ),
        ],
      ),
    );
  }
}