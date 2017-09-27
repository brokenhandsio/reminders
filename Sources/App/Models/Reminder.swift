import FluentProvider

final class Reminder: Model {
    let storage = Storage()
    
    let title: String
    let description: String
    let user: Identifier?
    
    init(title: String, description: String, userId: Identifier) {
        self.title = title
        self.description = description
        self.user = userId
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        description = try row.get("description")
        user = try row.get(User.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("description", description)
        try row.set(User.foreignIdKey, user)
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
        try self.init(title: json.get("title"), description: json.get("description"), userId: try json.get("user_id"))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("title", title)
        try json.set("description", description)
        try json.set("user_id", user)
        return json
    }
}

extension Reminder: ResponseRepresentable {}
