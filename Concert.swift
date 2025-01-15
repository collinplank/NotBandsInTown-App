import Foundation

struct Concert: Identifiable, Codable {
    var id: Int
    var date: String
    var venue: String
    var city: String
    var artist_id: Int
}
