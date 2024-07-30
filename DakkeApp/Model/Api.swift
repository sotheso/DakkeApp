//
//  Api.swift
//  DakkeApp
//
//  Created by Sothesom on 09/05/1403.
//

import SwiftUI
import Combine

struct MyData: Codable, Identifiable {
    var id: Int
    var title: String
    var category: String
    
    init(id: Int, title: String, category: String) {
        self.id = id
        self.title = title
        self.category = category
    }
    
    var displayCategory: String {
        switch category {
        case "Omomi":
            return "عمومی"
        case "Varzrshi":
            return "ورزشی"
        case "Eghtesadi":
            return "اقتصادی"
        default:
            return category
        }
    }
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
