//
//  Router.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/18/26.
//

import SwiftUI

enum Route: Hashable {
    case initial
    case main
    case description
    case make
}

struct RouteWrapper: Hashable {
    let route: Route
    let id: AnyHashable?
    let namespace: Namespace.ID?
    
    init(route: Route, id: AnyHashable? = nil, namespace: Namespace.ID? = nil) {
        self.route = route
        self.id = id
        self.namespace = namespace
    }
}

final class Router: ObservableObject {
    @Published var path: NavigationPath
    
    init() {
        self.path = NavigationPath()
    }
    
    func push(_ route: Route) {
        path.append(RouteWrapper(route: route))
    }
    
    func push(_ route: Route, id: any Hashable, in namespace: Namespace.ID) {
        path.append(RouteWrapper(route: route, id: AnyHashable(id), namespace: namespace))
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    @MainActor @ViewBuilder
    func view(_ route: Route) -> some View {
        switch route {
        case .initial:
            InitialView(router: self)
        case .main:
            MainView(router: self)
        case .description:
            DescriptionView(router: self)
        case .make:
            MakeView()
        }
    }
}
