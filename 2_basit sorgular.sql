--5 ile 11 arasýndaki
select * from Urunler
where UrunID>5 and UrunID<11

select * from Urunler
where UrunID between 5 and 11

--birim fiyatý 15-75 arasý
select * from Urunler
where BirimFiyati between 15 and 75

--ilk 10 ürün 
select top 10 * from Urunler

select top 3 * from Urunler
where UrunAdi like 'c%[a,n]_' and BirimFiyati between 15 and 75

--kategori id si 5 olmayan ürün adýnýn ikinci harfi i olan ürünleri stoklarýna göre tersten 
select * from Urunler
where KategoriID!=5 and UrunAdi like '_i%'
order by HedefStokDuzeyi desc

--ürün id si 5,14,17,25,34 olmayan ürünler
select * from Urunler
where UrunID not in (5,14,17,25,34)

--kategori idsi 2,3,4 olan
select * from Urunler
where KategoriID in (2,3,4)

--içinde c ve a harfi geçmeyen ürün isimleri
select * from Urunler
where UrunAdi not like '%[c,a]%'

--personel idsi 4 olan ve nakliyeci ücreti 15 ile 45 arasýnda olan sevk tarihine göre tersten son 3 kaydý getiren satýþlarý
select top 3 * from Satislar
where PersonelID=4  and NakliyeUcreti between 15 and 45
order by SevkTarihi desc


