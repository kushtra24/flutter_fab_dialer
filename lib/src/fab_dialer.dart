part of flutter_fab_dialer;

class FabDialer extends StatefulWidget {
  // AnimationStyle is an optional parameter to avoid breaking changes
  FabDialer({
      @required this.fabMiniMenuItemList,
      this.fabColor = Colors.grey,
      this.fabIcon,
      this.elevation,
      this.closeFabIcon,
      this.fabAnimationStyle = AnimationStyle.defaultAnimation
});

  final List<FabMiniMenuItem> fabMiniMenuItemList;
  final Color fabColor;
  final Icon fabIcon;
  final AnimationStyle fabAnimationStyle;
  final double elevation;
  final Icon closeFabIcon;

  @override
  FabDialerState createState() => new FabDialerState(
      fabMiniMenuItemList, fabColor, fabIcon, elevation, fabAnimationStyle, closeFabIcon);
}

class FabDialerState extends State<FabDialer> with TickerProviderStateMixin {

  FabDialerState(this._fabMiniMenuItemList, this._fabColor, this._fabIcon, this.elevation,
      this._fabAnimationStyle, this.closeFabIcon);

  int _angle = 90;
  bool _isRotated = true;
  final List<FabMiniMenuItem> _fabMiniMenuItemList;
  final Color _fabColor;
  final Icon _fabIcon;
  final double elevation;
  final Icon closeFabIcon;
  final AnimationStyle _fabAnimationStyle;
  List<FabMenuMiniItemWidget> _fabMenuItems;

  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _controller.reverse();

    setFabMenu(this._fabMiniMenuItemList);
    super.initState();
  }

  void setFabMenu(List<FabMiniMenuItem> fabMenuList) {
    List<FabMenuMiniItemWidget> fabMenuItems = new List();
    for (int i = 0; i < _fabMiniMenuItemList.length; i++) {
      fabMenuItems.add(new FabMenuMiniItemWidget(
        tooltip: _fabMiniMenuItemList[i].tooltip,
        text: _fabMiniMenuItemList[i].text,
        elevation: _fabMiniMenuItemList[i].elevation,
        icon: _fabMiniMenuItemList[i].icon,
        image: _fabMiniMenuItemList[i].image,
        index: i,
        onPressed: _fabMiniMenuItemList[i].onPressed,
        textColor: _fabMiniMenuItemList[i].textColor,
        fabColor: _fabMiniMenuItemList[i].fabColor,
        chipColor: _fabMiniMenuItemList[i].chipColor,
        controller: _controller,
        animationStyle: _fabAnimationStyle,
        itemCount: _fabMiniMenuItemList.length,
        // Send item count to each item to help animation calc
        hideWidget:
            _fabMiniMenuItemList[i].hideOnClick == false ? null : _rotate,
      ));
    }

    this._fabMenuItems = fabMenuItems;
  }

  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Icon closeIcon = closeFabIcon == null
        ? Icon(Icons.close)
        : closeFabIcon;
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _fabMenuItems,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext _, Widget child) {
                    return FloatingActionButton(
                      elevation: elevation,
                        child: Transform(
                          transform: Matrix4.rotationZ(
                              (2 * Math.pi) * _controller.value),
                          alignment: Alignment.center,
                          child: _controller.value >= 0.5
                              ? closeIcon
                              : _fabIcon,
                        ),
                        backgroundColor: _fabColor,
                        onPressed: _rotate);
                  },
                )
              ],
            ),
          ],
        ));
  }
}
