import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;


  MovieHorizontal({ @required this.peliculas, @required this.siguientePagina});
  final _pageController = new PageController(
      initialPage: 1,
      //cuantos se ven por pagina
      viewportFraction: 0.3,
  );


  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

  _pageController.addListener(() { 
    //200 pixeles antes del final, para que vaya cargando 
    if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
      siguientePagina();
    }
  });
    
    return Container(
      height: _screenSize.height*0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        //cuando items va a renderizar
        itemCount: peliculas.length,
        itemBuilder: (context, i){
          return _crearTarjeta(context, peliculas[i]);
        },
      
      ),
      
    );
  }

  Widget _crearTarjeta(BuildContext context, Pelicula peli){
    //como ya el codigo es muy grande, voy a crear una variable pelicula
      peli.uniqueId =  '${ peli.id }-moviehor';

    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag:  peli.uniqueId,
                child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  image: NetworkImage(peli.getPosterImg()),
                  placeholder: AssetImage('assets/imgs/loading.gif'),
                  fit: BoxFit.cover,
                  height: 160,

                ),
              ),
            ),
            //SizedBox(),
            Text(peli.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );



      return GestureDetector(
        child: tarjeta,
        onTap: (){
          //print('titulo de la pelicula ${peli.title}');
          Navigator.pushNamed(context, 'detalle', arguments: peli);
        },


      );
  }

//al final esta ya no lo usamos despues de la optimizacion 
  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((peli){

    }).toList();


  }
}