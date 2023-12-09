import 'package:flutter/material.dart';
import 'package:usefast/constant.dart';

class ProfileCardItem extends StatefulWidget {
  const ProfileCardItem(
      {Key? key,
      required this.iconData,
      required this.name,
      required this.onTap})
      : super(key: key);
  final IconData iconData;
  final String name;
  final VoidCallback onTap;

  @override
  State<ProfileCardItem> createState() => _ProfileCardItemState();
}

class _ProfileCardItemState extends State<ProfileCardItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          color: kSecondaryColor,
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(60),
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      widget.iconData,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 14.0),
                child: Icon(
                  Icons.chevron_right_sharp,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
