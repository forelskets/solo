import 'package:flutter/material.dart';
import 'package:vendue_vendor/src/views/country_code/bloc/country_code_bloc.dart';

import 'country_codes.dart';

class CountryPicker extends StatefulWidget {
  @override
  _CountryCodeState createState() => _CountryCodeState();
}

class _CountryCodeState extends State<CountryPicker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 370,
              width: MediaQuery.of(context).size.width - 50,
              child: new Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                height: 300,
                width: MediaQuery.of(context).size.width - 100,
                // color: Colors.red,
                child: ListView.builder(
                  itemCount: CountryCode().codes.length,
                  itemBuilder: (context, int index) {
                    String country = CountryCode().codes[index]["name"];
                    String code = CountryCode().codes[index]["dial_code"];
                    return InkWell(
                      onTap: () {
                        countryClodeBloc.countrySink(code);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        padding: EdgeInsets.only(left: 5.0),
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(code),
                            Container(width: 5.0),
                            Container(
                              // color: Colors.red,
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(
                                country,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}
