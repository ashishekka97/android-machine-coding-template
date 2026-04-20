package me.ashishekka.machine.template.util

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.flow.transformLatest
import kotlinx.coroutines.delay

/**
 * Utility to debounce search queries.
 * Usage:
 * searchQueryStateFlow
 *   .debounce(500L)
 *   .collectLatest { query -> fetchData(query) }
 */
fun <T> Flow<T>.debounce(waitMs: Long): Flow<T> = transformLatest { value ->
    delay(waitMs)
    emit(value)
}
