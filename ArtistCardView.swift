import SwiftUI

struct ArtistCardView: View {
    let artist: Artist
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: artist.image_url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .cornerRadius(12)
                    .clipped()
                    .shadow(radius: 10)
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }

            Text(artist.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.top, 10)

            Text(artist.genre)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(.horizontal)
        .frame(width: 160) 
    }
}
