--FUNCTION: Geri dönüþlü metot karþýlýðýna gelen yapý

--ürünlerin kdv sini hesaplayalým, yanýna kolon olarak ekleyelim
go
create function fncKdvHesapla (@fiyat money)
returns money 
as
begin
	declare @kdv money
	set @kdv=@fiyat*0.18
	return @kdv
end

select UrunAdi, BirimFiyati, dbo.fncKdvHesapla(BirimFiyati) as KDV from Urunler --fonksiyonu kullanalým
select *, dbo.fncKdvHesapla(BirimFiyati) as KDV from [Satis Detaylari]

--ürünün kdvli fiyatýný hesaplayan functionsý yazýn
go
create function fncKdvliFiyat(@fiyat money)
returns money 
as
begin
	set @fiyat=@fiyat*1.18
	return @fiyat
end

select UrunAdi, BirimFiyati, dbo.fncKdvHesapla(BirimFiyati) as KDV, dbo.fncKdvliFiyat(BirimFiyati) as KDVDahilFiyat from Urunler 

--satýlan ürünlerin adetlerini ve indirimleri baz alarak her ürünün kdvli fiyatýný hesaplayan fonksiyonu yazýn
go
alter function fncGenelKdvliFiyat (@fiyat money, @adet int, @indirim float)
returns money
as
begin
	declare @Toplam money  --kdv dahil fiyata @Toplam dedik
	set @Toplam=(@fiyat+@fiyat*0.18)*@adet*(1-@indirim)
	return @Toplam
end

select UrunID, Miktar, Ýndirim, dbo.fncGenelKdvliFiyat (BirimFiyati, Miktar, Ýndirim) as Toplam from [Satis Detaylari] 

--Scalar Valued Fonksiyon: Bir tane deðer döndüren fonskiyonlara denir
--Table Valued Fonsiyon: Geriye table tipinder deðer döndüren fonskiyonlara denir

--kategori id ye göre ürünleri getiren fonsiyonu yazalým
go
create function KategoriyeGoreUrunler(@kId int)
returns table
as
return select * from Urunler where KategoriID=@kId

select * from dbo.KategoriyeGoreUrunler(5)

--