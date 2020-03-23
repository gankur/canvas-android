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

import android.content.Context
import com.instructure.canvasapi2.utils.pageview.PageView
import com.instructure.interactions.router.Route
import com.instructure.student.util.AppManager
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.android.extensions.CacheImplementation
import kotlinx.android.extensions.ContainerOptions

@PageView(url = "calendar")
@ContainerOptions(cache = CacheImplementation.NO_CACHE)
class FlutterCalendarFragment : FlutterFragment() {

    override fun provideFlutterEngine(context: Context): FlutterEngine? = AppManager.flutterEngine

    // Use texture mode instead of surface mode so the FlutterView doesn't render over things like the nav drawer
    override fun getRenderMode() = FlutterView.RenderMode.texture

    companion object {
        @JvmStatic
        fun newInstance(route: Route) = if (validRoute(route)) FlutterCalendarFragment() else null

        private fun validRoute(route: Route) = route.primaryClass == FlutterCalendarFragment::class.java

        fun makeRoute() = Route(FlutterCalendarFragment::class.java, null)
    }
}
