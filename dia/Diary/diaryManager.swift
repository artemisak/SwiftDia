import Foundation
import SQLite

enum foodListErorrs: Error {
    case generalError
}

class diaryManager {
    
    static let provider = diaryManager()
    
    func SaveToDB(FoodName: String, gram: String, table_id: String, selectedDate: Date, selectedType: String) {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let diary = Table("diary")
            let id_food = Expression<Int>("id_food")
            let foodName = Expression<String>("foodName")
            let g = Expression<String>("g")
            let date = Expression<String>("date")
            let time = Expression<String>("time")
            let timeStamp = Expression<String>("timeStamp")
            let type = Expression<String>("foodType")
            let picker = Expression<String>("dateTime")
            
            let dateFormatter = DateFormatter()
            let dateFormatter1 = DateFormatter()
            let dateFormatter2 = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
            dateFormatter1.locale = Locale(identifier: "ru_RU")
            dateFormatter1.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
            dateFormatter2.locale = Locale(identifier: "ru_RU")
            dateFormatter2.setLocalizedDateFormatFromTemplate("HH:mm")
            
            let realDateTime = dateFormatter.string(from: Date.now)
            let selectDate = dateFormatter1.string(from: selectedDate)
            let dtime = dateFormatter2.string(from: selectedDate)
            try db.run(diary.insert(id_food <- convertToInt(txt: table_id), foodName <- FoodName, g <- gram, date <- selectDate, time <- dtime,timeStamp <- realDateTime, type <- selectedType, picker <- dtime+" "+selectDate))
        }
        catch {
            print(error)
        }
    }
    
    func checkIfAlreadyEx(selectedDate: Date, idForDelete: [Int]) -> Bool {
        if idForDelete.isEmpty {
            do {
                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let path = documents + "/diacompanion.db"
                let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
                _=copyDatabaseIfNeeded(sourcePath: sourcePath)
                let db = try Connection(path)
                let diary = Table("diary")
                let date = Expression<String>("date")
                let time = Expression<String>("time")
                let dateFormatter1 = DateFormatter()
                let dateFormatter2 = DateFormatter()
                dateFormatter1.locale = Locale(identifier: "ru_RU")
                dateFormatter1.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
                dateFormatter2.locale = Locale(identifier: "ru_RU")
                dateFormatter2.setLocalizedDateFormatFromTemplate("HH:mm")
                if Array(try db.prepare(diary.select(date,time).filter(date == dateFormatter1.string(from: selectedDate) && time == dateFormatter2.string(from: selectedDate)))).isEmpty{
                    return false
                } else {
                    return true
                }
            }
            catch {
                print(error)
                return true
            }
        } else {
            return false
        }
    }
    
    func addPredictedRecord(selectedDate: Date, selectedType: String, BG0: Double, BG1: Double) {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let predicted = Table("predicted")
            let _timeStamp = Expression<String>("timeStamp")
            let _date = Expression<String>("date")
            let _time = Expression<String>("time")
            let _priem = Expression<String>("priem")
            let _BG0 = Expression<Double>("BG0")
            let _BG1 = Expression<Double>("BG1")
            let dateFormatter = DateFormatter()
            let dateFormatter1 = DateFormatter()
            let dateFormatter2 = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
            dateFormatter1.locale = Locale(identifier: "ru_RU")
            dateFormatter1.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
            dateFormatter2.locale = Locale(identifier: "ru_RU")
            dateFormatter2.setLocalizedDateFormatFromTemplate("HH:mm")
            let realDateTime = dateFormatter.string(from: Date.now)
            let selectDate = dateFormatter1.string(from: selectedDate)
            let dtime = dateFormatter2.string(from: selectedDate)
            try db.run(predicted.insert(_timeStamp <- realDateTime, _date <- selectDate, _time <- dtime, _priem <- selectedType, _BG0 <- BG0, _BG1 <- BG1))
        }
        catch {
            print(error)
        }
    }
    
    func addNewFood(items: [foodItem], newReceitName: String, category: String, isEditing: Bool, idToDelete: Int?, imageURL: String?) {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let food = Table("food")
            let table_id = Expression<Int>("_id")
            let foodName = Expression<String>("name")
            let cat = Expression<String>("category")
            let carbo = Expression<Double?>("carbo")
            let prot = Expression<Double?>("prot")
            let fat = Expression<Double?>("fat")
            let ec = Expression<Double?>("ec")
            let gi = Expression<Double?>("gi")
            let water = Expression<Double?>("water")
            let nzhk = Expression<Double?>("nzhk")
            let hol = Expression<Double?>("hol")
            let pv = Expression<Double?>("pv")
            let zola = Expression<Double?>("zola")
            let na = Expression<Double?>("na")
            let k = Expression<Double?>("k")
            let ca = Expression<Double?>("ca")
            let mg = Expression<Double?>("mg")
            let p = Expression<Double?>("p")
            let fe = Expression<Double?>("fe")
            let a = Expression<Double?>("a")
            let b1 = Expression<Double?>("b1")
            let b2 = Expression<Double?>("b2")
            let rr = Expression<Double?>("rr")
            let c = Expression<Double?>("c")
            let re = Expression<Double?>("re")
            let kar = Expression<Double?>("kar")
            let mds = Expression<Double?>("mds")
            let kr = Expression<Double?>("kr")
            let te = Expression<Double?>("te")
            let ok = Expression<Double?>("ok")
            let ne = Expression<Double?>("ne")
            let zn = Expression<Double?>("zn")
            let cu = Expression<Double?>("cu")
            let mn = Expression<Double?>("mn")
            let se = Expression<Double?>("se")
            let b5 = Expression<Double?>("b5")
            let b6 = Expression<Double?>("b6")
            let fol = Expression<Double?>("fol")
            let b9 = Expression<Double?>("b9")
            let dfe = Expression<Double?>("dfe")
            let holin = Expression<Double?>("holin")
            let b12 = Expression<Double?>("b12")
            let ear = Expression<Double?>("ear")
            let a_kar = Expression<Double?>("a_kar")
            let b_kript = Expression<Double?>("b_kript")
            let likopin = Expression<Double?>("likopin")
            let lut_z = Expression<Double?>("lut_z")
            let vit_e = Expression<Double?>("vit_e")
            let vit_d = Expression<Double?>("vit_d")
            let d_mezd = Expression<Double?>("d_mezd")
            let vit_k = Expression<Double?>("vit_k")
            let mzhk = Expression<Double?>("mzhk")
            let pzhk = Expression<Double?>("pzhk")
            let w_1ed = Expression<Double?>("w_1ed")
            let op_1ed = Expression<Double?>("op_1ed")
            let w_2ed = Expression<Double?>("w_2ed")
            let op_2ed = Expression<Double?>("op_2ed")
            let proc_pot = Expression<Double?>("proc_pot")
            let favor = Expression<Int?>("favor")
            let url = Expression<String?>("url")
            
            let usersRecipes = Table("usersRecipes")
            let recipe_id = Expression<Int>("food_id")
            if isEditing {
                try db.run(usersRecipes.filter(recipe_id == idToDelete!).delete())
            }
            
            var parameters: [[Double]] = []
            for i in items {
                for j in try db.prepare(food.filter(table_id == i.table_id)){
                    parameters.append([(j[carbo] ?? 0.0) * i.gram!/100,
                                       (j[prot] ?? 0.0) * i.gram!/100,
                                       (j[fat] ?? 0.0) * i.gram!/100,
                                       (j[ec] ?? 0.0) * i.gram!/100,
                                       (j[gi] ?? 0.0) * (j[carbo] ?? 0.0) * i.gram!/100,
                                       (j[water] ?? 0.0) * i.gram!/100,
                                       (j[nzhk] ?? 0.0) * i.gram!/100,
                                       (j[hol] ?? 0.0) * i.gram!/100,
                                       (j[pv] ?? 0.0) * i.gram!/100,
                                       (j[zola] ?? 0.0) * i.gram!/100,
                                       (j[na] ?? 0.0) * i.gram!/100,
                                       (j[k] ?? 0.0) * i.gram!/100,
                                       (j[ca] ?? 0.0) * i.gram!/100,
                                       (j[mg] ?? 0.0) * i.gram!/100,
                                       (j[p] ?? 0.0) * i.gram!/100,
                                       (j[fe] ?? 0.0) * i.gram!/100,
                                       (j[a] ?? 0.0) * i.gram!/100,
                                       (j[b1] ?? 0.0) * i.gram!/100,
                                       (j[b2] ?? 0.0) * i.gram!/100,
                                       (j[rr] ?? 0.0) * i.gram!/100,
                                       (j[c] ?? 0.0) * i.gram!/100,
                                       (j[re] ?? 0.0) * i.gram!/100,
                                       (j[kar] ?? 0.0) * i.gram!/100,
                                       (j[mds] ?? 0.0) * i.gram!/100,
                                       (j[kr] ?? 0.0) * i.gram!/100,
                                       (j[te] ?? 0.0) * i.gram!/100,
                                       (j[ok] ?? 0.0) * i.gram!/100,
                                       (j[ne] ?? 0.0) * i.gram!/100,
                                       (j[zn] ?? 0.0) * i.gram!/100,
                                       (j[cu] ?? 0.0) * i.gram!/100,
                                       (j[mn] ?? 0.0) * i.gram!/100,
                                       (j[se] ?? 0.0) * i.gram!/100,
                                       (j[b5] ?? 0.0) * i.gram!/100,
                                       (j[b6] ?? 0.0) * i.gram!/100,
                                       (j[fol] ?? 0.0) * i.gram!/100,
                                       (j[b9] ?? 0.0) * i.gram!/100,
                                       (j[dfe] ?? 0.0) * i.gram!/100,
                                       (j[holin] ?? 0.0) * i.gram!/100,
                                       (j[b12] ?? 0.0) * i.gram!/100,
                                       (j[ear] ?? 0.0) * i.gram!/100,
                                       (j[a_kar] ?? 0.0) * i.gram!/100,
                                       (j[b_kript] ?? 0.0) * i.gram!/100,
                                       (j[likopin] ?? 0.0) * i.gram!/100,
                                       (j[lut_z] ?? 0.0) * i.gram!/100,
                                       (j[vit_e] ?? 0.0) * i.gram!/100,
                                       (j[vit_d] ?? 0.0) * i.gram!/100,
                                       (j[d_mezd] ?? 0.0) * i.gram!/100,
                                       (j[vit_k] ?? 0.0) * i.gram!/100,
                                       (j[mzhk] ?? 0.0) * i.gram!/100,
                                       (j[pzhk] ?? 0.0) * i.gram!/100,
                                       (j[w_1ed] ?? 0.0) * i.gram!/100,
                                       (j[op_1ed] ?? 0.0) * i.gram!/100,
                                       (j[w_2ed] ?? 0.0) * i.gram!/100,
                                       (j[op_2ed] ?? 0.0) * i.gram!/100,
                                       (j[proc_pot] ?? 0.0) * i.gram!/100])
                }
            }
            
            for i in 0..<parameters.count-1 {
                for j in 0..<parameters[i].count {
                    parameters[i+1][j] = parameters[i][j] + parameters[i+1][j]
                }
            }
            
            var summOfParam = parameters.last!
            summOfParam[4] = round(summOfParam[4]/summOfParam[0]*100)/100
            summOfParam = summOfParam.map({round($0*10)/10})
            
            let recipesTable = Table("usersRecipes")
            let food_id = Expression<Int>("food_id")
            let item_id = Expression<Int>("item_id")
            let gram = Expression<Double>("gram")
            
            if isEditing {
                let editingRow = food.filter(table_id == idToDelete!)
                try db.run(editingRow.update(foodName <- newReceitName, cat <- category, carbo <- summOfParam[0], prot <- summOfParam[1], fat <- summOfParam[2], ec <- summOfParam[3], gi <- summOfParam[4], water <- summOfParam[5], nzhk <- summOfParam[6], hol <- summOfParam[7], pv <- summOfParam[8], zola <- summOfParam[9], na <- summOfParam[10], k <- summOfParam[11], ca <- summOfParam[12], mg <- summOfParam[13], p <- summOfParam[14], fe <- summOfParam[15], a <- summOfParam[16], b1 <- summOfParam[17], b2 <- summOfParam[18], rr <- summOfParam[19], c <- summOfParam[20], re <- summOfParam[21], kar <- summOfParam[22], mds <- summOfParam[23], kr <- summOfParam[24], te <- summOfParam[25], ok <- summOfParam[26], ne <- summOfParam[27], zn <- summOfParam[28], cu <- summOfParam[29], mn <- summOfParam[30], se <- summOfParam[31], b5 <- summOfParam[32], b6 <- summOfParam[33], fol <- summOfParam[34], b9 <- summOfParam[35], dfe <- summOfParam[36], holin <- summOfParam[37], b12 <- summOfParam[38], ear <- summOfParam[39], a_kar <- summOfParam[40], b_kript <- summOfParam[41], likopin <- summOfParam[42], lut_z <- summOfParam[43], vit_e <- summOfParam[44], vit_d <- summOfParam[45], d_mezd <- summOfParam[46], vit_k <- summOfParam[47], mzhk <- summOfParam[48], pzhk <- summOfParam[49], w_1ed <- summOfParam[50], op_1ed <- summOfParam[51], w_2ed <- summOfParam[52], op_2ed <- summOfParam[53], proc_pot <- summOfParam[54], favor <- 1, url <- imageURL))
                for i in items {
                    try db.run(recipesTable.insert(food_id <- idToDelete!, item_id <- i.table_id, gram <- i.gram!))
                }
            }
            else {
                var num = 1
                var resultingName = newReceitName
                while Array(try db.prepare(food.filter(foodName == resultingName))).count != 0 {
                    resultingName = newReceitName + " " + "(рецепт №\(num))"
                    num += 1
                }
                let insertID = try db.run(food.insert(foodName <- resultingName, cat <- category, carbo <- summOfParam[0], prot <- summOfParam[1], fat <- summOfParam[2], ec <- summOfParam[3], gi <- summOfParam[4], water <- summOfParam[5], nzhk <- summOfParam[6], hol <- summOfParam[7], pv <- summOfParam[8], zola <- summOfParam[9], na <- summOfParam[10], k <- summOfParam[11], ca <- summOfParam[12], mg <- summOfParam[13], p <- summOfParam[14], fe <- summOfParam[15], a <- summOfParam[16], b1 <- summOfParam[17], b2 <- summOfParam[18], rr <- summOfParam[19], c <- summOfParam[20], re <- summOfParam[21], kar <- summOfParam[22], mds <- summOfParam[23], kr <- summOfParam[24], te <- summOfParam[25], ok <- summOfParam[26], ne <- summOfParam[27], zn <- summOfParam[28], cu <- summOfParam[29], mn <- summOfParam[30], se <- summOfParam[31], b5 <- summOfParam[32], b6 <- summOfParam[33], fol <- summOfParam[34], b9 <- summOfParam[35], dfe <- summOfParam[36], holin <- summOfParam[37], b12 <- summOfParam[38], ear <- summOfParam[39], a_kar <- summOfParam[40], b_kript <- summOfParam[41], likopin <- summOfParam[42], lut_z <- summOfParam[43], vit_e <- summOfParam[44], vit_d <- summOfParam[45], d_mezd <- summOfParam[46], vit_k <- summOfParam[47], mzhk <- summOfParam[48], pzhk <- summOfParam[49], w_1ed <- summOfParam[50], op_1ed <- summOfParam[51], w_2ed <- summOfParam[52], op_2ed <- summOfParam[53], proc_pot <- summOfParam[54], favor <- 1, url <- imageURL))
                for i in items {
                    try db.run(recipesTable.insert(food_id <- Int(insertID), item_id <- i.table_id, gram <- i.gram!))
                }
            }
        }
        catch {
            print(error)
        }
    }
}
