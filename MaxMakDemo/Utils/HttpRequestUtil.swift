//
//  HttpRequestUtil.swift
//  CWChat
//
//  Created by maxmak on 2020/6/1.
//

import Foundation
import UIKit
public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}




class HttpRequestUtil : NSObject{
    //成功的闭包
    typealias SuccessClosure = (Data)->Void
    //参数错误的闭包
    typealias ParaFailClosure = (Any)->Void
    //网络错误的回掉
    typealias NetFailClosure = ()->Void
    //完成的闭包
    typealias CompleteClosure = ()->Void
    //展示提示框的视图
    private var onView:UIView?
    private var successClosure : SuccessClosure? = nil
    func successClosure(_ closure :  SuccessClosure?) -> Void {
        successClosure = closure
    }
    private var paraFailClosure : ParaFailClosure? = nil
    func paraFailClosure(_ closure : ParaFailClosure?) -> Void {
        paraFailClosure = closure
    }
    private var netFailClosure : NetFailClosure? = nil
    func netFailClosure(_ closure : NetFailClosure?) -> Void {
        netFailClosure = closure
    }
    private var completeClosure : CompleteClosure? = nil
    func completeClosure(_ closure : CompleteClosure?) -> Void {
        completeClosure = closure
    }
    //请求方法
    private var httpMethod : HTTPMethod
    //请求参数
    private var para : Dictionary<String,Any>
    //路径
    private var path : String
    private var paraEncoding = ParameterEncoding()
    /// 头部
    private var header : [String : String]!
    public init(path:String,method:HTTPMethod,onView:UIView? ,para:Dictionary<String, Any> = Dictionary() ,header: [String:String] = [String:String]()) {
        self.onView = onView;
        self.path = path
        self.httpMethod = method
        self.para = para
        self.header = header
        super.init()
        print("method : \(self.httpMethod.rawValue)")
        print("path : \(self.path)")
        print("para : \(self.para)")
        
        if httpMethod == .get{
            getRequest()
        }else if httpMethod == .post{
            postRequest()
        }
    }
    /// get请求
    private func getRequest(){
        
        guard let url = URL(string: self.path) else{return}
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        
        let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + paraEncoding.query(para)
        if !para.keys.isEmpty{
            urlComponents.percentEncodedQuery = percentEncodedQuery
        }
        
        guard let requestUrl = urlComponents.url else{return}
        
        var request = URLRequest(url: requestUrl)
        startRequest(with: &request,header: header)
    }
    /// post请求
    private func postRequest(){
        guard let url = URL(string: self.path) else{return}
        var request = URLRequest(url: url)
        request.httpBody = paraEncoding.query(para).data(using: .utf8, allowLossyConversion: false)
        startRequest(with: &request,header: header)
    }
    
    /// 启动http请求
    /// - Parameter request: URLRequest
    private func startRequest(with request : inout URLRequest , header : [String : String]){
        for (key , value) in header{
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = self.httpMethod.rawValue
        if httpMethod == .post{
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = paraEncoding.query(para).data(using: .utf8, allowLossyConversion: false)
        }else{
            
        }
        let queue = OperationQueue()
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: queue)
        let task = session.dataTask(with: request)
        task.resume()
    }
}
//MARK : 网络请求的回调
extension HttpRequestUtil: URLSessionDataDelegate{
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard error != nil else {
            return
        }
        DispatchQueue.main.async {
            defer{
                if self.completeClosure != nil {
                    self.completeClosure!()
                }
            }
            if self.onView != nil{
                /// 提示错误信息
                ToastUtil.show(text: "net error", onView: self.onView)
            }
            if self.netFailClosure != nil{
                self.netFailClosure!()
            }
        }
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void){
        completionHandler(.allow)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        DispatchQueue.main.async {
            defer{
                //必须放在最后面,不然会影响图片离线上传
                if self.completeClosure != nil {
                    self.completeClosure!()
                }
            }
            self.successClosure?(data)
        }
        
    }
    
}

fileprivate struct ParameterEncoding{
      fileprivate func query(_ parameters: [String: Any]) -> String {
          var components: [(String, String)] = []

          for key in parameters.keys.sorted(by: <) {
              let value = parameters[key]!
              components += queryComponents(fromKey: key, value: value)
          }
          return components.map { "\($0)=\($1)" }.joined(separator: "&")
      }
      public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
          var components: [(String, String)] = []

          if let dictionary = value as? [String: Any] {
              for (nestedKey, value) in dictionary {
                  components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
              }
          }
              /*
          else if let array = value as? [Any] {
              for value in array {
                  components += queryComponents(fromKey: arrayEncoding.encode(key: key), value: value)
              }
          } else if let value = value as? NSNumber {
              if value.isBool {
                  components.append((escape(key), escape(boolEncoding.encode(value: value.boolValue))))
              } else {
                  components.append((escape(key), escape("\(value)")))
              }
          } else if let bool = value as? Bool {
              components.append((escape(key), escape(boolEncoding.encode(value: bool))))
          }*/
          else {
              components.append((escape(key), escape("\(value)")))
          }

          return components
      }
      
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        var escaped = ""
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex

            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex

                let substring = string[range]

                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)

                index = endIndex
            }
        }

        return escaped
    }
}


