import CoreData

class CoreDataSaveOrganizationUseCase: SaveOrganizationUseCase {
    
    private let manager: CoreDataLocalStorage
    
    init(manager: CoreDataLocalStorage) {
        self.manager = manager
    }
    
    func save(organization: OrganizationListItemViewModel) {
        let org = Org(context: manager.container.viewContext)
        org.avatarURL = organization.imageURL
        org.desc = organization.description
        org.name = organization.name
        manager.save()
    }
}
