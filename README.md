# Android Machine Coding Interview Starter

A high-performance, zero-boilerplate Android template designed for 90-120 minute machine coding interview rounds.

## 🚀 Speed-Run Flow (Interview Day)

1. **Click "Use this template"** on GitHub to create a private repo.
2. **Clone** your new repo locally.
3. **Run the customizer** to set your package and model:
   ```bash
   chmod +x customizer.sh
   # Usage: ./customizer.sh <package.name> <DataModelName> [ApplicationName]
   ./customizer.sh com.example.pokedex Pokemon Pokedex
   ```
   *Note: Ensure the package name contains at least one dot (e.g., `com.project` instead of just `project`).*
4. **Open in Android Studio** and start coding!

## 🛠 Tech Stack
- **UI:** Jetpack Compose (Material 3)
- **Arch:** MVVM + Unidirectional Data Flow (StateFlow)
- **DI:** Hilt
- **Network:** Retrofit + OkHttp + Kotlinx Serialization
- **Paging:** Paging 3 (BasePagingSource + UI components included)
- **Image Loading:** Coil
- **Persistence:** Room
- **Logging:** Timber
- **Testing:** JUnit4 + MockK + Turbine + Coroutines Test

## 📦 Key Utilities Included
- **ConnectivityObserver:** Pre-baked Flow-based internet monitoring.
- **Search Debounce:** Ready-to-use search logic in `FlowUtils.kt`.
- **Resource Wrapper:** `Success`, `Error`, `Loading` sealed class.
- **Auth Interceptor:** Placeholder for API Keys in `NetworkModule`.
- **MainDispatcherRule:** Instant coroutine testing setup.

## 📝 License
This is a starter template. Feel free to use it for any interview assignments.
