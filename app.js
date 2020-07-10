require('dotenv').config();
const log = require('./log.js').app(process.env.DEBUG);
const url = require('url');
const Crawler = require("crawler");
const querystring = require('querystring');

const db = require('./db');

const BASE_URL = "https://forum.qnap.com";
const BLOCK_NAME = "Surveillance Solution";
const BLOCK_LIST_URL = BASE_URL + "/viewforum.php?f=74"
const BLOCK_URL = BASE_URL + "/viewforum.php?f=187"

//計算分頁
function query_content(type, url_link, topic_number) {
    return new Promise((resolve, reject) => {
        if (topic_number == null) {
            log.error("No page number");
            reject(Error("No page number"));
        } else {
            var url_list = [];
            var page_count = 0;
            var split_num = 0;
            switch (type) {
                case 0:
                    split_num = 20;
                    break;
                case 1:
                    split_num = 15;
                    break;
                default:
                    reject(Error("No Type"));
            }
            page_count = topic_number - (topic_number % split_num)
            log.debug('Paqge : ', (page_count / split_num) + 1)
            for (let page = 0; page <= page_count; page += split_num) {
                url_list.push(url_link + '&start=' + page);
            }
            //console.log(url_list[url_list.length - 1]);
            resolve(url_list);
        }
    });
}

//去掉sid
function link_parse(url_link) {
    var base_link = url.resolve(BASE_URL, url_link);
    var link = new url.URL(base_link);
    link.searchParams.delete('sid');
    return link.href
}

//抓取該板塊總共有多少Topic
var topic_pages = new Crawler({
    maxConnections: 1,
    callback: function (error, res, done) {
        if (error) {
            log.error(error);
        } else {
            var $ = res.$;
            log.info("WEB-Title: " + $("title").text());
            var topic_number = parseInt($('.row-item:contains(' + BLOCK_NAME + ')').find('.topics').text().split(" ")[0])
            log.info('Topic number : ', topic_number)
            query_content(0, BLOCK_URL, topic_number).then(url_list => {
                log.debug('List : ', url_list)
                topic_list.queue(url_list);
            });

        }
        done();
    }
});

//抓取Topic Metadata
var topic_list = new Crawler({
    // 工作線程池的大小
    maxConnections: 10,
    // 兩次請求之間的間隔時間
    rateLimit: 500,

    callback: function (error, res, done) {
        if (error) {
            log.error(error);
        } else {
            var $ = res.$;
            log.info("Topic-Title: " + $("title").text());

            $topiclist = $('.topiclist.topics > li');
            $topiclist.each(function (index, item) {

                var metadata = {
                    topic: $(item).find('.topictitle').text(),
                    poster: $(item).find('.topic-poster > .username').text(),
                    link: link_parse($(item).find('.topictitle').attr("href")),
                    id: parseInt(querystring.parse($(item).find('.topictitle').attr("href")).t),
                    create_date: new Date($(item).find('.topic-poster').text().split("»")[1]),
                    last_post_date: new Date($(item).find('.lastpost').text().split("\n")[5]),
                    replies: parseInt($(item).find('.posts').text().split(" ")[0]),
                    views: parseInt($(item).find('.views').text().split(" ")[0]),
                    rank: parseInt(querystring.parse(res.request.uri.query).start) + index
                }
                
                log.debug(metadata);

                db.update("metadata", metadata);
                
                query_content(1, metadata.link, metadata.replies).then(url_list => {
                    log.debug('List : ', url_list)
                    topic_content.queue(url_list);
                });


            });
        }
        done();
    }
});

//抓取Topic Content
var topic_content = new Crawler({
    // 工作線程池的大小
    maxConnections: 10,
    // 兩次請求之間的間隔時間
    rateLimit: 500,
    callback: function (error, res, done) {
        if (error) {
            log.error(error);
        } else {
            var $ = res.$;
            log.info("Content-Title: " + $("title").text());
            //console.log(res.request.uri);
            $topiclist = $('.post.has-profile');
            $topiclist.each(function (index, item) {

                var data = {
                    id: $(item).attr("id"),
                    topic_id: parseInt(querystring.parse(res.request.uri.query).t),
                    post_index: parseInt(querystring.parse(res.request.uri.query).start) + index,
                    post_type: querystring.parse(res.request.uri.query).start + index == 0 ? ("Main") : ("Re"),
                    poster: $(item).find('.author .username').text(),
                    create_date: new Date($(item).find('.post.has-profile .author').text().split("»")[1]),
                    content: $(item).find('.content').html(),
                }

                log.debug(data);

                db.update("content", data);

            });
        }
        done();
    }
});

topic_pages.queue([BLOCK_LIST_URL]);
