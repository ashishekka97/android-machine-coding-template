package me.ashishekka.machine.template.data.remote

import androidx.paging.PagingSource
import androidx.paging.PagingState

abstract class BasePagingSource<Key : Any, Value : Any> : PagingSource<Key, Value>() {

    abstract suspend fun fetchData(params: LoadParams<Key>): LoadResult<Key, Value>

    override fun getRefreshKey(state: PagingState<Key, Value>): Key? {
        return state.anchorPosition?.let { anchorPosition ->
            val anchorPage = state.closestPageToPosition(anchorPosition)
            anchorPage?.prevKey ?: anchorPage?.nextKey
        }
    }

    override suspend fun load(params: LoadParams<Key>): LoadResult<Key, Value> {
        return try {
            fetchData(params)
        } catch (e: Exception) {
            LoadResult.Error(e)
        }
    }
}

