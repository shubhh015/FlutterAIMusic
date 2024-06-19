# Flutter AI Music

The Flutter AI Music is a Flutter-based application designed to generate and play AI-generated music tracks. The application uses the `SunoApi` to create music based on user-provided prompts and styles, and integrates with the `audioplayers` package for audio playback.

## Features

-   **Music Generation**: Create unique music tracks by providing a prompt and a music style.
-   **Audio Playback**: Listen to generated tracks directly within the app.
-   **Custom Themes**: Stylish user interface with customizable themes.
-   **Responsive UI**: Adapts to various screen sizes for a seamless user experience.
-   **Settings**: Placeholder for future settings customization.

## Getting Started

### Prerequisites

-   **Flutter**: Make sure you have Flutter installed on your machine. You can download it from the [official Flutter website](https://flutter.dev).
-   **Dart**: Flutter comes with Dart, but ensure it's up-to-date.
-   **API Access**: You need access to the `SunoApi`. Replace the placeholder API key and cookies with your actual credentials.

### Installation

1. **Clone the repository**:

    ```bash
    git clone https://github.com/shubhh015/FlutterAIMusic.git
    cd FlutterAIMusic
    ```

2. **Install dependencies**:

    ```bash
    flutter pub get
    ```

3. **Run the app**:

    ```bash
    flutter run
    ```

## Project Structure

-   **`lib/`**: Contains the Dart source files.
    -   **`main.dart`**: The main entry point for the app.
    -   **`api/api.dart`**: Handles API interactions with `SunoApi`.
    -   **`models/SunoModel.dart`**: Data models for the `SunoApi`.
-   **`assets/`**: Placeholder for images and other assets.
-   **`pubspec.yaml`**: Dependency management file.

## Key Components

### `MusicApp`

-   The main app class that sets up the `MaterialApp`.
-   Configures global theming using `ThemeData`.

### `MusicScreen`

-   The primary screen of the app.
-   Includes text fields for user input, a button to generate music, and a grid view to display generated tracks.
-   Manages state for loading, playing, and stopping music.

### `MusicCard`

-   A widget that represents an individual music track.
-   Displays track details and includes a play/pause button.

### `SunoApi`

-   Handles API interactions for generating and fetching music.
-   Utilizes HTTP requests to communicate with the Suno service.
-   Includes methods for fetching authentication tokens and checking for audio URLs.

## Usage

1. **Enter a description prompt**: Type a description for the music you want to generate.
2. **Enter a music style**: Specify the style of music you want.
3. **Generate Song**: Click the "Generate Song" button to generate the music.
4. **Play Song**: Use the play button on a music card to listen to the track.

## Configuration

-   **API Integration**: Replace the placeholder values in `SunoApi` with your actual API key and session details.
-   **Customization**: You can modify the theme colors and styles by changing the `ThemeData` properties in `main.dart`.

## Dependencies

-   **`audioplayers`**: For audio playback.
-   **`flutter/material.dart`**: Core Flutter UI framework.
-   **`google_fonts`**: To use custom Google Fonts in the app.
-   **`http`**: For making HTTP requests to the API.

## Troubleshooting

-   **API Errors**: Ensure your API key and session details are correct.
-   **Audio Playback Issues**: Check the URL for the audio file and ensure it's accessible.
-   **UI Issues**: Make sure all necessary assets and fonts are properly linked in `pubspec.yaml`.

## Future Enhancements

-   **Settings Page**: Add a settings page for user customization.
-   **Offline Playback**: Enable downloading of tracks for offline listening.
-   **Enhanced UI**: Add animations and improve the user interface.
