struct Config: Decodable {
    let categories: [Category]
    let remainderCategory: RemainderCategory
}

struct Category: Decodable {
    let name: String
    let file: String
}

struct RemainderCategory: Decodable {
    let name: String
    let files: [String]
}
