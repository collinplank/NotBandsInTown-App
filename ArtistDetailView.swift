import SwiftUI

struct ArtistDetailView: View {
    let artist: Artist
    @State private var concerts: [Concert] = []
    @State private var bandInfo: BandInfo? = nil
    @State private var isLoadingConcerts: Bool = true
    @State private var isLoadingBandInfo: Bool = true

    func iconForSocialMedia(type: String) -> String? {
        let socialMediaIcons = [
            "Facebook": "logo.facebook",
            "Twitter": "logo.twitter",
            "Instagram": "camera",
            "YouTube": "play.rectangle",
            "TikTok": "music.note",
            "LinkedIn": "briefcase",
            "Spotify": "music.note.list"
        ]
        return socialMediaIcons[type.capitalized] ?? "questionmark"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let bandInfo = bandInfo {
                    AsyncImage(url: URL(string: bandInfo.image_url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 250)
                            .cornerRadius(12)
                            .clipped()
                            .shadow(radius: 10)
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    }

                    Text(artist.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)

                    Text(artist.genre)
                        .font(.title2)
                        .foregroundColor(.secondary)

                    Text(artist.bio)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .multilineTextAlignment(.leading)

                    Text("Followers: \(bandInfo.tracker_count.formatted())")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.top, 10)

                    Text("Upcoming Concerts: \(bandInfo.upcoming_event_count)")
                        .font(.headline)
                        .foregroundColor(.primary)

                    if let links = bandInfo.links, !links.isEmpty {
                        Text("Follow \(artist.name):")
                            .font(.headline)
                            .padding(.top, 20)

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(links, id: \.url) { link in
                                let type = link.type.capitalized
                                let iconName = iconForSocialMedia(type: link.type)
                                
                                if let url = URL(string: link.url) {
                                    Link(destination: url) {
                                        HStack {
                                            if let iconName = iconName {
                                                Image(systemName: iconName)
                                                    .foregroundColor(.blue)
                                            }
                                            Text(type)
                                            Spacer()
                                            Image(systemName: "arrow.up.right.square")
                                        }
                                        .font(.body)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                } else if isLoadingBandInfo {
                    ProgressView("Loading artist info...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Failed to load artist info.")
                        .foregroundColor(.red)
                        .padding()
                }

                if isLoadingConcerts {
                    ProgressView("Loading concerts...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if concerts.isEmpty {
                    Text("No upcoming concerts.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    Text("Upcoming Concerts")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.top, 20)

                    ForEach(concerts) { concert in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(concert.date)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)

                            Text("\(concert.venue), \(concert.city)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Button(action: {
                                print("Buy tickets for \(concert.date) at \(concert.venue)")
                            }) {
                                Text("Buy Tickets")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                    .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 3)
                            }
                            .padding(.top, 10)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                        .padding(.horizontal)
                    }
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .onAppear {
            fetchBandInfo()
            fetchConcerts()
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
            } else {
                print("Failed to fetch band info: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    isLoadingBandInfo = false
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
            } else {
                print("Failed to fetch concerts: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    isLoadingConcerts = false
                }
            }
        }.resume()
    }
}
