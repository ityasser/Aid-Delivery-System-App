package app.mosd.gov.ps.aid_registry_flutter_app

import io.flutter.embedding.android.FlutterActivity



class MainActivity : FlutterActivity()

/*
class MainActivity : FlutterActivity(){

// Create a new event for the activity.
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // Set the layout for the content view.
    setContentView(R.layout.main_activity)

    // Set up an OnPreDrawListener to the root view.
    val content: View = findViewById(android.R.id.content)
    content.viewTreeObserver.addOnPreDrawListener(
        object : ViewTreeObserver.OnPreDrawListener {
            override fun onPreDraw(): Boolean {
                // Check whether the initial data is ready.
                return if (viewModel.isReady) {
                    // The content is ready. Start drawing.
                    content.viewTreeObserver.removeOnPreDrawListener(this)
                    true
                } else {
                    // The content isn't ready. Suspend.
                    false
                }
            }
        }
    )
}
}
*/