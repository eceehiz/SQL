---------------------DDL KOMUTLARI---------------------------
/*
Create: Yeni veritaban�, view, procedure trigger functions olu�turmak i�in kullan�l�r.
Alter: Veritaban�, view, procedure trigger functions tekrar d�zenlemek i�in kullan�l�r.
Drop: Veritaban�, view, procedure trigger functions kald�rmak i�in kullan�l�r.
*/

create table Kisiler (  
KisiId int primary key identity (1,1),
Adi varchar(50) not null,
Soyadi varchar(50) not null,
Sehir varchar(50)
)

create table Urun(  
UrunId int primary key identity (1,1),
UrunAdi varchar(50),
Miktar int,
BirimFiyati float
)

alter table Kisiler   --kisiler tablosu g�ncellendi, Adi kolonu silndi
drop column Adi

drop table Kisiler --kisiler tablosu silindi
drop table Urun  --urun tablosu silindi
