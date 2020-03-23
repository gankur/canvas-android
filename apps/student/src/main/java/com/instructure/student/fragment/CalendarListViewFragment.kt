/*
 * Copyright (C) 2016 - present Instructure, Inc.
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, version 3 of the License.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

package com.instructure.student.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.instructure.canvasapi2.utils.pageview.PageView
import com.instructure.interactions.router.Route
import com.instructure.pandautils.utils.TelemetryUtils
import com.instructure.student.R
import com.instructure.student.events.CalendarEventCreated
import com.instructure.student.events.CalendarEventDestroyed
import kotlinx.android.extensions.CacheImplementation
import kotlinx.android.extensions.ContainerOptions
import kotlinx.android.synthetic.main.fragment_calendar_listview.*
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

@PageView(url = "calendar")
@ContainerOptions(cache = CacheImplementation.NO_CACHE)
class CalendarListViewFragment : ParentFragment() {

    override fun title() = getString(R.string.calendar)

    override fun applyTheme() {
        toolbar?.let { navigation?.attachNavigationDrawer(this, it) }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        TelemetryUtils.setInteractionName(this::class.java.simpleName)
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_calendar_listview, container, false)
    }

    @Suppress("unused")
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onCalendarEventCreated(event: CalendarEventCreated) {
        event.once(javaClass.simpleName) {
            // TODO
        }
    }

    @Suppress("unused")
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onCalendarEventDestroyed(event: CalendarEventDestroyed) {
        event.once(javaClass.simpleName) {
            // TODO
        }
    }

    override fun onStart() {
        super.onStart()
        EventBus.getDefault().register(this)
    }

    override fun onStop() {
        super.onStop()
        EventBus.getDefault().unregister(this)
    }

    private fun eventCreation() {
        // TODO
        //RouteMatcher.route(requireContext(), CreateCalendarEventFragment.makeRoute(time ?: 0L))
    }

    companion object {
        @JvmStatic
        fun newInstance(route: Route) = if (validRoute(route)) CalendarListViewFragment() else null

        private fun validRoute(route: Route) = route.primaryClass == CalendarListViewFragment::class.java

        fun makeRoute() = Route(CalendarListViewFragment::class.java, null)
    }
}
