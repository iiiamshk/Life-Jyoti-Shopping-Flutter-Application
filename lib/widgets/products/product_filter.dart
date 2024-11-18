import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:life_jyoti/misc/product_service.dart';
import 'package:life_jyoti/misc/store_provider.dart';
import 'package:provider/provider.dart';

class ProductFilterWidget extends StatefulWidget {
  @override
  _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  ProductServices _services = ProductServices();
  List _subCatList = [];

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);
    FirebaseFirestore.instance
        .collection('products')
        .where('category.maincategory',
            isEqualTo: _store.selectedProductCategory)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _subCatList.add(doc['category']['subCategory']);
                });
              }),
            });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeData = Provider.of<StoreProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: _services.category.doc(_storeData.selectedProductCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Container();
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Container(
          height: 50,
          color: Colors.grey,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 10,
              ),
              ActionChip(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  elevation: 4,
                  backgroundColor: Colors.white,
                  label: Text('All ${_storeData.selectedProductCategory}'),
                  onPressed: () {
                    _storeData.selectedSubCategory(null);
                  }),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _subCatList.contains(data['subCat'][index]['name'])
                        ? ActionChip(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            elevation: 4,
                            backgroundColor: Colors.white,
                            label: Text(data['subCat'][index]['name']),
                            onPressed: () {
                              _storeData.selectedSubCategory(
                                  data['subCat'][index]['name']);
                            })
                        : Container(),
                  );
                },
                itemCount: data.length,
              ),
            ],
          ),
        );
      },
    );
  }
}
