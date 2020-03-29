// Copyright (C) 2020 - present Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parent/l10n/app_localizations.dart';
import 'package:flutter_parent/network/utils/api_prefs.dart';
import 'package:flutter_parent/router/panda_router.dart';
import 'package:flutter_parent/utils/common_widgets/dialog_with_navigator_key.dart';
import 'package:flutter_parent/utils/common_widgets/respawn.dart';
import 'package:flutter_parent/utils/design/parent_colors.dart';
import 'package:flutter_parent/utils/design/parent_theme.dart';
import 'package:flutter_parent/utils/quick_nav.dart';
import 'package:flutter_parent/utils/service_locator.dart';

class MasqueradeUI extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navKey;

  const MasqueradeUI({Key key, this.child, this.navKey}) : super(key: key);

  @override
  MasqueradeUIState createState() => MasqueradeUIState();

  static MasqueradeUIState of(BuildContext context) {
    return context.findAncestorStateOfType<MasqueradeUIState>();
  }

  static void showMasqueradeCancelDialog(GlobalKey<NavigatorState> navKey) {
    showDialogWithNavigatorKey(
      navKey: navKey,
      builder: (context) {
        AppLocalizations l10n = L10n(context);
        bool logout = ApiPrefs.getCurrentLogin()?.isMasqueradingFromQRCode == true;
        String userName = ApiPrefs.getUser()?.name;
        return AlertDialog(
          title: Text(L10n(context).stopActAsUser),
          content: Text(logout ? l10n.endMasqueradeLogoutMessage(userName) : l10n.endMasqueradeMessage(userName)),
          actions: [
            FlatButton(
              child: new Text(L10n(context).cancel),
              onPressed: () => navKey.currentState.pop(false),
            ),
            FlatButton(
              child: new Text(L10n(context).ok),
              onPressed: () async {
                if (logout) {
                  ParentTheme.of(context).studentIndex = 0;
                  await ApiPrefs.performLogout();
                  MasqueradeUI.of(context).refresh();
                  locator<QuickNav>().pushRouteAndClearStack(context, PandaRouter.login());
                } else {
                  ApiPrefs.updateCurrentLogin((b) => b
                    ..masqueradeUser = null
                    ..masqueradeDomain = null);
                  Respawn.of(context).restart();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class MasqueradeUIState extends State<MasqueradeUI> {
  bool _enabled = false;
  String _userName;

  GlobalKey _childKey = GlobalKey();

  bool get enabled => _enabled;

  @override
  void initState() {
    refresh(shouldSetState: false);
    super.initState();
  }

  void refresh({bool shouldSetState = true}) {
    bool wasEnabled = _enabled;
    if (ApiPrefs.isLoggedIn() && ApiPrefs.isMasquerading()) {
      _enabled = true;
      _userName = ApiPrefs.getUser().name;
    } else {
      _enabled = false;
    }
    if (wasEnabled != _enabled && shouldSetState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = KeyedSubtree(key: _childKey, child: widget.child);
    if (!_enabled) return child;
    return SafeArea(
      child: Material(
        child: Container(
          key: Key('masquerade-ui-container'),
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: ParentColors.masquerade, width: 3.0),
          ),
          child: Column(
            children: [
              Container(
                color: ParentColors.masquerade,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        L10n(context).actingAsUser(_userName),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        semanticLabel: L10n(context).stopActAsUser,
                      ),
                      onPressed: () => MasqueradeUI.showMasqueradeCancelDialog(widget.navKey),
                    ),
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
