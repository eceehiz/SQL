/*
Outer join 
3 çeşit outer join vardır 
Left Outer Join : Left tablo ilk yazılan soldaki tablodur. Sol tablodaki tüm kayıtlar gelir null olsa dahi ve sağ tablodan sol tablonun ilişkili kayıtları getirilir. 
(sol tablo + sağ’ın solla ilişkili olan kısmı)*/

select * from Kategoriler k left outer join Urunler u on  k.KategoriID=u.KategoriID where k.KategoriID is null
select * from Urunler u left outer join Kategoriler k on u.KategoriID=k.KategoriID where u.UrunID is null

/*Right Outer Join : Right tablo ilk yazılan tablodur. 
Sağ tablodaki tüm kayırtlar gelir null olsa bile sol tablodan sağ tablonun  ilişkili kayıtları getirilir.(sağ tablo + sol’un sağla ilişkili olan kısmı)*/

select * from Kategoriler k right join Urunler u on  u.KategoriID=k.KategoriID where k.KategoriID is null
select * from Urunler u right join Kategoriler k on u.KategoriID=k.KategoriID where u.KategoriID is null


--Full Outer Join: hem sağdaki hem soldaki tablodan null kayıtlar dahil tüm kayıtları getirir

select * from Kategoriler k full join Urunler u on u.KategoriID=k.KategoriID where k.KategoriID is null or u.KategoriID is null
select * from Urunler k full join Kategoriler u on u.KategoriID=k.KategoriID

--hiç satış yapılmayan müşterileri tablo halinde ekrana yaz
select * from Musteriler m
left join Satislar s on s.MusteriID=m.MusteriID
where s.MusteriID is null

--hiç nakliye yapmayan nakliyeciler
select * from Nakliyeciler n left join Satislar s on n.NakliyeciID=s.ShipVia
where s.ShipVia is null

----------------------------
--cross join: yazılan tablolardaki tüm kayıtları birbiri ile kartezyen çarparak birbiriyle ilişkilendirir

select * from Urunler cross join Kategoriler

select p.Adi, u.UrunAdi, t.SirketAdi from Urunler u 
cross join Personeller p
cross join Tedarikciler t

/*kümeleme fonksiyonları: birleştirme (union), kesişim(intersect) ve fark(except) olmak üzere 3e ayrılır
farklı 2 sorgu üzerine kümeleme fonksiyonları uygulanırsa; kolon sayısı ve kolon tipi aynı olmalıdır
*/
select SirketAdi from Tedarikciler
union 
select SirketAdi from Musteriler

select SirketAdi from Tedarikciler
intersect                           --kesişim
select SirketAdi from Musteriler

select SirketAdi from Tedarikciler   --29
except                              --ortak 2 tane olduğunu düşün
select SirketAdi from Musteriler    --91,  cevap 27


--hangi personel hangi üründen satış yapmamış
select p.Adi, u.UrunAdi from Urunler u cross join Personeller p
except
select p.Adi, u.UrunAdi from Personeller p
left join Satislar s on p.PersonelID=s.PersonelID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID


--hangi tedarikçi hangi ürünü hiç tedarik etmemiştir
select u.UrunAdi, t.SirketAdi  from Tedarikciler t cross join Urunler u
except
select u.UrunAdi, t.SirketAdi from Tedarikciler t
left join Urunler u on t.TedarikciID=u.TedarikciID

--hangi ürün hangi müşteriye hiç satılmamıştır
select u.UrunAdi, m.MusteriAdi from Urunler u cross join Musteriler m
except
select u.UrunAdi, m.MusteriAdi from Urunler u --left joinle başladıysan öyle devam etmek mantıklı oluyor
left join [Satis Detaylari] sd on sd.UrunID=u.UrunID
left join Satislar s on s.SatisID=sd.SatisID
left join Musteriler m on m.MusteriID=s.MusteriID

--satış fiyatı 1000 dolardan fazla olan ürünleri hangi personel satmıştır
select u.UrunAdi, p.Adi from Urunler u cross join Personeller p
except
select p.Adi, u.UrunAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.İndirim)) as Tutar from Personeller p
left join Satislar s on s.PersonelID=p.PersonelID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by u.UrunAdi, p.Adi
having sum(sd.BirimFiyati*sd.Miktar*(1-sd.İndirim))>1000
