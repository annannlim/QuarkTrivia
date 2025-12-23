//
//  Credits.swift
//  Trivia
//
//  Created by Annabel Lim on 3/14/24.
//

import SwiftUI

struct Credits: View {
        
    var body: some View {

        GeometryReader { geo in

            ZStack {
                
                BackgroundParchment()
                
                VStack {
//                     iPadBig w=1024 h=1322
//                     iPadMini w=744 h=1089
//                     iPhoneMax w=430 h=839
                    if (geo.size.width > 740) {
                        VStack {
                            Spacer()
                            CreditsLogo()
                            CreditsText()
                            Spacer()
                            CreditsVersionCopyright()
                            CreditsDone()
                            Spacer()
                        }
                        .frame(width: geo.size.width/1.5, height: geo.size.height, alignment: .center)

                    } else {
                        CreditsLogo()
                        ScrollView {
                            CreditsText()
                        }
                        CreditsVersionCopyright()
                        CreditsDone()
                    }

                }
                .foregroundColor(.black)
            }
        
        }
        .statusBarHidden()
    }

}

struct CreditsLogo: View {
    var body: some View {
        Image("appIconRounded")
            .resizable()
            .scaledToFit()
            .frame(width: 150)
            .padding(.top)
        
    }
}

struct CreditsText: View {
    var body: some View {
        Text("Quark Trivia")
            .font(.largeTitle)
            .padding()
        
        VStack(alignment: .center) {
            
            Text("Content provided by the-trivia-api.com")
                .multilineTextAlignment(.center)
                .padding([.horizontal, .bottom])
            
            Text("Music created by Rob Gillette")
                .multilineTextAlignment(.center)
                .padding([.horizontal,.bottom])
            
            Text("Icon and images sourced from Pixabay.com")
                .multilineTextAlignment(.center)
                .padding([.horizontal, .bottom])

        }
        .font(.title3)
    }
}

struct CreditsVersionCopyright: View {
    var body: some View {
        Text("Version \(getVersion())")
        Text(getCopyright())
            .multilineTextAlignment(.center)
    }
}


struct CreditsDone: View {
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label : {
            Text("OK")
                .padding(.horizontal, 28)
        }
        .doneButton()
    }
}


func getVersion() -> String{
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    return appVersionString
}


func getCopyright() -> String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    let yearString = dateFormatter.string(from: date)
    return "Copyright © \(yearString) Quark Solutions, Inc."
}

#Preview {
    Credits()
}
