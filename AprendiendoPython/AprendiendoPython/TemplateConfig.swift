//
//  TemplateConfig.swift
//  AprendiendoPython
//
//  Created by Domene on 25/04/21.
//

import Foundation

struct Template: Codable{
    
    struct simulation_steps: Codable {
        let line: Int
        let operation: [[String]]
    }
    
    struct textLine: Codable {
        let line: String
        let hasTf: Bool
    }
    
    let id: Int
    let title: String
    let topic: String
    let code: [textLine]
    let simulation: [simulation_steps]
}
    

struct configValues {
    static func getPlist() -> [Template] {
        guard let url = Bundle.main.url(forResource: "templates", withExtension: "plist") else {
            fatalError("Couldn't find templates.plist")
        }
        do {
            let data = try Data(contentsOf: url)
            print(data)
            let decoder = PropertyListDecoder()
            return try decoder.decode([Template].self, from: data)
        } catch let err {
            fatalError(err.localizedDescription)
        }
    }
}
