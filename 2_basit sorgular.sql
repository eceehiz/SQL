--5 ile 11 aras�ndaki
select * from Urunler
where UrunID>5 and UrunID<11

select * from Urunler
where UrunID between 5 and 11

--birim fiyat� 15-75 aras�
select * from Urunler
where BirimFiyati between 15 and 75

--ilk 10 �r�n 
select top 10 * from Urunler

select top 3 * from Urunler
where UrunAdi like 'c%[a,n]_' and BirimFiyati between 15 and 75

--kategori id si 5 olmayan �r�n ad�n�n ikinci harfi i olan �r�nleri stoklar�na g�re tersten 
select * from Urunler
where KategoriID!=5 and UrunAdi like '_i%'
order by HedefStokDuzeyi desc

--�r�n id si 5,14,17,25,34 olmayan �r�nler
select * from Urunler
where UrunID not in (5,14,17,25,34)

--kategori idsi 2,3,4 olan
select * from Urunler
where KategoriID in (2,3,4)

--i�inde c ve a harfi ge�meyen �r�n isimleri
select * from Urunler
where UrunAdi not like '%[c,a]%'

--personel idsi 4 olan ve nakliyeci �creti 15 ile 45 aras�nda olan sevk tarihine g�re tersten son 3 kayd� getiren sat��lar�
select top 3 * from Satislar
where PersonelID=4  and NakliyeUcreti between 15 and 45
order by SevkTarihi desc


