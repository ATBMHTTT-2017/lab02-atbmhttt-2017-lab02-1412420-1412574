
--------------------------------------------------------
--  DDL for Package NV_ENCRYPT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "ADMIN_BT_02"."NV_ENCRYPT" IS
  FUNCTION ENCRYPT_NhanVien(inputData IN VARCHAR2,Mykey IN NUMBER) RETURN RAW DETERMINISTIC;
  FUNCTION DECRYPT_NhanVien(inputEncryptData IN RAW,Mykey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC;
END;

/
--------------------------------------------------------
--  DDL for Package Body NV_ENCRYPT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ADMIN_BT_02"."NV_ENCRYPT" IS 
  encrypt_Type PLS_INTEGER :=DBMS_CRYPTO.ENCRYPT_DES
							+DBMS_CRYPTO.CHAIN_CBC
							+DBMS_CRYPTO.PAD_PKCS5;
  FUNCTION ENCRYPT_NhanVien(inputData IN VARCHAR2,Mykey IN NUMBER) RETURN RAW DETERMINISTIC
  IS
  	encrypted_raw raw(3000);
    
  BEGIN
       encrypted_raw := dbms_crypto.encrypt(
          src => utl_raw.cast_to_raw(inputData),
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(Mykey)
      );
      return encrypted_raw;
  END ENCRYPT_NhanVien;
  
  FUNCTION DECRYPT_NhanVien(inputEncryptData IN RAW,Mykey IN NUMBER) RETURN VARCHAR2 DETERMINISTIC
  IS
    decrypted_raw raw(3000);
  BEGIN
       decrypted_raw := dbms_crypto.decrypt(
          src => inputEncryptData,
          typ => encrypt_Type,
          key => utl_raw.cast_to_raw(Mykey)
      );
      return  utl_raw.cast_to_VARCHAR2(decrypted_raw);
  END DECRYPT_NhanVien;

END NV_Encrypt;

/
-- test
--UPDATE TREN BANG LUONG NHAN VIEN
BEGIN
	FOR v_MaNV IN (select MaNV from NhanVien)
	LOOP
    UPDATE NhanVien SET LUONG = NV_Encrypt.ENCRYPT_NhanVien(LUONG, MaNV) WHERE MaNV = v_MaNV.MaNV;
	END LOOP;
END;

SELECT  MaNV,HoTen,LUONG,NV_Encrypt.DECRYPT_NhanVien(NV.LUONG, NV.MANV) LUONGDC FROM NhanVien NV;
--
SELECT *
FROM NhanVien
--
--Test decrypt
select NV_Encrypt.DECRYPT_NhanVien(NV_Encrypt.ENCRYPT_NhanVien(3000000, 2018100),2018100) from dual;
--Test Encrypt
select NV_Encrypt.ENCRYPT_NhanVien(3000000, 2018100) from dual;

