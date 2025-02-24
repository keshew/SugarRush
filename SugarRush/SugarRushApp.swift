import SwiftUI

@main
struct SugarRushApp: App {
    var body: some Scene {
        WindowGroup {
            SugarLoadingView()
                .onAppear {
                    UserDefaultsManager().firstLaunch()
                }
        }
    }
}
