DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    customer_id        INT,
    order_id           INT,
    product_id         INT,
    order_date         DATE,
    first_name         VARCHAR(50),
    last_name          VARCHAR(50),
    gender             VARCHAR(10),
    birthday           DATE,
    country            VARCHAR(50),
    product_category   VARCHAR(50),
    product_name       VARCHAR(50),
    quantity           INT,
    price              NUMERIC(10,2),
    total_price        NUMERIC(10,2)
);


WITH customers AS (
    SELECT
        id AS customer_id,
        gender,
        country,
        birthday,
        first_name,
        last_name
    FROM (
        SELECT
            id,
            (ARRAY['Male','Female'])[FLOOR(RANDOM()*2)+1] AS gender,
            (ARRAY[
                'Slovakia','Czech Republic','Poland','France','Germany',
                'Italy','Spain','Netherlands','Hungary'
            ])[FLOOR(RANDOM()*9)+1] AS country,
            (CURRENT_DATE - ((18 + RANDOM()*50)::INT * 365)) AS birthday
        FROM generate_series(1, 1000) AS id
    ) base
    CROSS JOIN LATERAL (
        SELECT
            CASE
                WHEN country = 'Slovakia' AND gender = 'Male' THEN (ARRAY['Jan','Peter','Martin','Lukas','Tomas','Marek','Juraj'])[FLOOR(RANDOM()*7)+1]
                WHEN country = 'Slovakia' AND gender = 'Female' THEN (ARRAY['Lucia','Zuzana','Simona','Katarina','Monika'])[FLOOR(RANDOM()*5)+1]

                WHEN country = 'Czech Republic' AND gender = 'Male' THEN (ARRAY['Jan','Jakub','Petr','Michal'])[FLOOR(RANDOM()*4)+1]
                WHEN country = 'Czech Republic' AND gender = 'Female' THEN (ARRAY['Tereza','Adela','Eliska','Karolina'])[FLOOR(RANDOM()*4)+1]

                WHEN country = 'Poland' AND gender = 'Male' THEN (ARRAY['Piotr','Andrzej','Krzysztof'])[FLOOR(RANDOM()*3)+1]
                WHEN country = 'Poland' AND gender = 'Female' THEN (ARRAY['Agnieszka','Magdalena','Natalia'])[FLOOR(RANDOM()*3)+1]

                WHEN country = 'France' AND gender = 'Male' THEN (ARRAY['Pierre','Louis','Jean','Laurent'])[FLOOR(RANDOM()*4)+1]
                WHEN country = 'France' AND gender = 'Female' THEN (ARRAY['Marie','Sophie','Camille'])[FLOOR(RANDOM()*3)+1]

                WHEN country = 'Germany' AND gender = 'Male' THEN (ARRAY['Hans','Lukas','Leon','Paul'])[FLOOR(RANDOM()*4)+1]
                WHEN country = 'Germany' AND gender = 'Female' THEN (ARRAY['Anna','Mia','Lena'])[FLOOR(RANDOM()*3)+1]

                WHEN country = 'Italy' AND gender = 'Male' THEN (ARRAY['Marco','Luca','Matteo'])[FLOOR(RANDOM()*3)+1]
                WHEN country = 'Italy' AND gender = 'Female' THEN (ARRAY['Giulia','Francesca','Chiara'])[FLOOR(RANDOM()*3)+1]

                WHEN country = 'Spain' AND gender = 'Male' THEN (ARRAY['Carlos','Juan','Jose'])[FLOOR(RANDOM()*3)+1]
                WHEN country = 'Spain' AND gender = 'Female' THEN (ARRAY['Maria','Carmen','Isabella'])[FLOOR(RANDOM()*3)+1]

                WHEN country = 'Netherlands' AND gender = 'Male' THEN (ARRAY['Daan','Bram','Lucas'])[FLOOR(RANDOM()*3)+1]
                WHEN country = 'Netherlands' AND gender = 'Female' THEN (ARRAY['Emma','Sophie','Julia'])[FLOOR(RANDOM()*3)+1]

                WHEN country = 'Hungary' AND gender = 'Male' THEN (ARRAY['Istvan','Laszlo','Zoltan'])[FLOOR(RANDOM()*3)+1]
                WHEN country = 'Hungary' AND gender = 'Female' THEN (ARRAY['Katalin','Eszter','Anna'])[FLOOR(RANDOM()*3)+1]
            END AS first_name,
            CASE country
                WHEN 'Slovakia' THEN (ARRAY['Kovac','Novak','Horvath','Varga','Toth'])[FLOOR(RANDOM()*5)+1]
                WHEN 'Czech Republic' THEN (ARRAY['Dvorak','Prochazka','Kral','Kucera'])[FLOOR(RANDOM()*4)+1]
                WHEN 'Poland' THEN (ARRAY['Kowalski','Nowak','Kaminski','Zielinski'])[FLOOR(RANDOM()*4)+1]
                WHEN 'France' THEN (ARRAY['Dubois','Laurent','Moreau','Lefevre','Roux'])[FLOOR(RANDOM()*5)+1]
                WHEN 'Germany' THEN (ARRAY['Muller','Schmidt','Schneider','Fischer'])[FLOOR(RANDOM()*4)+1]
                WHEN 'Italy' THEN (ARRAY['Rossi','Russo','Ferrari','Esposito'])[FLOOR(RANDOM()*4)+1]
                WHEN 'Spain' THEN (ARRAY['Garcia','Martinez','Lopez','Sanchez'])[FLOOR(RANDOM()*4)+1]
                WHEN 'Netherlands' THEN (ARRAY['de Vries','Jansen','Bakker','Visser'])[FLOOR(RANDOM()*4)+1]
                WHEN 'Hungary' THEN (ARRAY['Nagy','Kovacs','Toth','Szabo'])[FLOOR(RANDOM()*4)+1]
            END AS last_name
    ) names
),
product_map AS (
    SELECT
        ROW_NUMBER() OVER () AS product_id,
        product_category,
        product_name,
        (10 + RANDOM()*90)::NUMERIC(10,2) AS base_price,
        (0.03 + RANDOM()*0.09)::NUMERIC(10,4) AS growth_rate
    FROM (
        VALUES
            ('Clothing','Shirt'),
            ('Clothing','Pants'),
            ('Clothing','Socks'),
            ('Clothing','Underwear'),
            ('Clothing','Hoodie'),
            ('Clothing','Leggings'),
            ('Health Supplements','Protein'),
            ('Health Supplements','Collagen'),
            ('Health Supplements','Vitamins'),
            ('Health Supplements','Minerals'),
            ('Health Supplements','Omega-3'),
            ('Beauty','Make-up'),
            ('Beauty','Skin Care'),
            ('Beauty','Hair Serum'),
            ('Beauty','Face Mask')
    ) AS p(product_category, product_name)
),
days AS (
    SELECT
        day::date AS order_date,
        CASE
            WHEN EXTRACT(YEAR FROM day) = 2023 THEN (5 + FLOOR(RANDOM()*11))
            WHEN EXTRACT(YEAR FROM day) = 2024 THEN (20 + FLOOR(RANDOM()*21))
            WHEN EXTRACT(YEAR FROM day) = 2025 THEN (50 + FLOOR(RANDOM()*31))
            WHEN EXTRACT(YEAR FROM day) = 2026 THEN (100 + FLOOR(RANDOM()*61))
        END AS orders_today
    FROM generate_series(
        '2023-01-01'::date,
        '2026-12-31'::date,
        '1 day'::interval
    ) AS day
),
expanded AS (
    SELECT
        order_date,
        generate_series(1, orders_today::int) AS seq
    FROM days
),
orders_raw AS (
    SELECT
        ROW_NUMBER() OVER () AS order_id,
        cust.customer_id,
        order_date,
        pm.product_id,
        pm.base_price,
        pm.growth_rate,
        (RANDOM()*9 + 1)::INT AS quantity
    FROM expanded
    -- náhodný produkt pre každý riadok
    CROSS JOIN LATERAL (
        SELECT *
        FROM product_map
        ORDER BY RANDOM()
        LIMIT 15
    ) pm
    -- náhodný zákazník podľa roku
    CROSS JOIN LATERAL (
        SELECT customer_id
        FROM customers
        WHERE customer_id <=
            CASE
                WHEN EXTRACT(YEAR FROM order_date) = 2023 THEN 100
                WHEN EXTRACT(YEAR FROM order_date) = 2024 THEN 400
                WHEN EXTRACT(YEAR FROM order_date) = 2025 THEN 700
                WHEN EXTRACT(YEAR FROM order_date) = 2026 THEN 1000
            END
        ORDER BY RANDOM()
        LIMIT 1
    ) cust
)
INSERT INTO orders (
    customer_id, order_id, product_id, order_date,
    first_name, last_name, gender, birthday, country,
    product_category, product_name, quantity, price, total_price
)
SELECT
    o.customer_id,
    o.order_id,
    o.product_id,
    o.order_date,
    c.first_name,
    c.last_name,
    c.gender,
    c.birthday,
    c.country,
    pm.product_category,
    pm.product_name,
    o.quantity,
    ROUND(
        o.base_price * POWER(1 + o.growth_rate, EXTRACT(YEAR FROM o.order_date) - 2023),
        2
    ) AS price,
    ROUND(
        o.quantity * o.base_price * POWER(1 + o.growth_rate, EXTRACT(YEAR FROM o.order_date) - 2023),
        2
    ) AS total_price
FROM orders_raw o
JOIN customers c ON c.customer_id = o.customer_id
JOIN product_map pm ON pm.product_id = o.product_id;

--test
select distinct
product_name
from orders

with names as (
select distinct
customer_id,
first_name,
last_name
from orders
order by customer_id), count as (
select
customer_id,
concat(first_name, ' ', last_name) as name
from names) select*,
count(*) over (partition by name) as name_count
from count
order by name_count desc;

drop view test1;

create view test1 as (
WITH sampled AS (
    SELECT *
    FROM orders
    WHERE RANDOM() < 0.25   -- SQL Server: use RAND()
)
SELECT *
FROM sampled)

-- Zobrazí mi koľko krát sa unikátne meno nachádza vo view PowerBi (jeto dataset zakaznikov za dobu 3 rokov- vela vysledkov je v poriadku)
with names as (
select
customer_id,
first_name,
last_name
from powerbi
order by customer_id), count as (
select
customer_id,
concat(first_name, ' ', last_name) as name
from names), final as (
select*,
count(*) over (partition by name) as name_count
from count
order by name_count desc) 
select distinct
name,
name_count
from final
order by name_count desc;


create view test2 as (
-- TOTO je veľmi mocný sposob ako redukovať náhodne duplicitné riadky:

WITH dedup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id, first_name, last_name ORDER BY RANDOM()
        ) AS rn, -- Tento kód  partition by definuje čo je duplicita a Order by Random () priemeša duplicity náhodne - Row_Number () im priradi v novom stlpci poradove čísla */ 													

        COUNT(*) OVER (
            PARTITION BY customer_id, first_name, last_name
        ) AS total -- Toto ti povie, koľko duplicít má daný zákazník.
    FROM test1
)
SELECT *
FROM dedup
WHERE rn <= total * 0.15 --Toto znamená: nechaj si iba 15 % riadkov z každej duplicitnej skupiny
						 -- zvyšných 85 % odstráň


-- Redukcia konkretnych duplicitných mien (cez 1,4m riadkov)
create view PowerBI as (
WITH marked AS (
    SELECT
        *,
        CASE 
            WHEN CONCAT(first_name, ' ', last_name) IN (
                'Laszlo Kovacs',
                'Juan Sanchez',
                'Krzysztof Kowalski',
                'Isabella Sanchez',
                'Isabella Garcia',
                'Giulia Esposito',
                'Francesca Rossi',
                'Sophie Roux',
                'Michal Dvorak',
                'Eliska Prochazka',
                'Julia de Vries',
                'Katalin Kovacs',
                'Giulia Russo',
                'Lena Muller',
                'Luca Russo',
                'Natalia Zielinski',
                'Lucas Visser',
                'Marco Ferrari',
                'Katalin Szabo',
                'Sophie Lefevre',
                'Jose Sanchez',
                'Istvan Toth',
                'Natalia Kaminski',
                'Jakub Prochazka',
                'Anna Nagy',
                'Sophie de Vries',
                'Camille Roux',
                'Natalia Kowalski',
                'Carmen Lopez',
                'Lucas Bakker',
                'Emma de Vries',
                'Luca Rossi',
                'Carlos Garcia',
                'Agnieszka Zielinski',
                'Petr Kucera',
                'Camille Laurent',
                'Piotr Kowalski',
                'Lena Schmidt',
                'Bram de Vries',
                'Jean Moreau',
                'Chiara Esposito',
                'Tereza Kral',
                'Maria Lopez',
                'Daan Visser',
                'Krzysztof Nowak',
                'Mia Muller',
                'Chiara Rossi',
                'Andrzej Kaminski',
                'Bram Jansen',
                'Francesca Esposito',
                'Magdalena Zielinski',
                'Julia Jansen',
                'Sophie Visser',
                'Juan Garcia',
                'Sophie Moreau',
                'Jean Roux',
                'Anna Toth',
                'Lena Schneider',
                'Jose Martinez',
                'Magdalena Kaminski',
                'Daan Bakker',
                'Piotr Nowak',
                'Adela Prochazka',
                'Jan Varga',
                'Matteo Russo',
                'Katarina Toth',
                'Bram Visser',
                'Chiara Russo',
                'Louis Roux',
                'Daan Jansen',
                'Mia Schmidt',
                'Louis Moreau',
                'Isabella Martinez',
                'Chiara Ferrari',
                'Natalia Nowak',
                'Eszter Szabo',
                'Andrzej Nowak',
                'Karolina Dvorak',
                'Zuzana Toth',
                'Andrzej Zielinski',
                'Agnieszka Kaminski',
                'Anna Schneider',
                'Andrzej Kowalski',
                'Paul Schmidt',
                'Anna Fischer',
                'Zoltan Nagy',
                'Carlos Lopez',
                'Marco Rossi',
                'Pierre Lefevre',
                'Luca Esposito',
                'Lucas de Vries',
                'Istvan Nagy',
                'Carmen Garcia',
                'Luca Ferrari',
                'Leon Muller',
                'Francesca Russo',
                'Isabella Lopez',
                'Zuzana Horvath',
                'Maria Martinez',
                'Agnieszka Nowak',
                'Monika Novak',
                'Hans Fischer',
                'Anna Szabo',
                'Lena Fischer',
                'Marie Laurent',
                'Marco Esposito',
                'Peter Toth',
                'Daan de Vries',
                'Tereza Dvorak',
                'Marie Dubois',
                'Marie Moreau',
                'Jan Kral',
                'Mia Schneider',
                'Camille Dubois',
                'Julia Visser',
                'Karolina Kral',
                'Juan Lopez',
                'Juan Martinez',
                'Jan Dvorak',
                'Hans Schmidt',
                'Sophie Bakker',
                'Lukas Schneider',
                'Marie Roux',
                'Zuzana Novak',
                'Lucia Varga',
                'Piotr Kaminski',
                'Petr Prochazka',
                'Jose Garcia',
                'Marco Russo',
                'Eliska Kucera',
                'Lukas Fischer',
                'Jakub Dvorak',
                'Katalin Nagy',
                'Jan Kovac',
                'Camille Lefevre',
                'Anna Muller',
                'Francesca Ferrari',
                'Paul Schneider',
                'Sophie Jansen',
                'Louis Dubois',
                'Jose Lopez',
                'Zuzana Varga',
                'Giulia Rossi',
                'Carlos Martinez',
                'Simona Horvath',
                'Bram Bakker',
                'Laurent Moreau',
                'Juraj Varga',
                'Paul Muller',
                'Laszlo Toth',
                'Mia Fischer',
                'Tomas Novak',
                'Pierre Dubois',
                'Marek Novak',
                'Zoltan Kovacs',
                'Carlos Sanchez',
                'Pierre Moreau',
                'Katalin Toth',
                'Carmen Sanchez',
                'Matteo Ferrari',
                'Lukas Schmidt',
                'Michal Kucera',
                'Marie Lefevre',
                'Maria Garcia',
                'Jakub Kucera',
                'Camille Moreau',
                'Leon Fischer',
                'Magdalena Nowak',
                'Jan Kucera',
                'Giulia Ferrari',
                'Zuzana Kovac',
                'Istvan Szabo',
                'Michal Prochazka',
                'Hans Schneider',
                'Eszter Kovacs',
                'Eliska Kral',
                'Jan Toth',
                'Leon Schneider',
                'Hans Muller',
                'Adela Kucera',
                'Adela Prochazka',
                'Agnieszka Kowalski'
            )
            THEN 1
            ELSE 0
        END AS target_group
    FROM test2
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY first_name, last_name
            ORDER BY RANDOM()
        ) AS rn_new,
        COUNT(*) OVER (
            PARTITION BY first_name, last_name
        ) AS total_new
    FROM marked
)
SELECT *
FROM ranked
WHERE 
    (target_group = 1 AND rn_new <= total_new * 0.25)
    OR
    (target_group = 0))

    -- Pridá výpočet veku podľa ZK zadaneho datumu narodenia
    select*,
    date_part('year', age(current_date,birthday)) as age
    from powerbi
    order by order_date asc;
    
---- Finalna databaza z fiktivnymi zakaznikmi, objednavkami, produktmi, cenami s náhodným vývojom počas rokov kde je každy ZK prepojeny zo spravnym customer_id etc. bez duplikatov v jednom datume.
    -- Problém tu bol že si Zákazník bežne v jeden deň spravil 3 obrovské objednávky- dataset obsahuje iba Info o 1 objednávke na deň per unikatneho zakaznika. 
create table Powerbi_projekt as (    
 WITH ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY order_date, customer_id
            ORDER BY RANDOM()
        ) AS rn_unique
    FROM powerbi
)
SELECT *
FROM ranked
WHERE rn_unique = 1) -- Zobrazi mi iba partition by obe kategorie kde su duplicity, priradí im všetkým poradové číslo, random ich zamieša a zobrazí mi iba rn_unique (prvý riadok) ! 
-- asi najlepšie možné riešenie pri redukcii duplicitných hodnot vytvorenej fiktivnej database



