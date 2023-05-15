---------------------DML KOMUTLARI---------------------------

/*
INSERT: Bir tabloya kayıt eklemeyi sağlayan komut
Insert [into] TabloAdi (kolon)
Values (degerler)
*/

INSERT INTO Urunler (UrunAdi, BirimFiyati, HedefStokDuzeyi)
VALUES('Elma', 2,30)

INSERT INTO Kategoriler (KategoriAdi, Tanimi)
VALUES('Baharatlar','Yörsel lezzetler')

select * from Personeller
INSERT INTO Personeller (SoyAdi,Adi,Unvan, UnvanEki, DogumTarihi)
VALUES('Çalışkan','Doğan','Yönetici Asistanı', 'Ms.', '1963-07-18')

/*
UPDATE: Belli kayıtları güncellemeyi sağlayan komut
Update TabloAdi 
Set kolon=deger
*/

--Güvenmediğin kodları begin tran ile rollback tran arasına yaz. bu şekilde geri dönüştürebilirsin. 
--begin tran ile update cümlesini birlikte seçerek çalıştır. geri almak için rollbacki tek çalıştır
begin tran
update Urunler
set BirimFiyati=15
rollback tran

update Urunler
set BirimFiyati=30
where UrunID=78

begin tran
update Urunler
set HedefStokDuzeyi=6
where TedarikciID=3
rollback tran

--kategori ıd si 2 olan ürünlerin stok adedini 5 arttır
begin tran
update Urunler
set HedefStokDuzeyi=HedefStokDuzeyi+5
where KategoriID=2
rollback tran

--Adı Robert olan personelin müşteriye yaptığı satışlara %5 indirim 
begin tran
update [Satis Detaylari] 
set BirimFiyati=BirimFiyati*0.95
where SatisID in (
select sd.SatisID from [Satis Detaylari] sd
join Satislar s on sd.SatisID=s.SatisID
join Personeller p on p.PersonelID=s.PersonelID
where p.Adi='Robert')
rollback tran

/*
DELETE: Belli kayıtları silmeyi sağlayan komut
Delete [from] TabloAdi 
Where şart
*/

begin tran
delete Nakliyeciler
where NakliyeciID=1
rollback tran

/*
bir tabloda o değer varsa eklemesin: 

if exists (select * from Urunler where UrunAdi='incir')
		begin
		select * from Urunler
		end
		else 
		begin 
		Insert into Urunler(UrunAdi,BirimFiyati,HedefStokDuzeyi) values('incir',2,30)
		end
*/

--ürünler tablosuna yeni bir ürün ekleyip o ürünün fiyatını ve stoğunu güncelleyip sonrafa o ürünü silen sorguları yazınız

select * from Urunler
insert into Urunler (UrunAdi,BirimFiyati,HedefStokDuzeyi)
values ('Çilek', 30, 10)

update Urunler
set BirimFiyati=40, HedefStokDuzeyi=5
where UrunID=(select top 1 UrunID from Urunler order by UrunID desc)

begin tran
delete from Urunler
where UrunID=(select top 1 UrunID from Urunler order by UrunID desc)

--Aynı soruyu değişken oluşturarak yapalım

--Değişken oluşturma:
declare @temp int 
set @temp=6

--En son girilen satırın id sini alır.
scope_identity()

insert into Urunler(UrunAdi)
values('Portakal')

declare @id int=scope_identity()
update Urunler
set BirimFiyati=15, HedefStokDuzeyi=125
where UrunID=@id

delete from Urunler
where UrunID=@id


