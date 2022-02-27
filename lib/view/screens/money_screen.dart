import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/view/screens/view_all_offers_screen.dart';
import 'package:b2connect_flutter/view/widgets/appBar_with_cart_notification_widget.dart';
import 'package:b2connect_flutter/view/widgets/blog_item_widget.dart';
import 'package:b2connect_flutter/view/widgets/eid_conirmation_bottom_sheet.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view/widgets/web_view_page.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:b2connect_flutter/view_model/providers/blogs_provider.dart';
import 'package:b2connect_flutter/view_model/providers/offers_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../screen_size.dart';
import 'blog_list_screen.dart';
import 'edit_number_top_up_screen.dart';
import 'popular_details_screen.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({Key? key}) : super(key: key);

  @override
  _MoneyScreenState createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  final CarouselController _controller = CarouselController();
  int _current = 0;
  final List<String> _imgList = [
    'assets/images/moneyBanner.png',
    /*'assets/images/moneyBanner.png',
    'assets/images/moneyBanner.png'*/
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Consumer<BlogsProvider>(
      builder: (context, i, _) {
        return Scaffold(
          appBar: AppBarWithCartNotificationWidget(
            title: 'Money',
            onTapIcon: () {
              i.moneyBlogsList.clear();
              navigationService.closeScreen();
            },
          )
          /*AppBar(
            leading: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  i.moneyBlogsList.clear();
                  navigationService.closeScreen();
                },
                icon: Icon(Icons.arrow_back_ios)),
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: false,
            toolbarHeight: height * 0.08,
            title: Text(
              AppLocalizations.of(context)!.translate('money')!,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenSize.appbarText,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: gradientColor),
            ),
          )*/
          ,
          body: WillPopScope(
            onWillPop: () {
              i.moneyBlogsList.clear();
              Navigator.pop(context, false);
              return Future.value(false);
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // height: height * 0.23,
                      child: Consumer<AuthProvider>(builder: (context, i, _) {
                        _imgList.forEach((element) {});
                        return _imgList.isNotEmpty
                            ? Container(
                                height: 170,
                                child: Image.asset(
                                  _imgList[0],
                                  fit: BoxFit.fill,
                                ),
                              ) /*Column(
                                children: [
                                  CarouselSlider(
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                      autoPlay: false,
                                      height: height * 0.2,
                                      //ScreenSize.sliderHeight,
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: false,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                    ),
                                    items: _imgList
                                        .map((item) => GestureDetector(
                                              onTap: () {
                                                */ /* print(
                                                'index---${item.clickRedirectTo}');
                                            if (item.clickRedirectTo == 'WIFI')
                                              navigationService
                                                  .navigateTo(WifiScreenRoute);
                                            else if (item.clickRedirectTo ==
                                                'SHOP')
                                              navigationService.navigateTo(
                                                  CategoriesScreenRoute);
                                            else if (item.clickRedirectTo ==
                                                'GAMES') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewPage(
                                                    url:
                                                        "https://go-games.gg/tournament?app=b2connect&country=ae&userid=${Provider.of<AuthProvider>(context, listen: false).getUID}",
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .translate('play')!,
                                                  ),
                                                ),
                                              );
                                            }*/ /*
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12.r,
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.r),
                                                      child: Image.asset(item,fit: BoxFit.fill,)
                                                         */ /* CachedNetworkImage(
                                                        imageUrl:
                                                            item.mediaUrLs![0],
                                                        */ /**/ /*placeholder: (context, url) => Image.asset(
                                              ),*/ /**/ /*
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Center(
                                                          child: Image.asset(
                                                            'assets/images/not_found1.png',
                                                            height: 100,
                                                          ),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )*/ /*

                                                      // FadeInImage(
                                                      //   image: NetworkImage(item.mediaUrLs![0]),
                                                      //   placeholder: AssetImage(
                                                      //   ),
                                                      //   fit: BoxFit.cover,
                                                      //
                                                      // ),
                                                      ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: _imgList.asMap().entries.map(
                                        (entry) {
                                          return GestureDetector(
                                            onTap: () => _controller
                                                .animateToPage(entry.key),
                                            child: Container(
                                              width: 15.w,
                                              height: 7.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _current == entry.key
                                                    ? pink
                                                    : Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ],
                              )*/
                            : Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              );
                      }),
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 15.0, bottom: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditNumberTopUpScreen()),
                                    );
                                    /* EasyLoading.show(status: 'Please Wait...');
                                    await getOfferDetail(460).then((value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewAllOffersScreen(
                                              categoryId: 460,
                                            )),
                                      );
                                    });*/
                                    //  confirmPhoneBottomSheet(context);
                                    // navigationService.navigateTo(TopUpScreenRoute);

                                    /* EasyLoading.show(status: 'Please Wait...');
                                    await getOfferDetail(460).then((value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAllOffersScreen(
                                                  categoryId: 460,
                                                )),
                                      );
                                    });*/
                                  },
                                  elevation: 0,
                                  fillColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  child: Icon(
                                    Icons.mobile_friendly,
                                    size: 30.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.all(25.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Top-Up',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    EasyLoading.show(status: 'Loading..');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage(
                                          url:
                                              "https://b2exchange.netlify.app/",
                                          title: "Exchange Rates",
                                        ),
                                      ),
                                    );
                                  },
                                  elevation: 0,
                                  fillColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  child: Icon(
                                    Icons.create_outlined,
                                    size: 30.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.all(25.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Exchange Rates',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: () async {
                                    EasyLoading.show(status: 'Please Wait..');
                                    await Provider.of<BlogsProvider>(context,
                                            listen: false)
                                        .getBlogsContent(
                                            page: 1,
                                            category: "Payments",
                                            screen: "payments");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BlogListScreen(
                                                    i.paymentsBlogsList,
                                                    'Payments')));
                                  },
                                  elevation: 0,
                                  fillColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  child: Icon(
                                    Icons.exposure,
                                    size: 30.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.all(25.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Payments',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                          /* Expanded(
                            child: Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 0,
                                  fillColor: */ /*Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)*/ /*
                                      Colors.black12,
                                  child: Icon(
                                    Icons.chrome_reader_mode_outlined,
                                    size: 25.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(height: 10),
                                Text('Payments',style: TextStyle(
                                    fontSize: 12
                                ),),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    /* Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 15.0, bottom: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 0,
                                  fillColor: */ /*Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)*/ /*
                                      Colors.black12,
                                  child: Icon(
                                    Icons.gradient,
                                    size: 25.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(height: 10),
                                Text('Scan to Pay',style: TextStyle(
                                    fontSize: 12
                                ),),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 0,
                                  fillColor: */ /*Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)*/ /*
                                      Colors.black12,
                                  child: Icon(
                                    Icons.local_atm,
                                    size: 25.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(height: 10),
                                Text('Loans',style: TextStyle(
                                    fontSize: 12
                                ),),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 0,
                                  fillColor: */ /*Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)*/ /*
                                      Colors.black12,
                                  child: Icon(
                                    Icons.monetization_on_outlined,
                                    size: 25.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(height: 10),
                                Text('Send Money',style: TextStyle(
                                    fontSize: 12
                                ),),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 0,
                                  fillColor: */ /*Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)*/ /*
                                      Colors.black12,
                                  child: Icon(
                                    Icons.speaker_group_outlined,
                                    size: 25.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(height: 10),
                                Text('Pay Later',style: TextStyle(
                                    fontSize: 12
                                ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Popular',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlogListScreen(
                                        i.moneyBlogsList, 'Money')));
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'View All',
                              style: TextStyle(
                                  //fontWeight: FontWeight.w500,
                                  //fontSize: 15,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    GridView.builder(
                      // scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: i.moneyBlogsList.length < 2
                          ? i.moneyBlogsList.length
                          : 2,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PopularDetailsScreen(
                                          i.moneyBlogsList,
                                          index,
                                        )));
                          },
                          child: BlogItemWidget(i.moneyBlogsList, index),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // mainAxisSpacing: 4.0,
                        // crossAxisSpacing: 4.0,
                        childAspectRatio: 3 / 4,
                        //ScreenSize.productCardWidth / ScreenSize.productCardHeight,
                        crossAxisCount: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> loadData() async {
    EasyLoading.show(status: 'Please Wait..');
    await Provider.of<BlogsProvider>(context, listen: false)
        .getBlogsContent(page: 1, category: "money", screen: "money");
    setState(() {});
  }

/*Future<void> getOfferDetail(int categoryId) async {
    await Provider.of<OffersProvider>(context, listen: false)
        .getOffers(categoryId: categoryId, perPage: 10);
  }*/

/* void confirmPhoneBottomSheet(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return ConfirmPhoneBottomSheet();
      },
    );
  }*/

}
