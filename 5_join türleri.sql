/*
Outer join 
3 çeþit outer join vardýr 
Left Outer Join : Left tablo ilk yazýlan soldaki tablodur. Sol tablodaki tüm kayýtlar gelir null olsa dahi ve sað tablodan sol tablonun iliþkili kayýtlarý getirilir. 
(sol tablo + sað’ýn solla iliþkili olan kýsmý)*/

select * from Kategoriler k left outer join Urunler u on  k.KategoriID=u.KategoriID where k.KategoriID is null
select * from Urunler u left outer join Kategoriler k on u.KategoriID=k.KategoriID where u.UrunID is null

/*Right Outer Join : Right tablo ilk yazýlan tablodur. 
Sað tablodaki tüm kayýrtlar gelir null olsa bile sol tablodan sað tablonun  iliþkili kayýtlarý getirilir.(sað tablo + sol’un saðla iliþkili olan kýsmý)*/

select * from Kategoriler k right join Urunler u on  u.KategoriID=k.KategoriID where k.KategoriID is null
select * from Urunler u right join Kategoriler k on u.KategoriID=k.KategoriID where u.KategoriID is null


--Full Outer Join: hem saðdaki hem soldaki tablodan null kayýtlar dahil tüm kayýtlarý getirir

select * from Kategoriler k full join Urunler u on u.KategoriID=k.KategoriID where k.KategoriID is null or u.KategoriID is null
select * from Urunler k full join Kategoriler u on u.KategoriID=k.KategoriID

--hiç satýþ yapýlmayan müþterileri tablo halinde ekrana yaz
select * from Musteriler m
left join Satislar s on s.MusteriID=m.MusteriID
where s.MusteriID is null

--hiç nakliye yapmayan nakliyeciler
select * from Nakliyeciler n left join Satislar s on n.NakliyeciID=s.ShipVia
where s.ShipVia is null

----------------------------
--cross join: yazýlan tablolardaki tüm kayýtlarý birbiri ile kartezyen çarparak birbiriyle iliþkilendirir

select * from Urunler cross join Kategoriler

select p.Adi, u.UrunAdi, t.SirketAdi from Urunler u 
cross join Personeller p
cross join Tedarikciler t

/*kümeleme fonksiyonlarý: birleþtirme (union), kesiþim(intersect) ve fark(except) olmak üzere 3e ayrýlýr
farklý 2 sorgu üzerine kümeleme fonksiyonlarý uygulanýrsa; kolon sayýsý ve kolon tipi ayný olmalýdýr
*/
select SirketAdi from Tedarikciler
union 
select SirketAdi from Musteriler

select SirketAdi from Tedarikciler
intersect                           --kesiþim
select SirketAdi from Musteriler

select SirketAdi from Tedarikciler   --29
except                              --ortak 2 tane olduðunu düþün
select SirketAdi from Musteriler    --91,  cevap 27


--hangi personel hangi üründen satýþ yapmamýþ
select p.Adi, u.UrunAdi from Urunler u cross join Personeller p
except
select p.Adi, u.UrunAdi from Personeller p
left join Satislar s on p.PersonelID=s.PersonelID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID


--hangi tedarikçi hangi ürünü hiç tedarik etmemiþtir
select u.UrunAdi, t.SirketAdi  from Tedarikciler t cross join Urunler u
except
select u.UrunAdi, t.SirketAdi from Tedarikciler t
left join Urunler u on t.TedarikciID=u.TedarikciID

--hangi ürün hangi müþteriye hiç satýlmamýþtýr
select u.UrunAdi, m.MusteriAdi from Urunler u cross join Musteriler m
except
select u.UrunAdi, m.MusteriAdi from Urunler u --left joinle baþladýysan öyle devam etmek mantýklý oluyor
left join [Satis Detaylari] sd on sd.UrunID=u.UrunID
left join Satislar s on s.SatisID=sd.SatisID
left join Musteriler m on m.MusteriID=s.MusteriID

--satýþ fiyatý 1000 dolardan fazla olan ürünleri hangi personel satmýþtýr
select u.UrunAdi, p.Adi from Urunler u cross join Personeller p
except
select p.Adi, u.UrunAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.Ýndirim)) as Tutar from Personeller p
left join Satislar s on s.PersonelID=p.PersonelID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by u.UrunAdi, p.Adi
having sum(sd.BirimFiyati*sd.Miktar*(1-sd.Ýndirim))>1000