import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/services/country_assets.dart';
import 'package:test_app/constants.dart';

Country country = Country();

// void main() => runApp(CountryPicker());

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
    'Search Country',
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
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
         // appBar: customAppBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 4.0, right: 4.0, bottom: 4.0),
                child: Container(
                  width: 100.0,
                  height: 50.0,
                 child: customAppBar(context),//customAppBar(context),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.3, color: Color(0xffd9d9d9)),
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x10263238),
                          blurRadius: 10.0,
                         // offset: Offset(0, 5)
                        )
                      ]
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: country.countries.length,
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
              Icons.keyboard_arrow_left,
              color: Colors.black45,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
         Flexible(
           child: appBarTitle,
         ),
          IconButton(
              icon: Icon(
                icon,
                color: Colors.black45,
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
                      cursorColor: Colors.black26,
                      autofocus: true,
                    );
                    icon = Icons.clear;
                  });
                } else {
                  setState(() {
                    icon = Icons.search;
                    appBarTitle = Text(
                      'Search Country',
                      style: kAppBarTextStyle,
                    );
                    controller.clear();
                  });
                }
              }),
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
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop([countryDialCode, countryName]);
        },
        child: Container(
          height: size.height/8.0,
          width: size.width/3.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffDCDCE5),
                  blurRadius: 10.0,
                )
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: CircleAvatar(
                    radius: size.height/33.0,
                    backgroundImage: AssetImage('images/${countryName.toLowerCase()}.png'),
                    backgroundColor: Colors.grey[100],
                  ),
                ),
                Flexible(
                  child: Text(
                    countryName,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1a1a1a)),
                  ),
                ),
                Flexible(
                  child: Text(
                    '(+$countryDialCode)',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff595959)),
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
