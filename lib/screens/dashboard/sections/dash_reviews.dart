import 'package:apniseva/screens/dashboard/widget/dash_strings.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../model/dashboard_model/dash_model.dart';

class DashReviews extends StatelessWidget {
  final List<TestimonialDtl>? getTestimonialDetail;
  const DashReviews({Key? key,
    this.getTestimonialDetail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.bottom + MediaQuery.of(context).padding.top);
    return Container(
      width: width,
      height: 190,
      alignment: Alignment.center,
      child: getTestimonialDetail!.isEmpty ? const Text('Your are the first one to share views') :
      ListView.builder(
          itemCount: getTestimonialDetail!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            ReviewCardColors getColor = cardColor[index];
            List<TestimonialDtl>? getTestimonial = getTestimonialDetail;
            return Container(
              width: 140,
              height: 80,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: getColor.colors,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(Remix.double_quotes_l),
                    ),
                    // Text('Best Services',
                    //   style: Theme.of(context).textTheme.labelMedium,
                    // ),
                    Text(getTestimonial![index].message!,
                      maxLines: 5,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(DashStrings.bannerImg),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(getTestimonial[index].name!,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            Text(getTestimonial[index].createdDate!,
                              style: Theme.of(context).textTheme.titleSmall,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            );
          }
      ),
    );
  }
}

List<ReviewCardColors> cardColor = [
  ReviewCardColors(colors: const Color(0xFFD0EF72)),
  ReviewCardColors(colors: const Color(0xFFEBE5FF)),
  ReviewCardColors(colors: const Color(0xFFDAB5DA)),
  ReviewCardColors(colors: const Color(0xFFFFCADE)),
  ReviewCardColors(colors: const Color(0xFFCAD3DC)),
  ReviewCardColors(colors: const Color(0xFFFFFF00)),
  ReviewCardColors(colors: const Color(0xFFF5F5E3)),
  ReviewCardColors(colors: const Color(0xFFFCE6C9)),
  ReviewCardColors(colors: const Color(0xFFFFE9E5)),
  ReviewCardColors(colors: const Color(0xFFAADD00)),
];

class ReviewCardColors {
  Color colors;
  ReviewCardColors({required this.colors});
}