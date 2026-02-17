import SwiftUI

@main
struct MyApp: App {
    @StateObject private var router = Router()
    
    init() {
        AppFontRegistrar.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                router.view(.initial)
                    .navigationDestination(for: RouteWrapper.self) { wrapper in
                        router.view(wrapper.route)
                    }
            }
        }
    }
}
