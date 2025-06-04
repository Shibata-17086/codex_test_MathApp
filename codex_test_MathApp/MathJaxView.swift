import SwiftUI
import WebKit

/// Simple WebView wrapper that loads MathJax to render LaTeX strings.
struct MathJaxView: UIViewRepresentable {
    let latex: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let html = """
        <html>
        <head>
        <script src='https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js'></script>
        </head>
        <body style='font-size:150%;'>
        $$\(latex)$$
        </body>
        </html>
        """
        uiView.loadHTMLString(html, baseURL: nil)
    }
}
