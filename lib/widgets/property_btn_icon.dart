import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PropertyBtnIcon extends StatefulWidget {
  PropertyBtnIcon({
    required this.onTap,
    required this.title,
    required this.bgColor,
    required this.icon,
    required this.icon_color,
    required this.icon_size,
    this.isSuffix = false,
    this.isLoading = false,
    this.elevation = 10,
    this.card_margin,
    this.container_margin,
    this.borderRadius = 0,
    this.textSize = 15,
  });

  final VoidCallback onTap;
  final String title;
  final Color bgColor;
  final IconData icon;
  final Color icon_color;
  final double icon_size;
  final bool isSuffix;
  final bool isLoading;
  final double elevation;

  final EdgeInsets? card_margin;
  final EdgeInsets? container_margin;
  final double borderRadius;
  final double textSize;

  @override
  State<PropertyBtnIcon> createState() => _PropertyBtnIconState();
}

class _PropertyBtnIconState extends State<PropertyBtnIcon> {
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
            margin: (widget.container_margin == null)
                ? const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                    top: 10,
                  )
                : widget.container_margin,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (widget.isLoading)
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (!widget.isSuffix)
                            ? Icon(
                                widget.icon,
                                color: widget.icon_color,
                                size: widget.icon_size,
                              )
                            : Container(),
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: widget.textSize,
                            color: Colors.white,
                            fontFamily: 'Passion One',
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        (widget.isSuffix)
                            ? Icon(
                                widget.icon,
                                color: widget.icon_color,
                                size: widget.icon_size,
                              )
                            : Container(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
