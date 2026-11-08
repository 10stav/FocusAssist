import SwiftUI

@MainActor
@Observable
final class SessionViewModel {
    var minutes = 25
    var remaining = 0
    var state: SessionState = .idle
    var quote: Quote?
    var isLoading = false
    var errorMessage: String?
    private var tickTask: Task<Void, Never>?

    func start() {
        remaining = minutes * 60
        state = .running
        tickTask?.cancel()
        tickTask = Task {
            while remaining > 0 && !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { return }
                remaining -= 1
            }
            if !Task.isCancelled { state = .completed }
        }
        Task { await loadQuote() }
    }

    func reset() {
        tickTask?.cancel()
        remaining = 0
        quote = nil
        state = .reset
    }

    func loadQuote() async {
        isLoading = true
        errorMessage = nil
        do {
            quote = try await QuoteService().fetchRandom()
        } catch {
            errorMessage = "Couldn't load a quote."
        }
        isLoading = false
    }
}
