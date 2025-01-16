import SwiftUI

struct HomePageView: View {
    @State private var searchText: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var barHeights = [30, 50, 40, 60, 50]

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 24) {
                    Spacer()

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
                    .padding(.top, 20)

                    VStack(spacing: 4) {
                        Text("Definitely Not")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .minimumScaleFactor(0.5)

                        Text("Bandsintown")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .minimumScaleFactor(0.5)
                    }

                    Text("Find Your Next Concert")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                        .padding(.horizontal, 40)

                    NavigationLink(destination: ContentView()) {
                        Text("Explore Artists")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.2), radius: 6, x: 0, y: 4)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 16)

                    VStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 2)
                                .frame(height: 140)
                                .padding(.horizontal, 40)

                            VStack(spacing: 12) {
                                if isLoggedIn {
                                    Button(action: {
                                        isLoggedIn = false
                                    }) {
                                        Text("Logout")
                                            .font(.system(size: 16, weight: .bold))
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.blue, .purple]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                            .shadow(color: Color.blue.opacity(0.2), radius: 6, x: 0, y: 4)
                                    }
                                } else {
                                    Button(action: {
                                        isLoggedIn = true
                                    }) {
                                        Text("Login")
                                            .font(.system(size: 16, weight: .bold))
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.blue, .purple]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                            .shadow(color: Color.blue.opacity(0.2), radius: 6, x: 0, y: 4)
                                    }
                                }

                                Button(action: {
                                }) {
                                    Text("Sign Up")
                                        .font(.system(size: 16, weight: .bold))
                                        .padding(.vertical, 8) 
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue, .purple]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.blue.opacity(0.2), radius: 6, x: 0, y: 4)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 24)

                    Spacer()
                }
                .padding(.top, 40)
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
