//
//  LoginHome.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 22/04/2023.
//

import Foundation
import SwiftUI

enum Field: Hashable {
    case usernameField
    case passwordField
}

struct LoginHome: View {
    @State private var page: LoginPages = LoginPages.MyRatedList
    
    @StateObject var userStatus = LoginViewModel()
    
    @State private var usernameForm = ""
    @State private var passwordForm = ""
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            if (userStatus.isLoggedIn) {
                switch page {
                case .MyRatedList:
                    RatedQuerier(title: page.rawValue,
                                 urlString: "https://api.tournesol.app/users/me/contributor_ratings/videos/",
                                 token: UserDefaults.standard.string(forKey: "access_token")!,
                                 page: page
                    )
                    .navigationTitle(page.rawValue)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ShareLink(
                                item: "https://tournesol.app/users/\(UserDefaults.standard.string(forKey: "username")!)/recommendations",
                                subject: Text("My Tournesol recommendations"),
                                message: Text("Have a look at my Tournesol recommendations!")
                            )
                            {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu(content: {
                                Button(action: {
                                    userStatus.logout()
                                }) {
                                    Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                                }
                                Picker("", selection: Binding(
                                    get: {
                                        self.page
                                    }, set: { (newValue) in
                                        self.page = newValue
                                    }))
                                {
                                    ForEach(LoginPages.allFilters, id: \.self)
                                    {
                                        filter in
                                        Label(filter.rawValue, systemImage: filter.icon())
                                    }
                                }
                            }, label: {Image(systemName: "ellipsis.circle")})
                        }
                    }
                case .MyRateLaterList:
                    RatedQuerier(title: page.rawValue,
                                 urlString: "https://api.tournesol.app/users/me/rate_later/videos/",
                                 token: UserDefaults.standard.string(forKey: "access_token")!,
                                 page: page
                    )
                    .navigationTitle(page.rawValue)
                    .toolbar {
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu(content: {
                                Button(action: {
                                    userStatus.logout()
                                }, label: {
                                    Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                                })
                                Picker("", selection: Binding(
                                    get: {
                                        self.page
                                    }, set: { (newValue) in
                                        self.page = newValue
                                    }))
                                {
                                    ForEach(LoginPages.allFilters, id: \.self)
                                    {
                                        filter in
                                        Label(filter.rawValue, systemImage: filter.icon())
                                    }
                                }
                            }, label: {Image(systemName: "ellipsis.circle")})
                        }
                    }
                }
            } else {
                Form {
                    TextField("Username", text: $userStatus.username)
                    SecureField("Password", text: $userStatus.password)
                    Button("Sign In") {
                        userStatus.login()
                    }
                    .disabled(userStatus.isLoading || userStatus.username.isEmpty || userStatus.password.isEmpty)
                }
                .navigationTitle("Log in")
            }
        }
    }
}


