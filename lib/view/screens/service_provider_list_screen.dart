import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/view/widgets/service_provider_items_widget.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:flutter/material.dart';

import '../../screen_size.dart';

class ServiceProviderListScreen extends StatelessWidget {
  final List<dynamic> _serviceProviderList;
  final String _screenName;
  final String? validator;

  const ServiceProviderListScreen(this._serviceProviderList,this._screenName, {this.validator}) : super();


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
             /* i.fitnessBlogsList.clear();
              i.healthBlogsList.clear();
              // i.mediaBlogsList.clear();
              i.paymentsBlogsList.clear();
              i.meditationBlogsList.clear();*/
              navigationService.closeScreen();
            },
            icon: Icon(Icons.arrow_back_ios)),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: height * 0.08,
        title: Text(
          _screenName,
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenSize.appbarText,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradientColor),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
         /* i.fitnessBlogsList.clear();
          i.healthBlogsList.clear();
          // i.mediaBlogsList.clear();
          i.paymentsBlogsList.clear();
          i.meditationBlogsList.clear();*/
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: double.infinity,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              addRepaintBoundaries: false,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //mainAxisSpacing: 30.0,
               // crossAxisSpacing: 10.0,
                childAspectRatio: 0.50/0.50,
                //ScreenSize.productCardWidth / ScreenSize.productCardHeight,
                crossAxisCount: 2,
              ),
              //shrinkWrap: true,
              itemCount: _serviceProviderList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                   /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PopularDetailsScreen(
                              _blogList,
                              index,
                            )));*/
                  },
                  child:
                  ServiceProviderItemsWidget(index,_serviceProviderList,validator: validator == null? 'Wrong Input' : validator),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
