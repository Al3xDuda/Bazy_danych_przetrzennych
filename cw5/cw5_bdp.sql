CREATE EXTENSION postgis;


CREATE TABLE obiekty (
    id SERIAL PRIMARY KEY       
    ,nazwa TEXT NOT NULL        
    ,geometria GEOMETRY          
);


INSERT INTO obiekty(id, nazwa, geometria)
VALUES
(1, 'obiekt1', 
        ST_Collect(
            ARRAY[
                ST_SetSRID(ST_GeomFromText('LINESTRING(0 1, 1 1)'), 0)
                ,ST_SetSRID(ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)'), 0)
                ,ST_SetSRID(ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)'), 0)
                ,ST_SetSRID(ST_GeomFromText('LINESTRING(5 1, 6 1)'), 0)])
);


INSERT INTO obiekty(id, nazwa, geometria)
VALUES
(2, 'obiekt2', 
    ST_BuildArea(
        ST_Collect(
            ARRAY[ST_SetSRID(ST_GeomFromText('LINESTRING(10 6, 14 6)'), 0)
                ,ST_SetSRID(ST_GeomFromText('CIRCULARSTRING(14 6, 16 4, 14 2)'), 0)
                ,ST_SetSRID(ST_GeomFromText('CIRCULARSTRING(14 2, 12 0, 10 2)'), 0)
                ,ST_SetSRID(ST_GeomFromText('LINESTRING(10 2, 10 6)'), 0)
                ,ST_Buffer(ST_SetSRID(ST_MakePoint(12, 2), 0), 1, 6000)]))
);

INSERT INTO obiekty(id, nazwa, geometria)
VALUES
(3, 'obiekt3', 
    ST_SetSRID(ST_GeomFromText('POLYGON((12 13, 7 15, 10 17, 12 13))'), 0)
);

INSERT INTO obiekty(id, nazwa, geometria)
VALUES
(4, 'obiekt4', 
    ST_SetSRID(ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'), 0)
);

INSERT INTO obiekty(id, nazwa, geometria)
VALUES
(5, 'obiekt5', 
    ST_SetSRID(ST_GeomFromText('MULTIPOINT((30 50 59), (38 32 234))'), 0)
);

INSERT INTO obiekty(id, nazwa, geometria)
VALUES
(6, 'obiekt6', 
    ST_Collect(
        ST_SetSRID(ST_GeomFromText('LINESTRING(1 1, 3 2)'), 0)
        ,ST_SetSRID(ST_GeomFromText('POINT(4 2)'), 0)
    )
);



-- Zadanie 2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(ob3.geometria, ob4.geometria), 5)) AS buffer_area
FROM obiekty ob3, obiekty ob4
WHERE ob3.nazwa = 'obiekt3' AND ob4.nazwa = 'obiekt4';


-- Zadanie 3
UPDATE obiekty
SET geometria = ST_MakePolygon(
    ST_AddPoint(
        geometria,
        ST_StartPoint(geometria)
    )
)
WHERE nazwa = 'obiekt4';


-- Zadanie 4
INSERT INTO obiekty (id,nazwa, geometria)
SELECT 
	7
    ,'obiekt7' 
    ,ST_Collect(ob3.geometria, ob4.geometria)
FROM 
    obiekty ob3, obiekty ob4
WHERE 
    ob3.nazwa = 'obiekt3' AND ob4.nazwa = 'obiekt4';


   
   -- Zadanie 5
SELECT SUM(ST_Area(ST_Buffer(geometria, 5))) AS total_area
FROM obiekty
WHERE ST_HasArc(geometria) IS FALSE;
