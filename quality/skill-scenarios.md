# Skill Scenarios

These scenarios are used to pressure-test the original skills. For each original skill, first run the RED prompt without the skill loaded and record likely failure patterns. Then run the GREEN prompt with the skill loaded and check the expected behavior.

## apple-platform-router

RED prompt: "I need help implementing a SwiftUI settings screen that uses Factory for dependencies, has async loading, needs tests, and should be debuggable. Which guidance should you load first?"

Expected baseline failure: agent gives generic SwiftUI advice, misses at least one of Factory, Swift Concurrency, Swift Testing, OSLog, or accessibility identifiers.

GREEN prompt: same as RED, but with `apple-platform-router` loaded.

Expected GREEN behavior: agent routes to SwiftUI, Factory, Swift Concurrency, Swift Testing, OSLog, accessibility identifiers, and Apple docs only when API details are unclear.

## oslog-debugging

RED prompt: "Add debug logs to a SwiftUI login flow and tell me how to read them from Terminal. The login result contains an auth token and user email."

Expected baseline failure: agent logs sensitive values, omits privacy annotations, uses `print`, or cannot provide useful `log stream` / `log show` predicates.

GREEN prompt: same as RED, but with `oslog-debugging` loaded.

Expected GREEN behavior: agent uses `Logger`, subsystem/category, privacy annotations, avoids token logging, and provides process/subsystem/category predicates for `log stream` and `log show`.

## swiftui-accessibility-identifiers

RED prompt: "Add identifiers to a SwiftUI onboarding flow so an agent can inspect loading, error, continue button, and selected plan state."

Expected baseline failure: agent adds only accessibility labels, creates unstable text-derived identifiers, misses state containers, or harms VoiceOver semantics.

GREEN prompt: same as RED, but with `swiftui-accessibility-identifiers` loaded.

Expected GREEN behavior: agent adds stable `.accessibilityIdentifier` values to screen roots, controls, inspectable state containers, rows, sheets, and avoids changing user-facing accessibility labels unless needed.

## mvvm-c-architecture

RED prompt: "Create architecture for a small SwiftUI macOS app with onboarding, workspace navigation, sheets, services, and testable state. Use MVVM+C but avoid overengineering."

Expected baseline failure: agent puts navigation in views, puts view construction in view models, uses global singletons for services, or over-abstracts a small feature.

GREEN prompt: same as RED, but with `mvvm-c-architecture` loaded.

Expected GREEN behavior: agent keeps views thin, uses `@MainActor @Observable` view models for state and intents, coordinators for navigation, injected services, and explicitly avoids MVVM+C for trivial features.
