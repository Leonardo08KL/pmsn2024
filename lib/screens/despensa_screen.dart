import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmsn2024/database/products_database.dart';
import 'package:pmsn2024/model/products_model.dart';

class DespensaScreen extends StatefulWidget {
  const DespensaScreen({super.key});

  @override
  State<DespensaScreen> createState() => _DespensaScreenState();
}

class _DespensaScreenState extends State<DespensaScreen> {
  ProductsDatabase? productDB;

  ProductsDatabase? productsDB;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productDB = new ProductsDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final conNombre = TextEditingController();
    final conCantidad = TextEditingController();
    final conFecha = TextEditingController();

    final txtNombre = TextFormField(
      keyboardType: TextInputType.text,
      controller: conNombre,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );

    final txtCantidad = TextFormField(
      keyboardType: TextInputType.number,
      controller: conCantidad,
    );

    final space = SizedBox(
      height: 10,
    );

    final txtFecha = TextFormField(
      controller: conFecha,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          print(
              pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(
              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
          print(
              formattedDate); //formatted date output using intl package =>  2022-07-04
          //You can format date as per your need

          setState(() {
            conFecha.text =
                formattedDate; //set foratted date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
      keyboardType: TextInputType.none,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );

    final btnAgregar = ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.save),
      label: Text('Guardar'),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi despensa :)'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    padding: EdgeInsets.all(10),
                    children: [
                      txtNombre,
                      space,
                      txtCantidad,
                      space,
                      txtFecha,
                      space,
                      btnAgregar,
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.shop),
          ),
        ],
      ),
      body: FutureBuilder(
        future: productDB!.CONSULTAR(),
        builder: (context, AsyncSnapshot<List<ProductosModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Algo salió mal'),
            );
          } else {
            if (snapshot.hasData) {
              return Center(
                child: Text('No hay datos'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }
}
