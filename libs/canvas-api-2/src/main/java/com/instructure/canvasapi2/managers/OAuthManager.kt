/*
 * Copyright (C) 2017 - present Instructure, Inc.
 *
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 *
 */
package com.instructure.canvasapi2.managers

import com.instructure.canvasapi2.StatusCallback
import com.instructure.canvasapi2.apis.OAuthAPI
import com.instructure.canvasapi2.builders.RestBuilder
import com.instructure.canvasapi2.builders.RestParams
import com.instructure.canvasapi2.models.AuthenticatedSession
import com.instructure.canvasapi2.models.OAuthToken
import com.instructure.canvasapi2.utils.Logger

object OAuthManager {

    @JvmStatic
    fun deleteToken() {
        val callback = object : StatusCallback<Void>() {}
        val adapter = RestBuilder(callback)
        val params = RestParams(isForceReadFromNetwork = true)
        OAuthAPI.deleteToken(adapter, params, callback)
    }

    @JvmStatic
    fun getToken(clientID: String, clientSecret: String, oAuthRequest: String, callback: StatusCallback<OAuthToken>) {
        val adapter = RestBuilder(callback)
        val params = RestParams(isForceReadFromNetwork = true)
        OAuthAPI.getToken(adapter, params, clientID, clientSecret, oAuthRequest, callback)
    }

    @JvmStatic
    fun getAuthenticatedSession(targetUrl: String, callback: StatusCallback<AuthenticatedSession>) {
        val adapter = RestBuilder(callback)
        val params = RestParams(isForceReadFromNetwork = true)
        Logger.d("targetURL to be authed: $targetUrl")
        OAuthAPI.getAuthenticatedSession(targetUrl, params, adapter, callback)
    }

    @JvmStatic
    fun getAuthenticatedSessionSynchronous(targetUrl: String): String? {
        val adapter = RestBuilder()
        val params = RestParams(isForceReadFromNetwork = true)
        Logger.d("targetURL to be authed: $targetUrl")
        return OAuthAPI.getAuthenticatedSessionSynchronous(targetUrl, params, adapter)
    }

}