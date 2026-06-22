---
name: oslog-debugging
description: Use when adding, reviewing, or reading Apple unified logs in Swift iOS or macOS apps, including OSLog, Logger, signposts, privacy annotations, log stream predicates, log show history, runtime diagnostics, and agent-assisted debugging.
---

# OSLog Debugging

## Overview

Use Apple unified logging for runtime diagnostics that need to survive beyond a local debug session. Prefer `Logger` over `print`, use stable subsystem/category names, and protect sensitive values with privacy annotations.

## When to Use

Use this skill when the task asks to:

- Add diagnostic logging to Swift app code.
- Read app logs from Terminal or Console.
- Debug a runtime issue with timestamps, categories, or state transitions.
- Add signposts around performance-sensitive work.
- Replace `print` debugging with structured Apple logging.

Do not use logs as a substitute for tests, error handling, or user-visible diagnostics.

## Quick Reference

| Need | Pattern |
| --- | --- |
| Define a logger | `private let logger = Logger(subsystem: "com.example.app", category: "Login")` |
| Public value | `logger.info("Loaded count: \(count, privacy: .public)")` |
| Private value | `logger.info("User id: \(userID, privacy: .private)")` |
| Avoid secret logging | Log presence, hash prefix, or redacted state instead of tokens/secrets |
| Live logs | `log stream --style compact --predicate 'subsystem == "com.example.app"'` |
| Recent history | `log show --last 10m --style compact --predicate 'subsystem == "com.example.app"'` |
| Category filter | `subsystem == "com.example.app" AND category == "Login"` |
| Process filter | `process == "MyApp"` |

## Swift Pattern

```swift
import OSLog

private let logger = Logger(subsystem: "com.example.myapp", category: "Account")

func loadAccount(id: String) async throws -> Account {
    logger.info("Loading account id: \(id, privacy: .private)")
    do {
        let account = try await service.account(id: id)
        logger.info("Loaded account hasSubscription: \(account.hasSubscription, privacy: .public)")
        return account
    } catch {
        logger.error("Failed to load account: \(error.localizedDescription, privacy: .public)")
        throw error
    }
}
```

## Reading Logs

Use the narrowest predicate that still captures the problem.

```bash
log stream --style compact --predicate 'subsystem == "com.example.myapp"'
log stream --style compact --predicate 'subsystem == "com.example.myapp" AND category == "Account"'
log show --last 15m --style compact --predicate 'process == "MyApp" AND subsystem == "com.example.myapp"'
```

For noisy sessions, add level filters:

```bash
log show --last 15m --style compact --predicate 'subsystem == "com.example.myapp" AND message CONTAINS[c] "Failed"'
```

## Signposts

Use signposts for intervals you want to correlate with performance traces.

```swift
import OSLog

private let points = OSSignposter(subsystem: "com.example.myapp", category: "ImageImport")

func importImages() async throws {
    let state = points.beginInterval("ImportImages")
    defer { points.endInterval("ImportImages", state) }
    try await importer.run()
}
```

## Privacy Rules

- Never log tokens, passwords, private keys, full emails, payment data, or raw personal documents.
- Mark identifiers as `.private` unless they are intentionally public diagnostics.
- Prefer logging counts, booleans, enum states, and operation names.
- If a sensitive value is needed for correlation, log a safe derived value agreed by the team.

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Using `print` for app diagnostics | Use `Logger` with subsystem and category. |
| Logging auth tokens or full emails | Log redacted state or `.private` identifiers only. |
| One global category for everything | Use categories that match features or subsystems. |
| No instructions for reading logs | Provide `log stream` and `log show` predicates. |
| Adding logs everywhere | Log at boundaries: start, success, failure, retry, state transition. |
| Treating logs as tests | Add tests for behavior; use logs for runtime observation. |
