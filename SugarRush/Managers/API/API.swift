import SwiftUI

struct UserRequest: Codable {
    let login: String
    let pass: String
    let metod: String
    let record: String?
}

enum NetworkingError: Error {
    case invalidStatusCode(Int)
    case decodingFailed(Error)
    case requestFailed(Error)
    case noDataReceived
}

struct UserResponse: Codable {
    let status: String
    let message: String
    let data: [Int]?
}

struct RecordData: Codable {
    let login: String
    let record: Int
}

struct Record2: Codable {
    let login: String
    let record: Int
}

struct UserResponse2: Codable {
    let status: String
    let message: String
    let data: [Record2]?
}

struct APIManager {
    func registerUser(login: String, pass: String, completion: @escaping (UserResponse?) -> Void) {
        guard let url = URL(string: "https://smartpuzzle.website/record.php") else {
            print("Error: Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = UserRequest(login: login, pass: pass, metod: "signup", record: nil)
        request.httpBody = try? JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: Invalid HTTP status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Error: No data received")
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(result)
            } catch {
                print("Error: JSON decoding failed: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }

    func loginUser(login: String, pass: String, completion: @escaping (UserResponse?) -> Void) {
        guard let url = URL(string: "https://smartpuzzle.website/record.php") else {
            print("Error: Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = UserRequest(login: login, pass: pass, metod: "login", record: nil)
        request.httpBody = try? JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: Invalid HTTP status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Error: No data received")
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(result)
            } catch {
                print("Error: JSON decoding failed: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }

    func saveUserRecord(login: String, pass: String, record: String, completion: @escaping (UserResponse?) -> Void) {
        guard let url = URL(string: "https://smartpuzzle.website/record.php") else {
            print("Error: Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = UserRequest(login: login, pass: pass, metod: "create", record: record)
        request.httpBody = try? JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: Invalid HTTP status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Error: No data received")
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(result)
            } catch {
                print("Error: JSON decoding failed: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }

    func getUserRecords(login: String, pass: String, completion: @escaping (Result<UserResponse, NetworkingError>) -> Void) {
        guard let url = URL(string: "https://smartpuzzle.website/record.php") else {
            print("Error: Invalid URL")
            completion(.failure(.requestFailed(NSError(domain: "Invalid URL", code: 0, userInfo: nil))))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = UserRequest(login: login, pass: pass, metod: "read_my_records", record: nil)
        request.httpBody = try? JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidStatusCode((response as? HTTPURLResponse)?.statusCode ?? 0)))
                return
            }

            guard let data = data else {
                completion(.failure(.noDataReceived))
                return
            }

            do {
                let result = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }

        task.resume()
    }

    func getAllRecords(completion: @escaping (UserResponse2?) -> Void) {
        guard let url = URL(string: "https://smartpuzzle.website/record.php") else {
            print("Error: Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = UserRequest(login: "toto", pass: "chtoto", metod: "read_all_records", record: nil)
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: Invalid HTTP status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Error: No data received")
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(UserResponse2.self, from: data)
                completion(result)
            } catch {
                print("Error: JSON decoding failed: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

