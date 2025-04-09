import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final double rating;
  final double starSize;
  final Color color;
  final bool allowEditing;
  final ValueChanged<double>? onRatingChanged;

  const StarRating({
    super.key,
    this.rating = 0.0,
    this.starSize = 24.0,
    this.color = Colors.amber,
    this.allowEditing = false,
    this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: widget.allowEditing
              ? () {
                  setState(() {
                    _currentRating = index + 1.0;
                  });
                  widget.onRatingChanged?.call(_currentRating);
                }
              : null,
          child: Icon(
            index < _currentRating.floor()
                ? Icons.star
                : (index < _currentRating ? Icons.star_half : Icons.star_border),
            color: widget.color,
            size: widget.starSize,
          ),
        );
      }),
    );
  }
}
