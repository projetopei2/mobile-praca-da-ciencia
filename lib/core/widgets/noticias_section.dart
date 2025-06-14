import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'dart:async';

import 'package:flutter/rendering.dart';

class NewsSection extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;

  const NewsSection({super.key, required this.snapshot});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  bool _userScrolling = false;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  // Movimento automatico do carrossel
  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (_userScrolling) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final itemWidth = 345 + 10;

      if (currentScroll >= maxScroll) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.animateTo(
          currentScroll + itemWidth,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        height: 180,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is UserScrollNotification) {
              setState(() {
                _userScrolling = notification.direction != ScrollDirection.idle;
              });
            }
            return false;
          },
          child: ListView.separated(
            controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.snapshot.data?.docs.length ?? 0,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => Navigator.of(context).pushNamed(
                      '/news',
                      arguments: {'id': widget.snapshot.data?.docs[index].id},
                    ),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 10),
                  width: 345,
                  decoration: BoxDecoration(
                    color: Styles.backgroundContentColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.2,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: AssetImage(
                              'assets/images/${widget.snapshot.data?.docs[index]['image']}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Align(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${widget.snapshot.data?.docs[index]['nome']}',
                                      style: TextStyle(
                                        color: Styles.fontColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        '${widget.snapshot.data?.docs[index]['data_publicacao']}',
                                        style: TextStyle(
                                          color: Styles.fontColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Styles.buttonSecond,
                                        shadowColor: Styles.button,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            32.0,
                                          ),
                                        ),
                                        minimumSize: const Size(50, 35),
                                      ),
                                      onPressed:
                                          () => Navigator.of(context).pushNamed(
                                            '/news',
                                            arguments: {
                                              'id':
                                                  widget
                                                      .snapshot
                                                      .data
                                                      ?.docs[index]
                                                      .id,
                                            },
                                          ),
                                      child: Text(
                                        'Informações',
                                        style: TextStyle(
                                          color: Styles.fontColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
