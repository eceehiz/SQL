---------------------DDL KOMUTLARI---------------------------
/*
Create: Yeni veritabanı, view, procedure trigger functions oluşturmak için kullanılır.
Alter: Veritabanı, view, procedure trigger functions tekrar düzenlemek için kullanılır.
Drop: Veritabanı, view, procedure trigger functions kaldırmak için kullanılır.
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

alter table Kisiler   --kisiler tablosu güncellendi, Adi kolonu silndi
drop column Adi

drop table Kisiler --kisiler tablosu silindi
drop table Urun  --urun tablosu silindi
