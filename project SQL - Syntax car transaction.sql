-- Creating Transactional Query

-- nomer 1

select * from product 
where tahun > 2015
limit 10;

-- nomer 2 

select * from bid
where bit_status = 'Sent';

-- setelah insert

-- nomor 2 insert

insert into bid (bid_id, product_id, user_id, iklan_id, harga_bit, tanggal_bit, bit_status)
values('101','2','100','30','150000000', '2023-01-01 14:05:27.12345','Sent');

-- nomer 3

select product_id, brand, model, tahun, harga, tanggal_posting from iklan 
left join user_info using(user_id)
left join product using(product_id)
where nama_user = 'Daniswara Astuti, S.H.'
order by tanggal_posting desc;

-- nomer 4

select product_id, brand, model, tahun, harga
from product 
where lower(model) like '%yaris%'
order by harga;

-- nomer 5

SELECT
    p.product_id,
    p.brand,
    p.model,
    k.kota_id,
    SQRT(POW(k.lokasi[0] - k.lokasi[0], 2) + POW(k.lokasi[1] - k.lokasi[1], 2)) AS distance
FROM
    product p
JOIN
    iklan i ON p.product_id = i.product_id
JOIN
	user_info ui on ui.user_id = i.user_id
JOIN
    kota k ON ui.kota_id = k.kota_id
WHERE
    k.kota_id = 3 
ORDER BY
    distance;

-- Creating Analytical Query

-- nomer 1

select 
	model,
	count(model) as count_product,
	count(*) as count_bid
from bid 
left join product using(product_id)
group by 1
order by count_bid desc
limit 5

-- nomer 2
  
SELECT
    k.nama_kota,
    p.brand,
    p.model,
    p.tahun,
    p.harga,
    ROUND(AVG(p.harga) OVER (PARTITION BY k.nama_kota)) AS avg_car_city
FROM
    product p
JOIN
    iklan i ON p.product_id = i.product_id
JOIN
    user_info ui ON i.user_id = ui.user_id
JOIN
	kota k on ui.kota_id = k.kota_id
limit 10

-- nomer 3
  
WITH BidComparison AS (
    SELECT
        model,
        user_id,
        tanggal_bid AS first_bid_date,
        LEAD(tanggal_bid) OVER (PARTITION BY model ORDER BY tanggal_bid) AS next_bid_date,
        harga_bid AS first_bid_price,
        LEAD(harga_bid) OVER (PARTITION BY model ORDER BY tanggal_bid) AS next_bid_price
    FROM
        bid join product using(product_id)
    WHERE
        model = 'Toyota Yaris'
)
SELECT
    model,
    user_id,
    first_bid_date,
    next_bid_date,
    first_bid_price,
    next_bid_price
FROM
    BidComparison
ORDER BY
    user_id;

-- nomer 4

WITH AvgPrices AS (
    SELECT
        model,
        AVG(harga) AS avg_price
    FROM
        product
    GROUP BY
        model
),
AvgBids AS (
    SELECT
        p.model,
        AVG(b.harga_bid) AS avg_bid_6month
    FROM
        bid b
    JOIN
        iklan i ON b.iklan_id = i.iklan_id
    JOIN
        product p ON i.product_id = p.product_id
    WHERE
        i.tanggal_posting >= CURRENT_DATE - INTERVAL '6 months'
    GROUP BY
        p.model
)
SELECT
    a.model,
    round(a.avg_price) as avg_price,
    round(b.avg_bid_6month) as avg_bid_6month,
    abs(round(a.avg_price - b.avg_bid_6month)) AS difference,
    abs(round(((a.avg_price - b.avg_bid_6month) / a.avg_price) * 100,2)) AS difference_percent
FROM
    AvgPrices a
JOIN
    AvgBids b ON a.model = b.model;

-- nomer 5

SELECT
    brand,
    model,
    round(AVG(CASE WHEN EXTRACT(MONTH FROM tanggal_bid) = EXTRACT(MONTH FROM CURRENT_DATE) THEN harga_bid END)) AS m_min_1,
    round(AVG(CASE WHEN EXTRACT(MONTH FROM tanggal_bid) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month') THEN harga_bid END)) AS m_min_2,
    round(AVG(CASE WHEN EXTRACT(MONTH FROM tanggal_bid) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '2 months') THEN harga_bid END)) AS m_min_3,
    round(AVG(CASE WHEN EXTRACT(MONTH FROM tanggal_bid) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '3 months') THEN harga_bid END)) AS m_min_4,
    round(AVG(CASE WHEN EXTRACT(MONTH FROM tanggal_bid) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '4 months') THEN harga_bid END)) AS m_min_5,
    round(AVG(CASE WHEN EXTRACT(MONTH FROM tanggal_bid) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '5 months') THEN harga_bid END)) AS m_min_6
FROM
    bid b
JOIN
    product p ON b.product_id = p.product_id
WHERE
    p.model = 'Toyota Yaris'
    AND b.tanggal_bid >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY
    brand, model;
