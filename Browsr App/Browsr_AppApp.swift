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
    let viewModel = OrganizationListViewModel(fetchOrganizationsUseCase: BrowsrApiFetchOrganizationUseCase(lib: Self.lib))
    var body: some Scene {
        WindowGroup {
            OrganizationList(viewModel: viewModel)
                .background(Color.white)
                .onAppear {
                    viewModel.getOrganizations()
                }
        }
    }
}
