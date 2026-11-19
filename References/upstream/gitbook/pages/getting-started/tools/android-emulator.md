> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/getting-started/tools/android-emulator.md).

# Android Emulator

{% hint style="warning" %}
It is **not** possible to create accounts using the regular signup in the app, bunq is not reviewing Sandbox applications. See [Creating a sandbox user and getting an API key](/tutorials/your-first-payment/creating-a-sandbox-user-and-getting-an-api-key.md) to learn how to get a user you can test with.
{% endhint %}

In case you do not own an Android device on which you can run our Sandbox app for end-to-end testing, you can set up an emulator to run the bunq Sandbox app for Android.

### Things you will need

You can choose to install on a physical or virtual device.

* For a physical device you'll need a modern Android Device
* If you want to virtualize the bunq app on your computer you need to install [Android Studio](https://developer.android.com/studio/index.html).

### Download sandbox app

{% hint style="success" %}
Download the APK file from an Android device to install it on that device
{% endhint %}

<a href="https://appstore.bunq.com/api/android/builds/bunq-android-sandbox-master.apk" class="button primary">Download APK File</a>

### Starting the Android Virtual Device (AVD) Manager

1. Open Android Studio.
2. From the top menu, select “Tools” > "Android" > "AVD Manager".

### Setting up a new virtual device

1. Start the wizard by clicking on "+ Create Virtual Device".
2. Select a device (we recommend: "Pixel 5.0" or "Nexus 6") and press "Next".
3. Select an x86 system image (we recommend: Nougat, API Level 25, Android 7.1.1 with Google APIs) and press "Next". The image needs to have Google Play Services 10.0.1 or higher.
4. In the bottom left corner, select "Show Advanced Settings".
5. Scroll to "Memory and Storage".
6. Change "Internal Storage" to "2048 MB".
7. Change "SD card" to "200 MB".
8. Press "Finish".

### Starting the virtual device

1. On the right side under "Actions", select the green "Play" button.
2. Wait for the device to boot, this may take a few minutes.

### Installing the bunq Sandbox App APK

1. Open the command line.
2. Navigate to your Android SDK platform tools directory (e.g. `cd ~/Library/Android/sdk/platform-tools` on macOS).
3. Make sure that the virtual device is started and has fully booted.
4. Run `./adb install ~/Downloads/bunq-android-sandboxEmulator-public-api.apk`, this may take a few minutes, and should finish with "Success".

### Creating an account and logging in

1. Create a sandbox user through the portal
   1. Create a sandbox account in the [developer portal](https://developer.bunq.com/).
   2. Grab the API key from the portal
2. Create a user through the API
3. With the API key [Start a Session](/tutorials/your-first-payment/creating-the-api-context/start-a-session.md). This will return a [User](/basics/bunq-api-objects/user.md) which has an alias attached. The Alias is a fake email address or phone number. All pass codes are either 000000 or 992266

{% hint style="info" %}
You will be asked to verify your phone number when you open the app for the first time. Sandbox does not send actual SMS messages. Enter any valid phone number and use the default verification code `992266`.
{% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/getting-started/tools/android-emulator.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
