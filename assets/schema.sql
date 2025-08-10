CREATE TABLE `persons` (
    `id` TEXT PRIMARY KEY DEFAULT ('r'||lower(hex(randomblob(7)))) NOT NULL, 
    `bio` TEXT DEFAULT '' NOT NULL, 
    `name` TEXT DEFAULT '' NOT NULL, 
    `phone` TEXT DEFAULT '' NOT NULL, 
    `related_to` TEXT DEFAULT '' NOT NULL, 
    `created` TEXT DEFAULT '' NOT NULL, 
    `updated` TEXT DEFAULT '' NOT NULL);

CREATE TABLE `transaction_types` (
    `id` TEXT PRIMARY KEY DEFAULT ('r'||lower(hex(randomblob(7)))) NOT NULL, 
    `sign` NUMERIC DEFAULT 0 NOT NULL, 
    `type` TEXT DEFAULT '' NOT NULL, 
    `created` TEXT DEFAULT '' NOT NULL, 
    `updated` TEXT DEFAULT '' NOT NULL);
CREATE UNIQUE INDEX `idx_mGmeyhxXgI` ON `transaction_types` (`type`);

CREATE TABLE `transactions` (
    `amount` NUMERIC DEFAULT 0 NOT NULL,
    `created` TEXT DEFAULT '' NOT NULL,
    `id` TEXT PRIMARY KEY DEFAULT ('r'||lower(hex(randomblob(7)))) NOT NULL,
    `notes` TEXT DEFAULT '' NOT NULL,
    `person` TEXT DEFAULT '' NOT NULL, 
    `type` TEXT DEFAULT '' NOT NULL, 
    `updated` TEXT DEFAULT '' NOT NULL);

CREATE VIEW `persons_overview` AS SELECT * FROM (SELECT
    p.id as id,
    p.name as name,
    SUM(CASE WHEN type.sign = -1 THEN t.amount END) as loan,
    SUM(t.amount * type.sign) as remainder,
    MAX(t.created) as last_transaction
FROM transactions AS t
INNER JOIN persons AS p on p.id = t.person
INNER JOIN transaction_types AS type on type.id = t.type
WHERE type.type = 'payment' OR type.type = 'loan'
GROUP BY person
HAVING remainder < 0);

