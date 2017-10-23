import FluentProvider

final class Reminder: Model {

    let storage = Storage()
    let title: String
    let description: String
    let userId: Identifier?

    struct Properties {
        static let id = "id"
        static let title = "title"
        static let description = "description"
        static let userID = "user_id"
    }
    
    init(title: String, description: String, user: User) {
        self.title = title
        self.description = description
        self.userId = user.id
    }
    
    init(row: Row) throws {
        title = try row.get(Properties.title)
        description = try row.get(Properties.description)
        userId = try row.get(User.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Properties.title, title)
        try row.set(Properties.description, description)
        try row.set(User.foreignIdKey, userId)
        return row
    }
}

extension Reminder: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Properties.title)
            builder.string(Properties.description)
            builder.parent(User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Reminder: JSONConvertible {
    convenience init(json: JSON) throws {
        let userId: Identifier = try json.get(Properties.userID)
        guard let user = try User.find(userId) else {
            throw Abort.badRequest
        }
        try self.init(title: json.get(Properties.title), description: json.get(Properties.description), user: user)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Properties.id, id)
        try json.set(Properties.title, title)
        try json.set(Properties.description, description)
        try json.set(Properties.userID, userId)
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
