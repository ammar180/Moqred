INSERT INTO transaction_types (id, sign, type, name, created, updated)
VALUES
('a3791c76', -1, 'loan', 'قرض', datetime('now', 'localtime'), datetime('now', 'localtime')),
('b7a4dbfa', 1, 'payment', 'سداد', datetime('now', 'localtime'), datetime('now', 'localtime')),
('bcf40d21', 1, 'filling', 'ملئ الرصيد', datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO persons (id, name, phone, created, updated)
VALUES
('b9289497', 'Mirna Lethabridge', '627-673-5999', datetime('now', 'localtime'), datetime('now', 'localtime')),
('03ad74ef', 'Doroteya Puttan', '691-941-2021', datetime('now', 'localtime'), datetime('now', 'localtime')),
('afe07692', 'Jemmy Faulconer', '810-744-5016', datetime('now', 'localtime'), datetime('now', 'localtime'));