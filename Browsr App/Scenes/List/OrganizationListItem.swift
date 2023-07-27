import SwiftUI

struct OrganizationListItem: View {
    
    @State
    var organization: Organization
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: organization.imageURL ?? ""),
                       content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }, placeholder: {
                Color.gray
            })
            .frame(width: 50, height: 50)
            .cornerRadius(10)
            VStack(alignment: .leading) {
                Text("Login: \(organization.name)")
                if let description = organization.description, !description.isEmpty {
                    Text("Description: \(description)")
                }
            }
            .padding()
            Spacer()
        }.padding()
    }
}

struct OrganizationListItem_Previews: PreviewProvider {
    static let organization = Organization(id: 1234, name: "Microsoft", description: "Noice company", imageURL: nil)
    static var previews: some View {
        OrganizationListItem(organization: organization)
    }
}
