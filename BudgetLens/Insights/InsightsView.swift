import SwiftUI
import SwiftData
import DesignFoundation

struct InsightsView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query(sort: \Category.name) private var categories: [Category]

    private var summary: BudgetSummary {
        BudgetSummary.compute(transactions: transactions, categories: categories)
    }

    var body: some View {
        NavigationStack {
            Group {
                #if canImport(FoundationModels)
                if #available(iOS 26.0, macOS 26.0, *) {
                    AIInsightsContent(summary: summary)
                } else {
                    unavailableState
                }
                #else
                unavailableState
                #endif
            }
            .navigationTitle("AI Insights")
        }
    }

    private var unavailableState: some View {
        DFEmptyState(
            icon: "sparkles",
            title: "Requires Apple Intelligence",
            message: "On-device spending insights need iOS 26 (or macOS 26) with Apple Intelligence enabled."
        )
    }
}

#if canImport(FoundationModels)
import FoundationModels

@available(iOS 26.0, macOS 26.0, *)
private struct AIInsightsContent: View {
    let summary: BudgetSummary

    @State private var engine = BudgetInsightEngine()
    @State private var insight: BudgetInsight?
    @State private var isGenerating = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !engine.isAvailable {
                    DFEmptyState(
                        icon: "sparkles",
                        title: "Apple Intelligence unavailable",
                        message: "Turn on Apple Intelligence in Settings to generate insights on this device."
                    )
                } else if isGenerating {
                    DFSkeleton(shape: .roundedRectangle(cornerRadius: 8)).frame(height: 20)
                    DFSkeleton(shape: .roundedRectangle(cornerRadius: 8)).frame(height: 60)
                    DFSkeleton(shape: .roundedRectangle(cornerRadius: 8)).frame(height: 40)
                } else if let insight {
                    DFCard {
                        VStack(alignment: .leading, spacing: 8) {
                            DFText(insight.headline, scale: .headline)
                            DFText(insight.detail, scale: .body)
                            Divider()
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "lightbulb.fill")
                                DFText(insight.suggestion, scale: .caption)
                            }
                        }
                        .padding()
                    }
                    DFButton("Regenerate", style: .outlined) {
                        Task { await generate() }
                    }
                } else if let errorMessage {
                    DFEmptyState(icon: "exclamationmark.triangle", title: "Couldn't generate insight", message: errorMessage)
                }
            }
            .padding()
        }
        .task {
            engine.prewarm()
            await generate()
        }
    }

    private func generate() async {
        guard engine.isAvailable else { return }
        isGenerating = true
        errorMessage = nil
        defer { isGenerating = false }
        do {
            insight = try await engine.generateInsight(for: summary)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
#endif
