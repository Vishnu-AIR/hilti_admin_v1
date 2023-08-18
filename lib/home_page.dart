import 'package:flutter/material.dart';
import 'package:hilti_admin/pur_req.dart';

import 'withdraw_req.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'purchased requests'),
            Tab(text: 'withdraw requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Replace with your content for CAMERA tab
          PurchasedReq(), // Replace with your content for CHATS tab
          WithdrawReq(), // Replace with your content for STATUS tab // Replace with your content for CALLS tab
        ],
      ),
    );
  }
}
