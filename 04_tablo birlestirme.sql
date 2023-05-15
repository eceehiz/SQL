select * from Urunler u, Kategoriler k
where u.KategoriID=k.KategoriID

select u.UrunAdi,t.SirketAdi from Tedarikciler t, Urunler u
where t.TedarikciID=u.TedarikciID

--hangi müþteriye hangi satýþ satýlmýþ
select * from Musteriler m , Satislar s
where m.MusteriID=s.MusteriID

--ürünler, kategoriler, tedarikçiler tablosunu birleþtir
select * from Urunler u , Kategoriler k, Tedarikciler t
where u.KategoriID=k.KategoriID and  t.TedarikciID=u.TedarikciID

--hangi müþteri hangi ürünü almýþ
select m.MusteriAdi, u.UrunAdi,  sum(sd.Miktar) as miktar, sum(sd.BirimFiyati*sd.Miktar*(1-sd.Ýndirim)) as fiyat  from Urunler u, Satislar s, [Satis Detaylari] sd, Musteriler m
where u.UrunID=sd.UrunID and sd.SatisID=s.SatisID and s.MusteriID=m.MusteriID 
group by u.UrunAdi, m.MusteriAdi

select m.MusteriAdi, u.UrunAdi,  sum(sd.Miktar) as miktar, sum(sd.BirimFiyati*sd.Miktar*(1-sd.Ýndirim)) as fiyat  from Urunler u, Satislar s, [Satis Detaylari] sd, Musteriler m
where u.UrunID=sd.UrunID and sd.SatisID=s.SatisID and s.MusteriID=m.MusteriID and m.MusteriAdi='Alexander Feuer'
group by u.UrunAdi, m.MusteriAdi

--hangi personel hangi þirkete hangi ürünü kaç kere satmýþtýr
select p.Adi+' ' + p.SoyAdi as PersonelAdi, m.SirketAdi, count(s.SatisID) as SatisAdet, sum(sd.Miktar) as ToplamMiktar, sd.UrunID, u.UrunAdi
from Personeller p, Satislar s, Musteriler m, [Satis Detaylari] sd, Urunler u
where p.PersonelID=s.PersonelID and s.MusteriID=m.MusteriID and sd.SatisID=s.SatisID and u.UrunID=sd.UrunID
group by p.Adi, p.SoyAdi, m.SirketAdi, sd.UrunID, u.UrunAdi
order by p.Adi

-------------------------------------------------------
--join
select * from Urunler u
join Kategoriler k on u.KategoriID=k.KategoriID

select * from Urunler u
join Kategoriler k on u.KategoriID=k.KategoriID
join Tedarikciler t on u.TedarikciID=t.TedarikciID

--personel satýþlar müþteriler vb. tablosunu baðla
select m.MusteriAdi, u.UrunAdi, p.Adi, k.KategoriAdi, t.TedarikciID from Satislar s
join Musteriler m on s.MusteriID=m.MusteriID
join Personeller p on p.PersonelID=s.PersonelID
join [Satis Detaylari] sd on sd.SatisID=S.SatisID
join Urunler u on u.UrunID=sd.UrunID
join Kategoriler k on k.KategoriID=u.KategoriID
join Tedarikciler t on t.TedarikciID=u.TedarikciID

--hangi personel hangi üründen toplam kaç dolarlýk satýþ yaptýðýný ekrana yaz
select p.Adi, u.UrunAdi,  Round(sum(sd.BirimFiyati*sd.Miktar*(1-sd.Ýndirim)),2) ToplamFiyat from Personeller p
join Satislar s on p.PersonelID=s.PersonelID
join [Satis Detaylari] sd on sd.SatisID=s.SatisID
join Urunler u on u.UrunID=sd.UrunID
group by p.Adi, u.UrunAdi
order by 3 desc

