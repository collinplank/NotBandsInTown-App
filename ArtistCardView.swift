import SwiftUI

struct ArtistCardView: View {
    let artist: Artist
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: artist.image_url)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .frame(width: 160, height: 160)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 160)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 160, height: 160)
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.top, 12)

            VStack(alignment: .center, spacing: 6) {
                Text(artist.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 8)
        }
        .padding(16)
        .background(
            Color.white
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
        )
        .frame(width: 200)
        .padding(.horizontal)
    }
}
