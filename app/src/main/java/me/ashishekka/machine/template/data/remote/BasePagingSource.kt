package me.ashishekka.machine.template.data.remote

import androidx.paging.PagingSource
import androidx.paging.PagingState

/**
 * A generic BasePagingSource to speed up implementation during interviews.
 * Replace [Key] with your paging key type (usually Int) and [Value] with your data model.
 */
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

/*
Example Implementation:

class MyPagingSource(private val apiService: ApiService) : BasePagingSource<Int, MyModel>() {
    override suspend fun fetchData(params: LoadParams<Int>): LoadResult<Int, MyModel> {
        val position = params.key ?: 1
        val response = apiService.getItems(page = position, size = params.loadSize)
        return LoadResult.Page(
            data = response,
            prevKey = if (position == 1) null else position - 1,
            nextKey = if (response.isEmpty()) null else position + 1
        )
    }
}
*/
