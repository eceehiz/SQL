---------------------DDL KOMUTLARI---------------------------
/*
Create: Yeni veritabaný, view, procedure trigger functions oluþturmak için kullanýlýr.
Alter: Veritabaný, view, procedure trigger functions tekrar düzenlemek için kullanýlýr.
Drop: Veritabaný, view, procedure trigger functions kaldýrmak için kullanýlýr.
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
