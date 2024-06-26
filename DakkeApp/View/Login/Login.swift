// 
//  Login.swift
//  DakkeApp
//
//  Created by Sothesom on 05/02/1403.
//

import SwiftUI
import Firebase
import Lottie

struct Login: View {
    
    @State private var activeTab : Tab = .login
    @State private var isLoading: Bool = false
    @State private var showEmailVerificationView: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""
    // Alert Properties
    @State private var alertMassege: String = ""
    @State private var showAlert: Bool = false
    // forgot password Properties
    @State private var showResetAlert: Bool = false
    @State private var resetAddressEmail: String = ""
    @AppStorage("log_status") private var logStatus: Bool = false


    var body: some View {
        NavigationStack{
            List{
                Section{
                    TextField("Email Address",text: $emailAddress)
                        .keyboardType(.emailAddress)
                        .customTextField("person")
                    
                    SecureField("Password", text: $password)
                        .customTextField("person", 0, activeTab != .login ? 10 : 0)
                    
                    if activeTab  == .SignUp {
                        SecureField("Re-Enter Password", text: $reEnterPassword)
                            .customTextField("person", 0, activeTab == .login ? 10 : 0)
                    }
                    
                } header:{
                    Picker("", selection: $activeTab) {
                        ForEach(Tab.allCases, id: \.rawValue) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(.init(top: 15, leading: 0, bottom: 15, trailing: 0))
                    .listRowSeparator(.hidden)
                    
                } footer:{
                    VStack(alignment: .trailing, spacing: 12, content: {
                        if activeTab == .login {
                            Button("Forget Password"){
                                showResetAlert = true
                            }
                            .font(.caption)
                            .tint(Color.accentColor)
                        }
                        
                        Button(action: loginAndSignUp, label:{
                            HStack(spacing: 12){
                                Text(activeTab == .login ? "Loging" : "Creat Account")
                                Image(systemName: "arrow.right")
                                    .font(.callout)
                            }
                            .padding(.horizontal, 10)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .showLoadingIndicator(isLoading)
                        .disabled(buttonStatus)
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 0))
                }
                .disabled(isLoading)
            }
            .animation(.snappy, value: activeTab)
            .listStyle(.insetGrouped)
            .navigationTitle("Welcome")
        }
        .sheet(isPresented: $showEmailVerificationView, content: {
            EmailVerficationView()
                .presentationDetents([.height(350)])
                .presentationCornerRadius(25)
                .interactiveDismissDisabled()
        })
        .alert(alertMassege, isPresented: $showAlert){ }
        .alert("Reset Password" ,isPresented: $showResetAlert, actions: {
            TextField("Email address", text: $resetAddressEmail)
            
            Button("Send reset link", role: .destructive, action: sendResetLink)
            
            Button("Cancel", role: .cancel){
                resetAddressEmail = ""
            }
        }, message: {
            Text("Enter the email address")
        })
        .onChange(of: activeTab, initial: false) { oldValue, newValue in
            password = ""
            reEnterPassword = ""
            
        }
    }
    
    // Email verification View
    @ViewBuilder
    func EmailVerficationView() -> some View {
        VStack(spacing: 6){
            GeometryReader{ _ in
                if let bundle =  Bundle.main.path(forResource: "Animation - 1714009106671", ofType: "json"){
                    LottieView {
                        await LottieAnimation.loadedFrom(url: URL(filePath: bundle))
                    }
                    .playing(loopMode: .loop)
                }
            }
            Text("Verification")
                .font(.title.bold())
            
            Text("We have sent a verification email to your email address Please verify to continue")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 25)
        }
        .overlay(alignment: .topTrailing, content: {
            Button("Cancel"){
                showEmailVerificationView = false
                // optional: You can delete the Account in firebase
//                if let user = Auth.auth().currentUser {
//                    user.delete{_ in
//                        
//                    }
//                }
            }
            .padding(15)
        })
        .padding(.bottom,15)
        
///I'm going to make use of SwiftUl's timer to refresh the user status every 2 seconds to verify whether the user's email address has been verified or not.
        .onReceive(Timer.publish(every: 2, on: .main, in: .default).autoconnect(), perform: { _ in
            if let user = Auth.auth().currentUser {
                user.reload()
                if user.isEmailVerified {
                    // Email Successfully Verified
                    showEmailVerificationView = false
                    logStatus = false
                }
            }
        })
    }
    
    func sendResetLink(){
        Task{
            do{
                if resetAddressEmail.isEmpty{
                    await presentAlert("Please enter an email address.")
                    return
                }
                
                isLoading = true
                try await Auth.auth().sendPasswordReset(withEmail: resetAddressEmail)
                await presentAlert("Please check your email inbox and follow the steps to reset your password!")
                resetAddressEmail = ""
                isLoading = false
                
            } catch{
                await presentAlert(error.localizedDescription)
            }
        }
    }
    
    func loginAndSignUp(){
        Task{
            isLoading = true
            do {
                if activeTab == .login {
                    // Logging in
                    let result = try await Auth.auth().signIn(withEmail: emailAddress, password: password)
                    if result.user.isEmailVerified {
                        // Verified User
                        // Redirect to Home View
                        logStatus = true
                    } else {
                        // send Verification Email and Presseting Verification View
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView  = true
                    }
                } else {
                    // Crating in
                    if password == reEnterPassword {
                        let result = try await Auth.auth().createUser(withEmail: emailAddress, password: password)
                        // Sending Verification email
                        try await result.user.sendEmailVerification()
                        // showing email verification view
                        showEmailVerificationView = true
                    } else {
                        await presentAlert("Mismatching Password")
                    }
                }
            } catch {
                await presentAlert(error.localizedDescription)
            }
        }
        ///Firebase makes email authentication simple. Now what I'm going to do is, whenever the "Login" button is pressed, I'm going to check if the given email has an account, and if so, I'll check if it's verified or not.
        ///If it's verified, then I will redirect the user to the home view. Otherwise, I will be sending a verification email to verify the user's email address.
        ///When the "Create Account" button is pressed, I will create a new account and will be sending a verification email to verify the user's email address.
    }
    // presenting alert
    func presentAlert(_ message: String) async {
        await MainActor.run{
            alertMassege = message
            showAlert = true
            isLoading = false
            resetAddressEmail = ""
        }
    }
    
    /// Tab type
    enum Tab: String, CaseIterable {
        case login = "Login"
        case SignUp = "Sign Up"
        
    }

    // button status
    var buttonStatus: Bool {
        if activeTab == .login {
            return emailAddress.isEmpty || password.isEmpty
        }
        return emailAddress.isEmpty || password.isEmpty || reEnterPassword.isEmpty
    }
}

// سفارشی کردن لیست
fileprivate extension View{
    
    @ViewBuilder
    func showLoadingIndicator(_ status: Bool) -> some View{
        self
            .animation(.snappy) {contet in
                contet
                    .opacity(status ? 0 : 1)
            }
            .overlay {
                if status {
                    ZStack{
                        Capsule()
                            .fill(.bar)
                        
                        ProgressView()
                    }
                }
            }
    }
    
    @ViewBuilder
    func customTextField(_ icon: String? = nil, _ paddingTop: CGFloat = 0, _ paddingBottom: CGFloat = 0) -> some View {
        HStack(spacing: 12){
            if let icon {
                Image(systemName: icon) // Added a space after 'if let icon'
                    .font(.title)
                    .foregroundStyle(.gray)
            }
            self
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(.bar, in: .rect(cornerRadius: 12))
        .padding(.horizontal, 15)
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ContentView()
}
