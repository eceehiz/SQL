--  Altsorgular
--Birinci Tip
-- select ile from arasýna yazýlan  istenilen sütunu getirmek için alt sorgu kullanýlýr.
--her bir istenen sütun için bir alt sorgu yazmak gerekir

--Ýkinci Tip
/* where den sonra istenilen filtrelemeyi yapmak için kullanýlýr
herbir filtre için yeni bir alt sorgu yazýlýr
*/

select UrunAdi, (select KategoriAdi from Kategoriler where KategoriID=Urunler.KategoriID)  from Urunler

select UrunAdi, (select SirketAdi from Tedarikciler where TedarikciID=Urunler.TedarikciID) from Urunler

--satýþlar tablosunu müþteri adý ünvaný personel adý soyadý ile yazýn

select (select MusteriAdi from Musteriler where MusteriID=Satislar.MusteriID) as musteriAdi, (select MusteriUnvani from Musteriler where MusteriID=Satislar.MusteriID) as musteriUnvani,
(select Adi from Personeller where PersonelID= Satislar.PersonelID) as personelAdi , (select SoyAdi from Personeller where PersonelID= Satislar.PersonelID) as personelSoyadi from Satislar

--ürünler tablosu ile birlikte her bir ürünün toplam satýþ adedini getir

select u.UrunAdi , (select sum(sd.BirimFiyati*sd.Miktar) from [Satis Detaylari] sd where  u.UrunID=sd.UrunID ) as toplamsatistutar from Urunler u

select u.UrunAdi , (select sum(Miktar) from [Satis Detaylari] sd where  u.UrunID=sd.UrunID ) as toplamsatisadedi from Urunler u

--satiþlardaki nakliyeciler
select s.ShipVia , (select SirketAdi from Nakliyeciler n where s.ShipVia=n.NakliyeciID) from Satislar s
group by s.ShipVia

--her bir ürün en fazla kaça satýlmýþtýr
select u.UrunAdi , (select max(sd.BirimFiyati) from [Satis Detaylari] sd where sd.UrunID=u.UrunID ) as enpahalýürün from Urunler u
order by 2 desc

--satýþlardaki satýþ id ile satýþ detaylarýndaki en yüksek birim fiyatý bulma ve en yüksek ürün id sini bulma
select (select Urunadi from Urunler where UrunID=(select max(UrunID) from [Satis Detaylari] SD where sd.SatisID=s.SatisID)) ,
(select max(sd.BirimFiyati) from [Satis Detaylari] SD where sd.SatisID=s.SatisID), * from Satislar S

select (select max(UrunID) from [Satis Detaylari] SD where sd.SatisID=s.SatisID) ,
(select max(sd.BirimFiyati) from [Satis Detaylari] SD where sd.SatisID=s.SatisID),
* from Satislar S

select *from [Satis Detaylari] sd where sd.SatisID =10250
select max(UrunID) from [Satis Detaylari] SD where sd.SatisID=10250

--------------------------------------------------------------------------------------------------

--kategori id si 1 olan ürünü getir
select * from Urunler
where KategoriID=(select KategoriID from Kategoriler where KategoriAdi='Beverages')

--Tedarikçisi Karkki Oy olan ürünleri getir
select * from Urunler
where TedarikciID=(select TedarikciID from Tedarikciler where SirketAdi='Karkki Oy')

--adý robert olan personelin yaptýðý satýþlar 
select * from Satislar
where PersonelID=(select PersonelID from Personeller where Adi='Robert')

 --nancy veya Janetýn yaptýðý satýþlar
select * from Satislar
where PersonelID in (select PersonelID from Personeller where Adi = 'Nancy' or Adi='Janet')

--chai toplamda kaç defa satýlmýþ --UrunAdi='Chai'
select * from [Satis Detaylari] sd
where UrunID=(select UrunID from Urunler where UrunAdi='Chai')

--personel adý Nancy veya Janet olan, nakliyecisi speedy express olan satýþlar
select * from Satislar
where PersonelID in (select PersonelID from Personeller where Adi='Nancy' or Adi='Janet') and
ShipVia=(select NakliyeciID from Nakliyeciler where SirketAdi='Speedy Express')

--1997 yýlýnda yapýlan satýþlarda ne kadar ciro edildiðini
select sum(sd.BirimFiyati*sd.Miktar*(1-sd.Ýndirim)) from [Satis Detaylari] sd
where sd.SatisID in (select s.SatisID from Satislar s where s.SatisTarihi between '1997-01-01' and '1997-12-31' )

--Alfký müþterisine yapýlan toplam satýþ kaç tane ve fiyat ne
select count(*), sum(BirimFiyati*Miktar*(1-indirim)) from [Satis Detaylari]
where SatisID in (select SatisID from Satislar where MusteriID='Alfký')

--speedy express isimli nakliyeci bugüne kadar kaç adet ürün taþýdý
select sum(Miktar) from [Satis Detaylari] 
where SatisID in(select SatisID from Satislar 
where ShipVia=(select NakliyeciID from Nakliyeciler where SirketAdi='Speedy Express'))

select sum(Miktar) from [Satis Detaylari] 
where SatisID in(select SatisID from Satislar 
where ShipVia=(select NakliyeciID from Nakliyeciler where SirketAdi='Speedy Express'))

