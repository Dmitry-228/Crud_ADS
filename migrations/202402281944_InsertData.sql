-- migrate:up
insert into advertisements_data.author(name) values
('Игорь'),
('Елена'),
('Артём'),
('Алиса'),
('Виктор'),
('Егор');


insert into advertisements_data.ads(name, description, publish_date, author_id) values
('Тур в Анапу', 'Краснодарский край, Анапа, улица Астраханская, 99', '2001-04-10', (SELECT id FROM advertisements_data.author WHERE name='Игорь')),
('Выходные в Сочи', 'Сочи, улица Навагинская, 23', '2024-04-28', (SELECT id FROM advertisements_data.author WHERE name='Елена')),
('Путешествие по Крыму', 'Крым, Ялта, проспект Ленина, 15', '2020-02-06', (SELECT id FROM advertisements_data.author WHERE name='Артём')),
('Экскурсии по Петербургу', 'Санкт-Петербург, Невский проспект, 28', '2010-10-10', (SELECT id FROM advertisements_data.author WHERE name='Алиса')),
('Отдых в Калининграде', 'Калининград, улица Генерала Челнокова, 12', '2023-10-15', (SELECT id FROM advertisements_data.author WHERE name='Виктор')),
('Живописные места Карелии', 'Карелия, озеро Онежское', '2024-03-04', (SELECT id FROM advertisements_data.author WHERE name='Егор'));


insert into advertisements_data.sites(name, url, rating) values
('Путешествия по России', 'http://puteshestviyarossii.com', 4.7),
('Отдых на море', 'http://otdyhnamore.com', 4.5),
('Крымские каникулы', 'http://krymkanikuly.com', 4.9),
('Северные каникулы', 'http://severnyekanikuly.com', 4.8),
('Исторические города России', 'http://istoricheskiegoroda.com', 4.6),
('Природа России', 'http://prirodarossii.com', 4.7);


insert into advertisements_data.ads_to_sites (ad_id, sites_id) values
((SELECT id FROM advertisements_data.ads WHERE name='Тур в Анапу'), (SELECT id FROM advertisements_data.sites WHERE name='Путешествия по России')),
((SELECT id FROM advertisements_data.ads WHERE name='Выходные в Сочи'), (SELECT id FROM advertisements_data.sites WHERE name='Отдых на море')),
((SELECT id FROM advertisements_data.ads WHERE name='Путешествие по Крыму'), (SELECT id FROM advertisements_data.sites WHERE name='Крымские каникулы')),
((SELECT id FROM advertisements_data.ads WHERE name='Экскурсии по Петербургу'), (SELECT id FROM advertisements_data.sites WHERE name='Исторические города России')),
((SELECT id FROM advertisements_data.ads WHERE name='Отдых в Калининграде'), (SELECT id FROM advertisements_data.sites WHERE name='Северные каникулы')),
((SELECT id FROM advertisements_data.ads WHERE name='Живописные места Карелии'), (SELECT id FROM advertisements_data.sites WHERE name='Природа России'));
-- migrate:down