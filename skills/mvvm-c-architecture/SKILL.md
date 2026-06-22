---
name: mvvm-c-architecture
description: Use when designing, reviewing, or refactoring SwiftUI iOS or macOS app architecture with MVVM+C, including thin views, @Observable view models, coordinators, routing, sheets, windows, deep links, dependency boundaries, services, repositories, and headless tests.
---

# MVVM+C Architecture

## Overview

MVVM+C separates SwiftUI presentation, state/intent handling, and navigation decisions. Views render state and send intents, view models own feature state and business-facing actions, and coordinators own routing, sheets, windows, and deep links.

## When to Use

Use this skill when a task asks to:

- Design SwiftUI app architecture using MVVM+C.
- Refactor navigation out of views or view models.
- Add coordinators, routing, sheets, windows, or deep-link handling.
- Make SwiftUI state and navigation testable without launching the UI.
- Decide where services, repositories, and dependency injection belong.

Do not force MVVM+C onto a tiny one-screen feature with no navigation, no side effects, and no testability problem.

## Quick Reference

| Responsibility | Put it in |
| --- | --- |
| Layout and visual composition | SwiftUI `View` |
| User intent forwarding | SwiftUI `View` calls view-model or coordinator methods |
| Feature state | `@MainActor @Observable` view model |
| Async UI-facing actions | View model, with clear actor isolation |
| Navigation stack, sheets, windows, deep links | Coordinator |
| Business logic | Service or domain object |
| Persistence/networking | Repository or client |
| Dependency registration | DI container such as Factory |
| Unit tests | View models, coordinators, services, repositories |

## Component Boundaries

### View

A SwiftUI view should be easy to preview and mostly declarative.

```swift
struct DocumentsScreen: View {
    @Bindable var viewModel: DocumentsViewModel
    let coordinator: DocumentsCoordinating

    var body: some View {
        List(viewModel.documents) { document in
            Button(document.title) {
                coordinator.open(document)
            }
        }
        .task { await viewModel.load() }
        .accessibilityIdentifier("documents.screen")
    }
}
```

### View Model

Use `@MainActor @Observable` for UI-facing state unless there is a clear reason not to.

```swift
@MainActor
@Observable
final class DocumentsViewModel {
    private let repository: DocumentsRepository
    private(set) var documents: [Document] = []
    private(set) var isLoading = false
    var errorMessage: String?

    init(repository: DocumentsRepository) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            documents = try await repository.documents()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

### Coordinator

Coordinators make navigation decisions and expose route state that views can bind to.

```swift
@MainActor
@Observable
final class AppCoordinator {
    enum Route: Hashable {
        case onboarding
        case workspace
    }

    var path: [Route] = []
    var presentedSheet: Sheet?

    func showWorkspace() {
        path = [.workspace]
    }

    func presentSettings() {
        presentedSheet = .settings
    }
}
```

## Dependency Boundaries

- Inject services and repositories into view models and coordinators.
- Keep concrete networking, persistence, and file-system code out of SwiftUI views.
- Prefer protocols only at meaningful boundaries: tests, modules, external systems, or multiple implementations.
- If using Factory, keep registrations near composition roots and use the upstream Factory skill for exact FactoryKit guidance.

## Testing Strategy

- Test view models by injecting fake repositories and asserting state changes.
- Test coordinators by invoking routing methods and asserting route/sheet/window state.
- Keep SwiftUI snapshot or UI tests for integration-level confidence.
- Avoid requiring an app launch for business-state tests.

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Putting navigation decisions inside view body branches | Move routing decisions to a coordinator. |
| Building SwiftUI views inside view models | View models expose state; views compose views. |
| Making every type a protocol | Add protocols at boundaries that need substitution. |
| Using global singletons for services | Inject dependencies through initializers or a DI container. |
| Marking everything `@MainActor` without thought | UI-facing state is main-actor isolated; heavy work belongs in services off the main actor. |
| Applying MVVM+C to trivial UI | Use a simple view and extract architecture when complexity appears. |
