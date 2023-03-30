//
//  CustomError.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation

enum CustomError: String {
    case notFound = "Something went wrong!"
    case parse = "Error occured. Try again."
    case failure = "Try again."
    case invalidPath = "Invalid path of json file"
}
