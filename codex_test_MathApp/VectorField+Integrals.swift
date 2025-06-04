import SwiftUI

extension VectorField {
    /// Approximate line integral over a parametric path defined by point(t) and tangent(t)
    /// using simple Riemann sum with n samples.
    func lineIntegral(path: PathType, samples n: Int, size: CGSize) -> Double {
        guard n > 1 else { return 0 }
        var total: Double = 0
        let rect = CGRect(origin: .zero, size: size)
        for i in 0..<n {
            let t = CGFloat(i) / CGFloat(n - 1)
            let point = path.point(t: t, in: rect)
            let tangent = path.tangent(t: t, in: rect)
            let fx = evaluate(x: Double((point.x - size.width/2)/40),
                              y: Double((size.height/2 - point.y)/40))
            let vector = CGPoint(x: fx.0, y: fx.1)
            let dot = Double(vector.x * tangent.x + vector.y * tangent.y)
            total += dot
        }
        // scale step length
        return total / Double(n)
    }
}
