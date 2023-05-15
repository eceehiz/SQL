-------------V�EW------------
--Sanal tablo olu�turma. metot mant���

create view urunListesi
as
select u.*, k.KategoriAdi from Urunler u
left join Kategoriler k on u.KategoriID=k.KategoriID
go

alter view urunListesi
as
select u.UrunAdi,u.BirimFiyati, k.KategoriAdi,k.Tanimi, t.MusteriAdi, t.SirketAdi from Urunler u
left join Kategoriler k on u.KategoriID=k.KategoriID
left join Tedarikciler t on t.TedarikciID=u.TedarikciID
go

select * from urunListesi
--view her �a�r�ld���nda sorgu �al���r. ama olu�turulurken bir kez derlenir

--personelsat�� viewi olu�t�ral�m. hangi personel ne kadar sat�� yapm��
go
create view PersonelSatisRaporu
as
select p.Adi, u.UrunAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.�ndirim)) as ToplamTutar from Satislar s
left join Personeller p on p.PersonelID=s.PersonelID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by p.Adi, u.UrunAdi

--hangi �r�n hangi m��teriye toplam ne kadar sat�lm��t�r, musteriUrunRaporu viewi
go
create view musteriUrunRaporu
as
select  u.UrunAdi, m.MusteriAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.�ndirim)) as ToplamTutar from Musteriler m
left join Satislar s on m.MusteriID=s.MusteriID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by u.UrunAdi, m.MusteriAdi

select * from musteriUrunRaporu


go
alter view musteriUrunRaporu1
with encryption  --kendin bir yerde saklad�ktan sonra koda ula��lmas�n istiyorsan ekle
as
select  u.UrunAdi, m.MusteriAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.�ndirim)) as ToplamTutar, count(u.UrunAdi) Adet from Musteriler m
left join Satislar s on m.MusteriID=s.MusteriID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by u.UrunAdi, m.MusteriAdi

--hangi nakliyeci hangi �r�n� hangi m��teriye adet ve toplam olarak ne satm��t�r. nakliyeciRaporu
go
create view nakliyeciRaporu
as
select n.SirketAdi, u.UrunAdi, m.MusteriAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.�ndirim)) as ToplamTutar,count(u.UrunAdi) as Adet from Nakliyeciler n
left join Satislar s on n.NakliyeciID=s.ShipVia
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Musteriler m on m.MusteriID=s.MusteriID
left join Urunler u on u.UrunID=sd.UrunID
group by n.SirketAdi, u.UrunAdi, m.MusteriAdi

select * from nakliyeciRaporu











