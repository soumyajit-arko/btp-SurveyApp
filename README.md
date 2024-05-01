### Step 1: Clone the Repository

Open your terminal or command prompt and navigate to the directory where you want to store the project. Use the `git clone` command followed by the GitHub repository URL.

```bash
git clone https://github.com/shashankgoud001/btp
```

### Step 2: Navigate to the Project Directory

Once the cloning process is complete, navigate to the directory of the downloaded project.

```bash
cd <project_directory>
```

### Step 3: Get Dependencies

Flutter projects use dependencies specified in the `pubspec.yaml` file. Run the following command to get all the dependencies required for the project.

```bash
flutter pub get
```

This command will download and install all the dependencies listed in the `pubspec.yaml` file.

### Step 4: Run the App

Now that you have cloned the repository and installed the dependencies, you can run the Flutter app on either an emulator or a physical device.

#### Emulator

If you have an emulator set up, you can run the app using the following command:

```bash
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```

Replace `<emulator_id>` with the ID of your emulator.

#### Physical Device

To run the app on a physical device, connect your device to your computer via USB and enable USB debugging. Then, run the app using the following command:

```bash
flutter devices
flutter run
```

### Additional Notes

- Make sure you have Flutter and Dart installed on your system. You can follow the official Flutter installation guide for detailed instructions.
- To change the protocol and domainName(url)  of the server go to lib/login_page.dart file and modify variables `protocol` and `domainName`
- The images and voice are base64 encoded before transferring to the server
