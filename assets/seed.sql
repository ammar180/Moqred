INSERT INTO transaction_types (sign, type, created, updated)
VALUES
(-1, 'loan', datetime('now'), datetime('now')),
(1, 'payment', datetime('now'), datetime('now')),
(1, 'filling', datetime('now'), datetime('now'));

INSERT INTO persons (bio, name, phone, related_to, created, updated)
VALUES
('', 'Alice Johnson', '1234567890', '', datetime('now'), datetime('now')),
('', 'Bob Smith', '9876543210', '', datetime('now'), datetime('now'));

INSERT INTO transactions (amount, created, notes, person, type, updated)
VALUES
(500, datetime('now'), 'Loan given to Alice', 
(SELECT id FROM persons WHERE name = 'Alice Johnson'),
(SELECT id FROM transaction_types WHERE type = 'loan'),
datetime('now')),

(200, datetime('now'), 'Payment from Alice', 
(SELECT id FROM persons WHERE name = 'Alice Johnson'),
(SELECT id FROM transaction_types WHERE type = 'payment'),
datetime('now')),

(300, datetime('now'), 'Loan given to Bob', 
(SELECT id FROM persons WHERE name = 'Bob Smith'),
(SELECT id FROM transaction_types WHERE type = 'loan'),
datetime('now'));