---
name: swiftui-accessibility-identifiers
description: Use when adding or reviewing SwiftUI accessibility identifiers for iOS or macOS views, UI tests, screenshot automation, agent debugging, inspectable loading/error/empty states, buttons, rows, sheets, popovers, and navigation roots.
---

# SwiftUI Accessibility Identifiers

## Overview

Add stable `.accessibilityIdentifier(...)` values so agents, UI tests, screenshots, and debugging tools can find important SwiftUI elements. Identifiers are for automation and inspection; labels, hints, traits, and values are for users.

## When to Use

Use this skill when a task asks to:

- Add accessibility IDs or identifiers.
- Make a SwiftUI screen easier for an agent to inspect or debug.
- Prepare UI for XCTest UI automation or screenshot tests.
- Identify loading, empty, error, selected, disabled, or expanded states.
- Review whether a SwiftUI view hierarchy is debuggable.

Do not use identifiers as a replacement for real accessibility labels or semantic grouping.

## Quick Reference

| Element | Identifier pattern |
| --- | --- |
| Screen root | `settings.screen` |
| Section/container | `settings.account.section` |
| Button | `settings.account.signOutButton` |
| Toggle | `settings.notifications.emailToggle` |
| Text field | `profile.name.textField` |
| Row | `documents.row.<stable-id>` |
| Loading state | `documents.loadingView` |
| Empty state | `documents.emptyView` |
| Error state | `documents.errorView` |
| Sheet | `settings.rename.sheet` |
| Popover | `editor.link.popover` |

## SwiftUI Pattern

```swift
struct SettingsScreen: View {
    var body: some View {
        Form {
            Section("Account") {
                Button("Sign Out") {
                    signOut()
                }
                .accessibilityIdentifier("settings.account.signOutButton")
            }
            .accessibilityIdentifier("settings.account.section")
        }
        .accessibilityIdentifier("settings.screen")
    }
}
```

For state-specific containers:

```swift
switch viewModel.state {
case .loading:
    ProgressView("Loading")
        .accessibilityIdentifier("documents.loadingView")
case .empty:
    ContentUnavailableView("No Documents", systemImage: "doc")
        .accessibilityIdentifier("documents.emptyView")
case .failed:
    ErrorView(retry: viewModel.retry)
        .accessibilityIdentifier("documents.errorView")
case .loaded(let documents):
    DocumentsList(documents: documents)
        .accessibilityIdentifier("documents.list")
}
```

## Naming Rules

- Use stable domain names, not visible copy that localization can change.
- Prefer `screen.section.element` for static controls.
- Use a stable model identifier for dynamic rows, such as `documents.row.<id>`.
- Use state suffixes only when the state is itself inspected, such as `loadingView` or `errorView`.
- Keep names readable and predictable; avoid UUIDs unless the model ID is already a UUID.

## Placement Rules

Add identifiers to:

- Screen roots and major navigation roots.
- Actionable controls: buttons, toggles, menus, pickers, text fields.
- Important containers: lists, forms, inspectors, sheets, popovers.
- Dynamic rows and selected/expanded state when tests or agents need to inspect them.
- Loading, empty, error, permission, and offline states.

Avoid identifiers on every decorative `Text`, `Image`, `Spacer`, or private subview unless it is inspected.

## Accessibility Semantics

`.accessibilityIdentifier` does not create a user-facing label. If a control lacks a good label, add an appropriate `.accessibilityLabel`, `.accessibilityHint`, or semantic container separately.

Do not change correct user-facing accessibility just to make automation easier.

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Adding `.accessibilityLabel` when automation needs an ID | Add `.accessibilityIdentifier` and keep user labels semantic. |
| IDs based on localized visible text | Use stable domain names. |
| Only tagging buttons | Also tag screen roots, lists, rows, sheets, and state views. |
| Tagging every tiny subview | Tag elements that tests or agents need to find. |
| Reusing the same ID in repeated rows | Include a stable row/model identifier. |
| Breaking VoiceOver grouping | Keep accessibility semantics separate from automation identifiers. |
