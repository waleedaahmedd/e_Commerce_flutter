import 'package:b2connect_flutter/model/models/userinfo_model.dart';
import 'package:b2connect_flutter/view/widgets/appbar_with_back_icon_and_language.dart';
import 'package:b2connect_flutter/view/widgets/user_information_widget.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:flutter/material.dart';
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:intl/intl.dart';
import '../../model/services/navigation_service.dart';
import '../../model/services/storage_service.dart';
import '../../model/utils/service_locator.dart';
import '../../view/widgets/change_language_bottom_sheet.dart';
import '../../view/widgets/csc_picker_widget.dart';

class EditPersonalInformationScreen extends StatefulWidget {
  const EditPersonalInformationScreen({Key? key}) : super(key: key);

  @override
  _EditPersonalInformationScreenState createState() =>
      _EditPersonalInformationScreenState();
}


class _EditPersonalInformationScreenState
    extends State<EditPersonalInformationScreen> {
  //String? _countryValue;
  //String? _stateValue;
  //String? _cityValue;
  late UserInfoModel _userInfoData;

  //bool _checkbox1 = false;
  // ignore: unused_field
  //bool _showPassword = false;
  //String _initialCountry = 'NG';
  //PhoneNumber _number = PhoneNumber(isoCode: 'NG');
  //var navigationService = locator<NavigationService>();
  //var storageService = locator<StorageService>();
  //DateTime _selectedFromDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _userInfoData =
    Provider.of<AuthProvider>(context, listen: false).userInfoData!;
  }

  @override
  // ignore: override_on_non_overriding_member
  // TextEditingController _passController = TextEditingController();
  // TextEditingController _emailController = TextEditingController();
  // TextEditingController _firstNameController = TextEditingController();
  // TextEditingController _lastNameController = TextEditingController();
  // TextEditingController _dateFromController = TextEditingController();
  // TextEditingController _phnController = TextEditingController();
  // ignore: unused_element
 /* Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onSurface: Colors.black,
              ),
              buttonTheme: ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedFromDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedFromDate = picked;
        dateFromController.text = DateFormat.yMMMMd().format(selectedFromDate);
      });
  }*/

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWithBackIconAndLanguage(
          onTapIcon: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Edit Personal \nInformation",
                  style: TextStyle(
                    height: 1.2,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  color: Colors.white,
                  child: UserInformationWidget(true),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}


