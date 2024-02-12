//
//  ContentView.swift
//  Edutainment
//
//  Created by Izaan Saleem on 12/02/2024.
//

import SwiftUI

struct Question {
    let text: String
    let answer: Int
}

struct CustomText: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundStyle(.black)
            .fontWeight(.bold)
            .fontDesign(.monospaced)
    }
}


struct ContentView: View {
    @State private var selectedTable = 2
    @State private var numberOfQuestions = [5, 10, 20]
    @State private var numberOfQuestionsSelected = 5
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.green.opacity(0.75), .yellow.opacity(0.75)], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Spacer()
                CustomText(text: "Table of")
                
                HStack {
                    Button(action: {
                        withAnimation {
                            if selectedTable > 2 {
                                selectedTable -= 1
                            }
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 20)
                    
                    Text("\(selectedTable)")
                        .font(.title)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                    
                    Button(action: {
                        withAnimation {
                            if selectedTable < 12 {
                                selectedTable += 1
                            }
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 20)
                }
                .padding()
                
                CustomText(text: "No. of questions")
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        .frame(width: 300, height: 50)
                    
                    HStack(spacing: 0) {
                        ForEach(numberOfQuestions.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    numberOfQuestionsSelected = numberOfQuestions[index]
                                }
                            }) {
                                Text("\(numberOfQuestions[index])")
                                    .font(.title2)
                                    .fontDesign(.monospaced)
                                    .fontWeight(.semibold)
                                    .foregroundColor(numberOfQuestions[index] == numberOfQuestionsSelected ? .white : .black)
                                    .padding()
                                    .frame(width: 300 / CGFloat(numberOfQuestions.count))
                                    .background(numberOfQuestions[index] == numberOfQuestionsSelected ? Color.black : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                    }
                }
                .padding()
                
                Button {
                    withAnimation {
                        startGame()
                    }
                } label: {
                    Text("S T A R T")
                        .font(.title)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                }
                .frame(width: 300, height: 64)
                .foregroundStyle(.black)
                .background(Color.white.gradient)
                .clipShape(.rect(cornerRadius: 100))
                .padding()

                
                if !questions.isEmpty {
                    VStack {
                        CustomText(text: "Question \(currentQuestionIndex + 1) / \(numberOfQuestionsSelected)")
                        CustomText(text: questions[currentQuestionIndex].text)
                            .font(.title)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            
                            TextField("Enter your answer", text: $userAnswer)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .padding()
                        }
                        .frame(height: 50)
                        .padding()
                        
                        Button {
                            checkAnswer()
                        } label: {
                            Text("S U B M I T")
                                .font(.title)
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 300, height: 64)
                        .foregroundStyle(.black)
                        .background(Color.green)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding()
                    }
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Result"), message: Text("Your score is \(score)"), dismissButton: .default(Text("Play Again")) {
                            startGame()
                        })
                    }
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    
    func startGame() {
        questions = generateQuestions()
        currentQuestionIndex = 0
        score = 0
    }
    
    func generateQuestions() -> [Question] {
        var questions = [Question]()
        for _ in 0..<numberOfQuestionsSelected {
            let randomNumber = Int.random(in: 1...12)
            let questionText = "\(selectedTable) x \(randomNumber) = ?"
            let correctAnswer = selectedTable * randomNumber
            questions.append(Question(text: questionText, answer: correctAnswer))
        }
        return questions
    }
    
    func checkAnswer() {
        guard let userAnswerInt = Int(userAnswer) else { return }
        if userAnswerInt == questions[currentQuestionIndex].answer {
            score += 1
        }
        
        if currentQuestionIndex + 1 < numberOfQuestionsSelected {
            currentQuestionIndex += 1
        } else {
            showAlert = true
        }
        userAnswer = ""
    }
}

#Preview {
    ContentView()
}
