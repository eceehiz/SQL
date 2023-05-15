--Transaction: En küçük iþlem parçacýðý
--Birden fazla iþlem parçacýðýný tek bir iþlem haline getirip, bu iþlem parçacýðýnýn herhangi bir yerinde bir hata olduðu zaman tüm iþlemi iptal edip geri almayý saðlayan yapý

begin tran guncelleme          --trana isim verdik
update Kategoriler set KategoriAdi='Yeni'
where KategoriID=2
delete from Kategoriler where KategoriID=1
commit tran guncelleme     --bu tran bitti anlamýna geliyor
rollback tran

select * from Kategoriler

--Hesaplar adlý bir tablo oluþturduk
alter proc HavaleYap
@aliciId int,
@gonderenId int,
@tutar  money
as
begin tran
begin try     --hata yakalama
	update Hesaplar set Bakiye-=@tutar where Id=@gonderenId
	declare @a int = 8/0    --burada hata alacaðý için alt satýra geçemeyecek. gönderenden para çýktý ama alýcýya ulaþmadý
	update Hesaplar set Bakiye+=@tutar where Id=@aliciId
commit tran      --açýlan transaction bitirir
end try
begin catch
rollback tran   --hata olduðunda geri alacaðýz, iþlem hiç gerçekleþemeyecek. yani gönderende de çýkmayacak
	print 'Hata oluþtu'
end catch

exec HavaleYap 1,2,500

select * from hesaplar