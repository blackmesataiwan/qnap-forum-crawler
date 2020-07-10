var log4js = require('log4js');

log4js.configure({
    appenders: {
        std: {
            type: "stdout",
            level: "all",
            layout: {
                type: "basic",
            }
        },
        file_app: {
            type: "file",
            filename: "log/app.log",
            encoding: "utf-8"
        },
        file_db: {
            type: "file",
            filename: "log/db.log",
            encoding: "utf-8"
        }
    },
    categories: {
        default: {
            appenders: ["std"],
            level: "debug"
        },
        debug_APP: {
            appenders: ["std"],
            level: "debug"
        },
        debug_DB: {
            appenders: ["std"],
            level: "debug"
        },
        app: {
            appenders: ["std", "file_app"],
            level: "info"
        },
        db: {
            appenders: ["file_db"],
            level: "info"
        }
    }
});

module.exports = {
    app(debug = 0) {
        if (debug != 0) {
            return log4js.getLogger("debug_APP")
        } else {
            return log4js.getLogger("app") 
        }
    },
    db(debug = 0) {
        if (debug != 0) {
            return log4js.getLogger("debug_DB")
        } else {
            return log4js.getLogger("db")
        }
    }
}