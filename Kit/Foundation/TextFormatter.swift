import Foundation

public class TextFormatter {
    public let formatters: [StringFormatable]
    
    public var maxCharsCount: Int? {
        for formatter in formatters {
            if let formatter = formatter as? MaxCharsFormatter {
                return formatter.maxChars
            }
        }
        return nil
    }
    
    init(_ formatters: [StringFormatable]) {
        self.formatters = formatters
    }
    
    init(_ formatter: StringFormatable) {
        self.formatters = [formatter]
    }
    
    public func formatText(_ text: String) -> String {
        var formattedText = text
        for formatter in formatters {
            formattedText = formatter.formatText(formattedText)
        }
        return formattedText
    }
    
    public static func + (lhs: TextFormatter, rhs: TextFormatter) -> TextFormatter {
        let combinedValidations = lhs.formatters + rhs.formatters
        return TextFormatter(combinedValidations)
    }
}

public struct TextFormatters {
    
    static public let albumTitleTextFormatter = TextFormatter([stripLeadingAndTrailingSpacesFormatter, albumTitleLengthFormatter])
    static private let albumTitleLengthFormatter = MaxCharsFormatter(maxChars: 8)
    static private let stripLeadingAndTrailingSpacesFormatter = StripLeadingAndTrailingSpaces()
}

public protocol StringFormatable: class {
    func formatText(_ string: String) -> String
}

// MARK: - Private

private class StripLeadingAndTrailingSpaces: StringFormatable {
    public func formatText(_ string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private class MaxCharsFormatter: StringFormatable {
    let maxChars: Int
    
    init(maxChars: Int) {
        self.maxChars = maxChars
    }
    public func formatText(_ string: String) -> String {
        return String(string.prefix(maxChars))
    }
}
