// ContentView2.swift
// testApi
//
// Created by Sothesom on 09/05/1403.
//

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
                        Text(item.title)
                    }
                }
            }
            .navigationTitle("My Data")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct MyData: Codable, Identifiable {
    var id: Int
    var title: String
    var category: String
    // بقیه فیلدها
}

class APIService {
    static let shared = APIService()

    func fetchData(completion: @escaping (Result<[MyData], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:5500/api/papers") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([MyData].self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }.resume()
    }
}

class MyDataViewModel: ObservableObject {
    @Published var myData: [MyData] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchData()
    }

    func fetchData() {
        Future<[MyData], Error> { promise in
            APIService.shared.fetchData { result in
                promise(result)
            }
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            case .finished:
                break
            }
        }, receiveValue: { data in
            self.myData = data
        })
        .store(in: &cancellables)
    }
}

#Preview {
    ContentView2()
}

