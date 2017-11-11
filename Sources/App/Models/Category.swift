import FluentProvider

final class Category: Model {
    
    static let entity = "categories"
    
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

extension Category: Preparation {
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

extension Category: JSONConvertible {
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

extension Category: ResponseRepresentable {}

extension Category {
    var reminders: Siblings<Category, Reminder, Pivot<Category, Reminder>> {
        return siblings()
    }

    static func addCategory(_ name: String, to reminder: Reminder) throws {
        var category: Category

        let foundCategory = try Category.makeQuery().filter(Properties.name, name).first()

        if let existingCategory = foundCategory {
            category = existingCategory
        } else {
            category = Category(name: name)
            try category.save()
        }

        try category.reminders.add(reminder)
    }
}

extension Category: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node([:], in: context)
        try node.set(Properties.id, id)
        try node.set(Properties.name, name)
        return node
    }
}
