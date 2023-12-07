import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class propertyBtn extends StatefulWidget {
  propertyBtn({
    required this.onTap,
    required this.title,
    required this.bgColor,
    this.isLoading,
    this.card_margin,
    this.container_margin,
    this.borderRadius = 0,
    this.elevation = 10,
  });

  final VoidCallback onTap;
  final String title;
  final Color bgColor;
  final bool? isLoading;
  final EdgeInsets? card_margin;
  final EdgeInsets? container_margin;
  final double borderRadius;
  final double elevation;

  @override
  State<propertyBtn> createState() => _propertyBtnState();
}

class _propertyBtnState extends State<propertyBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        margin: (widget.card_margin == null)
            ? const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 40,
                top: 20,
              )
            : widget.card_margin,
        elevation: widget.elevation,
        child: Ink(
          color: widget.bgColor,
          child: Container(
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
            margin: (widget.container_margin == null)
                ? const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                    top: 10,
                  )
                : widget.container_margin,
            width: double.infinity,
            // width: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (widget.isLoading == true)
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  : Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Passion One',
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
