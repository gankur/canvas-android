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
 */

package com.instructure.student.flutterChannels

import android.content.Context
import android.util.Log
import com.google.gson.Gson
import com.instructure.canvasapi2.utils.ApiPrefs
import com.instructure.canvasapi2.utils.isValid
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

object FlutterComm {
    private const val CHANNEL = "com.instructure.student/flutterComm"
    private const val METHOD_REQUEST_LOGIN_DATA = "requestLoginData"
    private const val METHOD_UPDATE_LOGIN_DATA = "updateLoginData"

    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    fun init(flutterEngine: FlutterEngine, context: Context) {
        this.context = context
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(::handleCall)
    }

    private fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_REQUEST_LOGIN_DATA -> {
                result.success(null) // Send empty response
                sendUpdatedLogin()
            }
            else -> result.notImplemented()
        }
    }

    private fun sendUpdatedLogin() {
        // Send null if not logged in
        if (!ApiPrefs.getValidToken().isValid()) {
            channel.invokeMethod(METHOD_UPDATE_LOGIN_DATA, null)
            return
        }

        val userJson = JSONObject(Gson().toJson(ApiPrefs.user)).apply {
            // Convert ID from Long to String
            put("id", getLong("id").toString())
        }
        val loginJson = JSONObject().apply {
            put("uuid", "")
            put("domain", ApiPrefs.fullDomain)
            put("accessToken", ApiPrefs.getValidToken())
            put("refreshToken", ApiPrefs.refreshToken)
            put("user", userJson)
        }
        channel.invokeMethod(METHOD_UPDATE_LOGIN_DATA, loginJson.toString())
    }
}
