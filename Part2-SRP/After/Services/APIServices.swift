import Foundation

protocol APIServiceProtocol {
    func fetchProfile(completion: @escaping (Result<[String: Any], Error>) -> Void)
}

class APIService: APIServiceProtocol {
    func fetchProfile(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "auth_token") else { return }
        let url = URL(string: "https://api.legacyapp.com/v1/user/profile")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
