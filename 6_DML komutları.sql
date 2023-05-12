---------------------DML KOMUTLARI---------------------------

/*
INSERT: Bir tabloya kay�t eklemeyi sa�layan komut
Insert [into] TabloAdi (kolon)
Values (degerler)
*/

INSERT INTO Urunler (UrunAdi, BirimFiyati, HedefStokDuzeyi)
VALUES('Elma', 2,30)

INSERT INTO Kategoriler (KategoriAdi, Tanimi)
VALUES('Baharatlar','Y�rsel lezzetler')

select * from Personeller
INSERT INTO Personeller (SoyAdi,Adi,Unvan, UnvanEki, DogumTarihi)
VALUES('�al��kan','Do�an','Y�netici Asistan�', 'Ms.', '1963-07-18')

/*
UPDATE: Belli kay�tlar� g�ncellemeyi sa�layan komut
Update TabloAdi 
Set kolon=deger
*/

--G�venmedi�in kodlar� begin tran ile rollback tran aras�na yaz. bu �ekilde geri d�n��t�rebilirsin. 
--begin tran ile update c�mlesini birlikte se�erek �al��t�r. geri almak i�in rollbacki tek �al��t�r
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

--kategori �d si 2 olan �r�nlerin stok adedini 5 artt�r
begin tran
update Urunler
set HedefStokDuzeyi=HedefStokDuzeyi+5
where KategoriID=2
rollback tran

--Ad� Robert olan personelin m��teriye yapt��� sat��lara %5 indirim 
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
DELETE: Belli kay�tlar� silmeyi sa�layan komut
Delete [from] TabloAdi 
Where �art
*/

begin tran
delete Nakliyeciler
where NakliyeciID=1
rollback tran

/*
bir tabloda o de�er varsa eklemesin: 

if exists (select * from Urunler where UrunAdi='incir')
		begin
		select * from Urunler
		end
		else 
		begin 
		Insert into Urunler(UrunAdi,BirimFiyati,HedefStokDuzeyi) values('incir',2,30)
		end
*/

--�r�nler tablosuna yeni bir �r�n ekleyip o �r�n�n fiyat�n� ve sto�unu g�ncelleyip sonrafa o �r�n� silen sorgular� yaz�n�z

select * from Urunler
insert into Urunler (UrunAdi,BirimFiyati,HedefStokDuzeyi)
values ('�ilek', 30, 10)

update Urunler
set BirimFiyati=40, HedefStokDuzeyi=5
where UrunID=(select top 1 UrunID from Urunler order by UrunID desc)

begin tran
delete from Urunler
where UrunID=(select top 1 UrunID from Urunler order by UrunID desc)

--Ayn� soruyu de�i�ken olu�turarak yapal�m

--De�i�ken olu�turma:
declare @temp int 
set @temp=6

--En son girilen sat�r�n id sini al�r.
scope_identity()

insert into Urunler(UrunAdi)
values('Portakal')

declare @id int=scope_identity()
update Urunler
set BirimFiyati=15, HedefStokDuzeyi=125
where UrunID=@id

delete from Urunler
where UrunID=@id


