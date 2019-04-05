import Foundation

public class TextValidator {
    public let validations: [StringValidatable]
    
    public init(_ validations: [StringValidatable]) {
        self.validations = validations
    }
    
    public init(_ validator: StringValidatable) {
        self.validations = [validator]
    }
    
    public func isTextValid(_ text: String) -> Bool {
        for validation in validations {
            guard validation.isValid(string: text) else {
                return false
            }
        }
        return true
    }
    
    public static func + (lhs: TextValidator, rhs: TextValidator) -> TextValidator {
        let combinedValidations = lhs.validations + rhs.validations
        return TextValidator(combinedValidations)
    }
}

public struct TextValidators {
    static public let photoTitleTextValidator = TextValidator(photoTitleMinCharacterRange)
    static private let photoTitleMinCharacterRange = MinCharacterLimitValidation(minCharacters: 8)
}

public protocol StringValidatable: class {
    func isValid(string: String) -> Bool
}

private class MinCharacterLimitValidation: StringValidatable {
    private let minCharacters: Int
    
    init(minCharacters: Int) {
        self.minCharacters = minCharacters
    }
    
    public func isValid(string: String) -> Bool {
        return string.count >= minCharacters
    }
}
