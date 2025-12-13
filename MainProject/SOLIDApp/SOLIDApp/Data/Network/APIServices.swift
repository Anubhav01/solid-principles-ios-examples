import Foundation

enum APIError: LocalizedError {
    case missingToken
    case invalidURL
    case noData
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    case encodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .missingToken:
            return "Authentication token not found. Please log in again."
        case .invalidURL:
            return "Invalid request URL"
        case .noData:
            return "No data received from server"
        case .invalidResponse:
            return "Invalid server response"
        case .httpError(let code):
            return "Server error (HTTP \(code))"
        case .decodingError:
            return "Failed to parse server response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .encodingError:
            return "Failed to encode request body"
        }
    }
}

protocol APIServiceProtocol {
    func fetchProfile(completion: @escaping (Result<UserProfileDTO, APIError>) -> Void)
    func updateProfile(data: UserProfileDTO, completion: @escaping (Result<UserProfileDTO, APIError>) -> Void)
}

class APIService: APIServiceProtocol {
    private let baseURL: String
    private let session: URLSession
    
    init(baseURL: String = "https://api.legacyapp.com/v1",
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func fetchProfile(completion: @escaping (Result<UserProfileDTO, APIError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "auth_token") else {
            completion(.failure(.missingToken))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/user/profile") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30
        
        executeRequest(request, completion: completion)
    }
    
    func updateProfile(data: UserProfileDTO, completion: @escaping (Result<UserProfileDTO, APIError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "auth_token") else {
            completion(.failure(.missingToken))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/user/profile") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
        } catch {
            completion(.failure(.encodingError(error)))
            return
        }
        
        executeRequest(request, completion: completion)
    }
    
    private func executeRequest(_ request: URLRequest, completion: @escaping (Result<UserProfileDTO, APIError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(UserProfileDTO.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
