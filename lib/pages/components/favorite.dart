import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isFavorite = !isFavorite),
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: isFavorite ? Colors.red : Colors.grey,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset("assets/icons/heart.svg"),
      ),
    );
  }
}
