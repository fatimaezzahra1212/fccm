import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore =
    FirebaseFirestore.instance; //3melna hado hna bach nstakhdmohom f code kaml
// ignore: non_constant_identifier_names
late User SignedInUser;

//this will give us the email

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagetextcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText; //this will give us the msg text
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        SignedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  /*void getMessages() async {
    final messages = await _firestore.collection('messages').get();//had star kidik n collection dyalk ya3ni dik FIRESTORE DYALK li kayna f firebase o fiha email o msg  o dik get() hiya likatal3lek dik bayanato hitach hiya future 3melna async+await
    for (var message in messages.docs) {//docs f firebase dyalna hiya fayn kayn messages, 3melna dik for hita 3andna BZF DYAL DOCS DONC GHANFICHIW KOL wahda bohda 'message in messages' ya3ni ghansepariw docs o nrj3ohom kol doc bohdo
      print(message.data());//hna kanaffichiw dik doc o data katjbdlek value lifwest key dyal dik doc, chihaja fhal hayda
    }
  }*/

  /*void messageStreams() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      //Snapshot ghat pushi les messages likaynin f collection f firestore automatiquement wakha itzado bla mat3mel refresh kol mara , une fois katzid msg tma rah kiban b snapshot
      for (var message in snapshot.docs) {
        //docs ya3ni collectio  dyalna, okhesna nfar9ohom b for loop bach iban kol wahd bihdo
        print(message.data());
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF013C61),
        title: Row(
          children: [
            Image.asset('assets/images/userImage.png', height: 25),
            SizedBox(width: 10),
            Text('MessageMe')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              //messageStreams(); //methode
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('drivers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final drivers = snapshot.data!.docs;

            return ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return ListTile(
                  title: Text(driver.get('name')),
                  subtitle: Text(driver.get('car')),
                  onTap: () {
                    // Do something with the selected driver
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF013C61),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messagetextcontroller,
                      onChanged: (value) {
                        messageText = value; //msg d user ghathat fhad value
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messagetextcontroller
                          .clear(); //kimsah dakchi liktebti une fois katsayfto
                      _firestore.collection('request').add({
                        'text': messageText,
                        'sender': SignedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('request')
          .orderBy('time')
          .snapshots(), //snapshot men naw3 query snapshot which is a class that containes our messages from the firebase
      builder: (context, snapshot) {
        List<MessageLine> MessageWidgets = [];
        if (!snapshot.hasData) {
          //lakan snapshot ma3andochi data
          //add a pinner
        }
        //lakan kayn data
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('text'); //text message dyalna
          final messageSender = message.get('sender'); //chkon lisayfet msg
          final currentUser = SignedInUser.email;

          final messageWidget = MessageLine(
            Sender: messageSender,
            text: messageText,
            isMe: currentUser ==
                messageSender, //lakant mha9a had == diksa3a isMe true
          ); /*Text(
                    '$messageText-$messageSender ',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ); */ //ghaytaaficha text - email dlisayfet
          MessageWidgets.add(
              messageWidget); //hatina messagewidget lifiha infos fwest Messagewidget lihiya list
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: MessageWidgets,
          ),
        );
      },
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({this.text, this.Sender, required this.isMe, Key? Key});
  final String? Sender;
  final String? text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$Sender',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF013C61),
            ),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    //hta nkon ana likansift
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    //howa likisifet
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe
                ? Colors.blue[900]
                : Colors
                    .white, //lakan signedin howa lisayfet msg chart lwl, else chart 2 color white
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text ',
                style: TextStyle(
                  fontSize: 30,
                  color: isMe
                      ? Colors.white
                      : Colors
                          .black45, //lakont ana likansifet ktaba b byad ama lakan xiwahd akhor color b khal
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
