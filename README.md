# Genetic-Algorithm

To Do List:

- Şuan Pressure hesaplama constraintler arasında ve her kromozom için ayrıca pressure hesaplanıyor ve FEM çağırılıyor. Bunun yerine constraintler arasından pressure hesaplama kalkacak. Fittness function içinde zaten pressure hesaplanabiliyor. Pressure'ı önemsemeden tüm kromozomlar için tüm değerler hesaplanacak (değerlerden kastım FEM fonksiyonunun döndürdükleri) Daha sonra bu değerler içinde pressure da olduğundan pressure'ı 100MPa'dan büyük olanlar popilasyondan silinecek ve daha sonra kalanlar rulete sokulup elitlik mutasyon vs'ye uğrayacak.

- Çözüm sırasında şuanda sadece Energy frafiği çiziliyor. Çözüm sırasında
	- L'
	- Mass_projectile
	- Pressure
	- Energy
	- velocity

grafikleri de çizilecek.

- Historyde bu değerlerin sadece fittestları değil tüm değerlerinin bilgisi tutulacak makalede tüm dataların scatter figürlerini koyacaz.