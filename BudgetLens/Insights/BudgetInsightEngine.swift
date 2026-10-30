import Foundation

#if canImport(FoundationModels)
import FoundationModels

@available(iOS 26.0, macOS 26.0, *)
@Generable
struct BudgetInsight: Sendable {
    @Guide(description: "A short, punchy headline under 8 words summarizing this month's spending")
    var headline: String

    @Guide(description: "One to two sentences of supporting detail that reference the actual numbers provided")
    var detail: String

    @Guide(description: "One concrete, actionable suggestion for next month")
    var suggestion: String
}

/// Generates a natural-language spending summary entirely on-device via Apple's Foundation
/// Models framework — no network round trip, no API key. Mirrors the on-device inference
/// pattern from DesignFoundation's other example app (AICompleteChat), applied to a
/// structured-output use case instead of open-ended chat.
@available(iOS 26.0, macOS 26.0, *)
@MainActor
final class BudgetInsightEngine {
    private var session: LanguageModelSession?

    var isAvailable: Bool {
        switch SystemLanguageModel.default.availability {
        case .available: return true
        case .unavailable: return false
        }
    }

    func prewarm() {
        guard isAvailable else { return }
        let session = session ?? makeSession()
        self.session = session
        session.prewarm()
    }

    func generateInsight(for summary: BudgetSummary) async throws -> BudgetInsight {
        let session = session ?? makeSession()
        self.session = session

        let categoryLines = summary.categorySpend
            .prefix(5)
            .map { "\($0.category.name): \(CurrencyFormat.string($0.spent)) of \(CurrencyFormat.string($0.category.monthlyLimit)) budgeted" }
            .joined(separator: "\n")

        let prompt = """
        Here is this month's spending data:
        Total spent: \(CurrencyFormat.string(summary.totalSpent))
        Total budget: \(CurrencyFormat.string(summary.totalBudget))
        Remaining: \(CurrencyFormat.string(summary.remaining))
        Compared to last month: \(summary.percentDelta)

        By category:
        \(categoryLines)

        Summarize how this month is going and suggest one concrete change for next month.
        """

        let response = try await session.respond(to: prompt, generating: BudgetInsight.self)
        return response.content
    }

    private func makeSession() -> LanguageModelSession {
        LanguageModelSession {
            "You are a friendly, concise personal finance assistant. Be specific and use the numbers you're given. Never invent numbers that weren't provided."
        }
    }
}
#endif
