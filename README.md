# QNAP Forum Crawler

## 前言
目前Surveillance板塊文章約有2600則，但目前沒有有效的方式去運用網友在論壇上面討論的內容進行功能上規劃，以及收集使用者在操作上可能發生的問題，若是以人工一個一個分類、統計將會花去很多時間，故規劃以非人工、自動化的方式收集論壇上的文章，並進行歸納及分析。

## 目的
收集、歸納網友分享文章中使用情境、功能要求、攝影機支援等訊息提供PM開發產品時的參考。也及早收集預警客戶對於產品品質疑慮的回報。

## 功能
### 主要功能(To Do) : 
* 歸納各類QVR產品有那些文章
* 統計哪類文章最多回覆
* 統計每個文章回覆頻率
* 在QVR新版本發行時，監測板塊文章討論熱度與新版本之間的關係
* 收集使用者需求(功能、攝影機整合等)
* 收集使用者遇到的問題

### 收集資料(初步完成) :
* 文章標題
* 文章ID
* 文章作者
* 作者註冊時間
* 文章建立日期
* 文章觀看次數
* 文章回覆數量
* 文章最後回覆日期
* 文章排名
* 於第一頁出現的累積日數
* 文章內容
* 文章回覆作者
* 文章回覆內容
* 每日新文章數量


## 採用工具

* [Jobber](https://github.com/dshearer/jobber/)
* Framework : 
    * node-crawler
    * log4js
    * mariadb
* Dashboard :
    * Grafana

## Prerequisites

* MariaDB
* Docker

## Getting started
1. Deploy
    ```BASH
    DB_HOST=<DB_IP> DB_USER=<DB_username> DB_PWD=<DB_password> DB=<DB_name> docker-compose up
    ```

2. Login to Grafana : [http://\<ip\>:3000/](http://<ip>:3000/)

## Usage-Job

* Check job status
    ```BASH
    docker exec -ti app-crawler jobber list
    ```
* Test job
    ```BASH
    docker exec -ti app-crawler jobber test DailyRun
    ```
* Edit job config : ./app/jobber/jobber