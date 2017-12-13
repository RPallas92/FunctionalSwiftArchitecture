// MARK: - Mocks generated from file: FunctionalSwiftArchitecture/presentation/JokesPresentation.swift at 2017-12-13 16:27:23 +0000

//
//  JokesPresentation.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Cuckoo
@testable import FunctionalSwiftArchitecture

import Foundation
import FunctionalKit

class MockJokesView: JokesView, Cuckoo.Mock {
    typealias MocksType = JokesView
    typealias Stubbing = __StubbingProxy_JokesView
    typealias Verification = __VerificationProxy_JokesView
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: JokesView?

    func spy(on victim: JokesView) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "showGenericError", "returnSignature": "", "fullyQualifiedName": "showGenericError()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func showGenericError()  {
        
            return cuckoo_manager.call("showGenericError()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.showGenericError()
                    }
                })
        
    }
    

    struct __StubbingProxy_JokesView: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func showGenericError() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("showGenericError()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_JokesView: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func showGenericError() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("showGenericError()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class JokesViewStub: JokesView {
    

    

    
     func showGenericError()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}



class MockJokeCategoriesListView: JokeCategoriesListView, Cuckoo.Mock {
    typealias MocksType = JokeCategoriesListView
    typealias Stubbing = __StubbingProxy_JokeCategoriesListView
    typealias Verification = __VerificationProxy_JokeCategoriesListView
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: JokeCategoriesListView?

    func spy(on victim: JokeCategoriesListView) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "drawCategories", "returnSignature": "", "fullyQualifiedName": "drawCategories(categories: [CategoryViewModel])", "parameterSignature": "categories: [CategoryViewModel]", "parameterSignatureWithoutNames": "categories: [CategoryViewModel]", "inputTypes": "[CategoryViewModel]", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "categories", "call": "categories: categories", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("categories"), name: "categories", type: "[CategoryViewModel]", range: CountableRange(335..<366), nameRange: CountableRange(335..<345))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func drawCategories(categories: [CategoryViewModel])  {
        
            return cuckoo_manager.call("drawCategories(categories: [CategoryViewModel])",
                parameters: (categories),
                original: observed.map { o in
                    return { (args) in
                        let (categories) = args
                         o.drawCategories(categories: categories)
                    }
                })
        
    }
    
    // ["name": "showGenericError", "returnSignature": "", "fullyQualifiedName": "showGenericError()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func showGenericError()  {
        
            return cuckoo_manager.call("showGenericError()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.showGenericError()
                    }
                })
        
    }
    

    struct __StubbingProxy_JokeCategoriesListView: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func drawCategories<M1: Cuckoo.Matchable>(categories: M1) -> Cuckoo.StubNoReturnFunction<([CategoryViewModel])> where M1.MatchedType == [CategoryViewModel] {
            let matchers: [Cuckoo.ParameterMatcher<([CategoryViewModel])>] = [wrap(matchable: categories) { $0 }]
            return .init(stub: cuckoo_manager.createStub("drawCategories(categories: [CategoryViewModel])", parameterMatchers: matchers))
        }
        
        func showGenericError() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("showGenericError()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_JokeCategoriesListView: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func drawCategories<M1: Cuckoo.Matchable>(categories: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == [CategoryViewModel] {
            let matchers: [Cuckoo.ParameterMatcher<([CategoryViewModel])>] = [wrap(matchable: categories) { $0 }]
            return cuckoo_manager.verify("drawCategories(categories: [CategoryViewModel])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func showGenericError() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("showGenericError()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class JokeCategoriesListViewStub: JokeCategoriesListView {
    

    

    
     func drawCategories(categories: [CategoryViewModel])  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func showGenericError()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}



class MockJokeDetailView: JokeDetailView, Cuckoo.Mock {
    typealias MocksType = JokeDetailView
    typealias Stubbing = __StubbingProxy_JokeDetailView
    typealias Verification = __VerificationProxy_JokeDetailView
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: JokeDetailView?

    func spy(on victim: JokeDetailView) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "drawJoke", "returnSignature": "", "fullyQualifiedName": "drawJoke(joke: JokeViewModel)", "parameterSignature": "joke: JokeViewModel", "parameterSignatureWithoutNames": "joke: JokeViewModel", "inputTypes": "JokeViewModel", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "joke", "call": "joke: joke", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("joke"), name: "joke", type: "JokeViewModel", range: CountableRange(427..<446), nameRange: CountableRange(427..<431))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func drawJoke(joke: JokeViewModel)  {
        
            return cuckoo_manager.call("drawJoke(joke: JokeViewModel)",
                parameters: (joke),
                original: observed.map { o in
                    return { (args) in
                        let (joke) = args
                         o.drawJoke(joke: joke)
                    }
                })
        
    }
    
    // ["name": "showGenericError", "returnSignature": "", "fullyQualifiedName": "showGenericError()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func showGenericError()  {
        
            return cuckoo_manager.call("showGenericError()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.showGenericError()
                    }
                })
        
    }
    

    struct __StubbingProxy_JokeDetailView: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func drawJoke<M1: Cuckoo.Matchable>(joke: M1) -> Cuckoo.StubNoReturnFunction<(JokeViewModel)> where M1.MatchedType == JokeViewModel {
            let matchers: [Cuckoo.ParameterMatcher<(JokeViewModel)>] = [wrap(matchable: joke) { $0 }]
            return .init(stub: cuckoo_manager.createStub("drawJoke(joke: JokeViewModel)", parameterMatchers: matchers))
        }
        
        func showGenericError() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("showGenericError()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_JokeDetailView: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func drawJoke<M1: Cuckoo.Matchable>(joke: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == JokeViewModel {
            let matchers: [Cuckoo.ParameterMatcher<(JokeViewModel)>] = [wrap(matchable: joke) { $0 }]
            return cuckoo_manager.verify("drawJoke(joke: JokeViewModel)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func showGenericError() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("showGenericError()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class JokeDetailViewStub: JokeDetailView {
    

    

    
     func drawJoke(joke: JokeViewModel)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func showGenericError()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}



