import Vapor

extension Droplet {
    func setupRoutes() throws {
        let remindersController = RemindersController()
        remindersController.addRoutes(to: self)
    }
}
