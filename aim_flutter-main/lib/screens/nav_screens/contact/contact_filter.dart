import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/screens/call_summary.dart';

class ContactFilter extends StatefulWidget {
  final filter;
  const ContactFilter({super.key, required this.filter});

  @override
  State<ContactFilter> createState() => _ContactFilterState();
}

class _ContactFilterState extends State<ContactFilter> {
  String selectedFilter = "All Contacts";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedFilter = widget.filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: TextButton(
          child: const Text(
            'Clear',
            style: TextStyle(
              color: DARK_TEXT_CLR,
              fontSize: FONT_SM,
            ),
          ),
          onPressed: () {
            Navigator.pop(context, "ALLCNT");
          },
        ),
        title: const Text(
          "Filters",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              //print('apply');
              Navigator.pop(context, selectedFilter);
            },
            child: const Text(
              'Apply',
              style: TextStyle(
                color: DARK_TEXT_CLR,
                fontSize: FONT_SM,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(PADDING_MD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = "ALLCNT";
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'All Contacts',
                        style: TextStyle(
                          color: DARK_TEXT_CLR,
                          fontSize: FONT_SM,
                        ),
                      ),
                    ),
                    selectedFilter == "ALLCNT"
                        ? SvgPicture.asset("assets/images/tick_contact_ic.svg")
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = "MYCNT";
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'My Contacts',
                        style: TextStyle(
                          color: DARK_TEXT_CLR,
                          fontSize: FONT_SM,
                        ),
                      ),
                    ),
                    selectedFilter == "MYCNT"
                        ? SvgPicture.asset("assets/images/tick_contact_ic.svg")
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = "LWCNT";
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'New Last Week',
                        style: TextStyle(
                          color: DARK_TEXT_CLR,
                          fontSize: FONT_SM,
                        ),
                      ),
                    ),
                    selectedFilter == "LWCNT"
                        ? SvgPicture.asset("assets/images/tick_contact_ic.svg")
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = "TWCNT";
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'New This Week',
                        style: TextStyle(
                          color: DARK_TEXT_CLR,
                          fontSize: FONT_SM,
                        ),
                      ),
                    ),
                    selectedFilter == "TWCNT"
                        ? SvgPicture.asset("assets/images/tick_contact_ic.svg")
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = "RMCNT";
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Recently Modified',
                        style: TextStyle(
                          color: DARK_TEXT_CLR,
                          fontSize: FONT_SM,
                        ),
                      ),
                    ),
                    selectedFilter == "RMCNT"
                        ? SvgPicture.asset("assets/images/tick_contact_ic.svg")
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: SIZE_XS,
              ),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
