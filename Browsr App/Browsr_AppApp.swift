//
//  Browsr_AppApp.swift
//  Browsr App
//
//  Created by Leonel Lima on 26/07/2023.
//
import Browsr_Lib
import SwiftUI

@main
struct Browsr_AppApp: App {
    private static let lib = BrowsrLib()
    let viewModel = OrganizationListViewModel(fetchOrganizationsUseCase: BrowsrApiFetchOrganizationUseCase(lib: Self.lib),
                                              searchOrganizationsUseCase: BrowserApiSearchOrganizationsUseCase(lib: Self.lib))
    var body: some Scene {
        WindowGroup {
            TabView {
                OrganizationList(viewModel: viewModel)
                    .onAppear {
                        viewModel.getOrganizations()
                    }
                    .tabItem {
                        Label("List", systemImage: "checklist")
                    }
                OrganizationList(viewModel: viewModel)
                    .onAppear {
                        viewModel.getOrganizations()
                    }
                    .tabItem {
                        Label("Favourites", systemImage: "heart.fill")
                    }
            }
        }
    }
}
