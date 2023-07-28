import SwiftUI

struct OrganizationListItem: View {
    
    @State
    var organization: OrganizationListItemViewModel
    @State
    var isFavorited = false
    @FetchRequest(sortDescriptors: [])
    var favourites: FetchedResults<Org>
    
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
            Button {
                if let favourite = favourites.first(where: { $0.name == organization.name }) {
                    CoreDataLocalStorage.shared.container.viewContext.delete(favourite)
                } else {
                    let org = Org(context: CoreDataLocalStorage.shared.container.viewContext)
                    org.avatarURL = organization.imageURL
                    org.desc = organization.description
                    org.name = organization.name
                    CoreDataLocalStorage.shared.save()
                }
                isFavorited.toggle()
            } label: {
                isFavorited ?
                Image(systemName: "heart.fill") :
                Image(systemName: "heart")
            }

        }.padding()
            .onAppear{
                isFavorited = favourites.contains { $0.name == organization.name }
            }
    }
}

struct OrganizationListItem_Previews: PreviewProvider {
    static let organization = OrganizationListItemViewModel(id: 1234, name: "Microsoft", description: "Noice company", imageURL: nil)
    static var previews: some View {
        OrganizationListItem(organization: organization)
    }
}
