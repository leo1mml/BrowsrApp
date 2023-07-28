//
//  Browsr_AppApp.swift
//  Browsr App
//
//  Created by Leonel Lima on 26/07/2023.
//
import BrowsrLib
import SwiftUI
@main
struct Browsr_AppApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var manager: CoreDataLocalStorage = CoreDataLocalStorage.shared
    private static let lib = BrowsrLib(requestMaker: GithubRequestMaker(source: BrowsrSource(baseUrl: "api.github.com",
                                                                                             listingPath: "/organizations",
                                                                                             searchPath: "/orgs",
                                                                                             authToken: "")))
    let viewModel = OrganizationListViewModel(fetchOrganizationsUseCase: BrowsrApiFetchOrganizationUseCase(lib: Self.lib),
                                              searchOrganizationsUseCase: BrowserApiSearchOrganizationsUseCase(lib: Self.lib))
    var body: some Scene {
        WindowGroup {
            TabView {
                OrganizationList(viewModel: viewModel, showCache: false)
                    .tabItem {
                        Label("List", systemImage: "checklist")
                    }
                    .environmentObject(manager)
                    .environment(\.managedObjectContext, manager.container.viewContext)
                OrganizationList(viewModel: viewModel, showCache: true)
                    .tabItem {
                        Label("Favourites", systemImage: "heart.fill")
                    }
                    .environmentObject(manager)
                    .environment(\.managedObjectContext, manager.container.viewContext)
            }
        }
        .onChange(of: scenePhase) { _ in
            manager.save()
        }
    }
}
