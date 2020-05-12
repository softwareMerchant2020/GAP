//
//  Chapter.swift
//  Gap International
//
//  Created by Sangeetha Gengaram on 2/28/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
struct Chapter: Codable {
    let name: String
    let url: String
}
struct ChapterList:Codable {
    var Chapters:[Chapter]?
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        Chapters = try values.decodeIfPresent([Chapter].self, forKey: .Chapters)
    }
}
