import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PurchasedReq extends StatefulWidget {
  const PurchasedReq({super.key});

  @override
  State<PurchasedReq> createState() => _PurchasedReqState();
}

class _PurchasedReqState extends State<PurchasedReq> {
  String tod = "";
  List argument1 = [];
  List myUsers = [];
  var user = {};

  doneStatus(userId) async {
    print(userId);

    var response = await http.post(
        Uri.parse(
            "https://node-backend-6a02.onrender.com/order/adminonly/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": "done"}));

    print(jsonDecode(response.body) as Map);

    getWithdraw();
  }

  getWithdraw() async {
    var response = await http.get(
        Uri.parse("https://node-backend-6a02.onrender.com/order/"),
        headers: {"Content-Type": "application/json"});

    //print(jsonDecode(response.body) as Map);
    var allOrders = jsonDecode(response.body);

    if (allOrders['success'] == true) {
      print(allOrders['data'].runtimeType);
      setState(() {
        argument1 = allOrders['data'];
      });
      //print(myOrders?.length);
    }
  }

  getUserProf(userId) async {
    var response = await http.get(
        Uri.parse("https://node-backend-6a02.onrender.com/users/${userId}"),
        headers: {"Content-Type": "application/json"});
    Map<String, dynamic> resUser = jsonDecode(response.body);
    //print(resUser);

    if (resUser['success'] == true) {
      user = resUser['data'];

      return user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWithdraw();
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
                              Text("${argument1![index]['userEmail']}"),
                              Text(
                                  "${argument1![index]['items'][0]['product']['title']}"),

                              Text(
                                  "quantity: ${argument1![index]['items'][0]['quantity']}"),
                              Text(
                                "total: ${argument1![index]['totalAmount']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("status: ${argument1![index]['status']}"),

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
