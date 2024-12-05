import Foundation

extension String {
    
    var localized: String {
        let localizationString = Bundle.main
            .localizedString(forKey: self, value: self, table: "Localizable")
        
        return localizationString
    }
    
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var addColon: String { self + ": " }
}
