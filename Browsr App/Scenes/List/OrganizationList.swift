import SwiftUI

struct OrganizationList: View {
    
    @ObservedObject
    var viewModel: OrganizationListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.organizations, id: \.id) {
                    OrganizationListItem(organization: $0)
                    Divider()
                }
            }
        }
    }
}
