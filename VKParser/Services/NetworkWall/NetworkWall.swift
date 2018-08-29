//
//  VKApi.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import SwiftyVK
import RxSwift
import NSObject_Rx

class NetworkWall: NSObject, NetworkWallService {
    
    private let delegate: VKApiDelegate
    
    struct Constant {
        static let wallItemsCount = 10
        static let extended = true
    }
    
    init(delegate: VKApiDelegate) {
        
        self.delegate = delegate
        super.init()
    }
    
    func wallItems(for userId: String) -> Observable<[WallItem]> {
        
        return response(.get([.ownerId: userId,
                        .count: "\(Constant.wallItemsCount)",
                        .extended: "\(Constant.extended)"]))
            .map(WallResponseItem.init(by:))
            .catchErrorJustReturn(WallResponseItem.empty)
            .map { $0.wallItems }
    }
    
    func delete(item: WallItem) -> Observable<Void> {
        
        return response(.delete([.ownerId: String(item.ownerId),
                                 .postId: String(item.id)]))
            .filter { self.processAction(by: $0) }
            .map { _ in }
    }
    
    func edit(item: WallItem, text: String) -> Observable<Void> {
        
        return response(.edit([.ownerId: String(item.ownerId),
                        .postId: String(item.id),
                        .message: text]))
            .filter { self.processAction(by: $0) }
            .map { _ in }
    }
    
    private func response(_ endPoint: VK.API.Wall) -> Observable<Data> {
        
        return Observable.create { observer in
            
            let task = endPoint
                .onSuccess {
                    observer.onNext($0)
                    observer.onCompleted()
                }
                .onError {
                    print($0)
                    observer.onError($0)
                }
                .send()
            
            return Disposables.create {
                task.cancel()
            }
        }.catchErrorJustReturn(Data())
    }
    
    private func processWallItems(by data: Data) throws -> [WallItem] {
        
        let response = try JSONDecoder.vkDecoder.decode(WallResponseItem.self, from: data)
        return response.wallItems
    }
    
    private func processAction(by data: Data) -> Bool {
        
        struct ActionResponse: Codable {
            let response: Int
        }
        
        guard let response = try? JSONDecoder.vkDecoder.decode(ActionResponse.self, from: data) else { return false }
        
        return response.response == 1
    }
}

extension JSONDecoder {
    
    static let vkDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
