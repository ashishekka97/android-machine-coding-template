
package me.ashishekka.machine.template.testdi

import dagger.Binds
import dagger.Module
import dagger.hilt.components.SingletonComponent
import dagger.hilt.testing.TestInstallIn
import me.ashishekka.machine.template.data.MyModelRepository
import me.ashishekka.machine.template.data.di.DataModule
import me.ashishekka.machine.template.data.di.FakeMyModelRepository

@Module
@TestInstallIn(
    components = [SingletonComponent::class],
    replaces = [DataModule::class]
)
interface FakeDataModule {

    @Binds
    abstract fun bindRepository(
        fakeRepository: FakeMyModelRepository
    ): MyModelRepository
}
