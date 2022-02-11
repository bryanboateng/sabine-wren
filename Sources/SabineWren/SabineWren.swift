import ArgumentParser
import Collections
import Foundation

@main
struct SabineWren: ParsableCommand {
    @Argument(help: "Folder", transform: URL.init(fileURLWithPath:))
    var folder: URL
    
    mutating func validate() throws {
        try validateFolderExists(atURL: folder)
    }
    
    private func validateFolderExists(atURL url: URL) throws {
        let path = url.path
        guard FileManager.default.fileExists(atPath: path) else {
            throw ValidationError("Foldeer does not exist at \(path)")
        }
    }
    
    func run() throws {
        let configJSONData = try String(contentsOf: folder.appendingPathComponent("config.json")).data(using: .utf8)!
        let config = try JSONDecoder().decode(Config.self, from: configJSONData)
        
        var result = try config.categories
            .reduce(into: OrderedDictionary<String, OrderedSet<String>>()) { partialResult, category in
                let symbols = try getSymbols(fromFile: category.file)
                partialResult[category.name] = OrderedSet(
                    symbols
                        .filter { symbol in
                            !symbolIsFilledVariant(symbol, allSymbols: symbols)
                        }
                )
            }
        result[config.remainderCategory.name] = try getRemainingSymbols(config: config, existingResult: result)
        
        try JSONEncoder()
            .encode(result)
            .write(to: folder.appendingPathComponent("result.json"))
    }
    private func getSymbols(fromFile filename: String) throws -> OrderedSet<String> {
        let fileURL = folder
            .appendingPathComponent("categories", isDirectory: true)
            .appendingPathComponent(filename)
        return try getLinesFromFile(atURL: fileURL)
    }
    
    private func getLinesFromFile(atURL url: URL) throws -> OrderedSet<String> {
        return try OrderedSet(String(contentsOf: url, encoding: .utf8).components(separatedBy: "\n"))
    }
    
    private func symbolIsFilledVariant(_ symbol: String, allSymbols symbols: OrderedSet<String>) -> Bool {
        if symbol.contains(".fill") {
            return symbols.contains(symbol.replacingOccurrences(of: ".fill", with: ""))
        }
        return false
    }
    
    private func getRemainingSymbols(config: Config, existingResult result: OrderedDictionary<String, OrderedSet<String>>) throws -> OrderedSet<String> {
        let symbols = try config.remainderCategory.files
            .reduce(OrderedSet<String>()) { partialResult, file in
                return try partialResult.union(getSymbols(fromFile: file))
            }
        try JSONEncoder()
            .encode(symbols)
            .write(to: folder.appendingPathComponent("mvp.json"))
        let symbolsFiltered = symbols
            .filter { symbol in
                !symbolIsFilledVariant(symbol, allSymbols: symbols)
            }
        return OrderedSet(symbolsFiltered)
            .subtracting(
                result.reduce(OrderedSet<String>()) { (partialResult: OrderedSet<String>, resultElement: (category: String, symbols: OrderedSet<String>)) in
                    partialResult.union(resultElement.symbols)
                }
            )
    }
}
