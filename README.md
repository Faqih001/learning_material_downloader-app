# Build-time Environment Variable Injection (Android)

To use your `.env` Google Maps API key in Android builds, you must sync it to `android/local.properties` before building:

1. Add this line to your `.env`:
   
	```
	GOOGLE_MAPS_API_KEY=your_api_key_here
	```

2. Add this line to `android/local.properties` (can be automated):
   
	```
	GOOGLE_MAPS_API_KEY=your_api_key_here
	```

3. The build system will inject this value into your `AndroidManifest.xml` automatically.

**Tip:** You can automate this step with a script:

```bash
grep GOOGLE_MAPS_API_KEY .env | xargs -d '\n' -I {} echo {} >> android/local.properties
```

Or manually copy the value from `.env` to `android/local.properties` before each build.
# learning_downloader

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
