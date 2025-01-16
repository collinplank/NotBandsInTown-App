import SwiftUI

struct ContentView: View {
    @State private var artists: [Artist] = []
    @State private var isLoading: Bool = true
    @State private var barHeights = [30, 50, 40, 60, 50]  // Music wave animation heights

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
                    VStack {
                        // Music Waveform Animation at the top
                        HStack(spacing: 8) {
                            ForEach(0..<5, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.black)
                                    .frame(width: 10, height: CGFloat(barHeights[index]))
                                    .animation(
                                        Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.1),
                                        value: barHeights[index]
                                    )
                                    .onAppear {
                                        barHeights[index] = Int.random(in: 30...80)
                                    }
                            }
                        }
                        .padding(.top, 20)  // Adds space between wave and content

                        // Artist Cards below the waveform
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 20) {
                            ForEach(artists, id: \.self) { artist in
                                NavigationLink(destination: ArtistDetailView(artist: artist)) {
                                    ArtistCardView(artist: artist)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Artists")
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
