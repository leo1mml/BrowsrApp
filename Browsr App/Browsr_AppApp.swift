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
    private static let lib = BrowsrLib(requestMaker: GithubRequestMaker(source: BrowsrSource(baseUrl: "api.github.com",
                                                                                             listingPath: "/organizations",
                                                                                             searchPath: "/orgs",
                                                                                             authToken: "")))
    let viewModel = OrganizationListViewModel(fetchOrganizationsUseCase: BrowsrApiFetchOrganizationUseCase(lib: Self.lib),
                                              searchOrganizationsUseCase: BrowserApiSearchOrganizationsUseCase(lib: Self.lib))
    var body: some Scene {
        WindowGroup {
            TabView {
                OrganizationList(viewModel: viewModel)
                    .tabItem {
                        Label("List", systemImage: "checklist")
                    }
                OrganizationList(viewModel: viewModel)
                    .tabItem {
                        Label("Favourites", systemImage: "heart.fill")
                    }
            }
        }
    }
}
