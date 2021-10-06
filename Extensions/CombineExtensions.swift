//
//  CombineExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/13/21.
//

import Combine
import Foundation
import CombineExt

public protocol Bindable: AnyObject {

    var cancellables: Set<AnyCancellable> { get set }

}

extension Publisher {
    
    func share<Target: Bindable>(target: Target, receiveValue: @escaping (Self.Output) -> Void) -> AnyPublisher<Self.Output, Self.Failure> {
        let sharedPublisher = self.share()
        sharedPublisher
            .ignoreFailure()
            .onValue(target: target, receiveValue: receiveValue)
        return sharedPublisher.eraseToAnyPublisher()
    }
    
    func bind<Target: Bindable>(target: Target, receiveCompletion: @escaping ( Subscribers.Completion<Self.Failure>) -> Void, receiveValue: @escaping (Self.Output) -> Void) {
        return self
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                receiveCompletion(completion)
            }, receiveValue: { output in
                receiveValue(output)
            }).store(in: &target.cancellables)
    }
}

extension Publisher where Self.Failure == Never {
    func onValue<Target: Bindable>(target: Target, receiveValue: @escaping (Self.Output) -> Void) {
        return self
            .receive(on: RunLoop.main)
            .sink(receiveValue: { output in
                receiveValue(output)
            }).store(in: &target.cancellables)
    }
}

extension Publishers {
    static func onValues<Target: Bindable, T: Publisher, Q: Publisher>(target: Target,
                                                                       _ publisher1: T,
                                                                       _ publisher2: Q,
                                                                       receiveValue: @escaping (T.Output, Q.Output) -> ())
    where T.Failure  == Never, Q.Failure == Never {
        Publishers.CombineLatest(publisher1, publisher2)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { output1, output2 in
                receiveValue(output1, output2)
            }).store(in: &target.cancellables)
    }
    
    static func asyncAfter<Q>(deadline: DispatchTime, completion: @escaping () -> (Q)) -> AnyPublisher<Q, Error>  {
        return Deferred<Future> {
            Future<Q, Error> { promise in
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    promise(.success(completion()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func tryAsyncAfter<Q>(deadline: DispatchTime, completion: @escaping () throws -> (Q)) -> AnyPublisher<Q, Error>  {
        return Deferred<Future> {
            Future<Q, Error> { promise in
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    do {
                        promise(.success(try completion()))
                    } catch let error {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}

extension Collection {
    func onValues(target: Bindable, receiveValue: @escaping ([Self.Element.Output]) -> Void)
    where Self.Element: Publisher, Self.Element.Failure == Never {
        return self
            .combineLatest()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { values in
                receiveValue(values)
            }).store(in: &target.cancellables)
    }
}


extension NSObject: Bindable {

    private struct AssociatedKeys {
        static var CancellablesKey = "CancellablesKey"
    }

    private final class Wrapped<T> {
        let value: T
        init(_ x: T) {
            value = x
        }
    }

    public var cancellables: Set<AnyCancellable> {
        get {
            if let cancellables = objc_getAssociatedObject(self, &NSObject.AssociatedKeys.CancellablesKey) as? Wrapped<Set<AnyCancellable>> {
                return cancellables.value
            } else {
                let cancellables = Set<AnyCancellable>()
                objc_setAssociatedObject(self, &NSObject.AssociatedKeys.CancellablesKey, Wrapped(cancellables), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellables
            }
        }
        set {
            objc_setAssociatedObject(self, &NSObject.AssociatedKeys.CancellablesKey, Wrapped(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
