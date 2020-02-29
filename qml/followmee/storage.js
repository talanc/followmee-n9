.pragma library

var __db = null

var __dummyScores = [{ name: "MEE", score: 1 },
                     { name: "MEE", score: 2 },
                     { name: "MEE", score: 3 } ]

var NUM_SCORES = __dummyScores.length

function __openDb() {
    if (__db === null) {
        __db = openDatabaseSync("followmee", "1.0", "followmee data", 100)
        __db.transaction(__createTables)
    }
}

function __createTables(tx) {
    tx.executeSql("CREATE TABLE IF NOT EXISTS Scores(name TEXT, score INT)")

    var rs = tx.executeSql("SELECT * FROM Scores")
    if (rs.rows.length === 0) {
        __insertScores(tx, __dummyScores)
    }
}

function __insertScores(tx, scores) {
    for (var i = 0, count = scores.length; i < count; i++) {
        tx.executeSql("INSERT INTO Scores VALUES(?, ?)",
                      [ scores[i].name, scores[i].score ])
    }
}

function insertDummyScores() {
    __openDb()
    __db.transaction(function (tx) {
                         tx.executeSql("DELETE FROM Scores")
                         __insertScores(tx, __dummyScores)
                     })
}

function getHighScores() {
    var rows = []
    __openDb()
    __db.transaction(function (tx) {
                       var rs = tx.executeSql("SELECT * FROM Scores ORDER BY score DESC")
                       for (var i = 0, count = rs.rows.length; i < count; i++) {
                           rows.push(rs.rows.item(i))
                       }
                   })
    return rows
}

function isHighScore(score) {
    var scores = getHighScores()
    for (var i = 0, count = scores.length; i < count; i++) {
        if (score >= scores[i].score) {
            return true
        }
    }
    return false
}

function postHighScore(name, score) {
    var scoreIdx = -1
    var scores = getHighScores()
    var obj = { name: name, score: score }
    for (var i = 0, count = scores.length; i < count; i++) {
        if (obj.score >= scores[i].score) {
            if (scoreIdx === -1) {
                scoreIdx = i
            }
            var temp = scores[i]
            scores[i] = obj
            obj = temp
        }
    }

    __openDb()
    __db.transaction(function (tx) {
                         tx.executeSql("DELETE FROM Scores")
                         __insertScores(tx, scores)
                     });
    return scoreIdx
}
