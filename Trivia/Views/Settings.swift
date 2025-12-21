//
//  SettingsView.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//

import SwiftUI

struct Settings: View {
    
    @ObservedObject var gameVM: GameVM
  
    var body: some View {
        
        GeometryReader { geo in

            ZStack {
                
                BackgroundParchment()
                
                VStack {
                    // iPadBig w=1024 h=1322
                    // iPadMini w=744 h=1089
                    // iPhoneMax w=430 h=839
                   
//                    if (geo.size.height > 1080) {
//                        Spacer()
//                        SettingsCategories(gameVM: gameVM)
//                        Spacer()
//                        SettingsLevels(gameVM: gameVM)
//                        Spacer()
//                        SettingsSound(gameVM: gameVM)
//                        Spacer()
//                        SettingsDone(gameVM: gameVM)
//                        Spacer()
//                    } else {
                        ScrollView {
                            SettingsCategories(gameVM: gameVM)
                            SettingsLevels(gameVM: gameVM)
                            SettingsSound(gameVM: gameVM)
                        }
                        SettingsDone(gameVM: gameVM)
//                    }
                }
                .foregroundColor(.black)
                
            }

        }

    }
    
}

struct SettingsCategories : View {

    @ObservedObject var gameVM: GameVM

    var body: some View {
        
        Text("Select the categories to include")
            .font(.title)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding([.horizontal, .top])
        
        LazyVGrid(columns: [GridItem()]) {
            
            ForEach(0..<gameVM.categories.count, id: \.self) { i in
                
                if (gameVM.categories[i].active) {
                    ZStack(alignment: .trailing) {
                        Text(gameVM.categories[i].name)
                            .frame(width: 280, height:46)
                            .foregroundColor(.white)
                            .background(.brown)
                            .cornerRadius(10)
                            .shadow(radius: 7)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                            .padding(3)
                    }
                    .onTapGesture {
                        gameVM.categories[i].active = false
                    }
                } else {
                    ZStack(alignment: .trailing) {
                        Text(gameVM.categories[i].name)
                            .frame(width: 280, height:46)
                            .foregroundColor(.white)
                            .background(.brown)
                            .cornerRadius(10)
                            .shadow(radius: 7)
                            .opacity(0.6)
                        Image(systemName: "circle")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.6))
                            .shadow(radius: 1)
                            .padding(3)
                    }
                    .onTapGesture {
                        gameVM.categories[i].active = true
                    }
                }
                
            }
            
        }
    }
}

struct SettingsLevels: View {

    @ObservedObject var gameVM: GameVM
    
    var body: some View {
        Text("Select the difficulty levels to include")
            .font(.title)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding([.horizontal, .top])

        
        LazyVGrid(columns: [GridItem()]) {
            
            ForEach (0..<gameVM.levels.count, id: \.self) { i in
                
                if (gameVM.levels[i].active) {
                    ZStack(alignment: .trailing) {
                        Text(gameVM.levels[i].name)
                            .frame(width: 280, height:46)
                            .foregroundColor(.white)
                            .background(.brown)
                            .cornerRadius(10)
                            .shadow(radius: 7)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                            .padding(3)
                    }
                    .onTapGesture {
                        gameVM.levels[i].active = false
                    }
                } else {
                    ZStack(alignment: .trailing) {
                        Text(gameVM.levels[i].name)
                            .frame(width: 280, height:46)
                            .foregroundColor(.white)
                            .background(.brown)
                            .cornerRadius(10)
                            .shadow(radius: 7)
                            .opacity(0.6)
                        Image(systemName: "circle")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.6))
                            .shadow(radius: 1)
                            .padding(3)
                    }
                    .onTapGesture {
                        gameVM.levels[i].active = true
                    }
                }
                
            }
            
        }
    }
    

}

struct SettingsSound: View {
    
    @ObservedObject var gameVM: GameVM
    
    var body: some View {
        
        VStack {
            Text("Set the music and sound options")
                .font(.title)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding([.horizontal, .top])
            
            Toggle("Music", isOn: $gameVM.bMusicOn)
                .font(.title2)
                .toggleStyle(SwitchToggleStyle(tint: .brown))
                .frame(width: 280, alignment: .center)
                .padding(.top)
            Toggle("Sound Effects", isOn: $gameVM.bSoundOn)
                .font(.title2)
                .toggleStyle(SwitchToggleStyle(tint: .brown))
                .frame(width: 280, alignment: .center)
                .padding(.vertical)
        }
    }
}

struct SettingsDone: View {

    @ObservedObject var gameVM: GameVM

    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    
    var body: some View {
        
        Button {
            if (gameVM.areSettingsValid()) {
                showAlert = false
                gameVM.saveSettings()
                dismiss()
            } else {
                showAlert = true
            }
        } label : {
            Text("Done")
                .padding(.horizontal,20)
        }
        .doneButton()
        .alert("Please select at least one category and one difficulty level",isPresented: $showAlert) {
            Button("OK") { }
        }
    }
}

#Preview {
    Settings(gameVM: GameVM(repo: QuestionRepository()))
}
