import SwiftUI

struct ArtistCardView: View {
    let artist: Artist

    var body: some View {
        VStack {
            ArtistImageView(imageURL: artist.image_url)
                .padding(.top, 12)
            
            ArtistDetailsView(name: artist.name)
                .padding(.top, 8)
        }
        .frame(width: 200)
        .padding(.horizontal)
    }
}

struct ArtistImageView: View {
    let imageURL: String

    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
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
    }
}

struct ArtistDetailsView: View {
    let name: String

    var body: some View {
        Text(name)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

