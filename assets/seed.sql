INSERT INTO transaction_types (id, sign, name, created, updated)
VALUES
('a3791c76', -1, 'loan', datetime('now'), datetime('now')),
('b7a4dbfa', 1, 'payment', datetime('now'), datetime('now')),
('bcf40d21', 1, 'filling', datetime('now'), datetime('now'));

INSERT INTO persons (id, name, phone, created, updated)
VALUES
('b9289497', 'Mirna Lethabridge', '627-673-5999', datetime('now'), datetime('now')),
('03ad74ef', 'Doroteya Puttan', '691-941-2021', datetime('now'), datetime('now')),
('afe07692', 'Jemmy Faulconer', '810-744-5016', datetime('now'), datetime('now')),
('5e3b6d8e', 'Fredelia Carneck', '735-453-6698', datetime('now'), datetime('now')),
('db997220', 'Florida Dredge', '353-771-8257', datetime('now'), datetime('now')),
('067d1e85', 'Ashleigh Galia', '803-308-5614', datetime('now'), datetime('now')),
('b69d4b5d', 'Rufus Pumfrett', '431-970-8974', datetime('now'), datetime('now')),
('ea7741f7', 'Guendolen McKniely', '384-672-0578', datetime('now'), datetime('now')),
('67f7506c', 'Queenie Higbin', '527-688-0196', datetime('now'), datetime('now')),
('573c7212', 'Clarisse Dumphrey', '732-561-2080', datetime('now'), datetime('now')),
('ef3b6bd0', 'Barclay Robins', '861-188-7584', datetime('now'), datetime('now')),
('ba9fa013', 'Leland Mc Caughan', '778-705-234', datetime('now'), datetime('now')),
('09ff15a3', 'Joshuah Welfair', '916-672-9321', datetime('now'), datetime('now')),
('8ba061d9', 'Sonia Martinek', '475-311-4381', datetime('now'), datetime('now')),
('c22bb382', 'King Ruggs', '671-533-9382', datetime('now'), datetime('now')),
('b7a4dbfa', 'Roxy Polo', '466-671-2963', datetime('now'), datetime('now')),
('bcf40d21', 'Ricca Vowdon', '752-284-7668', datetime('now'), datetime('now')),
('a3791c76', 'Jaclin Sanches', '194-387-2465', datetime('now'), datetime('now')),
('88c0581b', 'Melloney Olennikov', '253-177-9467', datetime('now'), datetime('now')),
('c8af1c44', 'Lauralee Leek', '796-534-6577', datetime('now'), datetime('now'));

INSERT INTO transactions (id, amount, created, updated, person, type)
VALUES
('b703d23e', 4336, datetime('now'), datetime('now'), 'bcf40d21', 'a3791c76'),
('ade8f7ab', 1612, datetime('now'), datetime('now'), '09ff15a3', 'bcf40d21'),
('0fffe207', 1913, datetime('now'), datetime('now'), '09ff15a3', 'b7a4dbfa'),
('d7b053cf', 2467, datetime('now'), datetime('now'), 'c8af1c44', 'b7a4dbfa'),
('959a9c09', 4272, datetime('now'), datetime('now'), 'b69d4b5d', 'bcf40d21'),
('44d0b8ad', 4335, datetime('now'), datetime('now'), 'c8af1c44', 'bcf40d21'),
('d460e5e1', 1841, datetime('now'), datetime('now'), 'ba9fa013', 'bcf40d21'),
('1952ed1a', 1243, datetime('now'), datetime('now'), 'db997220', 'bcf40d21'),
('d56caec7', 1762, datetime('now'), datetime('now'), 'c8af1c44', 'bcf40d21'),
('c6668d98', 1391, datetime('now'), datetime('now'), 'bcf40d21', 'a3791c76'),
('36468c95', 2635, datetime('now'), datetime('now'), 'c22bb382', 'bcf40d21'),
('c14893ff', 3067, datetime('now'), datetime('now'), 'b69d4b5d', 'bcf40d21'),
('ff544a80', 3400, datetime('now'), datetime('now'), '09ff15a3', 'b7a4dbfa'),
('988b8977', 3980, datetime('now'), datetime('now'), 'afe07692', 'b7a4dbfa'),
('5a15c2f6', 4890, datetime('now'), datetime('now'), 'ef3b6bd0', 'a3791c76'),
('a5a5ddae', 3318, datetime('now'), datetime('now'), 'ef3b6bd0', 'bcf40d21'),
('a4dfd55d', 3986, datetime('now'), datetime('now'), 'ef3b6bd0', 'bcf40d21'),
('0040e0a9', 2807, datetime('now'), datetime('now'), 'b69d4b5d', 'a3791c76'),
('e92b87b4', 2439, datetime('now'), datetime('now'), 'ef3b6bd0', 'a3791c76'),
('08387bc8', 2469, datetime('now'), datetime('now'), '5e3b6d8e', 'b7a4dbfa'),
('62c9b958', 523, datetime('now'), datetime('now'), '8ba061d9', 'a3791c76'),
('b17eafa0', 4224, datetime('now'), datetime('now'), '09ff15a3', 'a3791c76'),
('d03dc754', 2823, datetime('now'), datetime('now'), 'b69d4b5d', 'a3791c76'),
('87fceb4d', 2789, datetime('now'), datetime('now'), '067d1e85', 'b7a4dbfa'),
('e3a28e62', 1886, datetime('now'), datetime('now'), 'b69d4b5d', 'a3791c76'),
('f8aeb163', 2207, datetime('now'), datetime('now'), '8ba061d9', 'a3791c76'),
('46d4d588', 3267, datetime('now'), datetime('now'), '573c7212', 'b7a4dbfa');