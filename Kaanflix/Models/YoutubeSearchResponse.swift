//
//  YoutubeSearchResponse.swift
//  Kaanflix
//
//  Created by Kaan Odabaş on 16.08.2023.
//

import Foundation



struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
