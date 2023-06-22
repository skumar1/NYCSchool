import Foundation
import UIKit
public struct UploadParameterEncoding: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        let bodyBoundary = "--------------------------\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(bodyBoundary)", forHTTPHeaderField: "Content-Type")
        
        var parameter: [String:Any]?
        if let imageData = parameters["imageData"] as? Data , let key = parameters["key"] as? String , let fileName = parameters["fileName"] as? String{
            if let param = parameters["param"] as? [String:Any] {
                parameter = param
            }
            let requestData = createRequestBody(param: parameter, imageData: imageData, boundary: bodyBoundary, attachmentKey: key, fileName: fileName)
            
            urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
            urlRequest.httpBody = requestData
        }
    }
    
    func createRequestBody(param: [String:Any]?, imageData: Data, boundary: String, attachmentKey: String, fileName: String) -> Data{
        let lineBreak = "\r\n"
        var requestBody = Data()
        if let parameters = param {
            for (key, value) in parameters {
                requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
                requestBody.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak+lineBreak)" .data(using: .utf8 )!)
                requestBody.append("\(value as? String ?? "" + lineBreak)" .data(using: .utf8 )!)
            }
        }
        requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)

        requestBody.append("Content-Disposition: form-data; name=\"\(attachmentKey)\"; filename=\"\(fileName).jpg\"\(lineBreak)" .data(using: .utf8)!)
        requestBody.append("Content-Type: image/* \(lineBreak + lineBreak)" .data(using: .utf8)!)
        // you can change the type accordingly if you want to
        requestBody.append(imageData)
        requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        
        return requestBody
    }
}
