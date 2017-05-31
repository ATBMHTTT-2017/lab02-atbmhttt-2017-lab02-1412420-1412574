
--------------------------------------------------------
--  DDL for Procedure UPDATEHICHITIEU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ADMIN_BT_02"."UPDATEHICHITIEU" (
	   pb_tenchitieu IN ChiTieu.TenChiTieu%TYPE,
     pb_sotien IN ChiTieu.SoTien%TYPE

     )
IS
BEGIN
        update ChiTieu
        set TenChiTieu = pb_tenchitieu, SoTien = pb_sotien
        where exists(
                      select *
                      from DuAn d
                      where d.TruongDA = 2018300 and user = '2018300' and ChiTieu.DuAn = d.MaDA
                     );
        COMMIT;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK;
END updatehiChiTieu;

/
--gan quyen cho user truong phong
--TAO VIEW CHO PHEP NHAN VIEN CHO TABLE CHI TIEU
CREATE VIEW CHITIEU_VIEW AS 
SELECT *
FROM ChiTieu ct
WHERE ct.DuAn in (
                  SELECT d.MaDA
                  FROM DuAn d
                  WHERE d.TruongDA = 2018300);
--Gan quyen cho role truong de an, chi co truong de an moi dc xem thong tin chi tieu cua minh



--tao user
CREATE USER  "2018300"
IDENTIFIED BY 123;
GRANT TRUONG_DU_AN_R TO "2018300";
--create role 
CREATE ROLE TRUONG_DU_AN_R;
GRANT CREATE SESSION TO TRUONG_DU_AN_R;
GRANT SELECT ON ChiTieu TO TRUONG_DU_AN_R;
GRANT EXECUTE ON updatehiChiTieu TO TRUONG_DU_AN_R;
GRANT SELECT ON CHITIEU_VIEW TO TRUONG_DU_AN_R;
--
select *
from admin_bt_02.ChiTieu;
--
select *
from admin_bt_02.DuAn;