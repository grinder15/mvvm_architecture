import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// A widget that provides a value passed through a provider as a parameter of the build function.
abstract class ProviderWidget<T> extends Widget {
  final bool listen;

  ProviderWidget({Key key, this.listen = true}) : super(key: key);

  @protected
  Widget build(BuildContext context, T value);

  @override
  _DataProviderElement<T> createElement() => _DataProviderElement<T>(this);
}

class _DataProviderElement<T> extends ComponentElement {
  _DataProviderElement(ProviderWidget widget) : super(widget);

  @override
  ProviderWidget get widget => super.widget;

  @override
  Widget build() =>
      widget.build(this, Provider.of<T>(this, listen: widget.listen));

  @override
  void update(ProviderWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild();
  }
}

class ProviderBuilder<T> extends StatelessWidget {
  final Function(BuildContext, T) builder;

  ProviderBuilder({@required this.builder}) : assert(builder != null);

  @override
  Widget build(BuildContext context) =>
      builder(context, Provider.of<T>(context));
}
