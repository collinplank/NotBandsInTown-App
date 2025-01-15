import SwiftUI

struct ArtistDetailView: View {
    let artist: Artist
    @State private var concerts: [Concert] = []
    @State private var isLoading: Bool = true

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: artist.image_url)) { image in
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
                    .lineLimit(nil)

                if isLoading {
                    ProgressView("Loading concerts...")
                        .progressViewStyle(CircularProgressViewStyle())
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
        .navigationTitle("Artist Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchConcerts()
        }
    }

    private func fetchConcerts() {
        guard let url = URL(string: "http://localhost:3000/concerts?artist_id=\(artist.id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedConcerts = try JSONDecoder().decode([Concert].self, from: data)
                    DispatchQueue.main.async {
                        concerts = decodedConcerts
                        isLoading = false
                    }
                } catch {
                    print("Failed to decode concerts: \(error)")
                    DispatchQueue.main.async {
                        isLoading = false
                    }
                }
            } else {
                print("Failed to fetch concerts: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
        }.resume()
    }
}
