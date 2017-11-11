import Vapor

class WebController {

    let viewRenderer: ViewRenderer

    init(viewRenderer: ViewRenderer) {
        self.viewRenderer = viewRenderer
    }

    func addRoutes(to drop: Droplet) {
        drop.get(handler: indexHandler)
        drop.get("reminders", Reminder.parameter, handler: reminderHandler)
    }

    func indexHandler(_ req: Request) throws -> ResponseRepresentable {
        var parameters: [String: NodeRepresentable] = [:]
        parameters["page_title"] = "Home"
        parameters["reminders"] = try Reminder.all()

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

}
