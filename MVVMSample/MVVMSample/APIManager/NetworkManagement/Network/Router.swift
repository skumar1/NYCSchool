import Foundation
import UIKit


public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request<T:Codable>(_ route: EndPoint, customResponse: Bool,  responseClass: T.Type , completion:@escaping (Result<T?, Error>) -> Void)
    func cancel()
    
    func requestReturnDic(_ route: EndPoint,  completion:@escaping (Result<[String:Any], Error>) -> Void)
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request<T:Codable>(_ route: EndPoint, customResponse: Bool = false,  responseClass: T.Type , completion:@escaping (Result<T?, Error>) -> Void) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            print("request",request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                print(data ?? "")
                print(response)
                guard  error == nil else {
                    completion(.failure(MVVMSampleError.networkError(reason: .requestTimeOut)))
                    return
                }
                do {
                    guard let data = data else {
                        completion(.failure(error!))
                        return
                    }
                    guard let _ = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                        guard let _ = (try? JSONSerialization.jsonObject(with: data)) as? [Any] else {
                            return
                        }
                        let responseData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(responseData))
                        return
                    }
                    let check = self.handleResponse(data: data)
                    switch check {
                    case .success:
                        let jsonDecoder = JSONDecoder()
                        do{
                            if customResponse  {
                                let responseData = try jsonDecoder.decode(T.self, from: data)
                                completion(.success(responseData))
                            } else {
                                let responseData = try jsonDecoder.decode(APIResponse<T>.self, from: data)
                                completion(.success(responseData.data))
                            }
                        }catch{
                            let responseData = try jsonDecoder.decode(T.self, from: data)
                            completion(.success(responseData))
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                } catch {
                    completion(.failure(MVVMSampleError.jsonError(reason: .jsonDecodeError)))
                }
                
            })
        }catch {
            completion(.failure(error))
        }
        self.task?.resume()
    }
    
    
    
    func requestReturnDic(_ route: EndPoint, completion: @escaping (Result<[String:Any], Error>) -> Void){
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                
                guard  error == nil else {
                    completion(.failure(MVVMSampleError.networkError(reason: .requestTimeOut)))
                    return
                }
                do {
                    guard let data = data else {
                        completion(.failure(error!))
                        return
                    }
                    guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                        return
                    }
                    let check = self.handleResponse(data: data)
                    switch check {
                    case .success:
                        
                        guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                            completion(.failure(MVVMSampleError.jsonError(reason: .jsonDecodeError)))
                            return
                        }
                        
                        completion(.success(json))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(MVVMSampleError.jsonError(reason: .jsonDecodeError)))
                }
                
            })
        }catch {
            completion(.failure(error))
        }
        self.task?.resume()
    }
    
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        print("base url",route.baseURL)
        print("path",route.path)

        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    //
    //MARK: Check Code Status
    //
    private func handleResponse(data: Data?) -> ResponseResult{
        if let data = data {
            guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                return .failure(MVVMSampleError.jsonError(reason: .jsonDecodeError))
            }
            print(json)
            if  ( json[ErrorConstant.code] as? String) == ErrorConstant.failed {
                let reason = Validation().validate(responseData: json)
                return .failure(reason)
            }else if json[ErrorConstant.code] as? String == ErrorConstant.success {
                return .success
            }
        }
        return .failure(MVVMSampleError.jsonError(reason: .jsonDecodeError))
    }
    
}

enum ResponseResult {
    case success
    case failure(Error)
}
