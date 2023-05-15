--TRIGGER(tetikleyici): Bir iþlemden sonra baþka bir iþlem yapabilmeyi veya bir iþlemin yerine baþka bir iþlem yapabilmeyi saðlayan yapý
--kullanýcý triggerý elle tetikleyemez
--triggerýn diðer yapýlardan farký: çalýþacaðý zamaný kendi belirler
--2 tane trigger türü vardýr. After(sonra) ve Instead Of(yerine)

--After: bir ürün satýldýktan sonra stok adetini güncellemek gibi
--Instead of: delete yazdýk ama aslýnda update iþlemi olmasý gibi

--Trigger iþlemlerinde kullanýlan 2 sanal tablo vardýr
--Inserted tablosu; eklemeye çalýþýlan kayýtlarýn tutulduðu sanal tablodur
--Deleted tablosu: silinmeye çalýþýlan kayýtlarýn tutulduðu sanal tablodur
--Update olayý içinse; güncellemeden önceki kayýt için deleted sanal tablosu, güncellemeden sonraki kayýt için inserted sanal tablosu kullanýlýr

--Ürünü sil dendiðinde biz silmeyeceðiz, onun yerine pasife geçireceðiz
alter trigger UrunSil2
on Urunler   --hangi tablo
instead of   --hangi trigger tipi
delete       --hangi iþlem için bu trigger çalýþacak
as
	declare @Id int
	select @Id=UrunID from deleted          --1.atama yöntemi
	--set @Id=(select UrunID from deleted)  --2.atama yöntemi
	update Urunler
	set Sonlandi=0
	where UrunID=@Id

select * from Urunler
delete Urunler 
where UrunID=4

--After trigger ise belirli bir tablo üzerinde belirli bir iþlemden sonra baþka bir iþlem daha yapabilmeyi saðlayan trigger çeþidi

--satýþ detay tablosuna kayýt girildiðinde satýlan ürün adedi kadar ürünün stoðundan düþen triggerý yazalým
go
alter trigger trg_stokDus
on [Satis Detaylari]
after   --trigger tipi after
insert  --insert olayý yapýldýktan sonra
as
	declare @id int, @adet smallint
	select @id=UrunID, @adet=Miktar from inserted
	update Urunler
	set HedefStokDuzeyi-=@adet
	where UrunID=@id

insert into [Satis Detaylari] (SatisID, UrunID, BirimFiyati, Miktar, Ýndirim)
values (10248, 4, 19, 7, 0) --hedef stok düzeyi 53 þuan. idsi 4 olan ürünü 7 adet düþürüyoruz. 46 olacak

select * from Urunler
select * from [Satis Detaylari]

--satis detay tablosunda kayýt silindiðinde ürünün stoðunu arttýran trigger
go
create trigger trg_stokArttir
on [Satis Detaylari]
after
delete
as
	declare @id int,@adet smallint
	select @id=UrunId,@adet=miktar from deleted
	update Urunler 
	set HedefStokDuzeyi+=@adet 
	where UrunID=@id

delete [Satis Detaylari] 
where SatisID=10248 and UrunID=4

--Yedek Alma
/*
database üzerinde sað týk>tasks>back up
full
database
back up to:disk veya url. diski seç>
yedeðin yerini seç. 
file name de yedek.bak 

2.yöntem ise
database üzerinde sað týk>tasks>generate scripts>next> select all> advanced den ayarlar yapýlýyor, sürümünü seç
þema ve datayý olaný seç
save as script file
yerini seçip ismini yaz .bak
*/


