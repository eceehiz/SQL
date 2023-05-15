--TRIGGER(tetikleyici): Bir i�lemden sonra ba�ka bir i�lem yapabilmeyi veya bir i�lemin yerine ba�ka bir i�lem yapabilmeyi sa�layan yap�
--kullan�c� trigger� elle tetikleyemez
--trigger�n di�er yap�lardan fark�: �al��aca�� zaman� kendi belirler
--2 tane trigger t�r� vard�r. After(sonra) ve Instead Of(yerine)

--After: bir �r�n sat�ld�ktan sonra stok adetini g�ncellemek gibi
--Instead of: delete yazd�k ama asl�nda update i�lemi olmas� gibi

--Trigger i�lemlerinde kullan�lan 2 sanal tablo vard�r
--Inserted tablosu; eklemeye �al���lan kay�tlar�n tutuldu�u sanal tablodur
--Deleted tablosu: silinmeye �al���lan kay�tlar�n tutuldu�u sanal tablodur
--Update olay� i�inse; g�ncellemeden �nceki kay�t i�in deleted sanal tablosu, g�ncellemeden sonraki kay�t i�in inserted sanal tablosu kullan�l�r

--�r�n� sil dendi�inde biz silmeyece�iz, onun yerine pasife ge�irece�iz
alter trigger UrunSil2
on Urunler   --hangi tablo
instead of   --hangi trigger tipi
delete       --hangi i�lem i�in bu trigger �al��acak
as
	declare @Id int
	select @Id=UrunID from deleted          --1.atama y�ntemi
	--set @Id=(select UrunID from deleted)  --2.atama y�ntemi
	update Urunler
	set Sonlandi=0
	where UrunID=@Id

select * from Urunler
delete Urunler 
where UrunID=4

--After trigger ise belirli bir tablo �zerinde belirli bir i�lemden sonra ba�ka bir i�lem daha yapabilmeyi sa�layan trigger �e�idi

--sat�� detay tablosuna kay�t girildi�inde sat�lan �r�n adedi kadar �r�n�n sto�undan d��en trigger� yazal�m
go
alter trigger trg_stokDus
on [Satis Detaylari]
after   --trigger tipi after
insert  --insert olay� yap�ld�ktan sonra
as
	declare @id int, @adet smallint
	select @id=UrunID, @adet=Miktar from inserted
	update Urunler
	set HedefStokDuzeyi-=@adet
	where UrunID=@id

insert into [Satis Detaylari] (SatisID, UrunID, BirimFiyati, Miktar, �ndirim)
values (10248, 4, 19, 7, 0) --hedef stok d�zeyi 53 �uan. idsi 4 olan �r�n� 7 adet d���r�yoruz. 46 olacak

select * from Urunler
select * from [Satis Detaylari]

--satis detay tablosunda kay�t silindi�inde �r�n�n sto�unu artt�ran trigger
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
database �zerinde sa� t�k>tasks>back up
full
database
back up to:disk veya url. diski se�>
yede�in yerini se�. 
file name de yedek.bak 

2.y�ntem ise
database �zerinde sa� t�k>tasks>generate scripts>next> select all> advanced den ayarlar yap�l�yor, s�r�m�n� se�
�ema ve datay� olan� se�
save as script file
yerini se�ip ismini yaz .bak
*/


