insert into births_main(ST_FILE_NBR, 
CHLD_FRST_NME, 
CHLD_MIDD_NME, 
CHLD_LST_NME, 
CHLD_SFX_NME, 
CHLD_BRTH_DT, 
CHLD_BRTH_TM, 
CHLD_BRTH_TM_IND, 
CHLD_SEX, 
BRTH_PLRLTY, 
BRTH_ORDR, 
BRTH_STRT, 
BRTH_CTY, 
BRTH_CNTY, 
PLC_BRTH_TYPE, 
PLC_BRTH_TYPE_OTHR, 
PLC_BRTH_FCLTY_NME, 
ATND_FRST_NME, 
ATND_MIDD_NME, 
ATND_LST_NME, 
ATND_TITLE, 
ATND_TITLE_OTHR, 
ATND_LIC_NBR, 
ATND_ADDR_STRT, 
ATND_ADDR_CTY, 
ATND_ADDR_ZIP5, 
ATND_ADDR_ST, 
MTHR_FRST_NME, 
MTHR_MIDD_NME, 
MTHR_LST_NME, 
MTHR_SFX_NME, 
MTHR_MAIDN_FRST_NME, 
MTHR_MAIDN_MIDD_NME, 
MTHR_MAIDN_LST_NME, 
MTHR_BRTH_DT, 
MTHR_BRTH_CTY, 
MTHR_RES_STRT, 
MTHR_RES_CTY, 
MTHR_RES_ZIP5, 
MTHR_RES_ST, 
MTHR_RES_CNTRY, 
MTHR_RES_CNTY, 
MTHR_MAIL_STRT, 
MTHR_MAIL_CTY, 
MTHR_MAIL_ST, 
MTHR_MAIL_ZIP5, 
FTHR_FRST_NME, 
FTHR_MIDD_NME, 
FTHR_LST_NME, 
FTHR_SFX_NME, 
FTHR_BRTH_DT, 
FTHR_BRTH_CTY, 
FTHR_MAIL_CTY, 
FTHR_MAIL_ST, 
FTHR_MAIL_ZIP5, 
FTHR_MAIL_CNTRY, 
MTHR_MARRIED, 
DT_FILED)
select 
certID, 
childfirst, 
childmid, 
childlast, 
childsuffix, 
dob, 
timebirth, 
timeindicator, 
gender, 
birthplurality, 
birthorder, 
birthaddress, 
bcitycd, 
birthcounty, 
placetype, 
placetypeother, 
facility, 
attendfirst, 
attendmid, 
attendlast, 
attendtitle, 
attendother, 
attendlicnbr, 
attendaddress, 
attendcity, 
attendzip, 
attendstate, 
motherfirst, 
mothermid, 
motherlast, 
mothersuffix, 
maidenfirst, 
maidenmiddle, 
mothermaiden, 
motherDOB, 
motherbirthplace, 
residenceaddress, 
mcityraw, 
residencezip, 
residencestate, 
mcntry, 
residencecounty, 
mailaddress, 
mailcity, 
mailst, 
mailzip, 
fatherfirst, 
fathermid, 
fatherlast, 
fathersuffix, 
fatherdob, 
fatherbirthplace, 
fathercity, 
fatherstate, 
fatherzip, 
fathercountry, 
mothermaritalstatus, 
datefiled
from births



update births_main set birthyear=year(chld_brth_dt)


update births_main set chld_frst_nme=rtrim(chld_frst_nme)
update births_main set chld_lst_nme=rtrim(chld_lst_nme)
update births_main set chld_midd_nme=rtrim(chld_midd_nme)
update births_main set mthr_frst_nme=rtrim(mthr_frst_nme)
update births_main set mthr_lst_nme=rtrim(mthr_lst_nme)
update births_main set mthr_midd_nme=rtrim(mthr_midd_nme)

update births_main set fthr_frst_nme=rtrim(fthr_frst_nme)
update births_main set fthr_lst_nme=rtrim(fthr_lst_nme)
update births_main set fthr_midd_nme=rtrim(fthr_midd_nme)

update births_main set brth_cty = upper(brth_cty)
update births_main set brth_cty = rtrim(brth_cty)


update births_main set brth_cnty = upper(brth_cnty)
update births_main set brth_cnty = rtrim(brth_cnty)

update births_main set plc_brth_type='CLINIC/DOCTOR OFFICE' where plc_brth_TYPE like 'clinic%'
update births_main set plc_brth_type='FREE STANDING BIRTHING CENTER' WHERE PLC_BRTH_TYPE LIKE 'FREE STANDING%'
UPDATE BIRTHS_MAIN SET PLC_BRTH_TYPE='HOME BIRTH' WHERE PLC_BRTH_TYPE='HOME'
UPDATE BIRTHS_MAIN SET PLC_BRTH_TYPE='HOME BIRTH: PLANNED' WHERE PLC_BRTH_TYPE='HOME BIRTH: PLANN'
UPDATE BIRTHS_MAIN SET PLC_BRTH_TYPE='HOME BIRTH: UNPLANNED' WHERE PLC_BRTH_TYPE='HOME BIRTH: UNPLAN'
UPDATE BIRTHS_MAIN SET PLC_BRTH_TYPE='HOME BIRTH: UNKNOWN IF PLANNED OR UNPLANNED' WHERE PLC_BRTH_TYPE='HOME BIRTH: UNKNO'
UPDATE BIRTHS_MAIN SET PLC_BRTH_TYPE='RESIDENCE' WHERE PLC_BRTH_TYPE LIKE 'MOTHER%'

UPDATE BIRTHS_MAIN SET PLC_BRTH_TYPE=UPPER(PLC_BRTH_TYPE)
UPDATE BIRTHS_MAIN SET PLC_BRTH_TYPE=RTRIM(PLC_BRTH_TYPE)

update births_main set mthr_age=datediff(year, mthr_brth_dt, chld_brth_dt)
where mthr_age is null and year(mthr_brth_dt)<>'9999' and mthr_brth_dt is not null

update births_main set fthr_age=datediff(year, fthr_brth_dt, chld_brth_dt)
where fthr_age is null and year(fthr_brth_dt)<>'9999' and fthr_brth_dt is not null

update births_main set mthr_res_cnty=UPPER(MTHR_RES_CNTY)

update births_main set mthr_res_cnty=RTRIM(MTHR_RES_CNTY)

update births_main set mthr_res_cty=UPPER(mthr_res_cty)

update births_main set mthr_res_cty=RTRIM(mthr_res_cty)



CREATE INDEX IX_childlast ON births_main (chld_lst_nme)
CREATE INDEX IX_childfirst ON births_main (chld_frst_nme)
CREATE INDEX IX_childmiddle ON births_main (chld_midd_nme)
CREATE INDEX IX_childdob ON births_main (chld_brth_dt)
CREATE INDEX IX_birthyear ON births_main (birthyear)
CREATE INDEX IX_motherlast ON births_main (mthr_lst_nme)
CREATE INDEX IX_motherfirst ON births_main (mthr_frst_nme)
CREATE INDEX IX_mothermidd ON births_main (mthr_midd_nme)
CREATE INDEX IX_fatherlast ON births_main (fthr_lst_nme)
CREATE INDEX IX_fatherfirst ON births_main (fthr_frst_nme)
CREATE INDEX IX_residence ON births_main (mthr_res_strt)
CREATE INDEX IX_city ON births_main (mthr_res_cty)
CREATE INDEX IX_state ON births_main (mthr_res_st)
CREATE INDEX IX_zip ON births_main (mthr_res_zip5)
CREATE INDEX IX_maiden ON births_main (mthr_maidn_lst_nme)
