//
//  Instructions.swift
//  Trivia
//
//  Created by Annabel Lim on 3/7/24.
//
import SwiftUI

struct Instructions: View {
    
    var body: some View {

        GeometryReader { geo in

            ZStack {
                
                BackgroundParchment()
                
                VStack {
                    // iPadBig w=1024 h=1322
                    // iPadMini w=744 h=1089
                    // iPhoneMax w=430 h=839
                    if (geo.size.width > 740) {
                        VStack {
                            Spacer()
                            InstructionsLogo()
                            InstructionsHowToPlay()
                            Spacer()
                            InstructionsCreditsButton()
                            Spacer()
                            InstructionsDone()
                            Spacer()
                        }
                        .frame(width: geo.size.width/1.5, height: geo.size.height, alignment: .center)

                    } else {
                        InstructionsLogo()
                        ScrollView {
                            InstructionsHowToPlay()
                            InstructionsCreditsButton()
                        }
                        InstructionsDone()
                    }

                }
                .foregroundColor(.black)
            }
            

        }

    }

}

struct InstructionsLogo: View {
    var body: some View {
        Image("appIconRounded")
            .resizable()
            .scaledToFit()
            .frame(width:150)
            .padding(.top)
        
    }
}

struct InstructionsHowToPlay: View {
    var body: some View {
        Text("How To Play")
            .font(.largeTitle)
            .padding()
        
        VStack(alignment: .leading) {
            
            Text("Welcome to Quark Trivia!  In this game you will be asked random questions from the categories and levels of difficulty you choose.")
                .padding([.horizontal,.bottom])
            
            Text("There are 20 questions per game. Each question is worth 5 points but if you guess a wrong answer, you lose a point! 😱")
                .padding([.horizontal, .bottom])
            
            Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score.")
                .padding([.horizontal, .bottom])
            
        }
        .font(.title3)
        
        Text("Good Luck!")
            .font(.title)
    }
}

struct InstructionsCreditsButton : View {

    @Environment(\.dismiss) private var dismiss
    @State private var showCredits = false
    
    var body: some View {
        Divider()
            .frame(width:300)
        Button {
            showCredits.toggle()
        } label: {
            Text("About Us")
                .font(.headline)
                .padding()
                .tint(.brown)
                .foregroundColor(.brown)
            
        }
        .fullScreenCover(isPresented: $showCredits) {
            Credits()
        }
        Divider()
            .frame(width:300)
    }
}

struct InstructionsDone: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label : {
            Text("Done")
                .padding(.horizontal,20)
        }
        .doneButton()
    }
}

#Preview {
    Instructions()
}
