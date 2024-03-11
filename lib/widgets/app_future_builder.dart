import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/misc/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppFutureBuilder<T> extends StatefulWidget {
  Future<T> future;
  final Widget Function(T data) onDataWidget;
  VoidCallback? onRefreshClicked;
  final Widget Function(dynamic error)? onErrorWidget;
  final Widget? loadingWidget;
  Color loadingColor;
  final void Function(dynamic error)? onError;
  bool asStream;
  AppFutureBuilder({
    super.key,
    required this.future,
    required this.onDataWidget,
    this.onErrorWidget,
    this.loadingColor = AppColors.primary,
    this.onRefreshClicked,
    this.onError,
    this.asStream = false,
    this.loadingWidget,
  });

  @override
  _AppFutureBuilderState<T> createState() => _AppFutureBuilderState<T>();
}

class _AppFutureBuilderState<T> extends State<AppFutureBuilder<T>> {
  late Future _future; // ! added 'late'
  late Stream<T> _stream; // ! added 'late'
  @override
  void initState() {
    super.initState();
    _future = widget.future;
  }

  _buildStream() {
    return StreamBuilder<T>(
      stream: Stream.fromFuture(widget.future),
      builder: (context, AsyncSnapshot<T> snapdata) {
        return _buildResult(snapdata);
      },
    );
  }

  Widget _buildResult(AsyncSnapshot<T> snapdata) {
    switch (snapdata.connectionState) {
      case ConnectionState.active:
      case ConnectionState.waiting:
        return widget.loadingWidget ??
            Center(
              child: CircularProgressIndicator(),
            );
      case ConnectionState.done:
        if (snapdata.hasData) {
          return widget.onDataWidget(snapdata.data!); // ! added "!" symbol
        }
        if (snapdata.hasError) {
          if (widget.onError != null) {
            widget.onError!(snapdata.error);
          }
          var err;
          try {
            err = extractMessage(snapdata.error);
          } catch (e) {
            err = snapdata.error.toString();
          }
          return widget.onErrorWidget != null
              ? widget.onErrorWidget!(err)
              : Container(
                  child: Text("$err"),
                );
        }
        return Container();
      case ConnectionState.none:
        return Text('Check Your Internet Connection');
      default:
        return Text('chect');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asStream) {
      return _buildStream();
    }
    if (widget.future == null) {
      debugPrint("future is null");
    }
    return FutureBuilder<T>(
        future: widget.future,
        // ignore: missing_return
        builder: (ctx, snapdata) {
          return _buildResult(snapdata);
        });
  }
}
