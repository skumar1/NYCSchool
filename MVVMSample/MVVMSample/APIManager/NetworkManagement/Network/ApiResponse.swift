import Foundation

struct APIResponse<Wrapped: Decodable>: Decodable {
    let code: String?
    var data: Wrapped?
    var error: String?
   }
struct apiResponse<Wrapped: Decodable>: Decodable {
    let code: String?
    var data: [Wrapped]?
}
