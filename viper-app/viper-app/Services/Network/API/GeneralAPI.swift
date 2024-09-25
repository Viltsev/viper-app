//
//  GeneralAPI.swift
//  viper-app
//
//  Created by viltsevdanila on 25.09.2024.
//

import Foundation

class GeneralAPI {
    func getTodoList(completion: @escaping (Result<LocalTodos, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            }
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                
                do {
                    let serverTodo = try JSONDecoder().decode(ServerTodos.self, from: data)
                    let localTodo = TodoModelMapper().toLocal(serverEntity: serverTodo)
                    
                    DispatchQueue.main.async {
                        completion(.success(localTodo))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
    }
}

