import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Definitely Not Bandsintown")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, 60)
                    Spacer()
                }
                .padding([.leading, .trailing], 20)
                
                Text("Find Your Next Concert")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                NavigationLink(destination: ContentView()) {
                    Text("Explore Artists")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding([.leading, .trailing], 30)
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true) 
        }
    }
}
