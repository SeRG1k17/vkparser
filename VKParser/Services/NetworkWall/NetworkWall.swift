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
    
    private(set) var searchSubject = PublishSubject<String>()
    private(set) var loadedWallItems = PublishSubject<[WallItem]>()
    
    init(delegate: VKApiDelegate) {
        
        self.delegate = delegate
        super.init()
        
        registerObservables()
    }
    
    private func registerObservables() {
        
        searchSubject
            .subscribe(onNext: wallItems(for:))
            .disposed(by: rx.disposeBag)
    }
    
    private func wallItems(for userId: String) {
        
        VK.API.Wall.get([.ownerId: userId,
                         .count: "\(Constant.wallItemsCount)",
                         .extended: "\(Constant.extended)"])
            .onSuccess { data in
                self.processWallItems(by: data)
            }
            .send()
    }
    
    private func processWallItems(by data: Data) {

        do {
            let response = try JSONDecoder.vkDecoder.decode(WallResponseItem.self, from: data)
            loadedWallItems.onNext(response.wallItems)
            
        } catch {
            loadedWallItems.onNext([])
            print(error)
        }
    }
    
    func delete(item: WallItem, closure: ((WallItem) -> Void)? = nil) {
        
        VK.API.Wall.delete([.ownerId: String(item.ownerId),
                            .postId: String(item.id)])
            .onSuccess { data in
                
                guard
                    let response = try? JSONDecoder.vkDecoder.decode(DeleteResponse.self, from: data),
                    response.response == 1
                    else { return }
                
                closure?(item)
        }
        .send()
    }
}

private struct DeleteResponse: Codable {
    let response: Int
}

private extension JSONDecoder {
    
    static let vkDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
