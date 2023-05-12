--  Altsorgular
--Birinci Tip
-- select ile from aras�na yaz�lan  istenilen s�tunu getirmek i�in alt sorgu kullan�l�r.
--her bir istenen s�tun i�in bir alt sorgu yazmak gerekir

--�kinci Tip
/* where den sonra istenilen filtrelemeyi yapmak i�in kullan�l�r
herbir filtre i�in yeni bir alt sorgu yaz�l�r
*/

select UrunAdi, (select KategoriAdi from Kategoriler where KategoriID=Urunler.KategoriID)  from Urunler

select UrunAdi, (select SirketAdi from Tedarikciler where TedarikciID=Urunler.TedarikciID) from Urunler

--sat��lar tablosunu m��teri ad� �nvan� personel ad� soyad� ile yaz�n

select (select MusteriAdi from Musteriler where MusteriID=Satislar.MusteriID) as musteriAdi, (select MusteriUnvani from Musteriler where MusteriID=Satislar.MusteriID) as musteriUnvani,
(select Adi from Personeller where PersonelID= Satislar.PersonelID) as personelAdi , (select SoyAdi from Personeller where PersonelID= Satislar.PersonelID) as personelSoyadi from Satislar

--�r�nler tablosu ile birlikte her bir �r�n�n toplam sat�� adedini getir

select u.UrunAdi , (select sum(sd.BirimFiyati*sd.Miktar) from [Satis Detaylari] sd where  u.UrunID=sd.UrunID ) as toplamsatistutar from Urunler u

select u.UrunAdi , (select sum(Miktar) from [Satis Detaylari] sd where  u.UrunID=sd.UrunID ) as toplamsatisadedi from Urunler u

--sati�lardaki nakliyeciler
select s.ShipVia , (select SirketAdi from Nakliyeciler n where s.ShipVia=n.NakliyeciID) from Satislar s
group by s.ShipVia

--her bir �r�n en fazla ka�a sat�lm��t�r
select u.UrunAdi , (select max(sd.BirimFiyati) from [Satis Detaylari] sd where sd.UrunID=u.UrunID ) as enpahal��r�n from Urunler u
order by 2 desc

--sat��lardaki sat�� id ile sat�� detaylar�ndaki en y�ksek birim fiyat� bulma ve en y�ksek �r�n id sini bulma
select (select Urunadi from Urunler where UrunID=(select max(UrunID) from [Satis Detaylari] SD where sd.SatisID=s.SatisID)) ,
(select max(sd.BirimFiyati) from [Satis Detaylari] SD where sd.SatisID=s.SatisID), * from Satislar S

select (select max(UrunID) from [Satis Detaylari] SD where sd.SatisID=s.SatisID) ,
(select max(sd.BirimFiyati) from [Satis Detaylari] SD where sd.SatisID=s.SatisID),
* from Satislar S

select *from [Satis Detaylari] sd where sd.SatisID =10250
select max(UrunID) from [Satis Detaylari] SD where sd.SatisID=10250

--------------------------------------------------------------------------------------------------

--kategori id si 1 olan �r�n� getir
select * from Urunler
where KategoriID=(select KategoriID from Kategoriler where KategoriAdi='Beverages')

--Tedarik�isi Karkki Oy olan �r�nleri getir
select * from Urunler
where TedarikciID=(select TedarikciID from Tedarikciler where SirketAdi='Karkki Oy')

--ad� robert olan personelin yapt��� sat��lar 
select * from Satislar
where PersonelID=(select PersonelID from Personeller where Adi='Robert')

 --nancy veya Janet�n yapt��� sat��lar
select * from Satislar
where PersonelID in (select PersonelID from Personeller where Adi = 'Nancy' or Adi='Janet')

--chai toplamda ka� defa sat�lm�� --UrunAdi='Chai'
select * from [Satis Detaylari] sd
where UrunID=(select UrunID from Urunler where UrunAdi='Chai')

--personel ad� Nancy veya Janet olan, nakliyecisi speedy express olan sat��lar
select * from Satislar
where PersonelID in (select PersonelID from Personeller where Adi='Nancy' or Adi='Janet') and
ShipVia=(select NakliyeciID from Nakliyeciler where SirketAdi='Speedy Express')

--1997 y�l�nda yap�lan sat��larda ne kadar ciro edildi�ini
select sum(sd.BirimFiyati*sd.Miktar*(1-sd.�ndirim)) from [Satis Detaylari] sd
where sd.SatisID in (select s.SatisID from Satislar s where s.SatisTarihi between '1997-01-01' and '1997-12-31' )

--Alfk� m��terisine yap�lan toplam sat�� ka� tane ve fiyat ne
select count(*), sum(BirimFiyati*Miktar*(1-indirim)) from [Satis Detaylari]
where SatisID in (select SatisID from Satislar where MusteriID='Alfk�')

--speedy express isimli nakliyeci bug�ne kadar ka� adet �r�n ta��d�
select sum(Miktar) from [Satis Detaylari] 
where SatisID in(select SatisID from Satislar 
where ShipVia=(select NakliyeciID from Nakliyeciler where SirketAdi='Speedy Express'))

select sum(Miktar) from [Satis Detaylari] 
where SatisID in(select SatisID from Satislar 
where ShipVia=(select NakliyeciID from Nakliyeciler where SirketAdi='Speedy Express'))

