import "package:flutter/material.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/theme/colors.dart";

class NoteManipulationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool _isManipulateNoteButtonAble;
  final bool _isConcludeNoteButtonAble;
  final bool _isDeleteNoteButtonAble;
  final VoidCallback _onNavigationIconButtonTap;
  final VoidCallback _onConcludeNoteIconButtonTap;
  final VoidCallback _onEditNoteIconButtonTap;
  final VoidCallback _onDeleteNoteIconButtonTap;

  NoteManipulationAppBar(
    this._isManipulateNoteButtonAble,
    this._isConcludeNoteButtonAble,
    this._isDeleteNoteButtonAble,
    this._onNavigationIconButtonTap,
    this._onConcludeNoteIconButtonTap,
    this._onEditNoteIconButtonTap,
    this._onDeleteNoteIconButtonTap, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PRIMARY_500,
      title: SizedBox.shrink(),
      toolbarHeight: kToolbarHeight,
      actions: [
        if (_isConcludeNoteButtonAble)
          IconButton(
            onPressed: _onConcludeNoteIconButtonTap,
            icon: const Icon(Icons.check),
            tooltip: CONCLUDE_NOTE_BUTTON_TOOLTIP,
            color: NEUTRALS_100,
          ),
        if (_isManipulateNoteButtonAble)
          IconButton(
            onPressed: _onEditNoteIconButtonTap,
            icon: const Icon(Icons.create),
            tooltip: EDIT_NOTE_TOOLTIP,
            color: NEUTRALS_100,
          ),
        if (_isDeleteNoteButtonAble)
          IconButton(
            onPressed: _onDeleteNoteIconButtonTap,
            icon: const Icon(Icons.delete),
            tooltip: DELETE_NOTE_TOOLTIP,
            color: NEUTRALS_100,
          ),
      ],
      leading: IconButton(
        onPressed: _onNavigationIconButtonTap,
        icon: const Icon(Icons.arrow_back),
        tooltip: BACK_BUTTON_TOOLTIP,
        color: NEUTRALS_100,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(8.0),
        child: SizedBox(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
