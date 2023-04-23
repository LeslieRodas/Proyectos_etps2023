// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appiparcial/modelo/NasaAppi.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AppiPracial());
}

class AppiPracial extends StatefulWidget {
  const AppiPracial({super.key});

  @override
  State<AppiPracial> createState() => _AppiPracialState();
}

class _AppiPracialState extends State<AppiPracial> {
late Future<List<NasaAppi>> _listadonasa;

Future<List<NasaAppi>> _getnasa () async {
final response = await http.get (Uri.parse('https://api.nasa.gov/EPIC/api/natural/images?api_key=DEMO_KEY'));
List<NasaAppi> gif=[];

if (response.statusCode==200){
  String bodys=utf8.decode(response.bodyBytes);
  //print(bodys);
  final jsonData = jsonDecode(bodys);
  //print(jsonData["data"][0]["type"]);
  for (var item in jsonData["data"]){
  gif.add(NasaAppi(item ["title"], item ["images"]["downsized"]["url"]));
  
}
return gif;
}else{
  throw Exception("Falla en conectarse");}

}

@override
void initState() {
  super.initState();
  _listadonasa=_getnasa();
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: "Api Parc",
    home: Scaffold(appBar: AppBar (
      title: Text("Api Parcial"),
      ),
      body: FutureBuilder(future: _listadonasa,
      builder: (context, snapshot){
        if (snapshot.hasData){
          print(snapshot.data);
          return ListView(
            children: _listadonasas(snapshot.requireData),
          );
        }
        else if (snapshot.hasError){
          print(snapshot.error);
          return Text("error");
        }
        return Center(child: CircularProgressIndicator(),);
      })
    ),
    );
  }
  List<Widget> _listadonasas(List<NasaAppi>data){
    List<Widget>gifs = [];
    for (var gif in data){
      gifs.add(Card(child: Column(
        children: [
          Image.network(gif.url, fit: BoxFit.fill,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(gif.nombre),
          ),
        ],
      )));

    }
    return gifs;
  }
}


