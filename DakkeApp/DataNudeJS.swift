import SwiftUI
import Combine

struct ContentView2: View {
    @StateObject private var viewModel = MyDataViewModel() // Use @StateObject for initialization

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.myData) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.displayCategory)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

#Preview {
    ContentView2()
}

