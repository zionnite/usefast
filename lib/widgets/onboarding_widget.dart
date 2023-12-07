import 'package:flutter/material.dart';
import 'package:usefast/model/onboarding_model.dart';

class onboardingWidget extends StatelessWidget {
  onboardingWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(30),
      color: model.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(
              model.image_name,
            ),
            height: height * 0.5,
            fit: BoxFit.contain,
            // color: Colors.blue.shade900.withOpacity(1),
            // colorBlendMode: BlendMode.color,
          ),
          Column(
            children: [
              Text(
                model.title,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: 'Passion One',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                model.sub_title,
                style: const TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          Text(
            model.counter,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
