//
//  SentenceEntry.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/26.
//

import Foundation

struct SentenceEntry: Codable {
    let context: [SingleSentence]
}

struct SingleSentence: Codable {
    let value: String
    let group: String
}
