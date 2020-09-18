import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/services/country_assets.dart';
import 'package:test_app/constants.dart';

Country country = Country();

 void main() => runApp(CountryPicker());

class CountryPicker extends StatefulWidget {
  static const String id = 'country_picker_screen';
  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  TextEditingController controller = TextEditingController();
  String filter;
  IconData icon = Icons.search;
  Widget appBarTitle = Text(
    '',
    style: kAppBarTextStyle,
  );
  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
           // appBar: customAppBar(context),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: <Widget>[
                       IconButton(
                          icon: Icon(Icons.chevron_left, color: Color(0xff666666), size: 30.0,),
                          onPressed: (){

                          },
                        ),
                      Text(
                        'Select your country',
                        style: TextStyle(
                          color: Color(0xff4d4d4d),
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                          fontFamily: 'Poppins'
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    width: 100.0,
                    height: 50.0,
                   child: customAppBar(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                       // border: Border.all(width: 1.8, color: Color(0xfff2f5f8)),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffDCDCE5),
                           blurRadius: 3.0,
                          )
                        ]
                    ),
                  ),
                ),
                SizedBox(height: 2.0,),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: country.countries.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        // i have added toLowercase() to avoid case sensitive search
                        return filter == null || filter == '' ? new CustomTiles(country.countries[index]["name"], country.countries[index]["code"])
                            : (country.countries[index]["name"].toLowerCase().contains((filter).toLowerCase())
                                ? CustomTiles(country.countries[index]["name"],
                                    country.countries[index]["code"])
                                : Container());
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }

  // Widget customAppBar(BuildContext context) {
  //   return AppBar(
  //     backgroundColor: Color(0xff262626),
  //     elevation: 0.0,
  //     centerTitle: true,
  //     leading: IconButton(
  //       icon: Icon(
  //         Icons.keyboard_arrow_left,
  //         color: Colors.white,
  //       ),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //     title: appBarTitle,
  //     actions: <Widget>[
  //       IconButton(
  //           icon: Icon(
  //             icon,
  //             color: Colors.white,
  //           ),
  //           onPressed: () {
  //             if (icon == Icons.search) {
  //               setState(() {
  //                 this.appBarTitle = TextField(
  //                   decoration: InputDecoration(
  //                     hintText: 'Search countries',
  //                     hintStyle: kAppBarTextFieldHintStyle,
  //                     border: InputBorder.none,
  //                   ),
  //                   controller: controller,
  //                   style: kAppBarTextFieldStyle,
  //                   cursorColor: Colors.grey[500],
  //                   autofocus: true,
  //                 );
  //                 icon = Icons.clear;
  //               });
  //             } else {
  //               setState(() {
  //                 icon = Icons.search;
  //                 appBarTitle = Text(
  //                   'Search Country',
  //                   style: kAppBarTextStyle,
  //                 );
  //                 controller.clear();
  //               });
  //             }
  //           }),
  //     ],
  //    // elevation: 2.0,
  //     // shape: RoundedRectangleBorder(
  //     //   borderRadius: BorderRadius.only(
  //     //     bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
  //     //   ),
  //     // ),
  //   );
  // }

  Widget customAppBar(BuildContext context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                icon,
                color: Color(0xff4c4b56),
              ),
              onPressed: () {
                if (icon == Icons.search) {
                  setState(() {
                    this.appBarTitle = TextField(
                      decoration: InputDecoration(
                        hintText: 'Search countries',
                        hintStyle: kAppBarTextFieldHintStyle,
                        border: InputBorder.none,
                      ),
                      controller: controller,
                      style: kAppBarTextFieldStyle,
                      cursorColor: Color(0xff4d4d4d),
                      autofocus: true,
                    );
                    icon = Icons.clear;
                  });
                } else {
                  setState(() {
                    icon = Icons.search;
                    appBarTitle = Text(
                      '',
                      style: kAppBarTextStyle,
                    );
                    controller.clear();
                  });
                }
              }),
         Flexible(
           child: appBarTitle,
         ),
        ],
      ),
    );
  }

}

class CustomTiles extends StatelessWidget {
  CustomTiles(this.countryName, this.countryDialCode);
  final String countryName;
  final String countryDialCode;
  @override
  Widget build(BuildContext context) {
    var size  = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
      child: GestureDetector(
        onTap: () {
         // Navigator.of(context).pop([countryDialCode, countryName]);
          print('tapped');
        },
        child: Container(
          height: size.height/13.0,
          width: size.width/3.0,
          // decoration: BoxDecoration(
          //     color: Colors.white, //Color(0xffdbe8fe)
          //     borderRadius: BorderRadius.circular(10.0),
          //     // boxShadow: [
          //     //   BoxShadow(
          //     //     color: Color(0xffDCDCE5),
          //     //     blurRadius: 10.0,
          //     //   )
          //     // ],
          // ),
          child:
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Material(
                      shape: CircleBorder(),
                      elevation: 4.0,
                      shadowColor: Color(0xffDCDCE5),
                      child: CircleAvatar(
                        radius: size.height/40.0,
                        backgroundImage: AssetImage('images/${countryName.toLowerCase()}.png'),//'images/${countryName.toLowerCase()}.png'
                        backgroundColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  Text(
                    countryName,
                    softWrap: false,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Color(0x900d0e13)//Color(0xff989dac)
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '(+$countryDialCode)',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Color(0xff666666)),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
