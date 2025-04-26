import 'package:flutter/material.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({super.key, required this.scrollController});

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    final show = widget.scrollController.offset > 300;
    if (show != _showButton) {
      setState(() {
        _showButton = show;
      });
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      right: 20,
      bottom: _showButton ? 80 : -100,
      child: FloatingActionButton.small(
        onPressed: _scrollToTop,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
        heroTag: 'scrollToTopButton',
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}
