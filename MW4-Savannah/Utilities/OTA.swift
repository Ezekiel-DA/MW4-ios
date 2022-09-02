//
//  OTA.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 8/30/22.
//

import Foundation

let manifestURL = "http://mw4-firmware-release.s3-website-us-east-1.amazonaws.com/deployment.json"

struct OTAManifest : Decodable {
    let type: String
    let version: Int
    let host: String
    let bin: String
}

func fetchManifest() async throws -> OTAManifest {
    let decoder = JSONDecoder()
    
    let (data, _) = try await URLSession.shared.data(from: URL(string: manifestURL)!)
    return try decoder.decode(OTAManifest.self, from: data)
}

func fetchFirmwareFile(_ url: String) async throws -> Data {
    let fwURL = URL(string: url)
    let (data, _) = try await URLSession.shared.data(from: fwURL!)
    
    return data
}
