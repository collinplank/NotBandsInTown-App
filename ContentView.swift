import SwiftUI

struct ContentView: View {
    @State private var artists: [Artist] = []
    @State private var isLoading: Bool = true
    @State private var barHeights: [CGFloat] = Array(repeating: 40, count: 5)

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    loadingView
                } else if artists.isEmpty {
                    emptyStateView
                } else {
                    artistListView
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .onAppear(perform: fetchArtists)
    }

    private var loadingView: some View {
        VStack {
            ProgressView("Loading artists...")
                .font(.headline)

            animatedBarsView
                .padding(.top, 20)
        }
    }

    private var emptyStateView: some View {
        Text("No artists found.")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }

    private var artistListView: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("All Artists")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

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
    }

    private var animatedBarsView: some View {
        HStack(spacing: 8) {
            ForEach(0..<barHeights.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 12, height: barHeights[index])
                    .animation(
                        Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: barHeights[index]
                    )
                    .onAppear {
                        barHeights[index] = CGFloat.random(in: 30...80)
                    }
            }
        }
        .frame(height: 100)
    }

    private func fetchArtists() {
        guard let url = URL(string: "http://localhost:3000/artists") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching artists: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            do {
                let artistData = try JSONDecoder().decode([Artist].self, from: data)
                DispatchQueue.main.async {
                    self.artists = artistData
                    self.isLoading = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
        .resume()
    }
}
