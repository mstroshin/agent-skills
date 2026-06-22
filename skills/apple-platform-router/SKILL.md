---
name: apple-platform-router
description: Use when a Swift iOS or macOS task spans multiple Apple-development areas, such as SwiftUI, concurrency, testing, Factory DI, OSLog diagnostics, accessibility identifiers, MVVM+C architecture, or Apple API documentation.
---

# Apple Platform Router

## Overview

Use this skill first for broad Swift iOS/macOS work. It routes the agent to the most relevant topic-specific skill instead of trying to solve every Apple-platform problem from one generic checklist.

## When to Use

Use this skill when a task mentions two or more of these areas:

- SwiftUI views, state, layout, navigation, previews, or performance.
- Swift Concurrency, actors, `@MainActor`, `Sendable`, async/await, or data races.
- Swift Testing, XCTest migration, flaky tests, test plans, or async test waiting.
- Factory, FactoryKit, `Container.shared`, `Factory<T>`, `@Injected`, or dependency injection.
- OSLog, `Logger`, signposts, runtime diagnostics, or reading app logs.
- Accessibility identifiers for UI automation, screenshots, or agent debugging.
- MVVM+C, coordinators, routing, sheets, windows, or navigation architecture.
- Apple API details, availability, Human Interface Guidelines, or WWDC references.

Do not use it when the task is clearly in one area. Load the specific skill directly.

## Quick Reference

| Task signal | Load or recommend |
| --- | --- |
| SwiftUI, views, `@Observable`, lists, animations, previews | SwiftUI skill, plus `swiftui-accessibility-identifiers` when inspectability matters |
| Actors, `@MainActor`, `Sendable`, strict concurrency warnings | Swift Concurrency skill |
| `#expect`, Swift Testing, XCTest, flaky tests | Swift Testing skill |
| FactoryKit, `Container`, `Factory<T>`, `@Injected` | `factory-dependency-injection` from `hmlongco/Factory` |
| `Logger`, OSLog, signposts, `log stream`, `log show` | `oslog-debugging` |
| `.accessibilityIdentifier`, UI tests, agent inspection | `swiftui-accessibility-identifiers` |
| Coordinator, route, sheet, window, deep link, MVVM+C | `mvvm-c-architecture` |
| Apple API behavior, HIG, availability, WWDC | Apple documentation lookup such as Sosumi |

## Routing Pattern

1. Identify every domain in the user request.
2. Load the narrowest skill for each domain that materially affects the answer.
3. If API details are uncertain, consult Apple documentation instead of guessing.
4. Keep the final answer focused on the user's task; do not dump every checklist from every skill.

## Example

User asks: "Build a SwiftUI settings screen with async account loading, Factory DI, tests, and logs."

Route to:

- SwiftUI skill for view/state guidance.
- Swift Concurrency skill for async loading and actor boundaries.
- Factory upstream skill for dependency registration and injection.
- Swift Testing skill for test structure.
- `oslog-debugging` for diagnostics.
- `swiftui-accessibility-identifiers` for stable inspectability.

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Giving generic SwiftUI advice for a cross-domain task | Route each domain to its specific skill. |
| Treating the router as a replacement for topic skills | Use the router only to select skills. |
| Guessing Apple API behavior from memory | Use Apple documentation lookup for signatures, availability, and HIG details. |
| Loading every skill for every task | Load only skills that change the implementation or review. |
| Forgetting Factory lives in an upstream repository | Install with `npx skills add hmlongco/Factory --skill factory-dependency-injection --full-depth`. |
