import 'package:bedspace/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class main_screen extends StatefulWidget {
  const main_screen({Key? key}) : super(key: key);
  static const routename = "/main_screen";

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {
  @override
  void didChangeDependencies() {
    try{
      Provider.of<products>(context).fetchandset();
    }catch (e){}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final itemsdata = Provider.of<products>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Scaffold(
          appBar: AppBar(
              title: const Text(
                'Main Screen',
              )),
          drawer: Drawer(child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Image.network('https://images.pexels.com/photos/2820884/pexels-photo-2820884.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',fit: BoxFit.cover,),
                      backgroundColor: Colors.amber,),
                  accountName: Text(itemsdata.items[0].title.toString()),
                  accountEmail: Text(itemsdata.items[0].description.toString()),
                ),
              ])),
          body: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: itemsdata.items.length,
            itemBuilder: (ctx, i) => Column(
              children: [
                Image.network('https://images.pexels.com/photos/2820884/pexels-photo-2820884.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',fit: BoxFit.cover,),
                Text(itemsdata.items[i].price.toString()),
                Text('data'),


              ],
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 5,
              mainAxisExtent: 310
            ),
          ),
    ),)
    ,
    );
  }
}
