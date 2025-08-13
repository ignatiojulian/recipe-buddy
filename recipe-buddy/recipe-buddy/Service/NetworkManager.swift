//
//  NetworkManager.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RecipeServiceError.networkError("Invalid response")
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw RecipeServiceError.networkError("HTTP Status: \(httpResponse.statusCode)")
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw RecipeServiceError.decodingError
            }
        } catch {
            if error is RecipeServiceError {
                throw error
            }
            throw RecipeServiceError.networkError(error.localizedDescription)
        }
    }
    
    func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw RecipeServiceError.networkError("Invalid response")
            }
            
            return data
        } catch {
            throw RecipeServiceError.networkError(error.localizedDescription)
        }
    }
}

