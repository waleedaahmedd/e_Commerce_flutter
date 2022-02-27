import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/models/blogs_model/blogs.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/view/screens/popular_details_screen.dart';
import 'package:b2connect_flutter/view/widgets/appBar_with_cart_notification_widget.dart';
import 'package:b2connect_flutter/view/widgets/blog_item_widget.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/blogs_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screen_size.dart';

class BlogListScreen extends StatelessWidget {

  final List<Blogs> _blogList;
  final String _screenName;
  const BlogListScreen(this._blogList, this._screenName) : super();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Consumer<BlogsProvider>(builder: (context, i, _) {
      return Scaffold(
        appBar:AppBarWithCartNotificationWidget(
          title: _screenName,
          onTapIcon: () {
            i.fitnessBlogsList.clear();
            i.healthBlogsList.clear();
            // i.mediaBlogsList.clear();
            i.paymentsBlogsList.clear();
            i.meditationBlogsList.clear();
            navigationService.closeScreen();
          },
        ) /*AppBar(
          leading: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {
                i.fitnessBlogsList.clear();
                i.healthBlogsList.clear();
               // i.mediaBlogsList.clear();
                i.paymentsBlogsList.clear();
                i.meditationBlogsList.clear();
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
        )*/,
        body: WillPopScope(
          onWillPop: () {
            i.fitnessBlogsList.clear();
            i.healthBlogsList.clear();
           // i.mediaBlogsList.clear();
            i.paymentsBlogsList.clear();
            i.meditationBlogsList.clear();
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
                 // mainAxisSpacing: 30.0,
                  //crossAxisSpacing: 10.0,
                   childAspectRatio: 3/4,
                  //ScreenSize.productCardWidth / ScreenSize.productCardHeight,
                  crossAxisCount: 2,
                ),
                //shrinkWrap: true,
                itemCount: _blogList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PopularDetailsScreen(
                                _blogList,
                                    index,
                                  )));
                    },
                    child: Container(
                        child: BlogItemWidget(_blogList, index)),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
