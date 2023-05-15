--Procedure: viewin parametreli hali. C#'daki metotların parametre alanı.
--veriyi direkt almayı engelliyor, view'i kontrollü alıyoruz
create procedure UrunListele
as
select * from Urunler
exec UrunListele --select ile değil böyle çağırınca geliyor

--tüm müşterileri listeleyen prosedür yazalım
create procedure MusteriListele
as
select * from Musteriler
exec MusteriListele

--ürün adı, fiyatı ve stoğu dışarıdan alan, urunler tablosuna ekleyen procedure yazalım
go
alter proc UrunEkle   --procedure yerine proc da yazabilirsin
@urunAdi nvarchar(50),   --parametreleri @ ile tanımlıyoruz
@fiyat money,
@stok smallint
as
if exists (select * from Urunler where UrunAdi=@urunAdi)
begin                           --begin end birden fazla satır varsa kullanılıyor, araya yazılıyor
	print 'Bu üründen vardır'
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

--dışarıdan gönderilen nakliyeciyi kaydeden prosedürü yazın
go
create proc NakliyeciEkle
@sirketAdi varchar(50),
@telefon varchar(50)
as
insert Nakliyeciler(SirketAdi,Telefon)
values (@sirketAdi, @telefon)

exec NakliyeciEkle 'Akpınar Nakliyat', '(555) 44-2211'
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

--dışarıdan girilen bilgiye göre nakliyeciyi silen prosedür
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
   print 'Bu Id ye sahip nakliyeci olmadığından silinemedi'
exec NakliyeciSil 5

select * from Nakliyeciler

--aynı anda birden fazla nakliyeciyi silmek istersek, 4den başla 8 e kadar mesela
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

--trim komutunu kullanalım
exec UrunEkle '       Kiraz',  60,300   --bunu eklememesi gerekiyordu ama ekledi. kontrol altına almak için trim kullanalım

create proc UrunSil
@urunAdi varchar(50)
as
delete Urunler where UrunAdi=ltrim(rtrim(@urunAdi))

--id parametresi alıp o id li urunun stoğunu [ ya da 10] kullanıcıdan gelen oran kadar arttıran procu yazalım

create proc StokArttır
@urunID int
as
if exists (select * from Urunler where UrunID=@urunID)
begin
update Urunler
set HedefStokDuzeyi+=10
where UrunID=@urunID
end
else
print 'Bu ürünün ID si ürün listesinde mevcut değil'
exec StokArttır 15
select * from Urunler




