import Vapor

class WebController {

    let viewRenderer: ViewRenderer

    init(viewRenderer: ViewRenderer) {
        self.viewRenderer = viewRenderer
    }

    func addRoutes(to drop: Droplet) {
        drop.get(handler: indexHandler)
    }

    func indexHandler(_ req: Request) throws -> ResponseRepresentable {
        var parameters: [String: NodeRepresentable] = [:]
        parameters["page_title"] = "Home"
        parameters["reminders"] = try Reminder.all()

        return try viewRenderer.make("index", parameters)
    }

}
