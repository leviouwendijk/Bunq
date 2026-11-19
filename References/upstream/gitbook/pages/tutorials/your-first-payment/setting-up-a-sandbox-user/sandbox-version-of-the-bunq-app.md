> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/tutorials/your-first-payment/setting-up-a-sandbox-user/sandbox-version-of-the-bunq-app.md).

# Sandbox version of the bunq app

Although Postman offers a great way to interact with our systems you might want to verify how something looks for a end-user in the app. Or you may want to have a device with a 2nd sandbox user to easily make payments with.

## Downloads:

* You can download the Sandbox app APK file for Android [here](https://appstore.bunq.com/api/android/builds/bunq-android-sandbox-master.apk)
* You can download android Studio [here](https://developer.android.com/studio)

### Setting up a fresh user

* You'll need to create a brand new user person to use the sandbox app.
* The reason for this is that our sandbox environment will only let you pass our security measures on the 1st API call that that user makes.
* As such you'll call the [Sandbox Users](/sandbox-users.md) endpoint.
* From that response note down the aliases (either phone number or email address) write that down for later.
* In the response you'll also find a login code. Usually 000000
* Be sure to **not** make any other api calls from this user for now.

## Installing the sandbox app on your physical device

* **Download the APK**
  * Ensure it’s saved in your device’s **Downloads** folder or any other location.
* **Enable Unknown Sources** (if not enabled)
  * Open **Settings** → **Apps & notifications** (or **Apps**).
  * Tap **Special app access** → **Install unknown apps**.
  * Select the app (e.g., Chrome, File Manager) that you’re using to open the APK.
  * Toggle **"Allow from this source"** ON.
* **Install the APK**
  * Open **File Manager** and navigate to the APK file.
  * Tap on the file and press **Install**.
  * Wait for the installation to complete.
* **Open the App**
  * Once installed, tap **Open** to launch the app.

## Starting the Android Device Manager

1. Once you have opened Android studio tap the dropdown menu and choose

<figure><img src="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-0c4cc762d8ff715825c4e2228a473d18f08c5e2c%2FScreenshot%202025-03-24%20at%2017.16.05.png?alt=media" alt=""><figcaption></figcaption></figure>

2. From that screen you can easily create a new device<br>
   1. Start the wizard by clicking on "+ Create Virtual Device".
   2. Select a device (recommendation: "Pixel 5.0" or "Nexus 6") and press "Next".
   3. Select an x86 system image (recommendation: Nougat, API Level 25, Android 7.1.1 with Google APIs) and press "Next". The image needs to have Google Play Services 10.0.1 or higher.
   4. In the bottom left corner, select "Show Advanced Settings".
   5. Scroll to "Memory and Storage".
   6. Change "Internal Storage" to "2048 MB".
   7. Change "SD card" to "200 MB".
   8. Press "Finish".

<figure><img src="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-2ceb61ed40f7b348f646c7afdcf6bdacbc36b3d8%2FScreenshot%202025-03-24%20at%2017.18.21.png?alt=media" alt=""><figcaption></figcaption></figure>

3. You can now start the virtual device by selecting the play button.
4. Installing thebunq Sandbox App APK
5. From the Virtual device simply navigate to our download link [here](https://appstore.bunq.com/api/android/builds/bunq-android-sandbox-master.apk) and download and install the app. You should now have the bunq app on your desktop

<figure><img src="https://346554585-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FGE9Y1hc6C24r4Hen6KFH%2Fuploads%2Fgit-blob-1007769aa03cfa3b4a651532dd80ca487619d631%2FScreenshot%202025-03-24%20at%2017.31.15.png?alt=media" alt=""><figcaption></figcaption></figure>

## Logging into a your user

In the fresh user you just created you saved the phone number or email addres. Now use those to **log in** to the app. The passcode is usually 000000 or 992266.

If you (for whatever reason) log out and back in again you should be able to since it's the same device. But you won't be able to repeat this on a new device as only the first login on sandbox bypasses our security.

{% hint style="info" %}
Be aware that you cannot create a user from the signup flow in the app. As we're not reviewing the users created in sandbox manually
{% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/tutorials/your-first-payment/setting-up-a-sandbox-user/sandbox-version-of-the-bunq-app.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
