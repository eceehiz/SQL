--Transaction: En k���k i�lem par�ac���
--Birden fazla i�lem par�ac���n� tek bir i�lem haline getirip, bu i�lem par�ac���n�n herhangi bir yerinde bir hata oldu�u zaman t�m i�lemi iptal edip geri almay� sa�layan yap�

begin tran guncelleme          --trana isim verdik
update Kategoriler set KategoriAdi='Yeni'
where KategoriID=2
delete from Kategoriler where KategoriID=1
commit tran guncelleme     --bu tran bitti anlam�na geliyor
rollback tran

select * from Kategoriler

--Hesaplar adl� bir tablo olu�turduk
alter proc HavaleYap
@aliciId int,
@gonderenId int,
@tutar  money
as
begin tran
begin try     --hata yakalama
	update Hesaplar set Bakiye-=@tutar where Id=@gonderenId
	declare @a int = 8/0    --burada hata alaca�� i�in alt sat�ra ge�emeyecek. g�nderenden para ��kt� ama al�c�ya ula�mad�
	update Hesaplar set Bakiye+=@tutar where Id=@aliciId
commit tran      --a��lan transaction bitirir
end try
begin catch
rollback tran   --hata oldu�unda geri alaca��z, i�lem hi� ger�ekle�emeyecek. yani g�nderende de ��kmayacak
	print 'Hata olu�tu'
end catch

exec HavaleYap 1,2,500

select * from hesaplar