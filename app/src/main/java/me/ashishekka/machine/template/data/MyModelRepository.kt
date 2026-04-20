
package me.ashishekka.machine.template.data

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import me.ashishekka.machine.template.data.local.database.MyModel
import me.ashishekka.machine.template.data.local.database.MyModelDao
import javax.inject.Inject

interface MyModelRepository {
    val myModels: Flow<List<String>>

    suspend fun add(name: String)
}

class DefaultMyModelRepository @Inject constructor(
    private val myModelDao: MyModelDao
) : MyModelRepository {

    override val myModels: Flow<List<String>> =
        myModelDao.getMyModels().map { items -> items.map { it.name } }

    override suspend fun add(name: String) {
        myModelDao.insertMyModel(MyModel(name = name))
    }
}
