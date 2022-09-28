// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🌎 Project imports:
import 'package:fluttermatic/app/constants.dart';
import 'package:fluttermatic/components/widgets/buttons/rectangle_button.dart';
import 'package:fluttermatic/components/widgets/ui/round_container.dart';
import 'package:fluttermatic/core/models/projects.dart';
import 'package:fluttermatic/core/notifiers/notifiers/actions/projects.dart';
import 'package:fluttermatic/core/notifiers/out.dart';
import 'package:fluttermatic/meta/views/dialogs/open_project.dart';
import 'package:fluttermatic/meta/views/tabs/sections/projects/dialogs/project_options.dart';
import 'package:fluttermatic/meta/views/tabs/sections/projects/projects.dart';
import 'package:fluttermatic/meta/views/workflows/views/existing.dart';

class ProjectInfoTile extends StatefulWidget {
  final ProjectObject project;

  const ProjectInfoTile({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectInfoTile> createState() => _ProjectInfoTileState();
}

class _ProjectInfoTileState extends State<ProjectInfoTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        ProjectsNotifier projectsNotifier =
            ref.watch(projectsActionStateNotifier.notifier);

        return MouseRegion(
          key: ValueKey<String>(widget.project.path),
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: RoundContainer(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.project.name,
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                    if (_isHovering) ...<Widget>[
                      HSeparators.small(),
                      Tooltip(
                        waitDuration: const Duration(seconds: 1),
                        message: widget.project.pinned ? 'Unpin' : 'Pin',
                        child: RectangleButton(
                          padding: EdgeInsets.zero,
                          hoverColor: Colors.transparent,
                          color: Colors.transparent,
                          onPressed: () {
                            projectsNotifier.updatePinnedStatus(
                                widget.project.path, !widget.project.pinned);
                          },
                          radius: BorderRadius.circular(2),
                          width: 22,
                          height: 22,
                          child: Icon(
                              widget.project.pinned
                                  ? Icons.push_pin_rounded
                                  : Icons.push_pin_outlined,
                              color:
                                  widget.project.pinned ? kYellowColor : null,
                              size: 14),
                        ),
                      ),
                      HSeparators.xSmall(),
                      RectangleButton(
                        padding: EdgeInsets.zero,
                        color: Colors.transparent,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                ProjectOptionsDialog(path: widget.project.path),
                          );
                        },
                        radius: BorderRadius.circular(2),
                        width: 22,
                        height: 22,
                        child: const Icon(Icons.more_vert, size: 14),
                      ),
                    ],
                  ],
                ),
                VSeparators.normal(),
                Expanded(
                  child: Text(
                    widget.project.description ??
                        'No project description found.',
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                if (_isHovering)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Tooltip(
                      waitDuration: const Duration(milliseconds: 500),
                      message: widget.project.path,
                      child: Text(
                        widget.project.path,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                VSeparators.small(),
                Text(
                  'Modified date: ${toMonth(widget.project.modDate.month)} ${widget.project.modDate.day}, ${widget.project.modDate.year}',
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                VSeparators.normal(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RectangleButton(
                        child: const Text('Open Project'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                OpenProjectInEditor(path: widget.project.path),
                          );
                        },
                      ),
                    ),
                    HSeparators.xSmall(),
                    HSeparators.xSmall(),
                    Tooltip(
                      message: 'Workflows',
                      waitDuration: const Duration(seconds: 1),
                      child: RectangleButton(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.zero,
                        child: const Icon(Icons.play_arrow_rounded,
                            color: kGreenColor),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => ShowExistingWorkflows(
                              pubspecPath:
                                  '${widget.project.path}\\pubspec.yaml',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
