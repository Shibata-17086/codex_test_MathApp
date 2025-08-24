import SwiftUI

/// Available parametric paths for integration animations.
enum PathType: String, CaseIterable, Identifiable {
    case circle
    case line

    var id: String { rawValue }

    /// Returns a path within the given size used for drawing and sampling.
    func path(in rect: CGRect) -> Path {
        switch self {
        case .circle:
            return Path { p in
                p.addEllipse(in: rect.insetBy(dx: rect.width * 0.2, dy: rect.height * 0.2))
            }
        case .line:
            return Path { p in
                let start = CGPoint(x: rect.minX + rect.width * 0.2,
                                     y: rect.midY)
                let end = CGPoint(x: rect.maxX - rect.width * 0.2,
                                   y: rect.midY)
                p.move(to: start)
                p.addLine(to: end)
            }
        }
    }

    /// Sample a point on the path for t in [0,1].
    func point(t: CGFloat, in rect: CGRect) -> CGPoint {
        let path = self.path(in: rect)
        switch self {
        case .circle:
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) * 0.3
            let angle = 2 * .pi * t
            return CGPoint(x: center.x + radius * cos(angle),
                           y: center.y + radius * sin(angle))
        case .line:
            let start = CGPoint(x: rect.minX + rect.width * 0.2,
                                 y: rect.midY)
            let end = CGPoint(x: rect.maxX - rect.width * 0.2,
                               y: rect.midY)
            return CGPoint(x: start.x + (end.x - start.x) * t,
                           y: start.y + (end.y - start.y) * t)
        }
    }

    /// Tangent vector for t in [0,1]. Used for line integral dot product.
    func tangent(t: CGFloat, in rect: CGRect) -> CGPoint {
        switch self {
        case .circle:
            let radius = min(rect.width, rect.height) * 0.3
            let angle = 2 * .pi * t
            return CGPoint(x: -radius * sin(angle) * 2 * .pi,
                           y: radius * cos(angle) * 2 * .pi)
        case .line:
            let start = CGPoint(x: rect.minX + rect.width * 0.2,
                                 y: rect.midY)
            let end = CGPoint(x: rect.maxX - rect.width * 0.2,
                               y: rect.midY)
            return CGPoint(x: end.x - start.x, y: end.y - start.y)
        }
    }
}
