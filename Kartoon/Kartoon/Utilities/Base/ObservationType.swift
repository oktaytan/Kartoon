//
//  ObservationType.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation

enum ObservationType<T, E> {
    case updateUI(data: T? = nil), error(error: E?)
}
