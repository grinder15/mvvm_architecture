import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'viewmodel.dart';

@immutable
class ViewModelProvider<VM extends ViewModel> extends StatefulWidget {
  final Function(VM) onViewModelReady;
  final Widget Function(BuildContext, VM) builder;
  final bool reuseExisting;

  ViewModelProvider({
    @required this.builder,
    this.onViewModelReady,
    this.reuseExisting = false,
  });

  @override
  _ViewModelProviderState<VM> createState() => _ViewModelProviderState<VM>();
}

class _ViewModelProviderState<VM extends ViewModel>
    extends State<ViewModelProvider<VM>> {
  VM _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<VM>();
    if (widget.onViewModelReady != null) {
      widget.onViewModelReady(_viewModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reuseExisting) {
      return Provider.value(
        value: _viewModel,
        child: widget.builder(context, _viewModel),
      );
    }

    return Provider(
      create: (context) => _viewModel,
      dispose: (context, viewModel) {
        locator.resetLazySingleton<VM>(
            instance: viewModel, disposingFunction: (vm) => vm.dispose());
      },
      child: widget.builder(context, _viewModel),
    );
  }
}
