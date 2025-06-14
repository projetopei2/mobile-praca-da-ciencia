import 'package:flutter/material.dart';

class Carrossel extends StatefulWidget {
  const Carrossel({super.key});

  @override
  State<Carrossel> createState() => _CarrosselState();
}

class _CarrosselState extends State<Carrossel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: CarouselView(
        itemExtent: MediaQuery.sizeOf(context).width,
        itemSnapping: true,
        elevation: 4,
        children: List.generate(3, (int index) {
          return Container(
            child: Image(image: AssetImage('assets/images/img-carousel-$index.png'), fit: BoxFit.cover,),
          );
        }),
      ),
    );
  }
}
