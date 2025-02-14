import Foundation
import SQLite
import os

struct FoodRecord {
    var day: Date
    var time: Date
    var foodType: String
    var id_food: [Int]
    var food:  [String]
    var g: [String]
    var carbo: [String]
    var prot: [String]
    var fat: [String]
    var ec: [String]
    var gi: [String]
    var empty: [String]
    var water: [String]
    var nzhk: [String]
    var hol: [String]
    var pv: [String]
    var zola: [String]
    var na: [String]
    var k: [String]
    var ca: [String]
    var mg: [String]
    var p: [String]
    var fe: [String]
    var a: [String]
    var b1: [String]
    var b2: [String]
    var rr: [String]
    var c: [String]
    var re: [String]
    var kar: [String]
    var mds: [String]
    var kr: [String]
    var te: [String]
    var ok: [String]
    var ne: [String]
    var zn: [String]
    var cu: [String]
    var mn: [String]
    var se: [String]
    var b5: [String]
    var b6: [String]
    var fol: [String]
    var b9: [String]
    var dfe: [String]
    var holin: [String]
    var b12: [String]
    var ear: [String]
    var a_kar: [String]
    var b_kript: [String]
    var likopin: [String]
    var lut_z: [String]
    var vit_e: [String]
    var vit_d: [String]
    var d_mezd: [String]
    var vit_k: [String]
    var mzhk: [String]
    var pzhk: [String]
    var w_1ed: [String]
    var op_1ed: [String]
    var w_2ed: [String]
    var op_2ed: [String]
    var proc_prot: [String]
    var timeStamp: String
    var BG0: String
    var BG1: String
}

struct TableRecord {
    var day: Date
    var time: [Date]
    var foodType: [String]
    var food:  [[String]]
    var g: [[String]]
    var carbo: [[String]]
    var prot: [[String]]
    var fat: [[String]]
    var ec: [[String]]
    var gi: [[String]]
    var empty: [[String]]
    var water: [[String]]
    var nzhk: [[String]]
    var hol: [[String]]
    var pv: [[String]]
    var zola: [[String]]
    var na: [[String]]
    var k: [[String]]
    var ca: [[String]]
    var mg: [[String]]
    var p: [[String]]
    var fe: [[String]]
    var a: [[String]]
    var b1: [[String]]
    var b2: [[String]]
    var rr: [[String]]
    var c: [[String]]
    var re: [[String]]
    var kar: [[String]]
    var mds: [[String]]
    var kr: [[String]]
    var te: [[String]]
    var ok: [[String]]
    var ne: [[String]]
    var zn: [[String]]
    var cu: [[String]]
    var mn: [[String]]
    var se: [[String]]
    var b5: [[String]]
    var b6: [[String]]
    var fol: [[String]]
    var b9: [[String]]
    var dfe: [[String]]
    var holin: [[String]]
    var b12: [[String]]
    var ear: [[String]]
    var a_kar: [[String]]
    var b_kript: [[String]]
    var likopin: [[String]]
    var lut_z: [[String]]
    var vit_e: [[String]]
    var vit_d: [[String]]
    var d_mezd: [[String]]
    var vit_k: [[String]]
    var mzhk: [[String]]
    var pzhk: [[String]]
    var w_1ed: [[String]]
    var op_1ed: [[String]]
    var w_2ed: [[String]]
    var op_2ed: [[String]]
    var proc_prot: [[String]]
    var timeStamp: [String]
    var BG0: [String]
    var BG1: [String]
}

struct sugarlvl {
    var date: String
    var natoshak: [[String]]
    var zavtrak: [[String]]
    var obed: [[String]]
    var yzin: [[String]]
    var dop: [[String]]
    var rodi: [[String]]
}

struct injectlvl {
    var date: String
    var natoshak: [String]
    var zavtrak: [String]
    var obed: [String]
    var uzin: [String]
    var dop: [String]
    var levemir: [String]
}

struct recordRow {
    var date: Date
    var time: Date
    var lvl: Double
    var period: String
}

struct injectRow {
    var date: Date
    var time: Date
    var ed: Double
    var type: String
    var priem: String
}

struct activityRow {
    var week: Int
    var data: Date
    var actStartTime: Date
    var actDuration: Int
    var actType: String
}

struct activity {
    var week: Int
    var data: [Date]
    var actStartTime: [[Date]]
    var actDuration: [[Int]]
    var actType: [[String]]
    var sleepTime: [[Date]]
    var sleepDuration: [[Int]]
}

struct ketonsRow {
    var date: Date
    var time: Date
    var lvl: Double
}

struct massaRow {
    var date: Date
    var time: Date
    var weight: Double
}

struct fullDays {
    var days: Date
}

struct deletedRecords {
    var date: Date
    var time: Date
    var type: String
    var context: String
}

class excelManager {
    
    static let sheetsManager = excelManager()
    
    func getFoodRecords() -> [TableRecord] {
        var record = [FoodRecord]()
        var table = [TableRecord]()
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            
            let foodTable = Table("diary")
            let id_food = Expression<Int>("id_food")
            let day = Expression<String>("date")
            let time = Expression<String>("time")
            let foodType = Expression<String>("foodType")
            let foodName = Expression<String>("foodName")
            let gram = Expression<String>("g")
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
            let dateFormatter1 = DateFormatter()
            dateFormatter1.locale = Locale(identifier: "ru_RU")
            dateFormatter1.setLocalizedDateFormatFromTemplate("HH:mm")
            
            let foodInfo = Table("food")
            let id_info = Expression<Int>("_id")
            let foodN = Expression<String>("name")
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
            let proc_prot = Expression<Double?>("proc_prot")
            
            let pred = Table("predicted")
            let timeStamp = Expression<String>("timeStamp")
            let _date = Expression<String>("date")
            let _time = Expression<String>("time")
            let BG0 = Expression<Double>("BG0")
            let BG1 = Expression<Double>("BG1")
            
            for i in try db.prepare(foodTable.select(day,time,foodType,id_food,foodName,gram)){
                record.append(FoodRecord(day: dateFormatter.date(from: i[day])!, time: dateFormatter1.date(from: i[time])!,foodType: i[foodType], id_food: [i[id_food]], food: [i[foodName]], g: [i[gram]], carbo: [""], prot: [""], fat: [""], ec: [""], gi: [""], empty: [""], water: [""], nzhk: [""], hol: [""], pv: [""], zola: [""], na: [""], k: [""], ca: [""], mg: [""], p: [""], fe: [""], a:[""], b1: [""], b2: [""], rr: [""], c: [""], re: [""], kar: [""], mds: [""], kr: [""], te: [""], ok: [""], ne: [""], zn: [""], cu: [""], mn: [""], se: [""], b5: [""], b6: [""], fol: [""], b9: [""], dfe: [""], holin: [""], b12: [""], ear: [""], a_kar:[""], b_kript: [""], likopin: [""], lut_z: [""], vit_e: [""], vit_d: [""], d_mezd: [""], vit_k: [""], mzhk: [""], pzhk: [""], w_1ed: [""], op_1ed: [""], w_2ed: [""], op_2ed: [""], proc_prot: [""], timeStamp: "", BG0: "", BG1: ""))
            }
            
            var tempPred: [[String]] = []
            for i in try db.prepare(pred.select(timeStamp, _date, _time, BG0, BG1)){
                tempPred.append([i[timeStamp], i[_date], i[_time], String(i[BG0]), String(i[BG1])])
            }
            
            for i in tempPred {
                let indexOf = record.firstIndex(where: {$0.day == dateFormatter.date(from: i[1])! && $0.time == dateFormatter1.date(from: i[2])!})
                if indexOf != nil {
                    record[indexOf!].timeStamp = i[0]
                    record[indexOf!].BG0 = i[3]
                    record[indexOf!].BG1 = i[4]
                }
            }
            
            for i in 0..<record.count {
                for i1 in try db.prepare(foodInfo.select(foodN, carbo, prot, fat, ec, gi, water, nzhk, hol, pv, zola, na, k, ca, mg, p, fe, a, b1, b2, rr, c, re, kar, mds, kr, te, ok, ne, zn, cu, mn, se, b5, b6, fol, b9, dfe, holin, b12, ear, a_kar, b_kript, likopin, lut_z, vit_e, vit_d, d_mezd, vit_k, mzhk, pzhk, w_1ed, op_1ed, w_2ed, op_2ed, proc_prot).filter(id_info == record[i].id_food[0])){
                    record[i].carbo = ["\(round((i1[carbo] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].prot = ["\(round((i1[prot] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].fat = ["\(round((i1[fat] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].ec = ["\(round((i1[ec] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].gi = ["\(i1[gi] ?? 0.0)"]
                    record[i].water = ["\(round((i1[water] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].nzhk = ["\(round((i1[nzhk] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].hol = ["\(round((i1[hol] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].pv = ["\(round((i1[pv] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].zola = ["\(round((i1[zola] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].na = ["\(round((i1[na] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].k = ["\(round((i1[k] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].ca = ["\(round((i1[ca] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].mg = ["\(round((i1[mg] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].p = ["\(round((i1[p] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].fe = ["\(round((i1[fe] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].a = ["\(round((i1[a] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].b1 = ["\(round((i1[b1] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].b2 = ["\(round((i1[b2] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].rr = ["\(round((i1[rr] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].c = ["\(round((i1[c] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].re = ["\(round((i1[re] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].kar = ["\(round((i1[kar] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].mds = ["\(round((i1[mds] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].kr = ["\(round((i1[kr] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].te = ["\(round((i1[te] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].ok = ["\(round((i1[ok] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].ne = ["\(round((i1[ne] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].zn = ["\(round((i1[zn] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].cu = ["\(round((i1[cu] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].mn = ["\(round((i1[mn] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].se = ["\(round((i1[se] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].b5 = ["\(round((i1[b5] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].b6 = ["\(round((i1[b6] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].fol = ["\(round((i1[fol] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].b9 = ["\(round((i1[b9] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].dfe = ["\(round((i1[dfe] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].holin = ["\(round((i1[holin] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].b12 = ["\(round((i1[b12] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].ear = ["\(round((i1[ear] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].a_kar = ["\(round((i1[a_kar] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].b_kript = ["\(round((i1[b_kript] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].likopin = ["\(round((i1[likopin] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].lut_z = ["\(round((i1[lut_z] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].vit_e = ["\(round((i1[vit_e] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].vit_d = ["\(round((i1[vit_d] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].d_mezd = ["\(round((i1[d_mezd] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].vit_k = ["\(round((i1[vit_k] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].mzhk = ["\(round((i1[mzhk] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].pzhk = ["\(round((i1[pzhk] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].w_1ed = ["\(round((i1[w_1ed] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].op_1ed = ["\(round((i1[op_1ed] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].w_2ed = ["\(round((i1[w_2ed] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].op_2ed = ["\(round((i1[op_2ed] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                    record[i].proc_prot = ["\(round((i1[proc_prot] ?? 0.0)*(Double(record[i].g[0])!/100)*100)/100)"]
                }
            }
            
            if record.count > 0 {
                record = record.sorted(by: {($0.day, $0.time, $0.foodType) < ($1.day, $1.time, $1.foodType)})
                
                var i = 1
                while i < record.count {
                    if record[i].day == record[i-1].day && record[i].time == record[i-1].time && record[i].foodType == record[i-1].foodType {
                        record[i].id_food = record[i-1].id_food + record[i].id_food
                        record[i].food = record[i-1].food + record[i].food
                        record[i].g = record[i-1].g + record[i].g
                        record[i].carbo = record[i-1].carbo + record[i].carbo
                        record[i].prot = record[i-1].prot + record[i].prot
                        record[i].fat = record[i-1].fat + record[i].fat
                        record[i].ec = record[i-1].ec + record[i].ec
                        record[i].gi = record[i-1].gi + record[i].gi
                        record[i].empty = record[i-1].empty + record[i].empty
                        record[i].water = record[i-1].water + record[i].water
                        record[i].nzhk = record[i-1].nzhk + record[i].nzhk
                        record[i].hol = record[i-1].hol + record[i].hol
                        record[i].pv = record[i-1].pv + record[i].pv
                        record[i].zola = record[i-1].zola + record[i].zola
                        record[i].na = record[i-1].na + record[i].na
                        record[i].k = record[i-1].k + record[i].k
                        record[i].ca = record[i-1].ca + record[i].ca
                        record[i].mg = record[i-1].mg + record[i].mg
                        record[i].p = record[i-1].p + record[i].p
                        record[i].fe = record[i-1].fe + record[i].fe
                        record[i].a = record[i-1].a + record[i].a
                        record[i].b1 = record[i-1].b1 + record[i].b1
                        record[i].b2 = record[i-1].b2 + record[i].b2
                        record[i].rr = record[i-1].rr + record[i].rr
                        record[i].c = record[i-1].c + record[i].c
                        record[i].re = record[i-1].re + record[i].re
                        record[i].kar = record[i-1].kar + record[i].kar
                        record[i].mds = record[i-1].mds + record[i].mds
                        record[i].kr = record[i-1].kr + record[i].kr
                        record[i].te = record[i-1].te + record[i].te
                        record[i].ok = record[i-1].ok + record[i].ok
                        record[i].ne = record[i-1].ne + record[i].ne
                        record[i].zn = record[i-1].zn + record[i].zn
                        record[i].cu = record[i-1].cu + record[i].cu
                        record[i].mn = record[i-1].mn + record[i].mn
                        record[i].se = record[i-1].se + record[i].se
                        record[i].b5 = record[i-1].b5 + record[i].b5
                        record[i].b6 = record[i-1].b6 + record[i].b6
                        record[i].fol = record[i-1].fol + record[i].fol
                        record[i].b9 = record[i-1].b9 + record[i].b9
                        record[i].dfe = record[i-1].dfe + record[i].dfe
                        record[i].holin = record[i-1].holin + record[i].holin
                        record[i].b12 = record[i-1].b12 + record[i].b12
                        record[i].ear = record[i-1].ear + record[i].ear
                        record[i].a_kar = record[i-1].a_kar + record[i].a_kar
                        record[i].b_kript = record[i-1].b_kript + record[i].b_kript
                        record[i].likopin = record[i-1].likopin + record[i].likopin
                        record[i].lut_z = record[i-1].lut_z + record[i].lut_z
                        record[i].vit_e = record[i-1].vit_e + record[i].vit_e
                        record[i].vit_d = record[i-1].vit_d + record[i].vit_d
                        record[i].d_mezd = record[i-1].d_mezd + record[i].d_mezd
                        record[i].vit_k = record[i-1].vit_k + record[i].vit_k
                        record[i].mzhk = record[i-1].mzhk + record[i].mzhk
                        record[i].pzhk = record[i-1].pzhk + record[i].pzhk
                        record[i].w_1ed = record[i-1].w_1ed + record[i].w_1ed
                        record[i].op_1ed = record[i-1].op_1ed + record[i].op_1ed
                        record[i].w_2ed = record[i-1].w_2ed + record[i].w_2ed
                        record[i].op_2ed = record[i-1].op_2ed + record[i].op_2ed
                        record[i].proc_prot = record[i-1].proc_prot + record[i].proc_prot
                        record[i].timeStamp = record[i-1].timeStamp
                        record[i].BG0 = record[i-1].BG0
                        record[i].BG1 = record[i-1].BG1
                        record.remove(at: i-1)
                    } else {
                        i += 1
                    }
                }
                
                table.append(TableRecord(day: record[0].day, time: [record[0].time], foodType: [record[0].foodType], food: [record[0].food], g: [record[0].g], carbo: [record[0].carbo], prot: [record[0].prot], fat: [record[0].fat], ec: [record[0].ec], gi: [record[0].gi], empty: [record[0].empty], water: [record[0].water], nzhk: [record[0].nzhk], hol: [record[0].hol], pv: [record[0].pv], zola: [record[0].zola], na: [record[0].na], k: [record[0].k], ca: [record[0].ca], mg: [record[0].mg], p: [record[0].p], fe: [record[0].fe], a: [record[0].a], b1: [record[0].b1], b2: [record[0].b2], rr: [record[0].rr], c: [record[0].c], re: [record[0].re], kar: [record[0].kar], mds: [record[0].mds], kr: [record[0].kr], te: [record[0].te], ok: [record[0].ok], ne: [record[0].ne], zn: [record[0].zn], cu: [record[0].cu], mn: [record[0].mn], se: [record[0].se], b5: [record[0].b5], b6: [record[0].b6], fol: [record[0].fol], b9: [record[0].b9], dfe: [record[0].dfe], holin: [record[0].holin], b12: [record[0].b12], ear: [record[0].ear], a_kar: [record[0].a_kar], b_kript: [record[0].b_kript], likopin: [record[0].likopin], lut_z: [record[0].lut_z], vit_e: [record[0].vit_e], vit_d: [record[0].vit_d], d_mezd: [record[0].d_mezd], vit_k: [record[0].vit_k], mzhk: [record[0].mzhk], pzhk: [record[0].pzhk], w_1ed: [record[0].w_1ed], op_1ed: [record[0].op_1ed], w_2ed: [record[0].w_2ed], op_2ed: [record[0].op_2ed], proc_prot: [record[0].proc_prot], timeStamp: [record[0].timeStamp], BG0: [record[0].BG0], BG1: [record[0].BG1]))
                record.remove(at: 0)
                
                while (record.count>0) {
                    if record[0].day == table[table.endIndex-1].day {
                        table[table.endIndex-1].time.append(record[0].time)
                        table[table.endIndex-1].foodType.append(record[0].foodType)
                        table[table.endIndex-1].food.append(record[0].food)
                        table[table.endIndex-1].g.append(record[0].g)
                        table[table.endIndex-1].carbo.append(record[0].carbo)
                        table[table.endIndex-1].prot.append(record[0].prot)
                        table[table.endIndex-1].fat.append(record[0].fat)
                        table[table.endIndex-1].ec.append(record[0].ec)
                        table[table.endIndex-1].gi.append(record[0].gi)
                        table[table.endIndex-1].empty.append(record[0].empty)
                        table[table.endIndex-1].water.append(record[0].water)
                        table[table.endIndex-1].nzhk.append(record[0].nzhk)
                        table[table.endIndex-1].hol.append(record[0].hol)
                        table[table.endIndex-1].pv.append(record[0].pv)
                        table[table.endIndex-1].zola.append(record[0].zola)
                        table[table.endIndex-1].na.append(record[0].na)
                        table[table.endIndex-1].k.append(record[0].k)
                        table[table.endIndex-1].ca.append(record[0].ca)
                        table[table.endIndex-1].mg.append(record[0].mg)
                        table[table.endIndex-1].p.append(record[0].p)
                        table[table.endIndex-1].fe.append(record[0].fe)
                        table[table.endIndex-1].a.append(record[0].a)
                        table[table.endIndex-1].b1.append(record[0].b1)
                        table[table.endIndex-1].b2.append(record[0].b2)
                        table[table.endIndex-1].rr.append(record[0].rr)
                        table[table.endIndex-1].c.append(record[0].c)
                        table[table.endIndex-1].re.append(record[0].re)
                        table[table.endIndex-1].kar.append(record[0].kar)
                        table[table.endIndex-1].mds.append(record[0].mds)
                        table[table.endIndex-1].kr.append(record[0].kr)
                        table[table.endIndex-1].te.append(record[0].te)
                        table[table.endIndex-1].ok.append(record[0].ok)
                        table[table.endIndex-1].ne.append(record[0].ne)
                        table[table.endIndex-1].zn.append(record[0].zn)
                        table[table.endIndex-1].cu.append(record[0].cu)
                        table[table.endIndex-1].mn.append(record[0].mn)
                        table[table.endIndex-1].se.append(record[0].se)
                        table[table.endIndex-1].b5.append(record[0].b5)
                        table[table.endIndex-1].b6.append(record[0].b6)
                        table[table.endIndex-1].fol.append(record[0].fol)
                        table[table.endIndex-1].b9.append(record[0].b9)
                        table[table.endIndex-1].dfe.append(record[0].dfe)
                        table[table.endIndex-1].holin.append(record[0].holin)
                        table[table.endIndex-1].b12.append(record[0].b12)
                        table[table.endIndex-1].ear.append(record[0].ear)
                        table[table.endIndex-1].a_kar.append(record[0].a_kar)
                        table[table.endIndex-1].b_kript.append(record[0].b_kript)
                        table[table.endIndex-1].likopin.append(record[0].likopin)
                        table[table.endIndex-1].lut_z.append(record[0].lut_z)
                        table[table.endIndex-1].vit_e.append(record[0].vit_e)
                        table[table.endIndex-1].vit_d.append(record[0].vit_d)
                        table[table.endIndex-1].d_mezd.append(record[0].d_mezd)
                        table[table.endIndex-1].vit_k.append(record[0].vit_k)
                        table[table.endIndex-1].mzhk.append(record[0].mzhk)
                        table[table.endIndex-1].pzhk.append(record[0].pzhk)
                        table[table.endIndex-1].w_1ed.append(record[0].w_1ed)
                        table[table.endIndex-1].op_1ed.append(record[0].op_1ed)
                        table[table.endIndex-1].w_2ed.append(record[0].w_2ed)
                        table[table.endIndex-1].op_2ed.append(record[0].op_2ed)
                        table[table.endIndex-1].proc_prot.append(record[0].proc_prot)
                        table[table.endIndex-1].timeStamp.append(record[0].timeStamp)
                        table[table.endIndex-1].BG0.append(record[0].BG0)
                        table[table.endIndex-1].BG1.append(record[0].BG1)
                        record.remove(at: 0)
                    } else {
                        table.append(TableRecord(day: record[0].day, time: [record[0].time], foodType: [record[0].foodType], food: [record[0].food], g: [record[0].g], carbo: [record[0].carbo], prot: [record[0].prot], fat: [record[0].fat], ec: [record[0].ec], gi: [record[0].gi], empty: [record[0].empty], water: [record[0].water], nzhk: [record[0].nzhk], hol: [record[0].hol], pv: [record[0].pv], zola: [record[0].zola], na: [record[0].na], k: [record[0].k], ca: [record[0].ca], mg: [record[0].mg], p: [record[0].p], fe: [record[0].fe], a: [record[0].a], b1: [record[0].b1], b2: [record[0].b2], rr: [record[0].rr], c: [record[0].c], re: [record[0].re], kar: [record[0].kar], mds: [record[0].mds], kr: [record[0].kr], te: [record[0].te], ok: [record[0].ok], ne: [record[0].ne], zn: [record[0].zn], cu: [record[0].cu], mn: [record[0].mn], se: [record[0].se], b5: [record[0].b5], b6: [record[0].b6], fol: [record[0].fol], b9: [record[0].b9], dfe: [record[0].dfe], holin: [record[0].holin], b12: [record[0].b12], ear: [record[0].ear], a_kar: [record[0].a_kar], b_kript: [record[0].b_kript], likopin: [record[0].likopin], lut_z: [record[0].lut_z], vit_e: [record[0].vit_e], vit_d: [record[0].vit_d], d_mezd: [record[0].d_mezd], vit_k: [record[0].vit_k], mzhk: [record[0].mzhk], pzhk: [record[0].pzhk], w_1ed: [record[0].w_1ed], op_1ed: [record[0].op_1ed], w_2ed: [record[0].w_2ed], op_2ed: [record[0].op_2ed], proc_prot: [record[0].proc_prot], timeStamp: [record[0].timeStamp], BG0: [record[0].BG0], BG1: [record[0].BG1]))
                        record.remove(at: 0)
                    }
                }
            }
        }
        catch {
            print(error)
        }
        return table
    }
    
    func getName() -> (String, String) {
        var fio: String = ""
        var shortFio: String = ""
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let userTable = Table("usermac")
            let id = Expression<Int>("id")
            let userName = Expression<String?>("fio")
            let dateOfBirth = Expression<String?>("birthday")
            let doc = Expression<String?>("doc")
            let vesrion = Expression<Int>("version")
            
            let df = DateFormatter()
            df.dateFormat = "dd.MM.yyyy"
            
            for i in try db.prepare(userTable.select(id, userName, dateOfBirth, doc, vesrion)){
                switch i[vesrion] {
                case 1:
                    fio = "Dia\(i[id]) Пациент: \(i[userName] ?? "Новый пользователь"); Дата рождения: \(i[dateOfBirth] ?? "01.01.1999"); Лечащий врач: \(i[doc] ?? "Попова П.В."); Программа: DiaCompanion iOS Dial v\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
                    shortFio = "Dia\(i[id]) \(i[userName] ?? "Новый_пользователь 1") \(df.string(from: Date.now))"
                case 2:
                    fio = "GDM\(i[id]) Пациент: \(i[userName] ?? "Новый пользователь"); Дата рождения: \(i[dateOfBirth] ?? "01.01.1999"); Лечащий врач: \(i[doc] ?? "Попова П.В."); Программа: DiaCompanion iOS Dial v\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
                    shortFio = "GDM\(i[id]) \(i[userName] ?? "Новый_пользователь 1") \(df.string(from: Date.now))"
                case 3:
                    fio = "MS\(i[id]) Пациент: \(i[userName] ?? "Новый пользователь"); Дата рождения: \(i[dateOfBirth] ?? "01.01.1999"); Лечащий врач: \(i[doc] ?? "Попова П.В."); Программа: DiaCompanion iOS Dial v\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
                    shortFio = "MS\(i[id]) \(i[userName] ?? "Новый_пользователь 1") \(df.string(from: Date.now))"
                case 4:
                    fio = "PCOS\(i[id]) Пациент: \(i[userName] ?? "Новый пользователь"); Дата рождения: \(i[dateOfBirth] ?? "01.01.1999"); Лечащий врач: \(i[doc] ?? "Попова П.В."); Программа: DiaCompanion iOS Dial v\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
                    shortFio = "PCOS\(i[id]) \(i[userName] ?? "Новый_пользователь 1") \(df.string(from: Date.now))"
                default:
                    fio = "ID\(i[id]) Пациент: \(i[userName] ?? "Новый пользователь"); Дата рождения: \(i[dateOfBirth] ?? "01.01.1999"); Лечащий врач: \(i[doc] ?? "Попова П.В."); Программа: DiaCompanion iOS Dial v\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
                    shortFio = "ID\(i[id]) \(i[userName] ?? "Новый_пользователь 1") \(df.string(from: Date.now))"
                }
            }
        }
        catch {
            print(error)
        }
        return (fio,shortFio)
    }
    
    func getSugarRecords() -> ([sugarlvl], [injectlvl]) {
        
        var sugarRecords = [sugarlvl]()
        var record = [recordRow]()
        var tableInjetcs = [injectlvl]()
        var injRecord = [injectRow]()
        
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let sugarChange = Table("sugarChange")
            let lvl = Expression<Double>("lvl")
            let period = Expression<String>("period")
            let time = Expression<String>("time")
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
            let dateFormatter1 = DateFormatter()
            dateFormatter1.locale = Locale(identifier: "ru_RU")
            dateFormatter1.setLocalizedDateFormatFromTemplate("HH:mm")
            
            for i in try db.prepare(sugarChange.select(lvl,period,time)) {
                record.append(recordRow(date: dateFormatter.date(from: i[time][6..<16])! , time: dateFormatter1.date(from: i[time][0..<5])!, lvl: i[lvl], period: i[period]))
            }
            record = record.sorted(by: {($0.date, $0.time) < ($1.date, $1.time)})
            
            var sugarUniqueDates = [Date]()
            for i in record {
                sugarUniqueDates.append(i.date)
            }
            sugarUniqueDates = Array(Set(sugarUniqueDates))
            sugarUniqueDates = sugarUniqueDates.sorted(by: <)
            
            let injects = Table("inject")
            let injectID = Expression<Int>("id")
            let injectED = Expression<Double>("ed")
            let injectType = Expression<String>("type")
            let injectPriem = Expression<String>("priem")
            let injectTime = Expression<String>("time")
            
            for i in try db.prepare(injects.select(injectID, injectED, injectType, injectPriem, injectTime)){
                injRecord.append(injectRow(date: dateFormatter.date(from: i[time][6..<16])!, time: dateFormatter1.date(from: i[time][0..<5])!, ed: i[injectED], type: i[injectType], priem: i[injectPriem]))
            }
            injRecord = injRecord.sorted(by: {($0.date, $0.time) < ($1.date, $1.time)})
            
            var injectUniqueDates = [Date]()
            for i in injRecord {
                injectUniqueDates.append(i.date)
            }
            injectUniqueDates = Array(Set(injectUniqueDates))
            injectUniqueDates = injectUniqueDates.sorted(by: <)
            
            var uniqueDates = [Date]()
            uniqueDates.append(contentsOf: sugarUniqueDates)
            uniqueDates.append(contentsOf: injectUniqueDates)
            uniqueDates = Array(Set(uniqueDates))
            uniqueDates = uniqueDates.sorted(by: { $0 < $1})
            
            var i = 0
            while i < uniqueDates.count-1 {
                if DateInterval(start: uniqueDates[i], end: uniqueDates[i+1]) > DateInterval(start: uniqueDates[i], duration: 60*60*24) {
                    uniqueDates.insert(uniqueDates[i].addingTimeInterval(60*60*24), at: i+1)
                    i += 1
                } else {
                    i += 1
                }
            }
            
            for i in uniqueDates {
                sugarRecords.append(sugarlvl(date: dateFormatter.string(from: i), natoshak: [], zavtrak: [], obed: [], yzin: [], dop: [], rodi: []))
                tableInjetcs.append(injectlvl(date: dateFormatter.string(from: i), natoshak: [], zavtrak: [], obed: [], uzin: [], dop: [], levemir: []))
            }
            
            var i1 = 0
            var i2 = 0
            while i2 <= record.count-1 {
                if record[i2].date == dateFormatter.date(from: sugarRecords[i1].date) {
                    if record[i2].period == "Натощак" {
                        sugarRecords[i1].natoshak.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                    }
                    if record[i2].period == "После завтрака" {
                        sugarRecords[i1].zavtrak.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                    }
                    if record[i2].period == "После обеда" {
                        sugarRecords[i1].obed.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                    }
                    if record[i2].period == "После ужина" {
                        sugarRecords[i1].yzin.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                    }
                    if record[i2].period == "Дополнительно" {
                        sugarRecords[i1].dop.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                    }
                    if record[i2].period == "При родах" {
                        sugarRecords[i1].rodi.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                    }
                    i2 += 1
                } else {
                    i1 += 1
                }
            }
            
            var i3 = 0
            var i4 = 0
            while i3 <= injRecord.count-1 {
                if dateFormatter.string(from: injRecord[i3].date) == tableInjetcs[i4].date {
                    if injRecord[i3].priem == "Натощак" {
                        tableInjetcs[i4].natoshak = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                    }
                    if injRecord[i3].priem == "Завтрак" {
                        tableInjetcs[i4].zavtrak = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                    }
                    if injRecord[i3].priem == "Обед" {
                        tableInjetcs[i4].obed = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                    }
                    if injRecord[i3].priem == "Ужин" {
                        tableInjetcs[i4].uzin = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                    }
                    if injRecord[i3].priem == "Дополнительно" {
                        tableInjetcs[i4].dop = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                    }
                    i3 += 1
                } else {
                    i4 += 1
                }
            }
        }
        catch {
            print(error)
        }
        return (sugarRecords, tableInjetcs)
    }
    
    func defWeek(nowDate: Date, dateBegin: Date, weekOfStart: Int, dayOfStartWeek: Int) -> Int {
        let pastInDays = Double(7*weekOfStart-(7-dayOfStartWeek))
        if dateBegin > nowDate {
            let delta = Double(DateInterval(start: nowDate, end: dateBegin).duration/(60*60*24))
            if pastInDays - delta < 0 {
                return 0
            }
            else {
                return Int(((Double(pastInDays) - delta)/7).rounded(.up))
            }
        }
        let delta = DateInterval(start: dateBegin, end: nowDate)
        let res = (pastInDays + Double(delta.duration/(60*60*24)))/7
        return Int(res.rounded(.up))
    }
    
    func getActivityRecords() -> [activity] {
        var actTable = [activityRow]()
        var act = [activity]()
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd.MM.yyyy"
            
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let activitySheet = Table("act")
            let dateTime = Expression<String>("time")
            let type = Expression<String>("rod")
            let duration = Expression<Int>("min")
            
            let usermac = Table("usermac")
            let weekOfStart = Expression<Int?>("week")
            let dayOfStartweek = Expression<Int?>("day")
            let dateOfStart = Expression<String?>("datebegin")
            
            var pweek = 1
            var pday = 1
            var pdate = Date.now
            for i in try db.prepare(usermac.select(weekOfStart,dayOfStartweek, dateOfStart)) {
                if i[weekOfStart] != nil {
                    pweek = i[weekOfStart]!
                }
                if i[dayOfStartweek] != nil {
                    pday = i[dayOfStartweek]!
                }
                if i[dateOfStart] != nil {
                    pdate = dateFormatter1.date(from: i[dateOfStart]!)!
                }
            }
            
            for i in try db.prepare(activitySheet.select(dateTime,duration,type)){
                actTable.append(activityRow(week: defWeek(nowDate: dateFormatter1.date(from: i[dateTime][6..<16])!, dateBegin: pdate, weekOfStart: pweek, dayOfStartWeek: pday), data: dateFormatter1.date(from: i[dateTime][6..<16])!, actStartTime: dateFormatter.date(from: i[dateTime][0..<6])!, actDuration: i[duration], actType: i[type]))
            }
            
            actTable = actTable.sorted(by: {($0.data, $0.actStartTime) < ($1.data, $1.actStartTime)})
            
            var i = 0
            var i1 = 0
            var i2 = 0
            while i <= actTable.count-1 {
                if (i == 0) && (actTable[i].actType != "Сон") {
                    act.append(activity(week: actTable[i].week, data: [actTable[i].data], actStartTime: [[actTable[i].actStartTime]], actDuration: [[actTable[i].actDuration]], actType: [[actTable[i].actType]], sleepTime: [[]], sleepDuration: [[]]))
                }
                if (i == 0) && (actTable[i].actType == "Сон") {
                    act.append(activity(week: actTable[i].week, data: [actTable[i].data], actStartTime: [[]], actDuration: [[]], actType: [[]], sleepTime: [[actTable[i].actStartTime]], sleepDuration: [[actTable[i].actDuration]]))
                }
                if (i > 0) && (actTable[i].week == act[i1].week) && (actTable[i].data == act[i1].data.last!) && (actTable[i].actType != "Сон"){
                    act[i1].actStartTime[i2].append(actTable[i].actStartTime)
                    act[i1].actDuration[i2].append(actTable[i].actDuration)
                    act[i1].actType[i2].append(actTable[i].actType)
                }
                else if (i > 0) && (actTable[i].week == act[i1].week) && (actTable[i].data == act[i1].data.last!) && (actTable[i].actType == "Сон"){
                    act[i1].sleepTime[i2].append(actTable[i].actStartTime)
                    act[i1].sleepDuration[i2].append(actTable[i].actDuration)
                }
                else if (i > 0) && (actTable[i].week == act[i1].week) && (actTable[i].data != act[i1].data.last!) && (actTable[i].actType != "Сон"){
                    act[i1].data.append(actTable[i].data)
                    act[i1].actStartTime.append([actTable[i].actStartTime])
                    act[i1].actDuration.append([actTable[i].actDuration])
                    act[i1].actType.append([actTable[i].actType])
                    act[i1].sleepTime.append([])
                    act[i1].sleepDuration.append([])
                    i2 += 1
                }
                else if (i > 0) && (actTable[i].week == act[i1].week) && (actTable[i].data != act[i1].data.last!) && (actTable[i].actType == "Сон"){
                    act[i1].data.append(actTable[i].data)
                    act[i1].actStartTime.append([])
                    act[i1].actDuration.append([])
                    act[i1].actType.append([])
                    act[i1].sleepTime.append([actTable[i].actStartTime])
                    act[i1].sleepDuration.append([actTable[i].actDuration])
                    i2 += 1
                }
                else if (i > 0) && (actTable[i].week != act[i1].week) && (actTable[i].actType != "Сон"){
                    act.append(activity(week: actTable[i].week, data: [actTable[i].data], actStartTime: [[actTable[i].actStartTime]], actDuration: [[actTable[i].actDuration]], actType: [[actTable[i].actType]], sleepTime: [[]], sleepDuration: [[]]))
                    i2 = 0
                    i1 += 1
                }
                else if (i > 0) && (actTable[i].week != act[i1].week) && (actTable[i].actType == "Сон"){
                    act.append(activity(week: actTable[i].week, data: [actTable[i].data], actStartTime: [[]], actDuration: [[]], actType: [[]], sleepTime: [[actTable[i].actStartTime]], sleepDuration: [[actTable[i].actDuration]]))
                    i2 = 0
                    i1 += 1
                }
                i += 1
            }
        }
        catch {
            print(error)
        }
        return act
    }
    
    func getKetons() -> [ketonsRow] {
        var ketTable = [ketonsRow]()
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let ket = Table("ketonur")
            let mmol = Expression<Double>("mmol")
            let dateTime = Expression<String>("time")
            
            let dtformatter = DateFormatter()
            dtformatter.dateFormat = "HH:mm"
            let dtformatter1 = DateFormatter()
            dtformatter1.dateFormat = "dd.MM.yyyy"
            
            for i in try db.prepare(ket.select(dateTime,mmol)){
                ketTable.append(ketonsRow(date: dtformatter1.date(from: i[dateTime][6..<16])!, time: dtformatter.date(from: i[dateTime][0..<5])!, lvl: i[mmol]))
            }
        }
        catch {
            print(error)
        }
        return ketTable.sorted(by: {($0.date, $0.time) < ($1.date, $1.time)})
    }
    
    func getMassa() -> [massaRow] {
        var mTable = [massaRow]()
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let massa = Table("massa")
            let m = Expression<Double>("m")
            let time = Expression<String>("time")
            
            let df = DateFormatter()
            df.dateFormat = "HH:mm"
            let df1 = DateFormatter()
            df1.dateFormat = "dd.MM.yyyy"
            
            for i in try db.prepare(massa.select(m,time)){
                mTable.append(massaRow(date: df1.date(from: i[time][6..<16])!, time: df.date(from: i[time][0..<5])!, weight: i[m]))
            }
        }
        catch {
            print(error)
        }
        return mTable.sorted(by: {($0.date, $0.time) < ($1.date, $1.time)})
    }
    
    func getFullDays() -> [fullDays] {
        var fdays = [fullDays]()
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let days = Table("fulldays")
            let day = Expression<String>("day")
            let df = DateFormatter()
            df.dateFormat = "dd.MM.yyyy"
            for i in try db.prepare(days.select(day)){
                fdays.append(fullDays(days: df.date(from: i[day])!))
            }
        }
        catch {
            print(error)
        }
        return fdays.sorted(by: {$0.days < $1.days})
    }
    
    func getDeletedRecords() -> [deletedRecords]{
        var deleted = [deletedRecords]()
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let ddeleted = Table("deleted")
            let ddate = Expression<String>("date")
            let dtime = Expression<String>("time")
            let dtype = Expression<String>("type")
            let dcontext = Expression<String>("context")
            
            let df = DateFormatter()
            df.dateFormat = "dd.MM.yyyy"
            let df1 = DateFormatter()
            df1.dateFormat = "HH:mm"
            
            for i in try db.prepare(ddeleted.select(ddate,dtime, dtype, dcontext)){
                deleted.append(deletedRecords(date: df.date(from: i[ddate])!, time: df1.date(from: i[dtime])!, type: i[dtype], context: i[dcontext]))
            }
        }
        catch {
            print(error)
        }
        return deleted.sorted(by: {($0.date, $0.time) < ($1.date, $1.time)})
    }
    
    func getWeeksInfo() -> (Int,Int,Date) {
        var pweek = 1
        var pday = 1
        var pdate = Date.now
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            
            let usermac = Table("usermac")
            let weekOfStart = Expression<Int?>("week")
            let dayOfStartweek = Expression<Int?>("day")
            let dateOfStart = Expression<String?>("datebegin")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            for i in try db.prepare(usermac.select(weekOfStart,dayOfStartweek, dateOfStart)) {
                if i[weekOfStart] != nil {
                    pweek = i[weekOfStart]!
                }
                if i[dayOfStartweek] != nil {
                    pday = i[dayOfStartweek]!
                }
                if i[dateOfStart] != nil {
                    pdate = dateFormatter.date(from: i[dateOfStart]!)!
                }
            }
        }
        catch {
            print(error)
        }
        return (pweek, pday, pdate)
    }
    
    func transliterate(nonLatin: String) -> String {
        return nonLatin
            .applyingTransform(.toLatin, reverse: false)?
            .applyingTransform(.stripDiacritics, reverse: false)?
            .lowercased()
            .replacingOccurrences(of: " ", with: "-") ?? nonLatin
    }
    
    func getQuestionaryInfo() -> [[String]] {
        let questions: [String] = ["Беременнось по счету", "Количество родов", "Применение комбинированных оральных контрацептивов", "Брали ли у вас пролактин?", "Если брали, то было ли зафиксировано повышение?", "Если да, вам назначили препарат?", "Перечислите препараты не вошедшие в список", "Принимали ли вы витамин D до беременности?", "Перечислите препараты", "Принимали ли вы витамин D во время беременности?", "Перечислите препараты", "Отдыхали ли вы в жарких/солнечных странах во время беременности?", "Отпуск пришелся на I триместр беременности?", "Отпуск пришелся на II триместр беременности?", "Отпуск пришелся на III триместр беременности?", "Посещали ли вы солярий во время беременности?", "Гликированный гемоглобин", "Уровень триглицеридов", "Уровень холестерина", "Уровень глюкозы (натощак)", "Был ли ранее выявлен диабет у кровных родственников?", "Было ли замечено нарушение толерантности к глюкозе до беременности?", "Диагностировали ли вам гипертоническую болезнь до беременности?", "Диагностировали ли вам гипертоническую болезнь во время беременности?", "Курили ли вы за 6 месяцев до беременности?", "Курили вы до того как узнали о том, что беременны?", "Курите ли вы во время беременности?", "Укажите частоту потребления фруктов в неделю до беременности", "Укажите частоту потребления фруктов в неделю во время беременности", "Укажите частоту потребления пирожных в неделю до беременности", "Укажите частоту потребления пирожных в неделю во время беременности", "Укажите частоту потребления выпечки в неделю до беременности", "Укажите частоту потребления выпечки в неделю во время беременности", "Укажите частоту потребления шоколада в неделю до беременности", "Укажите частоту потребления шоколада в неделю во время беременности", "Укажите частоту потребления обезжиренных молочных продуктов в неделю до беременности", "Укажите частоту потребления обезжиренных молочных продуктов в неделю во время беременности", "Укажите частоту потребления не обезжиренных молочных продуктов в неделю до беременности", "Укажите частоту потребления не обезжиренных молочных продуктов в неделю во время беременности", "Укажите частоту потребления бобовых в неделю до беременности", "Укажите частоту потребления бобовых в неделю во время беременности", "Укажите частоту потребления мяса и мясных изделий в неделю до беременности", "Укажите частоту потребления мяса и мясных изделий в неделю во время беременности", "Укажите частоту потребления сухофруктов в неделю до беременности", "Укажите частоту потребления сухофруктов в неделю во время беременности", "Укажите частоту потребления рыбы и рыбных изделий в неделю до беременности", "Укажите частоту потребления рыбы и рыбных изделий в неделю во время беременности", "Укажите частоту потребления цельнозернового хлеба в неделю до беременности", "Укажите частоту потребления цельнозернового хлеба в неделю во время беременности", "Укажите частоту потребления любого хлеба в неделю до беременности", "Укажите частоту потребления любого хлеба в неделю во время беременности", "Укажите частоту потребления соусов и майонеза в неделю до беременности", "Укажите частоту потребления соусов и майонеза в неделю во время беременности", "Укажите частоту потребления овощей (сырых или приготовленных) в неделю до беременности", "Укажите частоту потребления овощей (сырых или приготовленных) в неделю во время беременности", "Укажите частоту потребления алкоголя в неделю до беременности", "Укажите частоту потребления алкоголя в неделю во время беременности", "Укажите частоту потребления сладких напитков в неделю до беременности", "Укажите частоту потребления сладких напитков в неделю во время беременности", "Укажите частоту потребления кофе в неделю до беременности", "Укажите частоту потребления кофе в неделю во время беременности", "Укажите частоту потребления сосисок и колбасы в неделю до беременности", "Укажите частоту потребления сосисок и колбасы в неделю во время беременности", "Укажите длительность легкой ходьбы до беременности, в день", "Укажите длительность легкой ходьбы во время беременности, в день", "Укажите среднее число лестничных пролетов, которые вы проходили в день до беременности", "Укажите среднее число лестничных пролетов, которые вы проходите в день во время беременности", "Укажите среднее число эпизодов посещения спортаза в неделю до беременности", "Укажите среднее число эпизодов посещения спортаза в неделю во время беременности"]
        var answers: [String] = []
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            
            let questionaryT = Table("questionary")
            let fpregnancy_n = Expression<String>("pregnancy_n")
            let fdelivery_n = Expression<String>("delivery_n")
            let fcontraceptive = Expression<String>("contraceptive")
            let fprolactin_test = Expression<String>("prolactin_test")
            let fheightened_prolactin = Expression<String>("heightened_prolactin")
            let fprolactin_drug_prescribed = Expression<String>("prolactin_drug_prescribed")
            let fprolactin_drug = Expression<String>("prolactin_drug")
            let fvitamin_d_before = Expression<String>("vitamin_d_before")
            let fvitamin_d_before_drug = Expression<String>("vitamin_d_before_drug")
            let fvitamin_d_after = Expression<String>("vitamin_d_after")
            let fvitamin_d_after_drug = Expression<String>("vitamin_d_after_drug")
            let fweekendAtSouth = Expression<String>("weekendAtSouth")
            let fweekendAtSouth_firstTrimester = Expression<String>("weekendAtSouth_firstTrimester")
            let fweekendAtSouth_secondTrimester = Expression<String>("weekendAtSouth_secondTrimester")
            let fweekendAtSouth_thirdTrimester = Expression<String>("weekendAtSouth_thirdTrimester")
            let fsolarium = Expression<String>("solarium")
            let fHbA1C = Expression<Double?>("HbA1C")
            let ftriglycerides = Expression<Double?>("triglycerides")
            let fcholesterol = Expression<Double?>("cholesterol")
            let fglucose = Expression<Double?>("glucose")
            let ffamily_diabetes = Expression<String>("family_diabetes")
            let fimpaired_glucose_tolerance = Expression<String>("impaired_glucose_tolerance")
            let fhypertension_before = Expression<String>("hypertension_before")
            let fhypertension_after = Expression<String>("hypertension_after")
            let fsmoking_before6month = Expression<String>("smoking_before6month")
            let fsmoking_before_known = Expression<String>("smoking_before_known")
            let fsmoking_after = Expression<String>("smoking_after")
            let ffruits_before = Expression<String>("fruits_before")
            let ffruits_after = Expression<String>("fruits_after")
            let fbisquits_before = Expression<String>("bisquits_before")
            let fbisquits_after = Expression<String>("bisquits_after")
            let fbaking_before = Expression<String>("baking_before")
            let fbaking_after = Expression<String>("baking_after")
            let fchocolate_before = Expression<String>("chocolate_before")
            let fchocolate_after = Expression<String>("chocolate_after")
            let fmilk_before = Expression<String>("milk_before")
            let fmilk_after = Expression<String>("milk_after")
            let fmilk_before_alt = Expression<String>("milk_before_alt")
            let fmilk_after_alt = Expression<String>("milk_after_alt")
            let flegumes_before = Expression<String>("legumes_before")
            let flegumes_after = Expression<String>("legumes_after")
            let fmeat_before = Expression<String>("meat_before")
            let fmeat_after = Expression<String>("meat_after")
            let fdried_fruits_before = Expression<String>("dried_fruits_before")
            let fdried_fruits_after = Expression<String>("dried_fruits_after")
            let ffish_before = Expression<String>("fish_before")
            let ffish_after = Expression<String>("fish_after")
            let fgrain_bread_before = Expression<String>("grain_bread_before")
            let fgrain_bread_after = Expression<String>("grain_bread_after")
            let fany_bread_before = Expression<String>("any_bread_before")
            let fany_bread_after = Expression<String>("any_bread_after")
            let fsauce_before = Expression<String>("sauce_before")
            let fsauce_after = Expression<String>("sauce_after")
            let fvegetable_before = Expression<String>("vegetable_before")
            let fvegetable_after = Expression<String>("vegetable_after")
            let falcohol_before = Expression<String>("alcohol_before")
            let falcohol_after = Expression<String>("alcohol_after")
            let fsweet_drinks_before = Expression<String>("sweet_drinks_before")
            let fsweet_drinks_after = Expression<String>("sweet_drinks_after")
            let fcoffe_before = Expression<String>("coffe_before")
            let fcoffe_after = Expression<String>("coffe_after")
            let fsausages_before = Expression<String>("sausages_before")
            let fsausages_after = Expression<String>("sausages_after")
            let fwalk_before = Expression<String>("walk_before")
            let fwalk_after = Expression<String>("walk_after")
            let fstep_before = Expression<String>("step_before")
            let fstep_after = Expression<String>("step_after")
            let fsport_before = Expression<String>("sport_before")
            let fsport_after = Expression<String>("sport_after")
            for i in try db.prepare(questionaryT) {
                answers.append(contentsOf: [i[fpregnancy_n], i[fdelivery_n], i[fcontraceptive], i[fprolactin_test], i[fheightened_prolactin], i[fprolactin_drug_prescribed], i[fprolactin_drug], i[fvitamin_d_before], i[fvitamin_d_before_drug], i[fvitamin_d_after], i[fvitamin_d_after_drug], i[fweekendAtSouth], i[fweekendAtSouth_firstTrimester], i[fweekendAtSouth_secondTrimester], i[fweekendAtSouth_thirdTrimester], i[fsolarium], (i[fHbA1C] == nil ? "" : String(i[fHbA1C]!)), (i[ftriglycerides] == nil ? "" : String(i[ftriglycerides]!)), (i[fcholesterol] == nil ? "" : String(i[fcholesterol]!)), (i[fglucose] == nil ? "" : String(i[fglucose]!)), i[ffamily_diabetes], i[fimpaired_glucose_tolerance], i[fhypertension_before], i[fhypertension_after], i[fsmoking_before6month], i[fsmoking_before_known], i[fsmoking_after], i[ffruits_before], i[ffruits_after], i[fbisquits_before], i[fbisquits_after], i[fbaking_before], i[fbaking_after], i[fchocolate_before], i[fchocolate_after], i[fmilk_before], i[fmilk_after], i[fmilk_before_alt], i[fmilk_after_alt], i[flegumes_before], i[flegumes_after], i[fmeat_before], i[fmeat_after], i[fdried_fruits_before], i[fdried_fruits_after], i[ffish_before], i[ffish_after], i[fgrain_bread_before], i[fgrain_bread_after], i[fany_bread_before], i[fany_bread_after], i[fsauce_before], i[fsauce_after], i[fvegetable_before], i[fvegetable_after], i[falcohol_before], i[falcohol_after], i[fsweet_drinks_before], i[fsweet_drinks_after], i[fcoffe_before], i[fcoffe_after], i[fsausages_before], i[fsausages_after], i[fwalk_before], i[fwalk_after], i[fstep_before], i[fstep_after], i[fsport_before], i[fsport_after]])
            }
        } catch {
            print(error)
        }
        return [questions, answers]
    }
}
