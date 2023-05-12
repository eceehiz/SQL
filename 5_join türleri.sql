/*
Outer join 
3 �e�it outer join vard�r 
Left Outer Join : Left tablo ilk yaz�lan soldaki tablodur. Sol tablodaki t�m kay�tlar gelir null olsa dahi ve sa� tablodan sol tablonun ili�kili kay�tlar� getirilir. 
(sol tablo + sa��n solla ili�kili olan k�sm�)*/

select * from Kategoriler k left outer join Urunler u on  k.KategoriID=u.KategoriID where k.KategoriID is null
select * from Urunler u left outer join Kategoriler k on u.KategoriID=k.KategoriID where u.UrunID is null

/*Right Outer Join : Right tablo ilk yaz�lan tablodur. 
Sa� tablodaki t�m kay�rtlar gelir null olsa bile sol tablodan sa� tablonun  ili�kili kay�tlar� getirilir.(sa� tablo + sol�un sa�la ili�kili olan k�sm�)*/

select * from Kategoriler k right join Urunler u on  u.KategoriID=k.KategoriID where k.KategoriID is null
select * from Urunler u right join Kategoriler k on u.KategoriID=k.KategoriID where u.KategoriID is null


--Full Outer Join: hem sa�daki hem soldaki tablodan null kay�tlar dahil t�m kay�tlar� getirir

select * from Kategoriler k full join Urunler u on u.KategoriID=k.KategoriID where k.KategoriID is null or u.KategoriID is null
select * from Urunler k full join Kategoriler u on u.KategoriID=k.KategoriID

--hi� sat�� yap�lmayan m��terileri tablo halinde ekrana yaz
select * from Musteriler m
left join Satislar s on s.MusteriID=m.MusteriID
where s.MusteriID is null

--hi� nakliye yapmayan nakliyeciler
select * from Nakliyeciler n left join Satislar s on n.NakliyeciID=s.ShipVia
where s.ShipVia is null

----------------------------
--cross join: yaz�lan tablolardaki t�m kay�tlar� birbiri ile kartezyen �arparak birbiriyle ili�kilendirir

select * from Urunler cross join Kategoriler

select p.Adi, u.UrunAdi, t.SirketAdi from Urunler u 
cross join Personeller p
cross join Tedarikciler t

/*k�meleme fonksiyonlar�: birle�tirme (union), kesi�im(intersect) ve fark(except) olmak �zere 3e ayr�l�r
farkl� 2 sorgu �zerine k�meleme fonksiyonlar� uygulan�rsa; kolon say�s� ve kolon tipi ayn� olmal�d�r
*/
select SirketAdi from Tedarikciler
union 
select SirketAdi from Musteriler

select SirketAdi from Tedarikciler
intersect                           --kesi�im
select SirketAdi from Musteriler

select SirketAdi from Tedarikciler   --29
except                              --ortak 2 tane oldu�unu d���n
select SirketAdi from Musteriler    --91,  cevap 27


--hangi personel hangi �r�nden sat�� yapmam��
select p.Adi, u.UrunAdi from Urunler u cross join Personeller p
except
select p.Adi, u.UrunAdi from Personeller p
left join Satislar s on p.PersonelID=s.PersonelID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID


--hangi tedarik�i hangi �r�n� hi� tedarik etmemi�tir
select u.UrunAdi, t.SirketAdi  from Tedarikciler t cross join Urunler u
except
select u.UrunAdi, t.SirketAdi from Tedarikciler t
left join Urunler u on t.TedarikciID=u.TedarikciID

--hangi �r�n hangi m��teriye hi� sat�lmam��t�r
select u.UrunAdi, m.MusteriAdi from Urunler u cross join Musteriler m
except
select u.UrunAdi, m.MusteriAdi from Urunler u --left joinle ba�lad�ysan �yle devam etmek mant�kl� oluyor
left join [Satis Detaylari] sd on sd.UrunID=u.UrunID
left join Satislar s on s.SatisID=sd.SatisID
left join Musteriler m on m.MusteriID=s.MusteriID

--sat�� fiyat� 1000 dolardan fazla olan �r�nleri hangi personel satm��t�r
select u.UrunAdi, p.Adi from Urunler u cross join Personeller p
except
select p.Adi, u.UrunAdi, sum(sd.BirimFiyati*sd.Miktar*(1-sd.�ndirim)) as Tutar from Personeller p
left join Satislar s on s.PersonelID=p.PersonelID
left join [Satis Detaylari] sd on sd.SatisID=s.SatisID
left join Urunler u on u.UrunID=sd.UrunID
group by u.UrunAdi, p.Adi
having sum(sd.BirimFiyati*sd.Miktar*(1-sd.�ndirim))>1000