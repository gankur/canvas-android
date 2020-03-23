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

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_student_embed/network/utils/api_prefs.dart';
import 'package:flutter_student_embed/screens/calendar/calendar_widget/calendar_widget.dart';
import 'package:flutter_student_embed/screens/calendar/planner_fetcher.dart';

import 'calendar_day_planner.dart';
import 'calendar_widget/calendar_filter_screen/calendar_filter_list_screen.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  PlannerFetcher _fetcher;

  @override
  void initState() {
    var user = ApiPrefs.getUser();
    _fetcher = PlannerFetcher(userId: ApiPrefs.getUser().id, userDomain: ApiPrefs.getDomain());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CalendarWidget(
        fetcher: _fetcher,
        onFilterTap: () async {
          Set<String> currentContexts = await _fetcher.getContexts();
          Set<String> updatedContexts = await showModalBottomSheet(
            context: context,
            builder: (context) => CalendarFilterListScreen(currentContexts),
          );
          // Check if the list changed or not
          if (!SetEquality().equals(currentContexts, updatedContexts)) {
            _fetcher.setContexts(updatedContexts);
          }
        },
        dayBuilder: (BuildContext context, DateTime day) {
          return CalendarDayPlanner(day);
        },
      ),
    );
  }
}
