import FluentProvider

final class Reminder: Model {
    let storage = Storage()
    
    let title: String
    let description: String
    let userId: Identifier?
    
    init(title: String, description: String, user: User) {
        self.title = title
        self.description = description
        self.userId = user.id
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        description = try row.get("description")
        userId = try row.get(User.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("description", description)
        try row.set(User.foreignIdKey, userId)
        return row
    }
}

extension Reminder: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("title")
            builder.string("description")
            builder.parent(User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Reminder: JSONConvertible {
    convenience init(json: JSON) throws {
        let userId: Identifier = try json.get("user_id")
        guard let user = try User.find(userId) else {
            throw Abort.badRequest
        }
        try self.init(title: json.get("title"), description: json.get("description"), user: user)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("title", title)
        try json.set("description", description)
        try json.set("user_id", userId)
        return json
    }
}

extension Reminder: ResponseRepresentable {}

extension Reminder {
    var user: Parent<Reminder, User> {
        return parent(id: userId)
    }
}

extension Reminder {
    var categories: Siblings<Reminder, Category, Pivot<Reminder, Category>> {
        return siblings()
    }
}
