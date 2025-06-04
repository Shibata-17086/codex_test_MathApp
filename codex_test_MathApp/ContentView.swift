//
//  ContentView.swift
//  codex_test_MathApp
//
//  Created by 柴田紘希 on 2025/06/04.
//

import SwiftUI
import WebKit

/// Main content view used during early prototyping.
/// Displays a text field for entering a vector field expression
/// and shows a simple evaluation result to confirm parsing works.

struct ContentView: View {
    /// Raw text entered by the user representing the vector field.
    @State private var inputText: String = "(-y, x)"
    /// Currently parsed vector field.
    @State private var vectorField: VectorField = VectorField(text: "(-y, x)")
    /// Selected path type for line integral demonstration.
    @State private var pathType: PathType = .circle
    /// Animation progress along the path [0,1].
    @State private var progress: CGFloat = 0
    /// Whether the path animation is active.
    @State private var isAnimating = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vector Field Input")
                .font(.headline)

            TextField("e.g. (-y, x)", text: $inputText)
                .textFieldStyle(.roundedBorder)

            Button("Parse") {
                vectorField = VectorField(text: inputText)
            }
            .buttonStyle(.borderedProminent)

            Picker("Path", selection: $pathType) {
                ForEach(PathType.allCases) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(.segmented)

            VectorFieldCanvas(field: vectorField)
                .overlay(
                    GeometryReader { geo in
                        pathType.path(in: geo.frame(in: .local))
                            .stroke(Color.red, lineWidth: 2)
                        let point = pathType.point(t: progress, in: geo.frame(in: .local))
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                            .position(point)
                        let integral = vectorField.lineIntegral(path: pathType, samples: 100, size: geo.size)
                        Text(String(format: "∮F·dr ≈ %.2f", integral))
                            .position(x: geo.size.width - 80, y: 20)
                    }
                )

            Button(isAnimating ? "Stop" : "Start") {
                isAnimating.toggle()
            }
            .buttonStyle(.bordered)

            Text("Evaluation at x=1, y=1:")
            let value = vectorField.evaluate(x: 1, y: 1)
            Text("(\(value.0), \(value.1))")
                .monospaced()

            MathJaxView(latex: "\\oint \mathbf{F}\cdot d\mathbf{r}")
        }
        .padding()
        .onReceive(Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()) { _ in
            guard isAnimating else { return }
            progress += 0.002
            if progress > 1 { progress = 0 }
        }
    }
}

#Preview {
    ContentView()
}
