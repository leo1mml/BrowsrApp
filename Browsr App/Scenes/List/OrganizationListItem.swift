import SwiftUI

struct OrganizationListItem: View {
    
    @State
    var organization: Organization
    
    var body: some View {
        HStack {
            Image("org")
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(25)
            VStack(alignment: .leading) {
                Text("Login: \(organization.name)")
                Text("Description")
            }
            .padding()
            Spacer()
        }.padding()
    }
}

struct OrganizationListItem_Previews: PreviewProvider {
    static let organization = Organization(id: 1234, name: "Microsoft", imageURL: nil)
    static var previews: some View {
        OrganizationListItem(organization: organization)
    }
}
