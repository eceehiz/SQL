--FUNCTION: Geri d�n��l� metot kar��l���na gelen yap�

--�r�nlerin kdv sini hesaplayal�m, yan�na kolon olarak ekleyelim
go
create function fncKdvHesapla (@fiyat money)
returns money 
as
begin
	declare @kdv money
	set @kdv=@fiyat*0.18
	return @kdv
end

select UrunAdi, BirimFiyati, dbo.fncKdvHesapla(BirimFiyati) as KDV from Urunler --fonksiyonu kullanal�m
select *, dbo.fncKdvHesapla(BirimFiyati) as KDV from [Satis Detaylari]

--�r�n�n kdvli fiyat�n� hesaplayan functions� yaz�n
go
create function fncKdvliFiyat(@fiyat money)
returns money 
as
begin
	set @fiyat=@fiyat*1.18
	return @fiyat
end

select UrunAdi, BirimFiyati, dbo.fncKdvHesapla(BirimFiyati) as KDV, dbo.fncKdvliFiyat(BirimFiyati) as KDVDahilFiyat from Urunler 

--sat�lan �r�nlerin adetlerini ve indirimleri baz alarak her �r�n�n kdvli fiyat�n� hesaplayan fonksiyonu yaz�n
go
alter function fncGenelKdvliFiyat (@fiyat money, @adet int, @indirim float)
returns money
as
begin
	declare @Toplam money  --kdv dahil fiyata @Toplam dedik
	set @Toplam=(@fiyat+@fiyat*0.18)*@adet*(1-@indirim)
	return @Toplam
end

select UrunID, Miktar, �ndirim, dbo.fncGenelKdvliFiyat (BirimFiyati, Miktar, �ndirim) as Toplam from [Satis Detaylari] 

--Scalar Valued Fonksiyon: Bir tane de�er d�nd�ren fonskiyonlara denir
--Table Valued Fonsiyon: Geriye table tipinder de�er d�nd�ren fonskiyonlara denir

--kategori id ye g�re �r�nleri getiren fonsiyonu yazal�m
go
create function KategoriyeGoreUrunler(@kId int)
returns table
as
return select * from Urunler where KategoriID=@kId

select * from dbo.KategoriyeGoreUrunler(5)

--