USE sql_learning;

SELECT * FROM doctors;

-- SELF JOIN:
-- We need to compare doctors with other doctors from the same table.
-- d1 = first copy of the doctors table
-- d2 = second copy of the doctors table

-- We want doctors who:
-- 1. Are not the same doctor              → d1.id <> d2.id
-- 2. Work at the same hospital            → d1.hospital = d2.hospital
-- 3. Have different specialties           → d1.specialty <> d2.specialty

-- SELECT d1.* → return only the details of the first doctor (d1).
-- DISTINCT    → the same doctor can match multiple doctors,
--               so DISTINCT removes duplicate d1 rows.

SELECT DISTINCT d1.*
FROM doctors d1
JOIN doctors d2
    ON d1.id <> d2.id
    AND d1.hospital = d2.hospital
    AND d1.specialty <> d2.specialty;