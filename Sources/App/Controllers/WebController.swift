import Vapor

class WebController {

    let viewRenderer: ViewRenderer

    init(viewRenderer: ViewRenderer) {
        self.viewRenderer = viewRenderer
    }

    func addRoutes(to drop: Droplet) {
        drop.get(handler: indexHandler)
        drop.get("reminders", Reminder.parameter, handler: reminderHandler)
        drop.get("users", handler: allUsersHandler)
        drop.get("users", User.parameter, handler: userHandler)
        drop.get("categories", handler: allCategoriesHandler)
        drop.get("categories", Category.parameter, handler: categoryHandler)
    }

    func indexHandler(_ req: Request) throws -> ResponseRepresentable {
        var parameters: [String: NodeRepresentable] = [:]
        parameters["page_title"] = "Home"
        parameters["reminders"] = try Reminder.all()
        parameters["users"] = try User.all()
        parameters["categories"] = try Category.all()

        return try viewRenderer.make("index", parameters)
    }

    func reminderHandler(_ req: Request) throws -> ResponseRepresentable {
        let reminder = try req.parameters.next(Reminder.self)

        var parameters: [String: NodeRepresentable] = [:]
        parameters["page_title"] = reminder.title
        parameters["reminder"] = reminder
        parameters["user"] = try reminder.user.get()

        if try reminder.categories.count() > 0 {
            parameters["categories"] = try reminder.categories.all()
        }

        return try viewRenderer.make("reminder", parameters)
    }

    func allUsersHandler(_ req: Request) throws -> ResponseRepresentable {
        var parameters: [String: NodeRepresentable] = [:]
        parameters["page_title"] = "Users"
        parameters["users"] = try User.all()

        return try viewRenderer.make("users", parameters)
    }

    func userHandler(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.parameters.next(User.self)

        var parameters: [String: NodeRepresentable] = [:]
        parameters["page_title"] = user.name
        parameters["user"] = user

        if try user.reminders.count() > 0 {
            parameters["reminders"] = try user.reminders.all()
        }

        return try viewRenderer.make("user", parameters)
    }

    func allCategoriesHandler(_ req: Request) throws -> ResponseRepresentable {
        var parameters: [String: NodeRepresentable] = [:]
        parameters["page_title"] = "Categories"
        parameters["categories"] = try Category.all()

        return try viewRenderer.make("categories", parameters)
    }

    func categoryHandler(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)

        var parameters: [String: NodeRepresentable] = [:]
        parameters["page_title"] = category.name
        parameters["category"] = category

        if try category.reminders.count() > 0 {
            parameters["reminders"] = try category.reminders.all()
        }

        return try viewRenderer.make("category", parameters)
    }

}
