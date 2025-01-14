import SwiftUI

struct ArtistDetailView: View {
    let artist: Artist

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

                Text("Genre: \(artist.genre)")
                    .font(.title2)
                    .foregroundColor(.secondary)

                Text(artist.bio)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)

            }
            .padding()
        }
        .navigationTitle("Artist Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
