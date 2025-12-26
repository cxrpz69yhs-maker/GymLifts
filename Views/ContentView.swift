import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Welcome")
                    .font(.largeTitle.bold())

                Text("Your fitness app is ready to go.")
                    .foregroundColor(.secondary)

                NavigationLink {
                    WorkoutsView()
                } label: {
                    Text("Go to Workouts")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.top, 80)
        }
    }
}

