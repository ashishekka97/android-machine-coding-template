# Project Architecture & Structure

This document provides a quick overview of the architecture and directory structure of this starter template. Understanding this layout will help you navigate and implement features rapidly during an interview.

## 🏗 Architecture: MVVM + Cleanish Layout

The project follows the **Model-View-ViewModel (MVVM)** pattern with a focus on **Unidirectional Data Flow (UDF)**.

- **UI Layer (Compose):** Composable functions observe `StateFlow` from ViewModels.
- **ViewModel Layer:** Manages UI state and communicates with Repositories.
- **Data Layer:** Handles data sourcing from Network (Retrofit) or Local DB (Room).

---

## 📂 Directory Structure

### `ui/`
- **`theme/`**: Material 3 color schemes, typography, and shapes.
- **`components/`**: Reusable UI atoms (Custom SearchBars, Loading Indicators, Paging Loading items).
- **`mymodel/`**: (Placeholder) Feature-specific UI. Rename this to your actual feature (e.g., `movies/`).
    - `xxxScreen.kt`: The main Composable for the screen.
    - `xxxViewModel.kt`: Handles logic and state for that screen.

### `data/`
- **`remote/`**: Retrofit interfaces, API response models, and `BasePagingSource`.
- **`local/`**: Room entities, DAOs, and Database configuration.
- **`repository/`**: Repository implementations (e.g., `DefaultProductRepository`).

### `di/`
- **`NetworkModule.kt`**: Provides Retrofit, OkHttp, and Json serializers.
- **`DataModule.kt`**: Provides Repository bindings.
- **`DatabaseModule.kt`**: Provides Room Database instances.

### `util/`
- **`Resource.kt`**: Sealed class for `Loading/Success/Error` states.
- **`ConnectivityObserver.kt`**: Flow-based network status listener.
- **`FlowUtils.kt`**: Debounce and other Flow operators.

---

## 🚀 Key Patterns to Use

### 1. Handling State
In your ViewModel, use `MutableStateFlow` with a UI State sealed class:
```kotlin
private val _uiState = MutableStateFlow<MyUiState>(MyUiState.Loading)
val uiState = _uiState.asStateFlow()
```

### 2. Debounced Search
When implementing search, use the built-in utility:
```kotlin
searchQuery
    .debounce(500L)
    .onEach { query -> _uiState.value = MyUiState.Loading }
    .collectLatest { query -> 
        val result = repository.search(query)
        _uiState.value = MyUiState.Success(result)
    }
```

### 3. Paging 3
Extend `BasePagingSource` to handle pagination with minimal boilerplate. Use `PagingLoadingItem` and `PagingErrorItem` in your `LazyColumn` for a polished look.
