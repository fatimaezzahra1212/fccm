import 'package:flutter/material.dart';
import 'package:fccm/drivers/driver.dart';
import 'package:fccm/clients/client.dart';

import '../app_theme.dart';

const Color primaryColor = Color(0xFF9A9696);
const Color secondaryColor = Color(0xFF013C61);

class LoginasPage extends StatelessWidget {
  @override
  /*  LoginasPagestate createState() => LoginasPagestate();
}

class LoginasPagestate extends State<LoginasPage> {
  final _jj = GlobalKey<FormState>();
  final DriverEditingController = new TextEditingController();
  final ClientEditingController = new TextEditingController();
  
   final DriverField = TextFormField(
        autofocus: false,
        controller: DriverEditingController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          DriverEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Driver",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }*/

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('                 Choice your profile ',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            )),
        backgroundColor: secondaryColor,
      ),
      body: Center(
          child: Row(children: [
        Expanded(
          child: OutlinedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                Text(
                  '         I am client !        ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Registractionscreen()));
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(8.8),
              fixedSize: Size(80, 50),
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              primary: secondaryColor,
              onPrimary: primaryColor,
              elevation: 15,
              shadowColor: secondaryColor,
              alignment: Alignment.topLeft,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ),
        Expanded(
          child: OutlinedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_taxi),
                Text(
                  '         I am Taxi driver !        ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                )
              ],
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Signupscreen()));
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10.8),
              fixedSize: Size(80, 50),
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              primary: secondaryColor,
              onPrimary: primaryColor,
              elevation: 15,
              shadowColor: secondaryColor,
              alignment: Alignment.topRight,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ),
      ])),
    );
  }
}
      //Icon(Icons.message, size: 10, color: primaryColor),
      //  ' I am client !'),

      /* ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => driverPage()));
                    },
                    child: Text(
                      '               I am Taxi Driver !              ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      //  ' I am Taxi Driver !'),
                    ),
                  ),
                  //Icon(Icons.message, size: 10, color: primaryColor),
                ],
              )*/
 
      /*child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

         child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("haha"),
          Text("ppppp"),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: secondaryColor,
            ),
            child: Container(
              constraints: BoxConstraints.expand(width: 80, height: 90),
              child: Image.asset('assets/image/taxit.png'),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: secondaryColor,
            ),
            child: Container(
              constraints: BoxConstraints.expand(width: 80, height: 90),
              child: Image.asset('assets/image/taxit.png'),
            ),
          ),
        ],
      ),
*/
      /* Column(
                children: <Widget>[
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 68,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Driver ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 68,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    color: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Client",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  )
                ],
              )
              
            ],
          ),
        ),
      ),
    );
    );
  }
}
*/
