-------------VİEW------------
--Sanal tablo oluşturma. metot mantığı

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
--view her çağrıldığında sorgu çalışır. ama oluşturulurken bir kez derlenir

--personelsatış viewi oluştıralım. hangi personel ne kadar satış yapmış
go
create view PersonelSatisRaporu
as
select p.Adi, u.UrunAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.İndirim)) as ToplamTutar from Satislar s
left join Personeller p on p.PersonelID=s.PersonelID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by p.Adi, u.UrunAdi

--hangi ürün hangi müşteriye toplam ne kadar satılmıştır, musteriUrunRaporu viewi
go
create view musteriUrunRaporu
as
select  u.UrunAdi, m.MusteriAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.İndirim)) as ToplamTutar from Musteriler m
left join Satislar s on m.MusteriID=s.MusteriID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by u.UrunAdi, m.MusteriAdi

select * from musteriUrunRaporu


go
alter view musteriUrunRaporu1
with encryption  --kendin bir yerde sakladıktan sonra koda ulaşılmasın istiyorsan ekle
as
select  u.UrunAdi, m.MusteriAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.İndirim)) as ToplamTutar, count(u.UrunAdi) Adet from Musteriler m
left join Satislar s on m.MusteriID=s.MusteriID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by u.UrunAdi, m.MusteriAdi

--hangi nakliyeci hangi ürünü hangi müşteriye adet ve toplam olarak ne satmıştır. nakliyeciRaporu
go
create view nakliyeciRaporu
as
select n.SirketAdi, u.UrunAdi, m.MusteriAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.İndirim)) as ToplamTutar,count(u.UrunAdi) as Adet from Nakliyeciler n
left join Satislar s on n.NakliyeciID=s.ShipVia
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Musteriler m on m.MusteriID=s.MusteriID
left join Urunler u on u.UrunID=sd.UrunID
group by n.SirketAdi, u.UrunAdi, m.MusteriAdi

select * from nakliyeciRaporu











