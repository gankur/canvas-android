/*
 * Copyright (C) 2020 - present Instructure, Inc.
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
package com.instructure.canvasapi2.managers

import com.instructure.canvasapi2.StatusCallback
import com.instructure.canvasapi2.apis.ConferencesApi
import com.instructure.canvasapi2.builders.RestBuilder
import com.instructure.canvasapi2.builders.RestParams
import com.instructure.canvasapi2.models.CanvasContext
import com.instructure.canvasapi2.models.Conference
import com.instructure.canvasapi2.models.ConferenceList
import com.instructure.canvasapi2.utils.DataResult
import com.instructure.canvasapi2.utils.ExhaustiveCallback
import com.instructure.canvasapi2.utils.weave.apiAsync
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async

object ConferenceManager {
    fun getConferencesForContext(
        canvasContext: CanvasContext,
        callback: StatusCallback<List<Conference>>,
        forceNetwork: Boolean
    ) {
        val adapter = RestBuilder(callback)
        val params = RestParams(
            usePerPageQueryParam = true,
            isForceReadFromNetwork = forceNetwork
        )
        val depaginatedCallback = object : ExhaustiveCallback<ConferenceList, Conference>(callback) {
            override fun getNextPage(callback: StatusCallback<ConferenceList>, nextUrl: String, isCached: Boolean) {
                ConferencesApi.getNextPage(nextUrl, adapter, callback, params)
            }

            override fun extractItems(response: ConferenceList): List<Conference> = response.conferences
        }
        ConferencesApi.getConferencesForContext(canvasContext, adapter, depaginatedCallback, params)
    }

    fun getConferencesForContextAsync(canvasContext: CanvasContext, forceNetwork: Boolean) =
        apiAsync<List<Conference>> { getConferencesForContext(canvasContext, it, forceNetwork) }

    // TODO: Remove this once the live conferences endpoint is available
    fun getLiveConferencesAsync(contexts: List<CanvasContext>, forceNetwork: Boolean) = GlobalScope.async {
        val results = contexts.map { getConferencesForContextAsync(it, forceNetwork) }.map { it.await() }
        results.find { it.isFail }?.let { return@async it }
        val conferences = results
            .mapIndexed { index, dataResult ->
                val contextType = when (contexts[index].type) {
                    CanvasContext.Type.GROUP -> "group"
                    CanvasContext.Type.COURSE -> "course"
                    else -> "unknown"
                }
                val contextId = contexts[index].id
                dataResult.dataOrThrow.map { it.copy(contextType = contextType, contextId = contextId) }
            }
            .flatten()
            .filter { it.startedAt != null && it.endedAt == null }
        DataResult.Success(conferences)
    }

    // TODO: Use this instead once the live conferences endpoint is available
    /*fun getLiveConferencesAsync(forceNetwork: Boolean) = apiAsync<List<Conference>> {
        val adapter = RestBuilder(it)
        val params = RestParams(
            usePerPageQueryParam = true,
            isForceReadFromNetwork = forceNetwork
        )
        val depaginatedCallback = object : ExhaustiveCallback<ConferenceList, Conference>(it) {
            override fun getNextPage(callback: StatusCallback<ConferenceList>, nextUrl: String, isCached: Boolean) {
                ConferencesApi.getNextPage(nextUrl, adapter, callback, params)
            }

            override fun extractItems(response: ConferenceList): List<Conference> = response.conferences
        }
        ConferencesApi.getLiveConferences(adapter, depaginatedCallback, params)
    }*/
}
