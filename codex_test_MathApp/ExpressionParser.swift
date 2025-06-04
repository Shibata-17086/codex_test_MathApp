import Foundation

/// Represents a single scalar expression parsed via `NSExpression`.
/// This supports variables `x` and `y` and basic arithmetic operators.
struct ParsedExpression {
    let expressionString: String
    private let nsExpression: NSExpression

    init(string: String) {
        self.expressionString = string
        // `NSExpression` will parse the expression for us.
        self.nsExpression = NSExpression(format: string)
    }

    /// Evaluates the expression with provided x and y values.
    func evaluate(x: Double, y: Double) -> Double {
        let variables: [String: Double] = ["x": x, "y": y]
        return nsExpression.expressionValue(with: variables, context: nil) as? Double ?? .nan
    }
}

/// Simple representation of a 2D vector field of the form `(fx, fy)`.
struct VectorField {
    var rawText: String
    var fx: ParsedExpression
    var fy: ParsedExpression

    init(text: String) {
        self.rawText = text
        let sanitized = text.trimmingCharacters(in: .whitespacesAndNewlines)
        var body = sanitized
        // remove surrounding parentheses if present
        if body.hasPrefix("(") && body.hasSuffix(")") {
            body.removeFirst()
            body.removeLast()
        }
        let parts = body.split(separator: ",", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
        let fxText = parts.count > 0 ? String(parts[0]) : "0"
        let fyText = parts.count > 1 ? String(parts[1]) : "0"
        self.fx = ParsedExpression(string: fxText)
        self.fy = ParsedExpression(string: fyText)
    }

    func evaluate(x: Double, y: Double) -> (Double, Double) {
        (fx.evaluate(x: x, y: y), fy.evaluate(x: x, y: y))
    }
}

