//
//  Quote.swift
//  Peace
//
//  Created by Joseph McCraw on 2/20/20.
//  Copyright © 2020 Joseph McCraw. All rights reserved.
//

import Foundation


struct Quote: Codable {
    var text: String
    var author: String
    
    var shareMessage: String {
        return "\"\(text)\" - \(author)"
    }
}
