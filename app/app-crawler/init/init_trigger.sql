DROP TRIGGER IF EXISTS Rank_daily_I;
DROP TRIGGER IF EXISTS Rank_daily_U;

CREATE TRIGGER Rank_daily_I 
AFTER INSERT ON metadata 
FOR EACH ROW 
BEGIN 
INSERT INTO date_rank SET id = NEW.id, rank = NEW.rank, _date=NOW(), replies=NEW.replies, views=NEW.views ON DUPLICATE KEY UPDATE id=VALUES(id),rank=VALUES(rank),_date=VALUES(_date),replies=VALUES(replies),views=VALUES(views); 
END;

CREATE TRIGGER Rank_daily_U 
AFTER UPDATE ON metadata 
FOR EACH ROW 
BEGIN 
INSERT INTO date_rank SET id = NEW.id, rank = NEW.rank, _date=NOW(), replies=NEW.replies, views=NEW.views ON DUPLICATE KEY UPDATE id=VALUES(id),rank=VALUES(rank),_date=VALUES(_date),replies=VALUES(replies),views=VALUES(views); 
END;