import 'package:b2connect_flutter/model/models/blogs_model/blogs.dart';
import 'package:b2connect_flutter/view/screens/view_all_service_screen.dart';
import 'package:b2connect_flutter/view_model/providers/offers_provider.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

List<Color> _colors = [
  Colors.blue,
  Colors.green,
  Colors.redAccent,
  Colors.orangeAccent,
  Colors.yellow,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.teal,
  Colors.brown,
  Colors.cyan
];

class ServiceProviderItemsWidget extends StatelessWidget {
  const ServiceProviderItemsWidget(
      this._serviceProviderIndex, this._serviceProviderList,
      {this.validator})
      : super();

  //TODO: change dynamic to ServiceProvider Model
  final List<dynamic> _serviceProviderList;
  final int _serviceProviderIndex;
  final String? validator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (validator == null || validator == 'Wrong Input') {
          final snackBar = SnackBar(
            content: Text('Please Enter Valid Mobile Number'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          EasyLoading.show(status: 'Please Wait...');

          await getServiceDetail(493,
              _serviceProviderList[_serviceProviderIndex]['name'], context);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewAllServiceScreen(
                      name: _serviceProviderList[_serviceProviderIndex]['name'],
                      categoryId: 493,
                    )),
          );
        }
      },
      child: Wrap(
        children: [
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Wrap(
                  children: [
                    Container(
                      color: _colors[_serviceProviderIndex],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              _serviceProviderList[_serviceProviderIndex]
                                  ['logo'],
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _serviceProviderList[_serviceProviderIndex]
                                        ['name'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    _serviceProviderList[_serviceProviderIndex]
                                        ['type'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30.0),
                  child: Column(
                    children: [
                      Text(
                        'Mobile Top Up',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${_serviceProviderList[_serviceProviderIndex]['name']} '
                        '|'
                        ' ${_serviceProviderList[_serviceProviderIndex]['type']}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getServiceDetail(
      int _categoryId, String _name, BuildContext context) async {
    await Provider.of<OffersProvider>(context, listen: false)
        .getOffers(categoryId: _categoryId, perPage: 10, name: _name);
  }
}
