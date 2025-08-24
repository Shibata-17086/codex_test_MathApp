//
//  codex_test_MathAppTests.swift
//  codex_test_MathAppTests
//
//  Created by 柴田紘希 on 2025/06/04.
//

import Testing
@testable import codex_test_MathApp

struct codex_test_MathAppTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    @Test func parserWorks() async throws {
        let field = VectorField(text: "(-y, x)")
        let result = field.evaluate(x: 1, y: 1)
        #expect(result.0 == -1)
        #expect(result.1 == 1)
    }


}
