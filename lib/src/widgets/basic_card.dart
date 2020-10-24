import 'dart:ui';

import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicCard extends StatelessWidget {
  final Widget child;
  final String title;
  final Color color;
  final Widget footer;
  final ScrollController scrollController;
  final bool withExpanded;
  final double height;

  const BasicCard({
    @required this.child,
    this.title,
    this.color,
    this.footer,
    this.scrollController,
    this.withExpanded,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      footer: footer,
      color: color,
      title: title,
      child: child,
      scrollController: scrollController,
      withExpanded: withExpanded,
      height: this.height,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    @required this.footer,
    @required this.color,
    @required this.title,
    @required this.child,
    this.scrollController,
    this.withExpanded,
    this.height,
  });

  final Widget footer;
  final Color color;
  final String title;
  final Widget child;
  final ScrollController scrollController;
  final bool withExpanded;
  final double height;

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03, top: size.height * 0.02),
      padding: this.footer != null ? EdgeInsets.only(top: size.height * 0.02) : EdgeInsets.symmetric(vertical: size.height * 0.02),
      decoration: BoxDecoration(
        color: this.color != null ? this.color : appTheme.accentColor.withOpacity(0.75),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        boxShadow: [
          new BoxShadow(
            color: appTheme.accentColor.withOpacity(0.5),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      // child: _Content(title: title, child: child, footer: footer),
      child: _ContentBuilder(
        title: title,
        child: child,
        footer: footer,
        scrollController: scrollController,
        withExpanded: withExpanded,
        height: this.height,
      ),
    );
  }
}

class _ContentBuilder extends StatelessWidget {
  const _ContentBuilder({
    @required this.title,
    @required this.child,
    @required this.footer,
    this.scrollController,
    this.withExpanded = false,
    this.height,
  });

  final String title;
  final Widget child;
  final Widget footer;
  final ScrollController scrollController;
  final bool withExpanded;
  final double height;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget body;
    if (withExpanded != null && withExpanded)
      body = Expanded(
        child: _CardBody(scrollController: scrollController, size: size, child: child, footer: footer),
      );
    else
      body = _CardBody(scrollController: scrollController, size: size, child: child, footer: footer);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Container(
          height: this.height,
          child: Flex(
            direction: Axis.vertical,
            children: [
              if (this.title != null)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: size.height * 0.01),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    child: Text(
                      this.title,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.04),
                    ),
                    margin: EdgeInsets.only(bottom: size.height * 0.01),
                  ),
                ),
              body,
            ],
          ),
        );
      },
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    Key key,
    @required this.scrollController,
    @required this.size,
    @required this.child,
    @required this.footer,
  }) : super(key: key);

  final ScrollController scrollController;
  final Size size;
  final Widget child;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: this.scrollController,
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: this.child,
            ),
            this.footer != null
                ? Container(
                    width: double.infinity,
                    child: this.footer,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({@required this.title, @required this.child, @required this.footer});

  final String title;
  final Widget child;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        if (this.title != null)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: size.height * 0.01),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: Text(this.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.04)),
              margin: EdgeInsets.only(bottom: size.height * 0.01),
            ),
          ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: this.child,
        ),
        this.footer != null
            ? Container(
                width: double.infinity,
                child: this.footer,
              )
            : Container()
      ],
    );
  }
}
