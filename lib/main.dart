// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _initialAmountController = TextEditingController();
  TextEditingController _downPaymentController = TextEditingController();
  TextEditingController _interestRateController = TextEditingController();

  String selected = '';
  late double totalInterest;
  late double monthlyInterest;
  late double monthlyInstallment;

  void loanCalculation() {
    //amount = initial amount - down payment
    final amount = int.parse(_initialAmountController.text) -
        int.parse(_downPaymentController.text);

    //total interest = amount * interest rate * loan duration
    final total_interest = amount *
        (double.parse(_interestRateController.text) / 100) *
        int.parse(selected);
    final monthly_interest = total_interest / (int.parse(selected));
    final monthly_installment =
        (amount + total_interest) / int.parse(selected) * 12;
    setState(() {
      totalInterest = total_interest;
      monthlyInterest = monthly_interest;
      monthlyInstallment = monthly_installment;
    });

    //monthly interest = total interest / 12
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.menu,
            size: 30,
            color: Colors.black,
          ),
          toolbarHeight: 40,
          backgroundColor: Colors.yellow,
          //remove the grey shadow thing
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(
                Icons.info,
                size: 20,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding:
              //leave extra room at the bottom to make room for the keyboard
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "STASH Loan",
                      style: GoogleFonts.robotoMono(fontSize: 35),
                    ),
                    Text(
                      "Calculator",
                      style: GoogleFonts.robotoMono(fontSize: 35),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 40, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputForm(
                    title: "Initial Amount Taken",
                    hintText: "eg. 40000",
                    controller: _initialAmountController),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    "Amount Owed",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                inputForm(
                    title: "Interest Rate",
                    hintText: "eg. 3.5",
                    controller: _interestRateController),
                Text(
                  "Loan Duration",
                  style: GoogleFonts.robotoMono(fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    //10 days:15%
                    loanPeriod("1"),
                    // 20 days: 25%
                    loanPeriod("2"),
                    //30 days: 30%
                    loanPeriod("3"),
                    loanPeriod("4"),
                    //30 days: 30%
                    loanPeriod("5"),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    loanPeriod("6"),
                    //30 days: 30%
                    loanPeriod("7"),
                    //10 days:15%
                    loanPeriod("8"),
                    // 20 days: 25%
                    loanPeriod("9"),
                    //30 days: 30%
                    loanPeriod("10"),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    loanCalculation();
                    //need to run a function after a user interface animation has completed.
                    Future.delayed(Duration.zero);
                    showModalBottomSheet(
                        //User cannot dismiss modal by tapping outside of it
                        isDismissible: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Result",
                                    style: GoogleFonts.robotoMono(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  result(
                                      title: "Total Interest",
                                      amount: totalInterest),
                                  result(
                                      title: "Monthly Interest",
                                      amount: monthlyInterest),
                                  result(
                                      title: "Monthly Installment",
                                      amount: monthlyInstallment),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  /*
                                  GestureDetector is a widget in Flutter that can detect gestures like taps, drags, and scale. 
                                  In this code snippet, GestureDetector is used to detect a tap gesture on a specific area in the screen, which triggers a pop event. 
                                  When the user taps on the area, Navigator.of(context).pop() is called, which removes the current route from the navigation stack and goes back to the previous route.
                                   This is often used to dismiss a modal dialog or a bottom sheet.
                                  */
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Recalculate",
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        "Calculate",
                        style: GoogleFonts.robotoMono(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

//{} for optional parameters
  Widget result({String title = '', double amount = 0}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 15),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Text(
          //string representation of this number to 2 decimal places
          "Kes.${amount.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget loanPeriod(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 10, 0),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            //if selected make the borders red with a size 2 else nothing
            border: title == selected
                ? Border.all(color: Colors.red, width: 2)
                : null,
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }

  Widget inputForm(
      {String title = '',
      required TextEditingController controller,
      String hintText = ''}) {
    return Column(
      //align the children to the start
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Title Text
        Text(title, style: GoogleFonts.robotoMono(fontSize: 20)),
        SizedBox(height: 10),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          //Input text
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintText: hintText,
              contentPadding: EdgeInsets.only(left: 20),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
