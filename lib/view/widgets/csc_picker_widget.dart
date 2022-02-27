library csc_picker;

import 'package:csc_picker/dropdown_with_search.dart';
import 'package:csc_picker/model/select_status_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Layout { vertical, horizontal }
enum CountryFlag { SHOW_IN_DROP_DOWN_ONLY, ENABLE, DISABLE }

class CSPickerWidget extends StatefulWidget {
  final ValueChanged<String>? onCountryChanged;
  final ValueChanged<String>? onStateChanged;
  final ValueChanged<String>? onCityChanged;

  ///Parameters to change style of CSC Picker
  final TextStyle? selectedItemStyle, dropdownHeadingStyle, dropdownItemStyle;
  final BoxDecoration? dropdownDecoration, disabledDropdownDecoration;
  final bool? showStates, showCities;
  final CountryFlag? flagState;
  final Layout? layout;
  final double? searchBarRadius;
  final double? dropdownDialogRadius;

  ///CSC Picker Constructor
  const CSPickerWidget(
      {Key? key,
      this.onCountryChanged,
      this.onStateChanged,
      this.onCityChanged,
      this.selectedItemStyle,
      this.dropdownHeadingStyle,
      this.dropdownItemStyle,
      this.dropdownDecoration,
      this.disabledDropdownDecoration,
      this.searchBarRadius,
      this.dropdownDialogRadius,
      this.flagState = CountryFlag.ENABLE,
      this.layout = Layout.horizontal,
      this.showStates = true,
      this.showCities = true})
      : super(key: key);

  @override
  _CSPickerWidgetState createState() => _CSPickerWidgetState();
}

class _CSPickerWidgetState extends State<CSPickerWidget> {
  bool isActive = false;
  List<String>? _cities = [];
  List<String>? _country = [];
  List<String>? _states = [];

  String _selectedCity = "City";
  String? _selectedCountry;
  String _selectedState = "State";
  var responses;

  @override
  void initState() {
    getCounty();
    super.initState();
  }

  ///Read JSON country data from assets
  Future getResponse() async {
    var res = await rootBundle
        .loadString('packages/csc_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  ///get countries from json response
  Future getCounty() async {
    _country!.clear();
    var countries = await getResponse() as List;
    countries.forEach((data) {
      var model = Country();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) return;
      setState(() {
        widget.flagState == CountryFlag.ENABLE ||
                widget.flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY
            ? _country!.add(model.emoji! +
                "    " +
                model.name!) /* : _country.add(model.name)*/
            : _country!.add(model.name!);
      });
    });
    return _country;
  }

  ///get states from json response
  Future getState() async {
    _states!.clear();
    //print(_selectedCountry);
    var response = await getResponse();
    var takeState = widget.flagState == CountryFlag.ENABLE ||
            widget.flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY
        ? response
            .map((map) => Country.fromJson(map))
            .where(
                (item) => item.emoji + "    " + item.name == _selectedCountry)
            .map((item) => item.state)
            .toList()
        : response
            .map((map) => Country.fromJson(map))
            .where((item) => item.name == _selectedCountry)
            .map((item) => item.state)
            .toList();
    var states = takeState as List;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var stateName in name) {
          //print(stateName.toString());
          _states!.add(stateName.toString());
        }
      });
    });
    _states!.sort((a, b) => a.compareTo(b));
    return _states;
  }

  ///get cities from json response
  Future getCity() async {
    _cities!.clear();
    var response = await getResponse();
    var takeCity = widget.flagState == CountryFlag.ENABLE ||
            widget.flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY
        ? response
            .map((map) => Country.fromJson(map))
            .where(
                (item) => item.emoji + "    " + item.name == _selectedCountry)
            .map((item) => item.state)
            .toList()
        : response
            .map((map) => Country.fromJson(map))
            .where((item) => item.name == _selectedCountry)
            .map((item) => item.state)
            .toList();
    var cities = takeCity as List;
    cities.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityName = name.map((item) => item.city).toList();
      cityName.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesName = ci.map((item) => item.name).toList();
          for (var cityName in citiesName) {
            //print(cityName.toString());
            _cities!.add(cityName.toString());
          }
        });
      });
    });
    _cities!.sort((a, b) => a.compareTo(b));
    return _cities;
  }

  ///get methods to catch newly selected country state and city and populate state based on country, and city based on state
  void _onSelectedCountry(String value) {
    if (!mounted) return;
    setState(() {
      if (widget.flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY) {
        try {
          this.widget.onCountryChanged!(value.substring(6).trim());
        } catch (e) {}
      } else
        this.widget.onCountryChanged!(value);
      //code added in if condition
      if (value != _selectedCountry) {
        _states!.clear();
        _cities!.clear();
        _selectedState = " State";
        _selectedCity = " City";
        this.widget.onStateChanged!('');
        this.widget.onCityChanged!('');
        _selectedCountry = value;
        getState();
      } else {
        this.widget.onStateChanged!(_selectedState);
        this.widget.onCityChanged!(_selectedCity);
      }
    });
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      this.widget.onStateChanged!(value);
      //code added in if condition
      if (value != _selectedState) {
        _cities!.clear();
        _selectedCity = " City";
        this.widget.onCityChanged!('');
        _selectedState = value;
        getCity();
      } else {
        this.widget.onCityChanged!(_selectedCity);
      }
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      //code added in if condition
      if (value != _selectedCity) {
        _selectedCity = value;
        this.widget.onCityChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Column(
      children: [
        widget.layout == Layout.vertical
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  countryDropdown(),
                  SizedBox(
                    height: 10.h,
                  ),
                  stateDropdown(),
                  SizedBox(
                    height: 10.h,
                  ),
                  cityDropdown()
                ],
              )
            : Column(
                children: [
                  countryDropdown(),
                  widget.showStates!
                      ? SizedBox(
                          height: 10.h,
                        )
                      : Container(),
                  widget.showStates! ? stateDropdown() : Container(),
                  SizedBox(
                    height: 10.h,
                  ),
                  widget.showStates! && widget.showCities!
                      ? cityDropdown()
                      : Container()
                ],
              ),
      ],
    );
  }

  ///filter Country Data according to user input
  Future<List<String>> getCountryData(filter) async {
    var filteredList = _country!
        .where(
            (country) => country.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    if (filteredList.isEmpty)
      return _country!;
    else
      return filteredList;
  }

  ///filter Sate Data according to user input
  Future<List<String>> getStateData(filter) async {
    var filteredList = _states!
        .where((state) => state.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    if (filteredList.isEmpty)
      return _states!;
    else
      return filteredList;
  }

  ///filter City Data according to user input
  Future<List<String>> getCityData(filter) async {
    var filteredList = _cities!
        .where((city) => city.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    if (filteredList.isEmpty)
      return _cities!;
    else
      return filteredList;
  }

  ///Country Dropdown Widget
  Widget countryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Country",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              "*",
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade200,
          ),
          child: DropdownWithSearch(
            title: "Country",
            placeHolder: "Search Country",
            selectedItemStyle: _selectedCountry != null
                ? widget.selectedItemStyle
                : TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
            dropdownHeadingStyle: widget.dropdownHeadingStyle,
            itemStyle: widget.dropdownItemStyle,
            decoration: widget.dropdownDecoration,
            disabledDecoration: widget.disabledDropdownDecoration,
            disabled: _country!.length == 0 ? true : false,
            dialogRadius: widget.dropdownDialogRadius,
            searchBarRadius: widget.searchBarRadius,
            items: _country!.map((String dropDownStringItem) {
              return dropDownStringItem;
            }).toList(),
            selected: _selectedCountry != null ? _selectedCountry : "Country",
            //selected: _selectedCountry != null ? _selectedCountry : "Country",
            //onChanged: (value) => _onSelectedCountry(value),
            onChanged: (value) {
              print("countryChanged $value $_selectedCountry");
              if (value != null) {
                _onSelectedCountry(value);
              }
            },
            label: '1',
          ),
        ),
      ],
    );
  }

  ///State Dropdown Widget
  Widget stateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "State",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade200,
          ),
          child: DropdownWithSearch(
            title: "State",
            placeHolder: "Search State",
            disabled: _states!.length == 0 ? true : false,
            items: _states!.map((String dropDownStringItem) {
              return dropDownStringItem;
            }).toList(),
            selectedItemStyle: _states!.length == 0
                ? TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                  )
                : widget.selectedItemStyle,
            dropdownHeadingStyle: widget.dropdownHeadingStyle,
            itemStyle: widget.dropdownItemStyle,
            decoration: widget.dropdownDecoration,
            dialogRadius: widget.dropdownDialogRadius,
            searchBarRadius: widget.searchBarRadius,
            disabledDecoration: widget.disabledDropdownDecoration,

            selected: _selectedState,
            //onChanged: (value) => _onSelectedState(value),
            onChanged: (value) {
              //print("stateChanged $value $_selectedState");
              value != null
                  ? _onSelectedState(value)
                  : _onSelectedState(_selectedState);
            },
            label: '2',
          ),
        ),
      ],
    );
  }

  ///City Dropdown Widget
  Widget cityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "City",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade200,
          ),
          child: DropdownWithSearch(
            title: "City",
            placeHolder: "Search City",
            disabled: _cities!.length == 0 ? true : false,
            items: _cities!.map((String dropDownStringItem) {
              return dropDownStringItem;
            }).toList(),
            selectedItemStyle: _cities!.length == 0
                ? TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                  )
                : widget.selectedItemStyle,

            dropdownHeadingStyle: widget.dropdownHeadingStyle,
            itemStyle: widget.dropdownItemStyle,
            decoration: widget.dropdownDecoration,
            dialogRadius: widget.dropdownDialogRadius,
            searchBarRadius: widget.searchBarRadius,
            disabledDecoration: widget.disabledDropdownDecoration,
            selected: _selectedCity,
            //onChanged: (value) => _onSelectedCity(value),
            onChanged: (value) {
              //print("cityChanged $value $_selectedCity");
              value != null
                  ? _onSelectedCity(value)
                  : _onSelectedCity(_selectedCity);
            },
            label: '3',
          ),
        ),
      ],
    );
  }
}
