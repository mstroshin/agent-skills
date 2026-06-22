# Install Recipes

## Original skills from this repository

```bash
npx skills add mstroshin/agent-skills --skill apple-platform-router
npx skills add mstroshin/agent-skills --skill oslog-debugging
npx skills add mstroshin/agent-skills --skill swiftui-accessibility-identifiers
npx skills add mstroshin/agent-skills --skill mvvm-c-architecture
```

## Recommended external skills

```bash
npx skills add avdlee/swiftui-agent-skill --skill swiftui-expert-skill
npx skills add avdlee/swift-concurrency-agent-skill --skill swift-concurrency
npx skills add avdlee/swift-testing-agent-skill --skill swift-testing-expert
npx skills add hmlongco/Factory --skill factory-dependency-injection --full-depth
```

## Optional external skills

```bash
npx skills add twostraws/swiftui-agent-skill --skill swiftui-pro
npx skills add dimillian/skills --skill swiftui-performance-audit
```

## Factory note

The Factory skill lives under `.claude/skills/` in the upstream `hmlongco/Factory` repository. Use `--full-depth` so `npx skills` searches nested skill directories.
