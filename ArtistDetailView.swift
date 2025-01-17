import SwiftUI

struct ArtistDetailView: View {
    let artist: Artist
    @State private var concerts: [Concert] = []
    @State private var bandInfo: BandInfo? = nil
    @State private var isLoadingConcerts: Bool = true
    @State private var isLoadingBandInfo: Bool = true
    @State private var isBioExpanded: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack {
                    if let bandInfo = bandInfo {
                        AsyncImage(url: URL(string: bandInfo.image_url)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: UIScreen.main.bounds.height * 0.4)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: UIScreen.main.bounds.height * 0.4)
                        }
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .black.opacity(0.7),
                                        .clear.opacity(0.2),
                                        .black.opacity(0.7)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        VStack(spacing: 12) {
                            Text(artist.name)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text(artist.genre)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.bottom, 20)
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.4)
                
                LazyVStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About the Band")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text(isBioExpanded ? artist.bio : String(artist.bio.prefix(150)) + "...")
                            .font(.body)
                            .foregroundColor(.primary.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                            .onTapGesture {
                                withAnimation {
                                    isBioExpanded.toggle()
                                }
                            }

                        if artist.bio.count > 150 {
                            Text(isBioExpanded ? "Show less" : "Read more...")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .padding(.top, 5)
                                .onTapGesture {
                                    withAnimation {
                                        isBioExpanded.toggle()
                                    }
                                }
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    
                    if let bandInfo = bandInfo {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Band Stats")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                HStack(spacing: 24) {
                                    VStack(alignment: .leading) {
                                        Text(bandInfo.tracker_count.formatted())
                                            .font(.headline)
                                        Text("Followers")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(bandInfo.upcoming_event_count)")
                                            .font(.headline)
                                        Text("Upcoming Shows")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Follow on Social Media")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                if let links = bandInfo.links {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(links, id: \.url) { link in
                                                Link(destination: URL(string: link.url) ?? URL(string: "https://www.bandsintown.com")!) {
                                                    VStack(spacing: 8) {
                                                        Circle()
                                                            .fill(socialMediaColor(for: link.type))
                                                            .frame(width: 50, height: 50)
                                                            .overlay(
                                                                Image(systemName: socialMediaIcon(for: link.type))
                                                                    .foregroundColor(.white)
                                                                    .font(.system(size: 22))
                                                            )
                                                        
                                                        Text(link.type.capitalized)
                                                            .font(.caption)
                                                            .foregroundColor(.primary)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Upcoming Concerts")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        if isLoadingConcerts {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else if concerts.isEmpty {
                            Text("No concerts available.")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(concerts) { concert in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(formatDate(concert.date))
                                        .font(.headline)
                                    
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.red)
                                        Text("\(concert.venue), \(concert.city)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Button(action: {
                                    }) {
                                        HStack {
                                            Text("Buy Tickets")
                                                .fontWeight(.semibold)
                                            Image(systemName: "ticket.fill")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            fetchBandInfo()
            fetchConcerts()
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        return dateString
    }
    
    private func socialMediaColor(for type: String) -> Color {
        switch type.lowercased() {
        case "facebook": return Color(hex: "1877F2")
        case "twitter": return Color(hex: "1DA1F2")
        case "instagram": return Color(hex: "E4405F")
        case "youtube": return Color(hex: "FF0000")
        case "spotify": return Color(hex: "1DB954")
        default: return .gray
        }
    }
    
    private func socialMediaIcon(for type: String) -> String {
        switch type.lowercased() {
        case "facebook": return "f.square.fill"
        case "twitter": return "t.square.fill"
        case "instagram": return "camera.fill"
        case "youtube": return "play.rectangle.fill"
        case "spotify": return "music.note"
        default: return "link"
        }
    }
    
    private func fetchBandInfo() {
        guard let url = URL(string: "https://rest.bandsintown.com/artists/\(artist.name)?app_id=d67080d15f4aec732eb223177a870440") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedBandInfo = try JSONDecoder().decode(BandInfo.self, from: data)
                    DispatchQueue.main.async {
                        bandInfo = decodedBandInfo
                        isLoadingBandInfo = false
                    }
                } catch {
                    print("Failed to decode band info: \(error)")
                    DispatchQueue.main.async {
                        isLoadingBandInfo = false
                    }
                }
            }
        }.resume()
    }

    private func fetchConcerts() {
        guard let url = URL(string: "http://localhost:3000/concerts?artist_id=\(artist.id)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedConcerts = try JSONDecoder().decode([Concert].self, from: data)
                    DispatchQueue.main.async {
                        concerts = decodedConcerts
                        isLoadingConcerts = false
                    }
                } catch {
                    print("Failed to decode concerts: \(error)")
                    DispatchQueue.main.async {
                        isLoadingConcerts = false
                    }
                }
            }
        }.resume()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
