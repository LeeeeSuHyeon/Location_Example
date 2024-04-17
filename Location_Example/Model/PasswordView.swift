//
//  PasswordView.swift
//  Location_Example
//
//  Created by 이수현 on 4/17/24.
//

import SwiftUI
import Combine

struct PasswordStrengthView: View {
    @State private var password: String = ""
    @State private var isSpecialCharacterIncluded: Bool = false     // 특수문자 사용
    @State private var isAlphabeticCharacterIncluded: Bool = false  // 영어 사용
    @State private var isNumericCharacterIncluded: Bool = false     // 숫자 사용
    
    // 특수문자, 영어, 숫자 사용했으면 true
    private var isValidPassword: Bool {
        return isSpecialCharacterIncluded && isAlphabeticCharacterIncluded && isNumericCharacterIncluded
    }
    
    // 비밀번호 기준 통과면 "특수문자 사용" -> 우리는 버튼 활성화 정도로 하면 될듯 + 안내
    private var passwordStrengthText: String {
        if isValidPassword {
            return "Strong Password"
        } else {
            return "Password should contain at least one special character, one alphabetic character, and one numeric character."
        }
    }
    
    
    // 통과 여부에 따른 배경색
    private var passwordStrengthColor: Color {
        return isValidPassword ? .green : .red
    }
    
    // 통과 여부에 따른 글자색
    private var passwordStrengthForegroundColor: Color {
        return isValidPassword ? .white : .black
    }
    
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text(passwordStrengthText)
                .padding()
                .foregroundColor(passwordStrengthForegroundColor)
                .background(passwordStrengthColor)
                .cornerRadius(10)
                .padding()
            
            VStack{
                HStack{
                    // 특수문자 입력 여부에 따른 Image뷰 변경
                    if isSpecialCharacterIncluded {
                        checkMark()
                    }else{
                        xMark()
                    }
                    Text("특수문자 입력 ")
                }
                
                // 영문 입력 여부에 따른 Image뷰 변경
                HStack{
                    if isAlphabeticCharacterIncluded {
                        checkMark()
                    }else{
                        xMark()
                    }
                    Text("영문 입력 ")
                }
                
                // 숫자 입력 여부에 따른 Image뷰 변경
                HStack{
                    if isNumericCharacterIncluded {
                        checkMark()
                    }else{
                        xMark()
                    }
                    Text("숫자 입력 ")
                }
               
            }
        }
        // password를 구독해서 실시간으로 받아옴 (password 필드 값 == newPass)
        .onReceive(Just(password)) { newPass in
            // 특수문자 사용했으면 isSpecialCharacterIncluded = true
            self.isSpecialCharacterIncluded = newPass.rangeOfCharacter(from: .specialCharacters) != nil
            
            // 영어 사용했으면 isAlphabeticCharacterIncluded = true
            self.isAlphabeticCharacterIncluded = newPass.rangeOfCharacter(from: .letters) != nil
            
            // 숫자 사용했으면 isNumericCharacterIncluded = true
            self.isNumericCharacterIncluded = newPass.rangeOfCharacter(from: .decimalDigits) != nil
        }
    }
}

struct xMark : View {
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.red)
    }
}

struct checkMark : View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
    }
}

#Preview {
    PasswordStrengthView()
}

// 특수문자 키
extension CharacterSet {
    static var specialCharacters: CharacterSet {
        return CharacterSet(charactersIn: "!@#$%^&*()-_=+[{]}|;:'\",<.>/?")
    }
}
