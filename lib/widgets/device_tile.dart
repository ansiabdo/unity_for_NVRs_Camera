/*
 * This file is a part of Bluecherry Client (https://github.com/bluecherrydvr/unity).
 *
 * Copyright 2022 Bluecherry, LLC
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 3 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:status_bar_control/status_bar_control.dart';

import 'package:bluecherry_client/providers/mobile_view_provider.dart';
import 'package:bluecherry_client/models/device.dart';
import 'package:bluecherry_client/widgets/misc.dart';
import 'package:bluecherry_client/utils/methods.dart';

class DeviceTile extends StatefulWidget {
  final Device device;
  final int tab;
  final int index;

  final double width;
  final double height;

  const DeviceTile({
    Key? key,
    required this.device,
    required this.tab,
    required this.index,
    this.width = 640.0,
    this.height = 360.0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeviceTileState();
}

class DeviceTileState extends State<DeviceTile> {
  FijkPlayer? ijkPlayer;
  FijkState? ijkState;

  @override
  void initState() {
    super.initState();
    ijkPlayer = MobileViewProvider.instance.players[widget.device];
    if (isDesktop) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          MobileViewProvider.instance.hoverStates[widget.tab]![widget.index] =
              false;
        });
      });
    }
    if (isMobile) {
      ijkPlayer?.addListener(ijkPlayerListener);
    }
  }

  @override
  void dispose() {
    if (isMobile) {
      ijkPlayer?.removeListener(ijkPlayerListener);
    }
    super.dispose();
  }

  void ijkPlayerListener() {
    if (ijkPlayer?.state != ijkState) {
      ijkState = ijkPlayer?.state;
      setState(() {});
    }
  }

  bool get hover =>
      MobileViewProvider.instance.hoverStates[widget.tab]![widget.index];
  set hover(bool value) =>
      MobileViewProvider.instance.hoverStates[widget.tab]![widget.index] =
          value;

  Widget get ijkView {
    return StatefulBuilder(
      builder: (context, _) {
        ijkPlayer = MobileViewProvider.instance.players[widget.device];
        debugPrint('${widget.device} ${ijkPlayer?.dataSource.toString()}');
        return FijkView(
          player: ijkPlayer!,
          color: Colors.black,
          fit: FijkFit.fill,
          panelBuilder: (player, _, ___, ____, _____) => Material(
            color: Colors.transparent,
            child: player.value.exception.message != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning,
                          color: Colors.white70,
                          size: 32.0,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          player.value.exception.message!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : [
                    FijkState.idle,
                    FijkState.asyncPreparing,
                  ].contains(player.state)
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 4.4,
                        ),
                      )
                    : hover
                        ? TweenAnimationBuilder(
                            tween: Tween<double>(
                              begin: 0.0,
                              end: hover ? 1.0 : 0.0,
                            ),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, value, child) => Center(
                              child: Opacity(
                                opacity: value as double,
                                child: IconButton(
                                  splashRadius: 20.0,
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DeviceFullscreenViewer(
                                          device: widget.device,
                                          ijkPlayer: ijkPlayer,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                    size: 32.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetectorWithReducedDoubleTapTime(
      onTap: () {
        setState(() {
          hover = !hover;
        });
      },
      // Fullscreen on double-tap.
      onDoubleTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DeviceFullscreenViewer(
            device: widget.device,
            ijkPlayer: ijkPlayer,
          ),
        ),
      ),
      child: ClipRect(
        child: Stack(
          children: [
            ijkPlayer == null
                ? Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : ijkView,
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedSlide(
                offset: Offset(0, hover ? 0.0 : 1.0),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  height: 48.0,
                  alignment: Alignment.centerRight,
                  color: Colors.black26,
                  child: Row(
                    children: [
                      const SizedBox(width: 16.0),
                      const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.device.name
                                  .split(' ')
                                  .map((e) =>
                                      e[0].toUpperCase() + e.substring(1))
                                  .join(' '),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                            ),
                            Text(
                              widget.device.uri,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 10.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceFullscreenViewer extends StatefulWidget {
  final Device device;
  final FijkPlayer? ijkPlayer;
  final bool restoreStatusBarStyleOnDispose;
  const DeviceFullscreenViewer({
    Key? key,
    required this.device,
    required this.ijkPlayer,
    this.restoreStatusBarStyleOnDispose = false,
  }) : super(key: key);

  @override
  State<DeviceFullscreenViewer> createState() => _DeviceFullscreenViewerState();
}

class _DeviceFullscreenViewerState extends State<DeviceFullscreenViewer> {
  bool overlay = false;
  FijkState? fijkState;
  FijkFit fit = FijkFit.contain;
  Brightness? brightness;

  @override
  void initState() {
    super.initState();
    widget.ijkPlayer?.addListener(ijkPlayerListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      brightness = Theme.of(context).brightness;
      await StatusBarControl.setHidden(true);
      await StatusBarControl.setStyle(
        getStatusBarStyleFromBrightness(Theme.of(context).brightness),
      );
      DeviceOrientations.instance.set([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });
  }

  @override
  void dispose() async {
    widget.ijkPlayer?.removeListener(ijkPlayerListener);
    if (widget.restoreStatusBarStyleOnDispose && brightness != null) {
      await StatusBarControl.setHidden(false);
      await StatusBarControl.setStyle(
        getStatusBarStyleFromBrightness(brightness!),
      );
      DeviceOrientations.instance.restoreLast();
    }
    super.dispose();
  }

  void ijkPlayerListener() {
    debugPrint(fijkState.toString());
    if (widget.ijkPlayer?.state != fijkState) {
      fijkState = widget.ijkPlayer?.state;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                overlay = !overlay;
              });
            },
            child: InteractiveViewer(
              child: FijkView(
                player: widget.ijkPlayer!,
                color: Colors.black,
                fit: fit,
                panelBuilder: (player, _, ___, ____, _____) => Scaffold(
                  backgroundColor: Colors.transparent,
                  body: player.value.exception.message != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.warning,
                                color: Colors.white70,
                                size: 32.0,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                player.value.exception.message!.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      : [
                          FijkState.idle,
                          FijkState.asyncPreparing,
                        ].contains(player.state)
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 4.4,
                              ),
                            )
                          : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSlide(
              offset: Offset(0, overlay ? 0.0 : -1.0),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AppBar(
                backgroundColor: Colors.black38,
                title: Text(
                  widget.device.name
                      .split(' ')
                      .map((e) => e[0].toUpperCase() + e.substring(1))
                      .join(' '),
                  style: const TextStyle(color: Colors.white70),
                ),
                leading: IconButton(
                  splashRadius: 22.0,
                  onPressed: Navigator.of(context).maybePop,
                  icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                    color: Colors.white.withOpacity(0.87),
                  ),
                ),
                centerTitle: Platform.isIOS,
                actions: [
                  IconButton(
                    splashRadius: 20.0,
                    onPressed: () {
                      setState(() {
                        fit = fit == FijkFit.fill
                            ? FijkFit.contain
                            : FijkFit.fill;
                      });
                    },
                    icon: Icon(
                      Icons.aspect_ratio,
                      color: fit == FijkFit.fill
                          ? Colors.white.withOpacity(0.87)
                          : Colors.white.withOpacity(0.54),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
