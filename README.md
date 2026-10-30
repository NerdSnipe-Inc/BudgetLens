# BudgetLens

[![Platform](https://img.shields.io/badge/platform-iOS%2018%2B%20%7C%20macOS%2015%2B-blue)](https://github.com/NerdSnipe-Inc/BudgetLens)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange)](https://github.com/NerdSnipe-Inc/BudgetLens)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Built with DesignFoundation](https://img.shields.io/badge/built%20with-DesignFoundation-8A2BE2)](https://github.com/NerdSnipe-Inc/design-foundation)

**BudgetLens** is an open-source [SwiftUI budget tracker and expense tracker app](https://github.com/NerdSnipe-Inc/BudgetLens)
for **iOS and macOS** — a full-source, production-quality example of a personal finance app,
[universal across iPhone, iPad, and Mac](https://github.com/NerdSnipe-Inc/BudgetLens), built from
real, reusable components instead of throwaway demo code. It's part of the same "Lens"
family of full-source example apps as [ScanLens](https://github.com/NerdSnipe-Inc/ScanLens),
[ClientLens](https://github.com/NerdSnipe-Inc/ClientLens), [BookLens](https://github.com/NerdSnipe-Inc/BookLens),
and [AICompleteChat](https://github.com/NerdSnipe-Inc/AICompleteChat), applying the same
[DesignFoundation](https://github.com/NerdSnipe-Inc/design-foundation) /
[DesignFoundation Pro](https://github.com/NerdSnipe-Inc/DesignFoundationPro) design system and
on-device [Apple Intelligence](https://github.com/NerdSnipe-Inc/BudgetLens) stack to a
structured-data use case instead of open-ended chat.

Every chart, stat card, and activity feed on the dashboard comes from
[DesignFoundation Pro's `Analytics` UI kit](https://github.com/NerdSnipe-Inc/DesignFoundationPro)
— nothing hand-rolled — and the "AI Insights" tab generates a real
[on-device spending summary](https://github.com/NerdSnipe-Inc/BudgetLens) via Apple's
[Foundation Models framework](https://github.com/NerdSnipe-Inc/BudgetLens), no server
round-trip, no API key, no cloud LLM cost.

Looking for a real-world **[SwiftUI expense tracker template](https://github.com/NerdSnipe-Inc/BudgetLens)**,
a working **[SwiftData example app](https://github.com/NerdSnipe-Inc/BudgetLens)**, or a
buildable reference for **[`LanguageModelSession` and `@Generable` structured output](https://github.com/NerdSnipe-Inc/BudgetLens)**
on iOS 26? This is a full app, not a snippet.

## Built With

- [**DesignFoundation**](https://github.com/NerdSnipe-Inc/design-foundation) — the free,
  open-source [SwiftUI design system](https://github.com/NerdSnipe-Inc/design-foundation) behind
  every button, text field, list row, and theme in this app.
- [**DesignFoundation Pro**](https://github.com/NerdSnipe-Inc/DesignFoundationPro) — the premium
  [SwiftUI analytics dashboard UI kit](https://github.com/NerdSnipe-Inc/DesignFoundationPro)
  (stat cards, charts, activity feeds, and 11 other full app verticals) that BudgetLens's
  Dashboard tab is assembled from wholesale.
- **Apple Foundation Models** — on-device [Apple Intelligence](https://github.com/NerdSnipe-Inc/BudgetLens)
  for the AI Insights tab, via `LanguageModelSession` and `@Generable`.
- **SwiftData** — local persistence for transactions and categories.

## Screenshots

### iPhone

| Dashboard | Trend & Breakdown | Activity |
|---|---|---|
| ![Dashboard overview](images/dashboard-overview.png) | ![Dashboard charts](images/dashboard-charts.png) | ![Dashboard activity feed](images/dashboard-activity.png) |

| Transactions | AI Insights | Categories |
|---|---|---|
| ![Transactions list](images/transactions.png) | ![On-device AI insight](images/ai-insights.png) | ![Categories list](images/categories.png) |

### Mac

The same SwiftUI codebase, unmodified, running natively on macOS — DesignFoundation's
cross-platform theming handles the desktop layout automatically, no `#if os(macOS)` needed in
app code.

| Dashboard | Transactions |
|---|---|
| ![macOS dashboard](images/mac-dashboard.png) | ![macOS transactions](images/mac-transactions.png) |

| AI Insights | Categories |
|---|---|
| ![macOS AI insight](images/mac-insights.png) | ![macOS categories](images/mac-categories.png) |

## What it does

- **A dashboard built from a real design system** — `DFAnalyticsOverviewScreen` and its stat
  card / line chart / bar chart / activity-feed blocks, fed with this month's real transaction
  data instead of a hand-built layout.
- **On-device AI spending insights** via `LanguageModelSession` and `@Generable` structured
  output (Apple Intelligence, iOS 26+) — a natural-language summary of how the month is going
  and one concrete suggestion, generated locally and gracefully degrading to an empty state on
  devices/OS versions without Apple Intelligence.
- **SwiftData persistence** for transactions and categories, with monthly budget limits per
  category.
- **Transaction and category management** built from DesignFoundation's core components
  (`DFList`, `DFEntityRow`, `DFTextField`, `DFPicker`, `DFDatePicker`, `DFEmptyState`).

## Requirements

- iOS 18+ or macOS 15+ (the Insights tab additionally requires iOS 26+ / macOS 26+ with Apple
  Intelligence enabled to actually generate on-device; the rest of the app works fully on the
  iOS 18 / macOS 15 baseline)
- Xcode 26+
- [xcodegen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`) — this repo has no
  committed `.xcodeproj`; regenerate it from `project.yml`
- **A [DesignFoundationPro](https://github.com/NerdSnipe-Inc/DesignFoundationPro) license.** This
  is the one intentional gate: the source here is meant to be read and learned from by anyone,
  but it only actually *builds* for someone with access to DesignFoundationPro, since the
  dashboard is assembled from its `Analytics` vertical rather than built from scratch.

  Without access, package resolution fails outright — you'll see something like this during
  `xcodegen generate` + build, or from Xcode's own package resolution:
  ```
  error: Failed to clone repository https://github.com/NerdSnipe-Inc/DesignFoundationPro.git:
      remote: Repository not found.
      fatal: repository 'https://github.com/NerdSnipe-Inc/DesignFoundationPro.git/' not found
  ```
  That's expected, not a bug in this repo: it means your GitHub account isn't on
  DesignFoundationPro's access list. [Grab a
  license](https://github.com/NerdSnipe-Inc/DesignFoundationPro) to fix it.

[DesignFoundation](https://github.com/NerdSnipe-Inc/design-foundation) (the free swift-ui design-system
core) is public and resolves automatically via Swift Package Manager.

## Building

```sh
git clone https://github.com/NerdSnipe-Inc/BudgetLens.git
cd BudgetLens
xcodegen generate
open BudgetLens.xcodeproj
```

Build and run the `BudgetLens` scheme (iOS, on a simulator or device) or the `BudgetLensMac`
scheme (native macOS app). The app seeds a month of sample transactions on first launch so the
dashboard and insights have real data immediately, on either platform.

## Architecture

```
BudgetLens/
  ContentView.swift          — four-tab shell: Dashboard, Transactions, Insights, Categories
  Models/
    Category.swift           — SwiftData model: name, icon, monthly limit
    Transaction.swift        — SwiftData model: amount, note, date, category
    SampleData.swift         — first-launch seed data
  Store/
    BudgetSummary.swift      — pure aggregation over transactions/categories (no SwiftData/SwiftUI
                                dependency — unit tested directly)
    CurrencyFormat.swift
  Dashboard/
    BudgetDashboardView.swift — maps BudgetSummary onto DFAnalyticsOverviewScreen.Configuration
  Transactions/               — DFList/DFEntityRow list + add-transaction sheet
  Categories/                 — category management + monthly limits
  Insights/
    BudgetInsightEngine.swift — LanguageModelSession + @Generable BudgetInsight, iOS 26+
    InsightsView.swift        — loading skeleton, generated insight card, unavailable fallback
```

The dashboard reuses DesignFoundationPro's `Analytics` vertical wholesale — only the data
mapping in `BudgetDashboardView` is app-specific. See DesignFoundationPro's own docs for how
that vertical is put together.

`project.yml` defines two application targets — `BudgetLens` (iOS) and `BudgetLensMac`
(macOS) — that both build from the same `BudgetLens/` source folder. No platform-conditional
code was needed beyond gating `#if os(iOS) .keyboardType(.decimalPad)` on the two numeric text
fields; DesignFoundation's theming and layout primitives handle the rest of the cross-platform
adaptation automatically.

## Related Projects

- DesignFoundation — the [free SwiftUI design system](https://github.com/NerdSnipe-Inc/design-foundation) this app (and its UI) is built on.
- DesignFoundation Pro — the [premium vertical UI kits for Swift](https://github.com/NerdSnipe-Inc/DesignFoundationPro) (Analytics, AI Chat, CRM, E-commerce, and more) BudgetLens's dashboard uses.
- [ScanLens](https://github.com/NerdSnipe-Inc/ScanLens) — the sibling full-source example app: an on-device AI document and receipt scanner built the same way.
- [ClientLens](https://github.com/NerdSnipe-Inc/ClientLens) — the sibling full-source example app: an on-device AI CRM/client tracker built the same way.
- [BookLens](https://github.com/NerdSnipe-Inc/BookLens) — the sibling full-source example app: an on-device AI reading tracker built the same way.
- AICompleteChat — the sibling full-source example app: an [on-device AI chat client example](https://github.com/NerdSnipe-Inc/AICompleteChat) built the same way.

## License

MIT — see [LICENSE](LICENSE). Note this only covers the code in *this* repo; DesignFoundationPro
is licensed separately (see its own repo).

---

**Keywords:** SwiftUI budget tracker, iOS expense tracker app, macOS budget app, personal
finance app SwiftUI, cross-platform SwiftUI app iOS and macOS, SwiftData example app,
on-device AI iOS app, on-device AI Mac app, Apple Intelligence example, Foundation Models
Swift example, LanguageModelSession @Generable, SwiftUI design system, SwiftUI analytics
dashboard, universal SwiftUI app example, open source iOS and macOS app example.
