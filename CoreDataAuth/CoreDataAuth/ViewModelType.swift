//
//  ViewModelType.swift
//  CoreDataAuth
//
//  Created by NH on 8/26/25.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
