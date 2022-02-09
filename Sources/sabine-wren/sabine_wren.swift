import ArgumentParser
import Collections
import Foundation

@main
struct SabineWren: ParsableCommand {
    @Argument(help: "File 1", transform: URL.init(fileURLWithPath:))
    var file1: URL
    
    @Argument(help: "File 2", transform: URL.init(fileURLWithPath:))
    var file2: URL
    
    mutating func validate() throws {
        try validateFileExists(atURL: file1)
        try validateFileExists(atURL: file2)
    }
    
    private func validateFileExists(atURL url: URL) throws {
        let path = url.path
        guard FileManager.default.fileExists(atPath: path) else {
            throw ValidationError("File does not exist at \(path)")
        }
    }
    
    func run() throws {
        let lines1: OrderedSet = try getLinesFromFile(atURL: file1)
        let lines2: OrderedSet = try getLinesFromFile(atURL: file2)
        
        let intersectingLines = lines1.intersection(lines2)
        print(intersectingLines)
        try lines1
            .subtracting(intersectingLines)
            .joined(separator: "\n")
            .write(toFile: file1.path, atomically: true, encoding: .utf8)
    }
    
    private func getLinesFromFile(atURL url: URL) throws -> OrderedSet<String> {
        return try OrderedSet(String(contentsOf: url, encoding: .utf8).components(separatedBy: "\n"))
    }
}
