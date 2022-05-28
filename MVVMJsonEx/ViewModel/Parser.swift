//
//  Parser.swift
//  MVVMJsonEx
//
//  Created by Магомед Ахильгов on 26.05.2022.
//

import Foundation
import Alamofire

struct Parser {
    let url = "https://pryaniky.com/static/json/sample.json"
    
    func parseCells(completion: @escaping([String]) -> ()) {
        AF.request(url).responseDecodable(of:[Welcome].self) { (response) in
            let result = response.data
            do {
                let result = try JSONDecoder().decode(Welcome.self, from: result!)
                completion(result.view)
            } catch {
                print("error")
            }
        }.resume()
    }
    
    func parseDatum(completion: @escaping([Datum]) -> ()) {
        AF.request(url).responseDecodable(of:[Datum].self) { (response) in
            let result = response.data
            do {
                let result = try JSONDecoder().decode(Welcome.self, from: result!)
                completion(result.data)
            } catch {
                print("error")
            }
        }.resume()
    }
}
