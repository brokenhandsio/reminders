import Vapor
import FluentProvider

struct UsersController {
    func addRoutes(to drop: Droplet) {
        let userGroup = drop.grouped("api", "users")
        userGroup.get(handler: allUsers)
        userGroup.post("create", handler: createUser)
        userGroup.get(User.parameter, handler: getUser)
        userGroup.get(User.parameter, "reminders", handler: getUsersReminders)
    }
    
    func createUser(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        let user = try User(json: json)
        try user.save()
        return user
    }
    
    func allUsers(_ req: Request) throws -> ResponseRepresentable {
        let users = try User.all()
        return try users.makeJSON()
    }
    
    func getUser(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.parameters.next(User.self)
        return user
    }
    
    func getUsersReminders(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.parameters.next(User.self)
        return try user.reminders.all().makeJSON()
    }
}
