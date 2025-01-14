import Foundation

struct Artist: Identifiable, Hashable, Decodable {
    let id: Int
    let name: String
    let genre: String
    let bio: String
    let image_url: String
}
