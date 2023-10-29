import 'package:ecommerce/Widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imaglist;
  const FullScreenView({super.key, required this.imaglist});

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _pagecontroller = PageController();
  int currimgind = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppbarBackButton(),
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$currimgind/${widget.imaglist.length}",
                textAlign: TextAlign.center,
                style:const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 8),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                child: PageView(
                    controller: _pagecontroller,
                    children: List.generate(widget.imaglist.length, (index) {
                      return InteractiveViewer(
                        trackpadScrollCausesScale: true,
                        transformationController: TransformationController(),
                        child: Image(
                            image: NetworkImage(
                                widget.imaglist[index].toString())),
                      );
                    })),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: ListView.builder(
                    itemCount: widget.imaglist.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currimgind = index + 1;
                          });
                          _pagecontroller.jumpToPage(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.orangeAccent),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Image.network(
                                  widget.imaglist[index].toString())),
                        ),
                      );
                    }),
              )
            ]),
      ),
    );
  }
}
