//
//  LoginComponent.swift
//  ApolloGraphQLSPA
//
//  Created by Kielan Lemons on 6/6/18.
//  Copyright © 2018 Kielan Lemons. All rights reserved.
//

import Foundation
import CoreArchitecture

// MARK: - State

struct LoginState: State {
    
    enum Change {
        case loadingState
        case error
    }
    
    var loadingState = ActivityTracker()
    var error: Error?
    var changelog: [Change] = []
}

class LoginComponent: Component<LoginState> {
    
    let service: LoginService
    let navigator: Navigator
    
    init(service: LoginService, state: LoginState, navigator: Navigator) {
        self.service = service
        self.navigator = navigator
        super.init(state: state)
    }
    
    func loginCommand(with credentials: Credentials) -> LoginCommand {
        return LoginCommand(service: service, credentials: credentials)
    }
    //component flux reducer
    override func process(_ action: Action) {
        if let navigation = navigator.resolve(action) {
            commit(navigation)
        } else {
            guard let action = action as? LoginAction else { return }
            var state = self.state
            state.changelog = []
            switch action {
            case .addActivity:
                state.loadingState.addActivity()
                state.changelog = [.loadingState]
            case .removeActivity:
                state.loadingState.removeActivity()
                state.changelog = [.loadingState]
            case .error(let error):
                state.error = error
                state.changelog = [.error]
            }
            
            commit(state)
        }
    }
}

// MARK: - Commands

class LoginCommand: Command {
    
    let service: LoginService
    let credentials: Credentials
    
    init(service: LoginService, credentials: Credentials) {
        self.service = service
        self.credentials = credentials
    }
    
    func execute(on component: Component<LoginState>, core: Core) {
        core.dispatch(LoginAction.addActivity)
        service.login(with: credentials) { (result) in
            core.dispatch(LoginAction.removeActivity)
            switch result {
            case .success(let response):
                core.dispatch(LoginNavigatorAction.login(response))
            case .failure(let error):
                core.dispatch(LoginAction.error(error))
            }
        }
    }
}
