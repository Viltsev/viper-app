//
//  BaseModelMapper.swift
//  viper-app
//
//  Created by viltsevdanila on 25.09.2024.
//

import Foundation

class BaseModelMapper<S, L> {
    func toLocal(list: [S]?) -> [L] {
        guard let list = list else { return [] }
        return list.compactMap { $0 }
            .map { entity -> L in
                return toLocal(serverEntity: entity)
            }
    }
    
    func toLocal(serverEntity: S) -> L {
        preconditionFailure("This method must be overriden")
    }
    
    func toLocal(serverEntity: S?) -> L? {
        guard let serverEntity = serverEntity else { return nil }
        
        let model = self.toLocal(serverEntity: serverEntity)
        return model
    }
}
