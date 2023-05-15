--Procedure: viewin parametreli hali. C#'daki metotlar�n parametre alan�.
--veriyi direkt almay� engelliyor, view'i kontroll� al�yoruz
create procedure UrunListele
as
select * from Urunler
exec UrunListele --select ile de�il b�yle �a��r�nca geliyor

--t�m m��terileri listeleyen prosed�r yazal�m
create procedure MusteriListele
as
select * from Musteriler
exec MusteriListele

--�r�n ad�, fiyat� ve sto�u d��ar�dan alan, urunler tablosuna ekleyen procedure yazal�m
go
alter proc UrunEkle   --procedure yerine proc da yazabilirsin
@urunAdi nvarchar(50),   --parametreleri @ ile tan�ml�yoruz
@fiyat money,
@stok smallint
as
if exists (select * from Urunler where UrunAdi=@urunAdi)
begin                           --begin end birden fazla sat�r varsa kullan�l�yor, araya yaz�l�yor
	print 'Bu �r�nden vard�r'
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

--d��ar�dan g�nderilen nakliyeciyi kaydeden prosed�r� yaz�n
go
create proc NakliyeciEkle
@sirketAdi varchar(50),
@telefon varchar(50)
as
insert Nakliyeciler(SirketAdi,Telefon)
values (@sirketAdi, @telefon)

exec NakliyeciEkle 'Akp�nar Nakliyat', '(555) 44-2211'
select * from Nakliyeciler

--nakliyecilerin t�m bilgilerini g�ncelleyen proc
go
alter proc NakliyeciGuncelle
@sirketAdi varchar(50),
@telefon varchar(50)
as
if not exists(select * from Nakliyeciler where SirketAdi=@sirketAdi)
begin
	insert into Nakliyeciler(SirketAdi,Telefon)
	values (@sirketAdi, @telefon)
	print '�r�n eklendi'
end

else
begin
    update Nakliyeciler
    set SirketAdi=@sirketAdi, Telefon=@telefon
    where SirketAdi=@sirketAdi
	print '�r�n g�ncellendi'
end
	
exec NakliyeciGuncelle 'Aras Kargo', '(555) 44-33-85'
select * from Nakliyeciler

--d��ar�dan girilen bilgiye g�re nakliyeciyi silen prosed�r
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
   print 'Bu Id ye sahip nakliyeci olmad���ndan silinemedi'
exec NakliyeciSil 5

select * from Nakliyeciler

--ayn� anda birden fazla nakliyeciyi silmek istersek, 4den ba�la 8 e kadar mesela
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

--trim komutunu kullanal�m
exec UrunEkle '       Kiraz',  60,300   --bunu eklememesi gerekiyordu ama ekledi. kontrol alt�na almak i�in trim kullanal�m

create proc UrunSil
@urunAdi varchar(50)
as
delete Urunler where UrunAdi=ltrim(rtrim(@urunAdi))

--id parametresi al�p o id li urunun sto�unu [ ya da 10] kullan�c�dan gelen oran kadar artt�ran procu yazal�m

create proc StokArtt�r
@urunID int
as
if exists (select * from Urunler where UrunID=@urunID)
begin
update Urunler
set HedefStokDuzeyi+=10
where UrunID=@urunID
end
else
print 'Bu �r�n�n ID si �r�n listesinde mevcut de�il'
exec StokArtt�r 15
select * from Urunler




