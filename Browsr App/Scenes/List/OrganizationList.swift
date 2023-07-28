import SwiftUI

struct OrganizationList: View {
    
    @ObservedObject
    var viewModel: OrganizationListViewModel
    @State
    var searchText: String = ""
    private var timer = Timer()
    
    init(viewModel: OrganizationListViewModel, searchText: String = "", timer: Timer = Timer()) {
        self.viewModel = viewModel
        self.searchText = searchText
        self.timer = timer
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.organizations, id: \.id) {
                        OrganizationListItem(organization: $0)
                        Divider()
                    }
                    if viewModel.canLoadNextPage && !viewModel.organizations.isEmpty {
                        ProgressView()
                            .onAppear {
                                viewModel.getOrganizations()
                            }
                    }
                }
            }.onAppear {
                viewModel.getOrganizations()
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText, perform: { newValue in
            viewModel.filterCurrentItems(by: newValue)
        })
        .onSubmit(of: .search) {
            viewModel.search(by: searchText)
        }
    }
}
