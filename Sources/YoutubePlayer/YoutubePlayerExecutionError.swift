//
//  YoutubePlayerExecutionError.swift
//  
//
//  Created by Nicholas Mata on 2/5/21.
//

import Foundation

enum YoutubePlayerExecutionError: Error {
    case unknown
    case unableToParse(Any?)
}
