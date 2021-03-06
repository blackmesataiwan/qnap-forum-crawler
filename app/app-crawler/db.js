var path = require('path');
var fs = require('fs');
require('dotenv').config({
    path: path.resolve(__dirname + "/.env")
});
const log = require('./log.js').db(process.env.DEBUG);
const mariadb = require('mariadb/callback');

const conn = mariadb.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PWD,
    database: process.env.DB,
    multipleStatements: true
})

function check_tablses() {
    var sql = `SHOW TABLES WHERE \`Tables_in_${process.env.DB}\` LIKE 'content' OR \`Tables_in_${process.env.DB}\` LIKE 'metadata' OR \`Tables_in_${process.env.DB}\` LIKE 'date_rank';`
    conn.query(sql,
        (err, result) => {
            if (err) throw err;
            log.debug(result);
            if (result.length != 3) {
                var initdb = fs.readFileSync(path.resolve(__dirname + "/init/init_tables.sql"), "utf-8");
                conn.query(initdb,
                    (err, result) => {
                        if (err) throw err;
                        log.debug(result);
                        return result
                    });
            }
        });
}

function check_triggers() {
    var sql = `SHOW TRIGGERS WHERE \`Trigger\` LIKE 'Rank_daily_I' OR \`Trigger\` LIKE 'Rank_daily_U'`
    conn.query(sql,
        (err, result) => {
            if (err) throw err;
            log.debug(result);
            if (result.length != 2) {
                var initdb = fs.readFileSync(path.resolve(__dirname + "/init/init_trigger.sql"), "utf-8");
                conn.query(initdb,
                    (err, result) => {
                        if (err) throw err;
                        log.debug(result);
                        return result
                    });
            }
        });
}

check_tablses();
check_triggers();

conn.on('error', err => {
    log.error(err);
    process.exit(1);
});

module.exports = {
    update(table, sourcedata) {
        let value_string = "",
            get_string = "",
            placeholder = "";
        let data = [];
        for (const [key, value] of Object.entries(sourcedata)) {
            value_string = value_string + `${key}=VALUES(${key}),`;
            get_string = get_string + `${key},`;
            placeholder = placeholder + "?,";
            data.push(value);
        }
        value_string = value_string.substring(0, value_string.length - 1)
        get_string = get_string.substring(0, get_string.length - 1)
        placeholder = placeholder.substring(0, placeholder.length - 1)
        log.debug(`INSERT INTO metadata(${get_string}) VALUES(${placeholder}) ON DUPLICATE KEY UPDATE ${value_string}`);
        conn.query(`INSERT INTO ${table}(${get_string}) VALUES(${placeholder}) ON DUPLICATE KEY UPDATE ${value_string}`,
            data, (err, result) => {
                if (err) throw err;
                log.info(result);
            });
    },
    sync_rank(table, metadata_table) {
        conn.query(`INSERT INTO ${table}(id,rank,_date) SELECT id,rank,_date FROM ${metadata_table}, (SELECT NOW() AS _date) AS DATE ON DUPLICATE KEY UPDATE id=VALUES(id),rank=VALUES(rank),_date=VALUES(_date);`,
            (err, result) => {
                if (err) throw err;
                log.info(result);
            });
    },
    close_db() {
        conn.end(err => {
            if (err) throw err;
            log.info(err);
        })
    },
    debug_query(query) {
        conn.query(query,
            (err, result) => {
                if (err) throw err;
                console.log(result);
                return result
            });
    }
}