# MDiscover - Movie Discovery App

Welcome to **MDiscover**, a premium, Netflix-themed movie discovery application built using Flutter. This app allows users to explore trending movies, search for their favorite titles, view upcoming releases, manage their download watchlist, and configure app settings.

---

## 🚀 Setup & Installation

Follow these steps to get the project running locally:

### 1. Prerequisites
Make sure you have the following installed on your machine:
* **Flutter SDK** (Channel stable, version `3.9.2` or later recommended)
* **Android SDK** (for running on Android devices/emulators)
* **Xcode & CocoaPods** (for running on iOS devices/simulators on macOS)

### 2. Get the Code & Dependencies
Clone the repository, navigate into the project directory, and run the following command to download all dependencies:

```bash
flutter pub get
```

---

## 🔑 Configuring the TMDB API Key

This application relies on the **TheMovieDB (TMDB) v3 API** for fetching movie content. The API key is securely loaded using Dart's environmental defines and is not committed to the source code.

To run the application, retrieve a v3 API key from your [TMDB Account Settings](https://www.themoviedb.org/) and pass it using the `--dart-define` flag:

```bash
flutter run --dart-define=TMDB_API_KEY=YOUR_TMDB_API_KEY
```

### IDE Setup

#### VS Code (`.vscode/launch.json`)
Add the API key to your launch configurations as a `toolArgs` option:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "mdiscover (Development)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "toolArgs": [
        "--dart-define",
        "TMDB_API_KEY=YOUR_TMDB_API_KEY"
      ]
    }
  ]
}
```

#### Android Studio / IntelliJ
1. Go to **Run > Edit Configurations**.
2. Under the **Additional run args** field, input:
   ```bash
   --dart-define=TMDB_API_KEY=YOUR_TMDB_API_KEY
   ```

---

## 📦 Packages Used

The project uses a modern and robust stack of packages to handle state management, networking, responsiveness, and visual cues:

* **`flutter_bloc`** - Handles state management using the BLoC and Cubit patterns.
* **`get_it`** - Lightweight service locator for dependency injection.
* **`dio`** - A powerful HTTP client used to fetch movie data from TMDB.
* **`flutter_screenutil`** - Adapts screen dimensions and scales UI elements/fonts responsively across different resolutions.
* **`cached_network_image`** - Caches TMDB poster and backdrop images locally to improve load performance and user experience.
* **`shimmer`** - Provides beautiful placeholder shimmer loaders during API request transitions.
* **`flutter_svg`** - Renders vector icons and design assets.
* **`google_fonts`** - Loads custom typography dynamically.
* **`url_launcher`** - Opens external links for Terms & Conditions or sharing.

---

## 🏗️ Architecture Overview

The app is built following a **Clean / Feature-First Architecture** structure to ensure scalability, ease of debugging, and testability.

The codebase is organized into two primary folders under `lib`:

1. **`core`**: Contains app-wide constants, shared widgets, style guides, and initialization configurations:
   * `constants`: Houses centralized styles, typography, color themes, and API configurations.
   * `di`: The dependency injection setup (`injection_container.dart`) where repositories, data sources, and blocs are registered.
   * `widgets`: Reusable, generic UI components like shimmer skeleton loaders and image containers.

2. **`features`**: Divided by logical feature domains (e.g. `dashboard`, `search`, `coming_soon`, `downloads_watchlist`, `profile`, `onboarding`).
   * Each feature contains its own logical layers:
     * **Data**: Handles raw network/local operations (models, API data sources, repository implementations).
     * **Domain**: Business rules and entities (independent of databases or UI layers).
     * **Presentation**: Views/Screens, sub-widgets, and state containers (Blocs/Cubits).

---

## 🔌 API-Driven vs. Mock Features

To balance dynamic content and offline accessibility, features are split between live API integrations and static local mocks:

### API-Driven Features
* **Dashboard / Home**: Feeds on live TMDB lists including Weekly Trending, Popular, Now Playing, and Top Rated movies.
* **Search Screen**: Realtime, debounced query searching on TMDB's movie index.
* **Coming Soon Screen**: Upcoming movie schedules loaded directly from the TMDB API.
* **Details Screen**: Comprehensive info cards, overviews, ratings, and backdrops fetched on-demand per movie ID.

### Mock-Driven / Offline Features
* **Onboarding Screen**: Static user profile selector interface.
* **Watchlist & Downloads**: Renders an offline download list using predefined sample movie models.
* **More Screen**: The profile settings menu showcasing profile switcher avatars, share options (copy link, social options), and settings list items ("My List", "App Settings", "Account", etc.).
