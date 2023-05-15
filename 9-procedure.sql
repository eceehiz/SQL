--Procedure: viewin parametreli hali. C#'daki metotlarýn parametre alaný.
--veriyi direkt almayý engelliyor, view'i kontrollü alýyoruz
create procedure UrunListele
as
select * from Urunler
exec UrunListele --select ile deðil böyle çaðýrýnca geliyor

--tüm müþterileri listeleyen prosedür yazalým
create procedure MusteriListele
as
select * from Musteriler
exec MusteriListele

--ürün adý, fiyatý ve stoðu dýþarýdan alan, urunler tablosuna ekleyen procedure yazalým
go
alter proc UrunEkle   --procedure yerine proc da yazabilirsin
@urunAdi nvarchar(50),   --parametreleri @ ile tanýmlýyoruz
@fiyat money,
@stok smallint
as
if exists (select * from Urunler where UrunAdi=@urunAdi)
begin                           --begin end birden fazla satýr varsa kullanýlýyor, araya yazýlýyor
	print 'Bu üründen vardýr'
	update Urunler set HedefStokDuzeyi+=@stok where UrunAdi=@urunAdi 
    select * from Urunler where UrunAdi=@urunAdi
end

else 
begin 
   insert Urunler(UrunAdi,BirimFiyati,HedefStokDuzeyi)
   values (@urunAdi,@fiyat,@stok)
end

exec UrunEkle 'Kiraz', 60,200
select * from Urunler

--dýþarýdan gönderilen nakliyeciyi kaydeden prosedürü yazýn
go
create proc NakliyeciEkle
@sirketAdi varchar(50),
@telefon varchar(50)
as
insert Nakliyeciler(SirketAdi,Telefon)
values (@sirketAdi, @telefon)

exec NakliyeciEkle 'Akpýnar Nakliyat', '(555) 44-2211'
select * from Nakliyeciler

--nakliyecilerin tüm bilgilerini güncelleyen proc
go
alter proc NakliyeciGuncelle
@sirketAdi varchar(50),
@telefon varchar(50)
as
if not exists(select * from Nakliyeciler where SirketAdi=@sirketAdi)
begin
	insert into Nakliyeciler(SirketAdi,Telefon)
	values (@sirketAdi, @telefon)
	print 'Ürün eklendi'
end

else
begin
    update Nakliyeciler
    set SirketAdi=@sirketAdi, Telefon=@telefon
    where SirketAdi=@sirketAdi
	print 'Ürün güncellendi'
end
	
exec NakliyeciGuncelle 'Aras Kargo', '(555) 44-33-85'
select * from Nakliyeciler

--dýþarýdan girilen bilgiye göre nakliyeciyi silen prosedür
go
alter proc NakliyeciSil
@nakliyeciID int
as
if exists(select * from Nakliyeciler where NakliyeciID=@nakliyeciID)
begin
	delete from Nakliyeciler
	where NakliyeciID=@nakliyeciID
	print 'Nakliyeci silindi'
end
else
   print 'Bu Id ye sahip nakliyeci olmadýðýndan silinemedi'
exec NakliyeciSil 5

select * from Nakliyeciler

--ayný anda birden fazla nakliyeciyi silmek istersek, 4den baþla 8 e kadar mesela
go
alter proc NakliyeciSil
@baslangic int,
@bitis int
as 
declare @sayac int=@baslangic
while @sayac<=@bitis
begin
delete from Nakliyeciler where NakliyeciID = @sayac
set @sayac=@sayac+1
end

exec NakliyeciSil 3,4

select * from Nakliyeciler

--trim komutunu kullanalým
exec UrunEkle '       Kiraz',  60,300   --bunu eklememesi gerekiyordu ama ekledi. kontrol altýna almak için trim kullanalým

create proc UrunSil
@urunAdi varchar(50)
as
delete Urunler where UrunAdi=ltrim(rtrim(@urunAdi))

--id parametresi alýp o id li urunun stoðunu [ ya da 10] kullanýcýdan gelen oran kadar arttýran procu yazalým

create proc StokArttýr
@urunID int
as
if exists (select * from Urunler where UrunID=@urunID)
begin
update Urunler
set HedefStokDuzeyi+=10
where UrunID=@urunID
end
else
print 'Bu ürünün ID si ürün listesinde mevcut deðil'
exec StokArttýr 15
select * from Urunler




