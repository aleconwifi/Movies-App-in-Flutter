import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top:10, bottom: 10),
      // width: _screenSize.width *0.70, //70 porciento de la pantalla
      // height: _screenSize.height *0.5, //la mitad de la pantalla,
      //color: Colors.blue,
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width *0.70,
        itemHeight: _screenSize.height *0.5,
        itemBuilder: (BuildContext context,int index){

          peliculas[index].uniqueId = '${ peliculas[index].id }-tarjeta';
          return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
                      },
                      child: FadeInImage(
                      image: NetworkImage(peliculas[index].getPosterImg()),
                      placeholder:AssetImage('assets/imgs/noimage.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
  
            
            );
        },
        itemCount: 3,
        
        //pagination: new SwiperPagination(), // los puntos de abajo 
        //control: new SwiperControl(), //las flechas
      ),
    );

  }
}
