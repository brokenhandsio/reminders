import FluentProvider

final class User: Model {

    let storage = Storage()
    let name: String

    struct Properties {
        static let id = "id"
        static let name = "name"
    }

    init(name: String) {
        self.name = name
    }
    
    init(row: Row) throws {
        name = try row.get(Properties.name)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Properties.name, name)
        return row
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Properties.name)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Properties.name))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Properties.id, id)
        try json.set(Properties.name, name)
        return json
    }
}

extension User: ResponseRepresentable {}

extension User {
    var reminders: Children<User, Reminder> {
        return children()
    }
}
