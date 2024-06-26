//
//  TestApi.swift
//  DakkeApp
//
//  Created by Sothesom on 08/02/1403.
//

import SwiftUI

struct TestApi: View {
    
    @State private var user: GetNews?
    
    var body: some View {
        VStack{
            
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 150)

            
            Text(user?.login ?? "Login persen")
                .font(.title2)
            
            Text(user?.bio ?? "data")
                .font(.caption)
            
            Spacer()
                
        }
        .padding(70)
        
// کارایی که قبل از بالا اومدن صفحه باید انجام بده
        .task {
            do{
            user = try await gettingNews()
            } catch SefareshiError.invalidURL{
                print("error URL")
            } catch SefareshiError.invalidResponse{
                print("error Response")
            } catch SefareshiError.invalidData{
                print("error Data")
            } catch {
                print("error")
            }
        }
    }

// async چون میخوایم پرتاب کنیم
// throws چون ممکنه ارور داشته باشه
    func gettingNews() async throws -> GetNews{
        let endpoint = "https://api.github.com/users/sotheso"

// این استرینگ بالایی رو اینجا تبدیل به یو ار ال کردیم
        guard let url = URL(string: endpoint) else {throw SefareshiError.invalidURL}
        
// دانلود کردن این یو ار ال
        let (data, response) = try await URLSession.shared.data(from: url)

// چک کردن وضعیت درخواستی که فرستادیم
// که اگه ۲۰۰ باشه یعنی اوکیه
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw SefareshiError.invalidResponse }

// حالا دیتایی که اون بالا گرفتیم رو ایجا رمز گشایی میکنیم
        do{
            let decoder = JSONDecoder()
            // این یه خط کد پایین برای اینکه ما توی دیتامون یو ار ال داریم
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GetNews.self, from: data)
        } catch {
            throw SefareshiError.invalidData
        }
    }
}

#Preview {
    TestApi()
}

struct GetNews: Codable{
    let login: String
    let avatarUrl: String
    let bio: String
}

enum SefareshiError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
