import FluentProvider

final class Reminder: Model {
    let storage = Storage()
    
    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        description = try row.get("description")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("description", description)
        return row
    }
}

extension Reminder: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("title")
            builder.string("description")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Reminder: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(title: json.get("title"), description: json.get("description"))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("title", title)
        try json.set("description", description)
        return json
    }
}

extension Reminder: ResponseRepresentable {}
