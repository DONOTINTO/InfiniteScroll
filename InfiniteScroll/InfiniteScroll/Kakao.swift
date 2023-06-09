//
//  Kakao.swift
//  InfiniteScroll
//
//  Created by 이중엽 on 2023/05/24.
//

import Foundation

struct Kakao: Decodable {
    var documents: [Documents]
}

struct Documents: Decodable {
    var blogname: String
    var contents: String
    var title: String
    var thumbnail: String
    var url: String
}
