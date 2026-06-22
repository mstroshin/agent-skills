# agent-skills

Hybrid Agent Skills for Swift iOS and macOS development.

This repository contains original skills for gaps that are not well covered by existing public skills, plus curated install commands for strong external Swift and Apple-platform skills.

## What is included

Original skills in this repository:

- `apple-platform-router` — choose the right Apple/Swift skill for broad iOS/macOS work.
- `oslog-debugging` — add and read Apple unified logs with `Logger`, privacy, predicates, and signposts.
- `swiftui-accessibility-identifiers` — add stable SwiftUI accessibility identifiers for agent debugging and UI automation.
- `mvvm-c-architecture` — structure SwiftUI apps with MVVM+C without overengineering.

Curated external skills are recommended, not vendored. See `references/recommended-external-skills.md`.

## Quick install

Install all original skills:

```bash
npx skills add mstroshin/agent-skills --skill apple-platform-router
npx skills add mstroshin/agent-skills --skill oslog-debugging
npx skills add mstroshin/agent-skills --skill swiftui-accessibility-identifiers
npx skills add mstroshin/agent-skills --skill mvvm-c-architecture
```

Install the recommended external Swift/Apple skills:

```bash
npx skills add avdlee/swiftui-agent-skill --skill swiftui-expert-skill
npx skills add avdlee/swift-concurrency-agent-skill --skill swift-concurrency
npx skills add avdlee/swift-testing-agent-skill --skill swift-testing-expert
npx skills add hmlongco/Factory --skill factory-dependency-injection --full-depth
```

Optional external skills:

```bash
npx skills add twostraws/swiftui-agent-skill --skill swiftui-pro
npx skills add dimillian/skills --skill swiftui-performance-audit
```

## Recommended setup

For general Apple-platform development, install:

1. `apple-platform-router` from this repository.
2. All recommended external SwiftUI, Swift Concurrency, Swift Testing, and Factory skills.
3. `oslog-debugging`, `swiftui-accessibility-identifiers`, and `mvvm-c-architecture` from this repository.
4. A documentation lookup skill such as Sosumi for Apple API reference, HIG, and WWDC transcripts.

Use the router when a task crosses multiple areas. Use a topic-specific skill directly when the task is obvious, such as fixing a `Sendable` warning or adding OSLog predicates.

## Why external skills are not vendored

The strongest SwiftUI, Swift Concurrency, Swift Testing, and Factory skills are maintained in their own upstream repositories. This repository links to those sources and provides installation commands instead of copying their content, so updates and attribution stay clear.

## Validate this repository

```bash
./scripts/validate.sh
```

After the repository is public, verify discovery through `npx skills`:

```bash
npx skills add mstroshin/agent-skills --list
```

The command should list:

- `apple-platform-router`
- `oslog-debugging`
- `swiftui-accessibility-identifiers`
- `mvvm-c-architecture`

## License

Original content in this repository is released under the MIT License. External skills keep their upstream licenses and are credited in `references/recommended-external-skills.md`.
