import Foundation

enum QuoteError: Error { case badResponse, decoding }

struct QuoteService {
    func fetchRandom() async throws -> Quote {
        let url = URL(string: "https://zenquotes.io/api/random")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("[API] \(request.httpMethod!) \(url)")
        // shows in console for screenshot

        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw QuoteError.badResponse }
        print("[API] Response: \(String(data: data, encoding: .utf8) ?? "")")       // raw JSON for screenshot

        guard let quote = try JSONDecoder().decode([Quote].self, from: data).first else {
            throw QuoteError.decoding
        }
        return quote
    }
}
