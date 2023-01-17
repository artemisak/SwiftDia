//
//  recommendationMesssage.swift
//  dia
//
//  Created by Артём Исаков on 15.08.2022.
//

import Foundation
import SQLite

func getMessage(highGI: Bool, manyCarbo: Bool, highBGBefore: Bool, lowPV: Bool, bg_pred: Double, isTrue: inout Bool) -> String {
    var txt = ""
    if (highGI && bg_pred >= 6.8) {
        txt = "Рекомендуется исключить из рациона или уменьшить количество " +
        "продуктов с высоким гликемическим индексом (более 55)"
    } else if (manyCarbo && bg_pred >= 6.8) {
        txt = "Рекомендовано уменьшить количество углеводов в приеме пищи"
    } else if (highBGBefore && bg_pred >= 6.8) {
        txt = "Высокий уровень глюкозы до еды. " +
        "Рекомендовано уменьшить количество углеводов во время перекусов."
    } else if (lowPV && bg_pred >= 6.8) {
        txt = "В последнее время в Вашем рационе было недостаточно пищевых волокон. " +
        "Добавьте в рацион разрешённые овощи, фрукты, злаковые, отруби " +
        "(см. обучающие материалы)."
    } else if (bg_pred >= 6.8) {
        txt = "Вероятно, уровень глюкозы после еды будет высоким, " +
        "рекомендована прогулка после приема пищи."
    }
    if txt != "" {
        isTrue = true
    }
    return txt
}


// если больше 3 раз за два дня

func checkGI(listOfFood: [food]) -> Bool {
    return listOfFood.contains(where: {$0.gi > 55})
}

func checkCarbo(foodType: String, listOfFood: [food]) -> Bool {
    var sum = 0.0
    for i in listOfFood {
        sum += i.carbo
    }
    if foodType == "Завтрак" && sum > 30 {
        return true
    } else if foodType != "" && sum > 60 {
        return true
    }
    return false
}

func checkBGBefore(BG0: Double) -> Bool {
    if BG0 > 6.7 {
        return true
    } else {
        return false
    }
}

func checkPV(listOfFood: [food], date: Date) -> Bool {
    var lowPV = false
    do {
        var sum = 0.0
        var sumToday = 0.0
        var sumYest = 0.0
        var listOfPV: [Double] = []
        
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        
        let food = Table("food")
        let id = Expression<String>("_id")
        let pv = Expression<Double?>("pv")
        for i in listOfFood {
            for i1 in try db.prepare(food.select(pv).filter(id == "\(i.table_id)")){
                listOfPV.append((i1[pv] ?? 0.0)*(i.gram ?? 0.0)/100)
            }
        }
        sum = listOfPV.reduce(0,+)
        listOfPV.removeAll()
        
        let diary = Table("diary")
        let id_food = Expression<Int>("id_food")
        let _date = Expression<String>("date")
        let g = Expression<String>("g")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        for i in try db.prepare(diary.select(id_food, g).filter(_date == dateFormatter.string(from: date))){
            for i1 in try db.prepare(food.select(pv).filter(id == "\(i[id_food])")){
                listOfPV.append((i1[pv] ?? 0.0)*(Double(i[g]) ?? 0.0)/100)
            }
        }
        sumToday = listOfPV.reduce(0,+)
        listOfPV.removeAll()
        
        let yest = date.addingTimeInterval(-60*60*24)
        for i in try db.prepare(diary.select(id_food, g).filter(_date == dateFormatter.string(from: yest))){
            for i1 in try db.prepare(food.select(pv).filter(id == "\(i[id_food])")){
                listOfPV.append((i1[pv] ?? 0.0)*(Double(i[g]) ?? 0.0)/100)
            }
        }
        sumYest = listOfPV.reduce(0,+)
        listOfPV.removeAll()
        
        if sum < 8 {
            lowPV = true
        } else if sum + sumToday < 20 {
            lowPV = true
        } else if sum + sumYest < 28 {
            lowPV = true
        }
//        если регулярно раз в три дня в день меньше 20
    }
    catch {
        print(error)
    }
    return lowPV
}
