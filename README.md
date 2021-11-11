# ASI Notes App (Flutter)

Devs:

David, Izekiel

Santos, Miguel Angelo

Serrano, Robin

Sosa, Jay Ivan

Setup Guide

This section focuses on the Step-by-step instruction to clone the project locally and install the needed Flutter packages.

1. Open GitBash or Terminal on your computer.
2. Change the current working directory to the location where you want the cloned directory.
3. Type git clone, and then paste the URL you copied earlier. git clone <project_url>.
4. Type cd asi_note_app to navigate to the downloaded repository.
5. Navigate first to the API folder by using the command cd asi_note_api.
6. Type node app.js in the terminal to run the app's API.
7. Navigate back to the project's root folder by typing cd .. in the terminal.
8. Navigate to the flutter project by using the command cd asi_flutter_app.
9. Type flutter pub get to install the required packages in pubspec.yaml to your device.
10. Type flutter run to start building or running the cloned flutter application. (Note: Dart and Flutter SDK must be already installed on your computer, otherwise follow the instructions in the provided [link](https://flutter.dev/docs/get-started/install/windows)).

## Flutter Version

The flutter version can be seen from pubspec.yaml which was set to ">=2.12.0 <3.0.0".

The most important note in the version used was the introduction of Flutter null safety which is a feature that was made accessible following the release of version 2 of the Dart programming language, which has a minimum version of 2.12.
