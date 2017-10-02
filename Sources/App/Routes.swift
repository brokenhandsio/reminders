import Vapor

extension Droplet {
    func setupRoutes() throws {
        let remindersController = RemindersController()
        remindersController.addRoutes(to: self)
        let usersControler = UsersController()
        usersControler.addRoutes(to: self)
        let categoriesController = CategoriesController()
        categoriesController.addRoutes(to: self)
    }
}
