-- c

INSERT INTO individu (prenom, nom ,adresseMail, motDePasse, telephonePortable)
VALUES ('quentin', 'falvard', 'toto@yopmail.com', SHA2(CONV(FLOOR(RAND()*99999999999999), 20, 36), 256), '0666666666');

INSERT INTO individu (prenom, nom ,adresseMail, motDePasse, telephonePortable)
VALUES ('rasta', 'tocket', 'rasta@yopmail.com', SHA2(CONV(FLOOR(RAND()*99999999999999), 20, 36), 256), '0666666668');

INSERT INTO restaurant (idAdresse, raisonSociale, delaiHabituel)
VALUES 	(1, 'Chamas Tacos', 15), 
		(2, 'Salmon Lovers', 30), 
		(3, 'La Pizza Lyonnaise', 20),
		(4, 'Cousbox', 25), 
		(5, 'Burger House', 10), 
		(6, 'Crok’in', 15);

BEGIN
	SET @max = 60 + RAND() * 60;
    SET @i = 0;
    
    WHILE @i < @max DO
		
		SET @montantTemp = ROUND(8 + RAND() * 62,2);
		SET @consigneTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
		SET @dateCommandeTemp = NOW() - INTERVAL RAND() * 21780 MINUTE;
		SET @datePreparationTermineeTemp = @dateCommandeTemp + INTERVAL 5 + RAND() * 30 MINUTE;
		SET @dateLivraisonEstimeeTemp = @datePreparationTermineeTemp + INTERVAL 5 + RAND() * 20 MINUTE;
		SET @dateLivraisonReelleTemp = @dateLivraisonEstimeeTemp + INTERVAL 5 + RAND() * 20 MINUTE;
		SET @idIndividuCoursierTemp = (SELECT idIndividu FROM coursier ORDER BY RAND() LIMIT 1);
		SET @idIndividuClientTemp = (SELECT idIndividu FROM client ORDER BY RAND() LIMIT 1);
		SET @idRestaurantTemp = (SELECT idRestaurant FROM restaurant ORDER BY RAND() LIMIT 1);
		SET @idAdresseTemp = (SELECT idAdresse FROM adresse ORDER BY RAND() LIMIT 1);
		
		INSERT INTO commande (montant, consigne, dateCommande, datePreparationTerminee, dateLivraisonEstimee, dateLivraisonReelle,
							  idIndividuCoursier, idIndividuClient, idRestaurant, idAdresse)
		VALUES (@montantTemp, @consigneTemp, @dateCommandeTemp, @datePreparationTermineeTemp, @dateLivraisonEstimeeTemp, @dateLivraisonReelleTemp,
				@idIndividuCoursierTemp, @idIndividuClientTemp, @idRestaurantTemp, @idAdresseTemp);
		
		SET @i = @i + 1;
	END WHILE;
	
	SELECT CONCAT(@i, ' commandes ont été ajoutées') AS Resultat
END

-- D
	-- 1 
	not null pour la colonne SIRET dans la table
	
	-- 2
	BEGIN
		IF (new.adresseMail NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,63}$')
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'L''adresse e-mail n''est pas sous la forme aa@aa.aa';
		END IF;
	END

	-- 3
	ALTER TABLE `individu` ADD UNIQUE( `adresseMail`); 
	
	-- 4
	ALTER TABLE `adresse` CHANGE `ligne2` `ligne2` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL, CHANGE `ligne3` `ligne3` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL; 
	
	-- 5
	ALTER TABLE `commande` CHANGE `montant` `montant` DECIMAL(10,2) UNSIGNED NOT NULL;
	
	-- 6
	BEGIN
		IF (LENGTH(new.numeroSiret) != 16)
		THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Numero de siret doit avoir 14 caractères';
		END IF;
	END
	
	-- 7
	BEGIN
		IF (new.delaiHabituel < 5 OR new.delaiHabituel > 75)
		THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Le delai doit être compris entre 5 et 75 minutes';
		END IF;
	END
	
-- E

	-- 1
	SELECT *
	FROM individu
	WHERE prenom = 'Hubert'

-- F
	
	-- 1
	SELECT * 
	WHERE commande.dateCommande < '2020-11-28'
	FROM commande
	
	-- 2
	DELETE commande
	FROM commande
	WHERE commande.dateCommande < '2020-11-28'
	
	--3
	SELECT *
	FROM commande
	WHERE montant > 20 AND dateCommande >= '2020-12-03'
	ORDER BY dateCommande
	
	-- 4
	SELECT idCommande, dateCommande, dateLivraisonEstimee, dateLivraisonReelle, TIME_FORMAT(TIMEDIFF(dateLivraisonEstimee, dateLivraisonReelle), "%i") Retard, CONCAT(individu.prenom, ' ', individu.nom) Coursier
	FROM commande
	JOIN coursier ON coursier.idIndividu = commande.idIndividuCoursier
	JOIN individu ON individu.idIndividu = coursier.idIndividu
	WHERE TIMEDIFF(dateLivraisonEstimee, dateLivraisonReelle) > 0
	
	-- 5
	CREATE VIEW ComRetard AS
	SELECT idCommande, dateCommande, dateLivraisonEstimee, dateLivraisonReelle, TIME_FORMAT(TIMEDIFF(dateLivraisonEstimee, dateLivraisonReelle), "%i") Retard, CONCAT(individu.prenom, ' ', individu.nom) Coursier
	FROM commande
	JOIN coursier ON coursier.idIndividu = commande.idIndividuCoursier
	JOIN individu ON individu.idIndividu = coursier.idIndividu
	WHERE TIMEDIFF(dateLivraisonEstimee, dateLivraisonReelle) > 0
	
	-- 6
	SELECT *
	FROM comretard
	WHERE Retard > 5
	ORDER BY Retard DESC
	
	-- 7
	SELECT COUNT(*) 'Nombre de retard', Coursier, CONCAT(ROUND(SUM(Retard)/COUNT(*),1), ' minute(s)') 'Retard Moyen'
	GROUP BY Coursier
	FROM comretard
	
	-- 8
	SELECT idCommande, DATE_FORMAT(dateCommande, "%d/%m/%Y") dateCommande, CONCAT(Cl.nom, ' ', Cl.prenom) infosClient, CONCAT(Co.nom, ' (', coursier.numeroSiret, ')') infosCoursier
	FROM commande
	JOIN individu Cl ON Cl.idIndividu = commande.idIndividuClient
	JOIN individu Co ON Co.idIndividu = commande.idIndividuCoursier
	JOIN coursier ON coursier.idIndividu = Co.idIndividu
	GROUP BY idCommande, DATE_FORMAT(dateCommande, "%d/%m/%Y"), CONCAT(Cl.nom, ' ', Cl.prenom), CONCAT(Co.nom, ' (', coursier.numeroSiret, ')')
	
	-- 9
	