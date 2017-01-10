update deaths_original set decd_frst_nme=ltrim(decd_frst_nme) where yr is null
update deaths_original set decd_midd_nme=ltrim(decd_midd_nme) where yr is null
update deaths_original set decd_lst_nme=ltrim(decd_lst_nme) where yr is null
update deaths_original set decd_sufx=ltrim(decd_sufx) where yr is null
update deaths_original set injury_date = injury_dt_txt where injury_date is null
update deaths_original set stribimportdate = getdate() where stribimportdate is null
update deaths_original set yr=year(decd_dth_dt) where yr is null

update deaths_original set race = deaths_race_lkup.racedesc
from deaths_original, deaths_race_lkup
where deaths_original.SUBJECT_RACEBRG=deaths_race_lkup.racebridge

update deaths_original set race='White' where race is null and SUBJECT_WHITE='Y'
update deaths_original set race='African American' where race is null and SUBJECT_AFRICAN_AMERICAN='Y'
update deaths_original set race='African American' where race is null and SUBJECT_SOMALI='Y'
update deaths_original set race='African American' where race is null and SUBJECT_ETHIOPIAN='Y'
update deaths_original set race='African American' where race is null and SUBJECT_LIBERIAN='Y'
update deaths_original set race='African American' where race is null and SUBJECT_KENYAN='Y'
update deaths_original set race='African American' where race is null and SUBJECT_SUDANESE='Y'
update deaths_original set race='African American' where race is null and SUBJECT_NIGERIAN='Y'
update deaths_original set race='African American' where race is null and SUBJECT_GHANIAN='Y'
update deaths_original set race='African American' where race is null and SUBJECT_OTHER_AFRICAN='Y'
update deaths_original set race='American Indian' where race is null and SUBJECT_AMERICAN_INDIAN='Y'
update deaths_original set race='Asian Indian' where race is null and SUBJECT_ASIAN_INDIAN='Y'
update deaths_original set race='Chinese' where race is null and SUBJECT_CHINESE='Y'
update deaths_original set race='Filipino' where race is null and SUBJECT_FILIPINO='Y'
update deaths_original set race='Japanese' where race is null and SUBJECT_JAPANESE='Y'
update deaths_original set race='Korean' where race is null and SUBJECT_KOREAN='Y'
update deaths_original set race='Vietnamese' where race is null and SUBJECT_VIETNAMESE='Y'
update deaths_original set race='Other Asian' where race is null and SUBJECT_HMONG='Y'
update deaths_original set race='Other Asian' where race is null and SUBJECT_CAMBODIAN='Y'
update deaths_original set race='Other Asian' where race is null and SUBJECT_LAOTIAN='Y'
update deaths_original set race='Other Asian' where race is null and SUBJECT_OTHER_ASIAN='Y'
update deaths_original set race='Hawaiian' where race is null and SUBJECT_HAWAIIAN='Y'
update deaths_original set race='Guanmanian/Chamorro' where race is null and SUBJECT_GUAMANIAN_CHAMORRO='Y'
update deaths_original set race='Samoan' where race is null and SUBJECT_SAMOAN='Y'
update deaths_original set race='Other Pacific Islander' where race is null and SUBJECT_OTHER_PACIFIC_ISLANDER='Y'
update deaths_original set race='Other Race' where race is null and SUBJECT_OTHER='Y'
update deaths_original set race='Unknown' where race is null and SUBJECT_REFUSED_RACE='Y'
update deaths_original set race='Unknown' where race is null and SUBJECT_UNKNOWN='Y'
update deaths_original set race='Unknown' where race is null and SUBJECT_NOTOBTAINABLE_RACE='Y'
update deaths_original set HispanicEthnicity='NOT HISPANIC' where subject_not_hispanic='Y'
update deaths_original set HispanicEthnicity='HISPANIC' where subject_mexican='Y' OR SUBJECT_PUERTO_RICAN='Y' OR SUBJECT_CUBAN='Y'
OR SUBJECT_OTHER_SPANISH='Y'
UPDATE DEATHS_ORIGINAL SET HISPANICETHNICITY='UNKNOWN' WHERE SUBJECT_REFUSED_HISPANIC='Y' OR SUBJECT_UNKNOWN_HISPANIC='Y' OR SUBJECT_NOTOBTAINABLE_HISPANIC='Y'
UPDATE DEATHS_ORIGINAL SET HISPANICETHNICITY='UNKNOWN' where hispanicethnicity is null
update deaths_original set sourcecode='MDHFull'




