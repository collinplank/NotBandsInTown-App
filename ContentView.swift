import SwiftUI

struct ContentView: View {
    @State private var artists: [Artist] = []
    @State private var isLoading: Bool = true
    @State private var barHeights = [30, 50, 40, 60, 50]

    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Loading artists...")
                    .font(.headline)
            } else if artists.isEmpty {
                Text("No artists found.")
                    .font(.subheadline)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        HStack(spacing: 8) {
                            ForEach(0..<5, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                                    .frame(width: 12, height: CGFloat(barHeights[index]))
                                    .animation(
                                        Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.2),
                                        value: barHeights[index]
                                    )
                                    .onAppear {
                                        barHeights[index] = Int.random(in: 30...80)
                                    }
                            }
                        }
                        .frame(height: 100)
                        .padding(.top, 20)

                        Text("All Artists")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        VStack(spacing: 16) {
                            ForEach(artists, id: \.self) { artist in
                                NavigationLink(destination: ArtistDetailView(artist: artist)) {
                                    ArtistCardView(artist: artist)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white)
                                                .shadow(color: .gray.opacity(0.4), radius: 6, x: 2, y: 4)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("")
                .navigationBarHidden(true)
            }
        }
        .onAppear(perform: fetchArtists)
    }

    func fetchArtists() {
        guard let url = URL(string: "http://localhost:3000/artists") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching artists: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let artistData = try JSONDecoder().decode([Artist].self, from: data)
                DispatchQueue.main.async {
                    self.artists = artistData
                    self.isLoading = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }
}
