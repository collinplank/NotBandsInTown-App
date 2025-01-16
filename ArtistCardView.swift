import SwiftUI

struct ArtistCardView: View {
    let artist: Artist
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: artist.image_url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 160)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }

            VStack(alignment: .center, spacing: 6) {
                Text(artist.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                
                Text(artist.genre)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 8)
        }
        .padding(16)
        .background(
            Color.white
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .frame(width: 180)
        .padding(.horizontal)
    }
}
