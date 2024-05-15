//
//  API.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeData(_ data: Data) throws -> Response
}

class API {
    static var url = "https://pokeapi.co/api/v2"
    
    static var shared = API()
    
    enum APIError: Error, LocalizedError {
        case unknownError
        case APIRequestFailed
        case GenericAPIRequestFailed
        case SpecificPokemonRequestFailed
        case ImageFetchFailed
        case GenerationAPIRequestFailed
    }
    
    func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let session = URLSession.shared
        let (data, _) = try await session.data(for: request.urlRequest)
        return try request.decodeData(data)
    }
}
