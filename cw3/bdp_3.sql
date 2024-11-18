CREATE EXTENSION postgis;

-- 1
CREATE VIEW res_task_1 AS
WITH changes AS (
    SELECT 
        b2.gid AS gid_2019
        ,b2.polygon_id
        ,b2.geom
        ,'modified' AS change_type  
    FROM 
        buildings_2018 AS b1
    JOIN 
        buildings_2019 AS b2 ON b1.polygon_id = b2.polygon_id
    WHERE 
        b1.height != b2.height OR NOT ST_Equals(b1.geom, b2.geom)
),
new_buldings AS (
    SELECT 
        b2.gid AS gid_2019
        ,b2.polygon_id
        ,b2.geom
        ,'new' AS change_type  -- Typ zmiany: nowy budynek
    FROM 
        buildings_2019 AS b2
    LEFT JOIN 
        buildings_2018 AS b1 ON b1.polygon_id = b2.polygon_id
    WHERE 
        b1.polygon_id IS NULL
)
SELECT * FROM changes
UNION ALL
SELECT * FROM new_buldings;


-- 2
WITH new_pois AS (
	SELECT poi_id FROM poi_2019 EXCEPT SELECT poi_id FROM poi_2018
)
SELECT p.type, COUNT(p.type) AS n_new 
FROM poi_2019 as p
JOIN res_task_1 AS b ON ST_DWithin(p.geom, b.geom, 500)
WHERE p.poi_id IN (SELECT * FROM new_pois)
GROUP BY p.type;

-- 3
SELECT * FROM streets_reprojected;

-- Zadanie 4
CREATE TABLE input_points(
	id SERIAL PRIMARY KEY
	,geom geometry
);

INSERT INTO input_points(geom) VALUES 
('POINT(8.36093 49.03174)')
,('POINT(8.39876 49.00644)');

SELECT * FROM input_points;

-- Zadanie 5
UPDATE input_points
SET geom = ST_SetSRID(geom, 3068);

-- Zadanie 6
SELECT * FROM street_node_2019 AS sn
WHERE ST_DWithin(sn.geom, ST_MakeLine(ARRAY(SELECT p.geom FROM input_points p)), 200)
	AND sn.intersect = 'Y';

-- Zadanie 7
SELECT COUNT(p.gid)
FROM poi_2019 AS p
JOIN land_use_2019 AS lu
	ON ST_DWithin(ST_SetSRID(p.geom, 3068), lu.geom, 300)
WHERE p.type='Sporting Goods Store' AND lu.type = 'Park (City/County)';

-- Zadanie 8
CREATE TABLE T2019_KAR_BRIDGES (
    gid SERIAL PRIMARY KEY,
    geom geometry
);

INSERT INTO T2019_KAR_BRIDGES (geom)
SELECT ST_Intersection(r.geom, w.geom) AS geom
FROM railways_2019 AS r
JOIN water_lines_2019 AS w
    ON ST_Intersects(r.geom, w.geom)
WHERE ST_GeometryType(ST_Intersection(r.geom, w.geom)) = 'ST_Point';

SELECT * FROM T2019_KAR_BRIDGES;