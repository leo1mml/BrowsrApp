import SwiftUI

struct OrganizationList: View {
    
    @ObservedObject
    var viewModel: OrganizationListViewModel
    @State
    var searchText: String = ""
    private var timer = Timer()
    var showCache: Bool
    @FetchRequest(sortDescriptors: [])
    var localItems: FetchedResults<Org>
    
    init(viewModel: OrganizationListViewModel, searchText: String = "", timer: Timer = Timer(), showCache: Bool) {
        self.viewModel = viewModel
        self.showCache = showCache
        self.searchText = searchText
        self.timer = timer
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                LazyVStack {
                    let orgs = showCache ?
                    localItems.map { OrganizationListItemViewModel(id: $0.id.hashValue,
                                                                   name: $0.name ?? "",
                                                                   description: $0.desc,
                                                                   imageURL: $0.avatarURL) }
                    :
                    viewModel.organizations
                    ForEach(orgs, id: \.id) {
                        OrganizationListItem(organization: $0)
                        Divider()
                    }
                    if viewModel.canLoadNextPage && !orgs.isEmpty && !showCache {
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
