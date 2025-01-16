struct BandInfo: Decodable {
    let id: String
    let name: String
    let image_url: String
    let facebook_page_url: String?
    let tracker_count: Int
    let upcoming_event_count: Int
    let links: [Link]?

    struct Link: Decodable {
        let type: String
        let url: String
    }
}

