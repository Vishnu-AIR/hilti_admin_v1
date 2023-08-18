import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WithdrawReq extends StatefulWidget {
  const WithdrawReq({super.key});

  @override
  State<WithdrawReq> createState() => _WithdrawReqState();
}

class _WithdrawReqState extends State<WithdrawReq> {
  String tod = "";
  List? argument1 = [];

  doneStatus(userId) async {
    print(userId);

    var response = await http.post(
        Uri.parse(
            "https://node-backend-6a02.onrender.com/wallet/adminonly/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": "done"}));

    print(jsonDecode(response.body) as Map);

    var allOrders = jsonDecode(response.body);
    getWithdraw();
  }

  getWithdraw() async {
    var response = await http.get(
        Uri.parse("https://node-backend-6a02.onrender.com/wallet"),
        headers: {"Content-Type": "application/json"});

    //print(jsonDecode(response.body) as Map);
    var allOrders = jsonDecode(response.body);

    if (allOrders['success'] == true) {
      //print(allOrders['data'].runtimeType);
      setState(() {
        argument1 = allOrders['data'];
      });
      //print(myOrders?.length);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      tod = getWithdraw().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: argument1 == []
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : Center(
                child: ListView.builder(
                    itemCount: argument1!.length,
                    itemBuilder: (context, int index) {
                      return Card(
                        color: argument1![index]['status'] == "pending"
                            ? const Color.fromARGB(255, 255, 173, 173)
                            : Color.fromARGB(205, 238, 255, 214),
                        child: ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "action: ${argument1![index]['action']}\naccount No.: ${argument1![index]['account']}\nifsc: ${argument1![index]['ifsc']}\nststus: ${argument1![index]['status']}\namount: ${argument1![index]['amount']}"),

                              // Text(
                              //     "quantity: ${argument1['index']['items'][0]['quantity']}"),
                              // Text("total: ${argument1['index']['totalAmount']}")
                            ],
                          ),
                          trailing: ElevatedButton(
                              onPressed: () {
                                doneStatus(argument1![index]['_id']);
                              },
                              child: Text("done")),
                          //leading: Image(image: NetworkImage("")),
                        ),
                      );
                    }),
              ));
    ;
  }
}
