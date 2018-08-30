//
//  RealmClient.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/19/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import RealmSwift

class RealmClient {

    // MARK: - Fetch

    func fetch<T: Object>(action: ((Realm, Results<T>) -> Results<T>)?) -> Observable<[T]> {

        let result = withRealm(#function) { realm -> Observable<[T]> in

            var models = realm.objects(T.self)

            if let action = action {
                models = action(realm, models)
            }

            return Observable.array(from: models, synchronousStart: true)
        }

        return result ?? .error(RealmClientError.fetch)
    }

    // MARK: - Create

    func create<T: Object>(model: T, action: ((Realm, T) -> Void)?) -> Observable<T> {

        let result = withRealm(#function) { realm -> Observable<T> in

            try realm.write {

                action?(realm, model)
                realm.add(model)
            }

            return .just(model)
        }

        return result ?? .error(RealmClientError.create(model))
    }

    // MARK: - Update

    func update<T: Object>(model: T, action: ((Realm, T) -> Void)? = nil) -> Observable<T> {

        let result = withRealm(#function) { realm -> Observable<T> in

            try realm.write {

                action?(realm, model)
                realm.add(model, update: true)
            }

            return .just(model)
        }

        return result ?? .error(RealmClientError.update(model))
    }

    func updateMany<T: Object>(models: [T], merge: ((Realm, T, T) -> T)) -> Observable<[T]> {

        let result = withRealm(#function) { realm -> Observable<[T]> in

            var newModels: [T] = []

            try realm.write {

                newModels = models.map { model in

                    guard
                        let key = T.primaryKey(),
                        let dbModel = realm.object(ofType: T.self, forPrimaryKey: model[key])
                        else { return model }

                    return merge(realm, dbModel, model)
                }

                realm.add(newModels, update: true)
            }

            realm.refresh()

            return .just(newModels)
        }

        return result ?? .error(RealmClientError.updateMany(models))
    }

    // MARK: - Delete

    func delete<T: Object>(model: T, action: ((Realm, T) -> Void)? = nil) -> Observable<Void> {

        let result = withRealm(#function) { realm -> Observable<Void> in

            do {
                try realm.write {
                    action?(realm, model)
                    realm.delete(model)
                }
                return .empty()

            } catch {
                print(error)
                return .error(error)
            }
        }

        return result ?? .error(RealmClientError.delete(model))
    }

    func delete<T: Object>(models: [T], action: ((Realm, [T]) -> Void)? = nil) -> Observable<Void> {

        let result = withRealm(#function) { realm -> Observable<Void> in

            do {
                try realm.write {
                    action?(realm, models)
                    realm.delete(models)
                }
                return .empty()

            } catch {
                print(error)
                return .error(error)
            }
        }

        return result ?? .error(RealmClientError.deleteMany(models))
    }

    private func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {

        do {
            let realm = try Realm()
            return try action(realm)

        } catch let err {
            print("Failed with \(operation) realm with err: \(err)")
            return nil
        }
    }
}
