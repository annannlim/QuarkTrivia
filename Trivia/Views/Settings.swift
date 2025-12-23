//
//  SettingsView.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//

import SwiftUI

struct Settings: View {
    
    @Environment(GameVM.self) private var gameVM
  
    var body: some View {
        
        GeometryReader { geo in

            ZStack {
                
                BackgroundParchment()
                
                VStack {
                        ScrollView {
                            SettingsCategories()
                            SettingsLevels()
                            SettingsSound()
                        }
                        SettingsDone()
                }
                .foregroundColor(.black)
                
            }

        }
        .statusBarHidden()

    }
    
}

struct SettingsCategories : View {

    @Environment(GameVM.self) private var gameVM

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

    @Environment(GameVM.self) private var gameVM

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
    
    @Environment(GameVM.self) var gameVM
    
    var body: some View {
    
        @Bindable var gameVM = gameVM

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

    @Environment(GameVM.self) private var gameVM
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
    Settings()
        .environment(GameVM())
}
