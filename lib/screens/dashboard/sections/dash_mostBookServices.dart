import 'package:apniseva/screens/dashboard/widget/dash_strings.dart';
import 'package:flutter/material.dart';

import 'sub_category_modal.dart';

class DashBookedServices extends StatelessWidget {
  const DashBookedServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.bottom + MediaQuery.of(context).padding.top);
    return Container(
      width: width,
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                showBottomSheet(
                    context: context,
                    builder: (context) {
                      return const ChooseSubCategory();
                    });
              },
              child: Container(
                width: 130,
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(DashStrings.bannerImg))
                      ),
                    ),
                    Text(DashStrings.productName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text('₹399',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    RichText(text:  TextSpan(
                        style: Theme.of(context).textTheme.titleMedium,
                        children: const [
                          WidgetSpan(child: Icon(Icons.star_rate_rounded,
                            size: 14,
                          )),
                          TextSpan(text: '4.7')
                        ])
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
