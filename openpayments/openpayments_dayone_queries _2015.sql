###This has been updated to run on the 2014 data



update general_2014 set payer=ltrim(payer)
update general_2014 set payer=rtrim(payer)
update general_2014 set mfgr=ltrim(mfgr)
update general_2014 set mfgr=rtrim(mfgr)
update general_2014 set physid=rtrim(physid)
update general_2014 set physid=ltrim(physid)

update research_2014 set physid=rtrim(physid)
update research_2014 set physid=ltrim(physid)

update sup_2014 set physid=rtrim(physid)
update sup_2014 set physid=ltrim(physid)



update research_2014 set payer=ltrim(payer)
update research_2014 set payer=rtrim(payer)

update research_2014 set mfgr=ltrim(mfgr)
update research_2014 set mfgr=rtrim(mfgr)

create index idx_payerstate on general_2014(payerstate) 
create index idx_lic1 on general_2014(lic1) 
create index idx_lic2 on general_2014(lic2) 
create index idx_lic3 on general_2014(lic3) 
create index idx_lic4 on general_2014(lic4) 
create index idx_lic5 on general_2014(lic5)  
create index idx_paynature on general_2014(paynature)  

create index idx_payerstate on research_2014(payerstate) 
create index idx_lic1 on research_2014(lic1) 
create index idx_lic2 on research_2014(lic2) 
create index idx_lic3 on research_2014(lic3) 
create index idx_lic4 on research_2014(lic4) 
create index idx_lic5 on research_2014(lic5)  




###create MNcompanies table

select 'general' as tabletype, a.tranid, progyr, mfgr, reciptype, '' as NonCoveredEntity, hospname, a.physid, rtrim(a.physid)+'-'+rtrim(b.physfname)+' '+rtrim(b.physlname) as DocName, b.addr1, b.addr2,
b.city, b.state, b.zip, b.country, b.province, 
b.spec1, b.lic1, b.lic2, b.lic3, b.lic4, b.lic5,  prodindicator, assoc1, assoc2, assoc3, assoc4, assoc5, ndc1, ndc2, ndc3, ndc4, ndc5, 
market1, market2, market3, market4, market5, ltrim(payer) as Payer, payerid,
payerstate, payercountry, disputestatus, payment, paydate, payments, payform, paynature, travelcity, travelstate, travelcountry, physownership,
thirdparty, thirdname, charity, covrecip, context, [delay], '' as expcat1, '' as expcat2, '' as expcat3, '' as expcat4, '' as expcat5, ''as preclin,
''as studyname, '' as prin1Name, ''as prin2Name 
into MNcompanies_tbl_2014
from general_2014 a left join sup_2014 b on rtrim(a.physid)=rtrim(b.physid)
where ltrim(payerstate)='MN'
union
select 'research' as tabletype, a.tranid, progyr, mfgr, reciptype, a.noncoventity as NonCoveredEntity,  hospname, a.physid,  rtrim(a.physid)+'-'+rtrim(b.physfname)+' '+rtrim(b.physlname) as DocName, b.addr1, b.addr2,
b.city, b.state, b.zip, b.country, b.province, 
b.spec1,   b.lic1, b.lic2, b.lic3, b.lic4, b.lic5,  prodindicator, assoc1, assoc2, assoc3, assoc4, assoc5, ndc1, ndc2, ndc3, ndc4, ndc5, 
market1, market2, market3, market4, market5, ltrim(payer) as Payer, payerid,
payerstate, payercountry, disputestatus, payment, paydate, '' as payments, payform, '' as paynature, '' as travelcity, '' as travelstate, '' as travelcountry, '' as physownership,
'' as thirdparty, '' as thirdname, '' as charity, '' as covrecip, '' as context, [delay], expcat1, expcat2, expcat3, expcat4, expcat5, preclin,
studyname, prin1FName+' '+prin1Lname as Prin1Name, prin2FName+' '+prin2Lname as Prin2Name
from research_2014 a left join sup_2014 b on rtrim(a.physid)=rtrim(b.physid)
where ltrim(payerstate)='MN'

go


###Create MNdocs table

select 'general' as tabletype, a.tranid, progyr, mfgr, reciptype, '' as NonCoveredEntity, hospname, a.physid, rtrim(a.physid)+'-'+rtrim(b.physfname)+' '+rtrim(b.physlname) as DocName, b.addr1, b.addr2,
b.city, b.state, b.zip, b.country, b.province, 
b.spec1, b.lic1, b.lic2, b.lic3, b.lic4, b.lic5,  prodindicator, assoc1, assoc2, assoc3, assoc4, assoc5, ndc1, ndc2, ndc3, ndc4, ndc5, 
market1, market2, market3, market4, market5, ltrim(payer) as Payer, payerid,
payerstate, payercountry, disputestatus, payment, paydate, payments, payform, paynature, travelcity, travelstate, travelcountry, physownership,
thirdparty, thirdname, charity, covrecip, context, [delay], '' as expcat1, '' as expcat2, '' as expcat3, '' as expcat4, '' as expcat5, ''as preclin,
''as studyname, '' as prin1Name, ''as prin2Name 
 into MNdocs_tbl_2014
from general_2014 a left join sup_2014 b on rtrim(a.physid)=rtrim(b.physid)
where ltrim(b.lic1)='MN' or ltrim(b.lic2)='MN' or ltrim(b.lic3)='MN' or ltrim(b.lic4)='MN' or ltrim(b.lic5)='MN'
union
select 'research' as tabletype, a.tranid, progyr, mfgr, reciptype, a.noncoventity as NonCoveredEntity,  hospname, a.physid,  rtrim(a.physid)+'-'+rtrim(b.physfname)+' '+rtrim(b.physlname) as DocName, b.addr1, b.addr2,
b.city, b.state, b.zip, b.country, b.province, 
b.spec1,   b.lic1, b.lic2, b.lic3, b.lic4, b.lic5,  prodindicator, assoc1, assoc2, assoc3, assoc4, assoc5, ndc1, ndc2, ndc3, ndc4, ndc5, 
market1, market2, market3, market4, market5, ltrim(payer) as Payer, payerid,
payerstate, payercountry, disputestatus, payment, paydate, '' as payments, payform, '' as paynature, '' as travelcity, '' as travelstate, '' as travelcountry, '' as physownership,
'' as thirdparty, '' as thirdname, '' as charity, '' as covrecip, '' as context, [delay], expcat1, expcat2, expcat3, expcat4, expcat5, preclin,
studyname, prin1FName+' '+prin1Lname as Prin1Name, prin2FName+' '+prin2Lname as Prin2Name
from research_2014 a left join sup_2014 b on rtrim(a.physid)=rtrim(b.physid)
where  ltrim(b.lic1)='MN' or ltrim(b.lic2)='MN' or ltrim(b.lic3)='MN' or ltrim(b.lic4)='MN' or ltrim(b.lic5)='MN'

go

###Create dataviz file

select 'general' as tabletype, a.tranid, progyr, mfgr, reciptype, '' as NonCoveredEntity, hospname, a.physid, b.physfname, b.physlname,  b.addr1, b.addr2,
b.city, b.state, b.zip, 
b.spec1,   assoc1, market1, market2,  ltrim(payer) as Payer, payerid,
payerstate,   payment, paydate,  payform, paynature, travelcity, travelstate, travelcountry, 
thirdparty, thirdname, charity,
''as studyname, '' as prin1Name into DataViz_tbl_2014
from general_2014 a left join sup_2014 b on rtrim(a.physid)=rtrim(b.physid)
where (ltrim(b.lic1)='MN' or ltrim(b.lic2)='MN' or ltrim(b.lic3)='MN' or ltrim(b.lic4)='MN' or ltrim(b.lic5)='MN') or payerstate='MN'
union
select 'research' as tabletype, a.tranid, progyr, mfgr, reciptype, a.noncoventity as NonCoveredEntity,  hospname, a.physid, b.physfname, b.physlname, b.addr1, b.addr2,
b.city, b.state, b.zip, 
b.spec1,   assoc1, 
market1, market2,  ltrim(payer) as Payer, payerid,
payerstate,   payment, paydate,  payform, 'Research' as paynature, '' as travelcity, '' as travelstate, '' as travelcountry, 
'' as thirdparty, '' as thirdname, '' as charity,  
studyname, prin1FName+' '+prin1Lname as Prin1Name
from research_2014 a left join sup_2014 b on rtrim(a.physid)=rtrim(b.physid)
where  (ltrim(b.lic1)='MN' or ltrim(b.lic2)='MN' or ltrim(b.lic3)='MN' or ltrim(b.lic4)='MN' or ltrim(b.lic5)='MN') or payerstate='MN'



###create DocByState_2014
select  rtrim(a.physid)+'-'+rtrim(b.physfname)+' '+rtrim(b.physlname) as DocName, b.spec1,b.city,  b.[state], a.payer, a.payerstate, a.payment, a.paynature, 'general' as tabletype INTO DocByState_2014
from general_2014 a left join sup_2014 b on rtrim(a.physid)=rtrim(b.physid) 
union
select  rtrim(a.physid)+'-'+rtrim(b.physfname)+' '+rtrim(b.physlname) as DocName, b.spec1, b.city, b.[state], a.payer, a.payerstate, a.payment, 'research' as paynature, 'research' as tabletype
from research_2014 a left join sup_2014 b on rtrim(a.physid)=rtrim(b.physid)