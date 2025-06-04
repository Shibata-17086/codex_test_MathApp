import SwiftUI

/// Canvas view that draws a simple representation of a vector field in 2D.
/// The field is sampled on a grid and small arrows are drawn for the vectors.
struct VectorFieldCanvas: View {
    var field: VectorField

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let step: CGFloat = 40
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                for x in stride(from: 0, to: size.width, by: step) {
                    for y in stride(from: 0, to: size.height, by: step) {
                        let px = x - center.x
                        let py = center.y - y
                        let v = field.evaluate(x: Double(px / 40), y: Double(py / 40))
                        let start = CGPoint(x: x, y: y)
                        let end = CGPoint(x: start.x + CGFloat(v.0) * 10,
                                         y: start.y - CGFloat(v.1) * 10)
                        var path = Path()
                        path.move(to: start)
                        path.addLine(to: end)
                        context.stroke(path, with: .color(.blue), lineWidth: 1)
                    }
                }
            }
        }
        .frame(height: 200)
    }
}

#Preview {
    VectorFieldCanvas(field: VectorField(text: "(-y, x)"))
}
