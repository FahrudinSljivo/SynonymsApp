import Foundation
import Combine

final class SynonymsData {
    
    /*
    Using Array<Set<String>> here instead of Set<Set<String>> because Set is a value type and it enforces immutability of its elements once inserted. That would be an issue here because we wouldn't be able to expand some of its sets with additional synonyms (through appendToSet method down below). Array is also value type, but it uses copy-on-write optimization and therefore its elements and modifiable.
     */
    
    private static var synonymSets: [Set<String>] = [
        ["empty", "vacant", "unfilled", "unoccupied"],
        ["strong", "powerful", "sturdy", "tough"],
        ["weak", "frail", "fragile"]
    ]
    
    private init() {}
    static var synonymSetsDataPublisher = PassthroughSubject<[Set<String>], Never>()
    
    static func fetchSets() -> [Set<String>] {
        return synonymSets
    }
    
    static func addSet(_ newSet: Set<String>) {
        synonymSets.append(newSet)
        synonymSetsDataPublisher.send(synonymSets)
    }
    
    static func appendToSet(withIndex index: Int, set: Set<String>) {
        synonymSets[index].formUnion(set)
        synonymSetsDataPublisher.send(synonymSets)
    }
}
