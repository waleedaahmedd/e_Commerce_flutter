import 'dart:convert';
import 'dart:core';

import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/models/filter_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/get_offers_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/offers_list_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/product_categories.dart';
import 'package:b2connect_flutter/model/models/offers_models/product_details_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/product_details_model.dart';
import 'package:b2connect_flutter/model/services/http_service.dart';
import 'package:b2connect_flutter/model/services/util_service.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'Repository/repository_pattern.dart';

class OffersProvider with ChangeNotifier {
  Repository? http = locator<HttpService>();
  GetOffers? offersData;
  final searchQueryController = TextEditingController();



  ProductDetailsModel? productDetailsData;
  List<ProductCategories> productCategories = [];
  UtilService utilsService = locator<UtilService>();


  //List<dynamic> productIds = [];
  double totalPriceNow = 0.0;
  //double totalPriceLater = 0.0;
  double installmentPrice = 0.0;
  double updatedInstallmentPrice = 0.0;
  List<ProductDetailsModel> cartData = [];


  bool onlySmartPhone=false;
  bool? showLoader;


  // filter Variables

  FilterData filterData = FilterData(
      sortByListIndex: 0,
      availabilityListIndex: 0,
      listOfAllOptions: [],
      addAttributeId: [],
      selectedList: [],
      addAttribute: []);

  Future<void> handleAttributeTap(
      String attributeId, String optionsName) async {
    if (filterData.addAttributeId.contains(attributeId)) {
      var idIndex = filterData.addAttributeId
          .indexWhere((element) => element == attributeId);
      print(idIndex);

      List<String> listOnIndex = filterData.listOfAllOptions[idIndex];

      if (filterData.listOfAllOptions[idIndex].contains(optionsName)) {
        List<String> addOptions = [];
        addOptions.addAll(listOnIndex);
        addOptions.removeWhere((element) => element == optionsName);
        filterData.listOfAllOptions.removeAt(idIndex);
        filterData.listOfAllOptions
            .insert(idIndex, addOptions.toList(growable: true));
        var optionsList = addOptions.join(';');
        if (optionsList == "") {
          filterData.addAttributeId.removeAt(idIndex);
          filterData.addAttribute.removeAt(idIndex);
          print(filterData.addAttribute.join(','));
          filterData.filterBy = filterData.addAttribute.join(',') == ""
              ? null
              : filterData.addAttribute.join(',');
        } else {
          var idWithOptions = '$attributeId:$optionsList';
          filterData.addAttribute[idIndex] = idWithOptions;
          print(filterData.addAttribute.join(','));
          filterData.filterBy = filterData.addAttribute.join(',');
          addOptions.clear();
        }
      } else {
        List<String> addOptions = [];

        addOptions.addAll(listOnIndex);
        addOptions.add(optionsName);
        filterData.listOfAllOptions.removeAt(idIndex);
        filterData.listOfAllOptions
            .insert(idIndex, addOptions.toList(growable: true));
        print(filterData.listOfAllOptions);
        var optionsList = addOptions.join(';');
        var idWithOptions = '$attributeId:$optionsList';
        filterData.addAttribute.removeAt(idIndex);
        filterData.addAttribute.insert(idIndex, idWithOptions);
        print(filterData.addAttribute.join(','));
        filterData.filterBy = filterData.addAttribute.join(',');
        addOptions.clear();
      }
    } else {
      List<String> addOptions = [];
      addOptions.add(optionsName);
      filterData.addAttributeId.add(attributeId);
      filterData.listOfAllOptions.add(addOptions.toList(growable: true));
      print(filterData.listOfAllOptions);
      var optionsList = addOptions.join(';');
      filterData.selectedList = [attributeId, optionsList];
      filterData.addAttribute.add(filterData.selectedList.join(':'));
      print(filterData.addAttribute.join(','));
      filterData.filterBy = filterData.addAttribute.join(',');
      addOptions.clear();
    }
  }

  Future<void> clearFilterData({int? catId}) async {

    filterData.availabilityListIndex = 0;
    filterData.filterByStock = null;
   // filterData.sortByListIndex = 0;
    filterData.sortBy = null;
    filterData.filterBy = null;
    filterData.selectedList.clear();
    filterData.addAttribute.clear();
    filterData.maximumPrice = null;
    filterData.minimumPrice = null;
    //filterData.addOptions.clear();
    filterData.listOfAllOptions.clear();
    filterData.addAttributeId.clear();
    filterData.colors = null;
    //EasyLoading.show(status: 'Please Wait...');
    if (catId != null){
      await getOffers(categoryId: catId);
    }
  }

  void handleSortByTap(int index, sortByListId) {
    filterData.sortByListIndex = index;
    if (sortByListId == '2') {
      filterData.sortBy = 'PRICE_LOW_TO_HIGH';
    } else if (sortByListId == '3') {
      filterData.sortBy = 'PRICE_HIGH_TO_LOW';
    } else if (sortByListId == '4') {
      filterData.sortBy = 'NAME_A_Z';
    } else if (sortByListId == '5') {
      filterData.sortBy = 'NEWEST';
    } else {
      filterData.sortBy = null;
    }
  }

  void handleAvailabilityTap(int index, availabilityListId) {
    filterData.availabilityListIndex = index;
    if (availabilityListId == '2') {
      filterData.filterByStock = 'IN_STOCK';
    } else if (availabilityListId == '3'){
      filterData.filterByStock = 'ON_BACK_ORDER';
    }else {
      filterData.filterByStock = null;
    }
  }

  Future<GetOffers?> getOffers(
      {int? page,
        int? perPage,
        int? categoryId,
        String? sortBy,
        String? filterBy,
        String? filterByStock,
        String? name,
        int? minPrice,
        int? maxPrice}) async {
    try {
      var response = await http!.getOffers(page, perPage, categoryId, sortBy,
          filterBy, filterByStock, name, minPrice, maxPrice);
      if (response.statusCode == 200) {
        saveOffersList(GetOffers.fromJson(json.decode(response.body)));
        EasyLoading.dismiss();

        return offersData;
      } else {
        return utilsService
            .showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      print(e);
      return utilsService.showToast(e.toString());
    }
  }

  Future<ProductDetailsModel?> getProductDetails(String id) async {
    print('id from api--${id}');
    try {
      var response = await http!.getProductsDetails(id);
      if (response.statusCode == 200) {
        saveProductDetails(ProductDetailsModel.fromJson(json.decode(response.body)));
        return productDetailsData;
      } else {
        return utilsService
            .showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      print(e);
      return utilsService.showToast(e.toString());
    }
  }

  Future<List<ProductCategories>> getProductCategories() async {
    try {
      productCategories.clear();
      var response = await http!.productCategories();
      if (response.statusCode == 200) {
        for (var abc in response.data) {
          if (ProductCategories.fromJson(abc).parent == 0) {
            saveProductCategory(ProductCategories.fromJson(abc));
          }
        }
        return productCategories;
      } else {
        return utilsService
            .showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      print(e);
      return utilsService.showToast(e.toString());
    }
  }

  saveTotalNow(double value) {
    totalPriceNow = totalPriceNow + value;
    notifyListeners();
  }

  minusTotalNow(double value) {
    totalPriceNow = totalPriceNow - value;
    notifyListeners();
  }
/*  saveTotalLater(double value) {
    totalPriceLater = totalPriceLater + value;
    notifyListeners();
  } */

  removeInstallmentPrice(double value) {
    var removeInstallmentPrice = value / 3;
    updatedInstallmentPrice = updatedInstallmentPrice - removeInstallmentPrice;
    notifyListeners();
  }

  saveOffersList(GetOffers value) {
    offersData = value;
    notifyListeners();
  }
  calculateInstallmentPrice(double value){
    installmentPrice = value / 3;
    installmentPrice = installmentPrice * 2;
    notifyListeners();
  }

  updationOfInstallmentPrice(double salePrice, double regularPrice){
    var calculationWithRegularPrice = totalPriceNow - salePrice;
    calculationWithRegularPrice = calculationWithRegularPrice + regularPrice;
    updatedInstallmentPrice = calculationWithRegularPrice - installmentPrice;
  }

  addOtherProductsPriceInInstallmentPrice(double salePrice){
    updatedInstallmentPrice = updatedInstallmentPrice + salePrice;
  }
  removeOtherProductsPriceInInstallmentPrice(double salePrice){
    updatedInstallmentPrice = updatedInstallmentPrice - salePrice;
  }

  /* addToCartList(int value) {
    productIds.add(value);
    notifyListeners();
  }*/

  /*removeFromCartList(int value) {
    productIds.remove(value);
    notifyListeners();
  }*/

  /*removeCartListRepeat(int value) {
    productIds.removeWhere((element) => element == value);
    notifyListeners();
  }*/

  /*addCartData(ProductDetailsModel value) {
    this.cartData.add(value);
    notifyListeners();
  }*/
  clearCartData() {
    this.cartData.clear();
    notifyListeners();
  }
  /*clearProduct() {
    this.productIds.clear();
    notifyListeners();
  }*/

  removeCartData(int value) {
    this.cartData.removeWhere((element) => element.offer.id == value);
    notifyListeners();
  }

  saveProductCategory(ProductCategories value) {
    this.productCategories.add(value);
    notifyListeners();
  }

  saveProductDetails(ProductDetailsModel value) {
    this.productDetailsData = value;
    notifyListeners();
  }

  updateFilterData(FilterData value) {
    this.filterData = value;
    notifyListeners();
  }
}


