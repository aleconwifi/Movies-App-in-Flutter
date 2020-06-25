import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:app_peliculas/src/providers/peliculas.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {

  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'Mojojojo',
    'Spiderman',
    'Hulk',
    'Shrek',
    'Batman'
  ];

  final peliculasRecientes = [
    'Hulk',
    'Shrek'

  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del Appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = ''; //es para limpiar al tocar el botn
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono al lado izquierdo del Appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Mostrar Resultados
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.blue,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // MOstrar sugerencias
      if(query.isEmpty){
        return Container();
      }

      //si no esta vacio, la persona ya escribio algo

      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
            if(snapshot.hasData){
              final peliculas = snapshot.data;
              return ListView(
                children: peliculas.map((pelicula){

                  return ListTile(
                    leading: FadeInImage(
                      image: NetworkImage(pelicula.getPosterImg()),
                      placeholder: AssetImage('assets/imgs/noimage.jpg'),
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                    title: Text(pelicula.title),
                    subtitle: Text(pelicula.originalTitle),
                    onTap: (){
                      close(context, null);
                      pelicula.uniqueId = ''; //cierra la busqueda
                      Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                    }

                  );
                }).toList()
              );
            } else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
        },
      );
  }


  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // MOstrar sugerencias

  //   final listaSugerida = (query.isEmpty)
  //                          ? peliculasRecientes
  //                          : peliculas.where(
  //                            (p)=>p.toLowerCase().startsWith(query.toLowerCase())).toList();
  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, index){
  //       return ListTile(
  //         title: Text(listaSugerida[index]),
  //         leading: Icon(Icons.movie),
  //         onTap: (){
  //           seleccion = listaSugerida[index];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }



}