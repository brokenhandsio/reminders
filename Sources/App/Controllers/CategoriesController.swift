import Vapor
import FluentProvider

struct CategoriesController {
    func addRoutes(to drop: Droplet) {
        let categoryGroup = drop.grouped("api", "categories")
        categoryGroup.get(handler: allCategories)
        categoryGroup.post("create", handler: createCategory)
        categoryGroup.get(Category.parameter, handler: getCategory)
        categoryGroup.get(Category.parameter, "reminders", handler: getCategorysReminders)
    }
    
    func createCategory(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        let category = try Category(json: json)
        try category.save()
        return category
    }
    
    func allCategories(_ req: Request) throws -> ResponseRepresentable {
        let categories = try Category.all()
        return try categories.makeJSON()
    }
    
    func getCategory(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)
        return category
    }
    
    func getCategorysReminders(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)
        return try category.reminders.all().makeJSON()
    }
}
