-- Projet IN513 - Base de données d'un restaurant

CREATE TABLE CARTE (
    num_carte number(2),
    nom_carte varchar(53),
    typeEPD varchar(1) CHECK(typeEPD IN ('E', 'P', 'D')),
    prix_carte float CHECK(prix_carte >0 AND prix_carte<100),
    CONSTRAINT pk_carte PRIMARY KEY (num_carte)
);

CREATE TABLE FOURNISSEURS (
    num_fournisseur number(2),
    nom_fournisseur varchar(28),
    ville varchar(21),
    num_tel varchar(14) UNIQUE,
    CONSTRAINT pk_fournisseurs PRIMARY KEY (num_fournisseur)
);

CREATE TABLE BOISSONS (
    num_boisson number(2),
    nom_boisson varchar(25),
    type_boisson varchar(9) CHECK(type_boisson IN ('eau', 'soda', 'sirop', 'jus', 'biere', 'vin', 'champagne', 'a_fort', 'cafe')),
    unite varchar(9) CHECK(unite IN ('L', 'canette', 'bouteille', 'kg')),
    prix_boisson_vente float CHECK(prix_boisson_vente>0.0),
    num_fournisseur number(2),
    prix_boisson_achat float CHECK(prix_boisson_achat>0.0),
    CONSTRAINT pk_boissons PRIMARY KEY (num_boisson),
    CONSTRAINT fk_boissons_fournisseurs FOREIGN KEY (num_fournisseur) REFERENCES FOURNISSEURS (num_fournisseur),
    CONSTRAINT marge_boissons CHECK(prix_boisson_achat <= prix_boisson_vente)
);

CREATE TABLE SERVEURS (
    num_serveur number(2),
    nom_serveur varchar(10),
    prenom_serveur varchar(10),
    sexe_serveur varchar(1) CHECK(sexe_serveur IN ('F', 'H')),
    CONSTRAINT pk_serveurs PRIMARY KEY (num_serveur)
);

CREATE TABLE COMMANDES (
    num_commande number(10),
    nom_client varchar(20),
    date_commande date,
    service varchar(1) CHECK(service IN ('M', 'S')),
    num_serveur number,
    num_table number CHECK(num_table BETWEEN 1 AND 15),
    CONSTRAINT pk_commandes PRIMARY KEY (num_commande),
    CONSTRAINT fk_commandes_serveurs FOREIGN KEY (num_serveur) REFERENCES SERVEURS (num_serveur)
);

CREATE TABLE INGREDIENTS (
    num_igd number(2),
    nom_igd varchar(20),
    unite varchar(5),
    prix_igd float CHECK(prix_igd>0),
    stock number CHECK(stock>=0),
    num_fournisseur number(2),
    CONSTRAINT pk_igd PRIMARY KEY (num_igd),
    CONSTRAINT fk_igd_fournisseurs FOREIGN KEY (num_fournisseur) REFERENCES FOURNISSEURS (num_fournisseur)
);

CREATE TABLE A_BOIRE (
    num_commande number(10),
    num_boisson number(2),
    nb_unites float CHECK(nb_unites>0.0),
    CONSTRAINT pk_a_boire PRIMARY KEY (num_commande, num_boisson),
    CONSTRAINT fk_a_boire_commandes FOREIGN KEY (num_commande) REFERENCES COMMANDES (num_commande),
    CONSTRAINT fk_a_boire_boissons FOREIGN KEY (num_boisson) REFERENCES BOISSONS (num_boisson)
);

CREATE TABLE COMPOSITION (
    num_carte number(2),
    num_igd number(2),
    nb_unites float CHECK(nb_unites>0),
    CONSTRAINT pk_composition PRIMARY KEY (num_carte, num_igd),
    CONSTRAINT fk_composition_carte FOREIGN KEY (num_carte) REFERENCES CARTE (num_carte),
    CONSTRAINT fk_composition_igd FOREIGN KEY (num_igd) REFERENCES INGREDIENTS (num_igd)
);

CREATE TABLE EST_COMMANDE (
    num_commande number(10),
    num_carte number(2),
    nb_EPD number CHECK(nb_EPD>0),
    CONSTRAINT pk_est_commande PRIMARY KEY (num_commande, num_carte),
    CONSTRAINT fk_est_commande_commandes FOREIGN KEY (num_commande) REFERENCES COMMANDES (num_commande),
    CONSTRAINT fk_est_commande_carte FOREIGN KEY (num_carte) REFERENCES CARTE (num_carte)
);

-- Exemples des commandes d'insertion des valeurs avec INSERT INTO
-- Tous les tuples ont été insérés dans la base de données grâce à l'outil de chargement massif d'Oracle

INSERT INTO FOURNISSEURS values (1, 'Fruity&Co', 'Versailles', '01 23 45 67 89');
INSERT INTO FOURNISSEURS values (2, 'Natures Bounty Produce', 'Saint-Germain-en-Laye', '01 34 56 78 90');
INSERT INTO FOURNISSEURS values (3, 'FreshHarvest Market', 'Poissy', '01 29 84 76 53');
INSERT INTO FOURNISSEURS values (4, 'Poissonnerie MerEclat', 'Trouville-sur-Mer', '02 31 45 67 89');
INSERT INTO FOURNISSEURS values (5, 'Mer et saveurs', 'Saint-Germain-en-Laye', '01 49 63 85 27');
INSERT INTO FOURNISSEURS values (6, 'La Ferme Des Limousines', 'Vicq', '06 62 25 82 35');
INSERT INTO FOURNISSEURS values (7, 'Ferme des Trois Chenes', 'Montfort-l_Amaury', '07 27 49 63 85');
INSERT INTO FOURNISSEURS values (8, 'Moulin de la Vallee Blanche', 'Maule', '06 73 92 84 56');

INSERT INTO  INGREDIENTS  VALUES( 1, 'farine', 'kg', 0.75, 10, 8 );
INSERT INTO  INGREDIENTS  VALUES( 2, 'lait', 'L', 1.3, 15, 10 );
INSERT INTO  INGREDIENTS  VALUES( 3, 'beurre', 'kg', 3, 6, 10 );
INSERT INTO  INGREDIENTS  VALUES( 4, 'oeuf', 'oeufs', 0.15, 360, 9 );
INSERT INTO  INGREDIENTS  VALUES( 5, 'sucre', 'kg', 3, 3.5, 8 );
INSERT INTO  INGREDIENTS  VALUES( 6, 'creme', 'L', 4.2, 4.8, 10 );
INSERT INTO  INGREDIENTS  VALUES( 7, 'pain', 'kg', 3.9, 20, 8 );
INSERT INTO  INGREDIENTS  VALUES( 8, 'levure', 'kg', 12, 0.5, 8 );

INSERT INTO  SERVEURS  VALUES( 0,'Foquet', 'Ambre', 'F' );
INSERT INTO  SERVEURS  VALUES( 1, 'Trottier', 'Nicolas', 'H' );
INSERT INTO  SERVEURS  VALUES( 2, 'Sertin', 'Jerome', 'H' );
INSERT INTO  SERVEURS  VALUES( 3, 'Ricord', 'Stephane', 'H' );
INSERT INTO  SERVEURS  VALUES( 4, 'Lagneux', 'Natalie', 'F' );
INSERT INTO  SERVEURS  VALUES( 5, 'Clissard', 'Thibaut', 'H' );
INSERT INTO  SERVEURS  VALUES( 6, 'Vadili', 'Samantha', 'F' );
INSERT INTO  SERVEURS  VALUES( 7, 'Lecuyer', 'Fabien', 'H' );

INSERT INTO  CARTE  VALUES( 1, 'soupe a l oignon', 'E', 11 );
INSERT INTO  CARTE  VALUES( 2, 'pate en croute', 'E', 9 );
INSERT INTO  CARTE  VALUES( 3, 'tomate-mozza', 'E', 9 );
INSERT INTO  CARTE  VALUES( 4, 'planche de charcuterie', 'E', 15.5 );
INSERT INTO  CARTE  VALUES( 5, 'oeuf cocotte a la truffe', 'E', 12 );
INSERT INTO  CARTE  VALUES( 6, 'couteaux en persillade', 'E', 13 );
INSERT INTO  CARTE  VALUES( 7, 'salade cesar', 'E', 13.5 );
INSERT INTO  CARTE  VALUES( 8, 'verrine avocat-crevette', 'E', 12 );

INSERT INTO  COMPOSITION  VALUES( 1, 47, 0.25 );
INSERT INTO  COMPOSITION  VALUES( 1, 3, 0.05 );
INSERT INTO  COMPOSITION  VALUES( 1, 6, 0.04 );
INSERT INTO  COMPOSITION  VALUES( 1, 7, 0.02 );
INSERT INTO  COMPOSITION  VALUES( 1, 33, 0.04 );
INSERT INTO  COMPOSITION  VALUES( 2, 1, 0.015 );
INSERT INTO  COMPOSITION  VALUES( 2, 13, 0.01 );
INSERT INTO  COMPOSITION  VALUES( 2, 18, 0.01 );

INSERT INTO  BOISSONS  VALUES( 1, 'eau plate', 'eau', 'L' , 3, 17, 0.2 );
INSERT INTO  BOISSONS  VALUES( 2, 'eau gazeuse', 'eau', 'L', 3, 17, 0.3 );
INSERT INTO  BOISSONS  VALUES( 3, 'Coca Cola', 'soda', 'canette', 3.50, 13, 0.4 );
INSERT INTO  BOISSONS  VALUES( 4, 'Coca Cola Zero', 'soda', 'canette', 3.50, 13, 0.4 );
INSERT INTO  BOISSONS  VALUES( 5, 'Fanta', 'soda', 'canette', 3.50, 13, 0.4 );
INSERT INTO  BOISSONS  VALUES( 6, 'Ice Tea', 'soda', 'canette', 3.50, 13, 0.4 );
INSERT INTO  BOISSONS  VALUES( 7, 'Oasis', 'soda', 'canette', 3.50, 13, 0.4 );
INSERT INTO  BOISSONS  VALUES( 8, 'sirop grenadine', 'sirop', 'L', 116, 13, 0.4 );

INSERT INTO  COMMANDES  VALUES( 1, 'Morvan', TO_DATE('Tue-05-01-2021', 'DY-DD-MM-YYYY'), 'M', 4, 8 );
INSERT INTO  COMMANDES  VALUES( 2, 'Trosset', TO_DATE('Tue-05-01-2021', 'DY-DD-MM-YYYY'), 'M', 4, 9 );
INSERT INTO  COMMANDES  VALUES( 3, NULL, TO_DATE('Tue-05-01-2021', 'DY-DD-MM-YYYY'), 'M', 4, 9 );
INSERT INTO  COMMANDES  VALUES( 4, NULL, TO_DATE('Tue-05-01-2021', 'DY-DD-MM-YYYY'), 'M', 1, 5 );
INSERT INTO  COMMANDES  VALUES( 5, NULL, TO_DATE('Tue-05-01-2021', 'DY-DD-MM-YYYY'), 'M', 4, 4 );
INSERT INTO  COMMANDES  VALUES( 6, NULL, TO_DATE('Tue-05-01-2021', 'DY-DD-MM-YYYY'), 'M', 4, 15 );
INSERT INTO  COMMANDES  VALUES( 7, 'Gallet', TO_DATE('Tue-05-01-2021', 'DY-DD-MM-YYYY'), 'M', 4, 4 );
INSERT INTO  COMMANDES  VALUES( 8, NULL, TO_DATE('Tue-05-01-2021', 'DY-DD-MM-YYYY'), 'M', 4, 12 );

INSERT INTO  EST_COMMANDE  VALUES( 1, 23, 1 );
INSERT INTO  EST_COMMANDE  VALUES( 2, 6, 1 );
INSERT INTO  EST_COMMANDE  VALUES( 2, 27, 1 );
INSERT INTO  EST_COMMANDE  VALUES( 3, 25, 1 );
INSERT INTO  EST_COMMANDE  VALUES( 3, 32, 1 );
INSERT INTO  EST_COMMANDE  VALUES( 4, 22, 1 );
INSERT INTO  EST_COMMANDE  VALUES( 4, 38, 1 );
INSERT INTO  EST_COMMANDE  VALUES( 5, 20, 1 );

INSERT INTO  A_BOIRE  VALUES( 1, 2, 1 );
INSERT INTO  A_BOIRE  VALUES( 1, 14, 1 );
INSERT INTO  A_BOIRE  VALUES( 1, 24, 1 );
INSERT INTO  A_BOIRE  VALUES( 1, 12, 1 );
INSERT INTO  A_BOIRE  VALUES( 1, 34, 1 );
INSERT INTO  A_BOIRE  VALUES( 2, 2, 1 );
INSERT INTO  A_BOIRE  VALUES( 2, 6, 1 );
INSERT INTO  A_BOIRE  VALUES( 2, 27, 1 );

-- TRIGGERS

-- Le prix d'un EPD doit être supérieur à la somme des prix des ingrédients qui le compose

CREATE OR REPLACE trigger prix_EPD_1
    BEFORE INSERT OR UPDATE ON Carte
    FOR EACH ROW
DECLARE
    cout number(7,4) := 0;
BEGIN
    SELECT sum(I.prix_igd*Co.nb_unites) INTO cout
    FROM Ingredients I, Composition Co
    WHERE :new.num_carte = Co.num_carte
    AND Co.num_igd = I.num_igd;
    IF :new.prix_carte <= cout THEN
        raise application_error(-20003, 'Le prix de vente cet EPD est trop faible comparé à son coût de production.');
    END IF;
END;
/

CREATE OR REPLACE trigger prix_EPD_2
    BEFORE INSERT OR UPDATE ON Composition
    FOR EACH ROW
DECLARE
    cout number(7,4) := 0;
BEGIN
    SELECT sum(I.prix_igd*:new.nb_unites) INTO cout
    FROM Ingredients I, Carte C
    WHERE :new.num_carte = C.num_carte;
    IF cout >= C.prix_carte THEN
        raise application_error(-20004, 'Le prix de vente d un EPD est trop faible comparé à son coût de production.');
    END IF;
END;
/

-- Pour chaque commande, le stock des ingrédients nécessaires aux EPD commandés diminue.
            -- Si le stock n’est pas suffisant à la préparation, alors le client doit en choisir un autre.

CREATE OR REPLACE trigger maj_stocks
    BEFORE INSERT OR UPDATE OR DELETE ON Est_commande
DECLARE
    CURSOR c1 IS (SELECT I.num_igd as constituant, C.nb_EPD as quantite
                    FROM Ingredients I, Est_Commande EC, Composition C
                    WHERE EC.num_carte = C.num_carte
                    AND C.num_igd = I.num_igd
                    AND EC.num_carte = :new.num_carte);
    nv_stock number := 0;
    nv_qte number := 0;
BEGIN
    FOR igd IN c1 LOOP
        IF inserting THEN
            nv_stock := (SELECT stock
                        FROM Ingredients
                        WHERE num_igd = igd.constituant) - (:new.nb_unites * igd.quantite);
            UPDATE Ingredients SET stock = nv_stock
            WHERE num_igd = igd.constituant;
        END IF;
        IF updating or deleting THEN
            IF deleting OR (:new.nb_EPD < :old.nb_EPD) THEN      -- commande annulée : on rajoute les ingrédients dans les stocks
                IF deleting THEN
                    nv_qte := :old.nb_EPD;
                ELSE
                    nv_qte := :old.nb_EPD - :new.nb_EPD;
                END IF;
                nv_stock := (SELECT stock
                        FROM Ingredients
                        WHERE num_igd = igd.constituant) + (nv_qte * igd.quantite);
                UPDATE Ingredients SET stock = nv_stock
                WHERE num_igd = igd.constituant;
                EXIT;
            END IF;
            IF :new.nb_EPD > :old.nb_EPD THEN                   -- ajout d'une commande pour cet EPD
                nv_qte := :new.nb_EPD - :old.nb_EPD;
            ELSE                                                -- nb_EPD n'a pas changé 
                nv_qte := :new.nb_EPD;
            END IF;
            nv_stock := (SELECT stock
                        FROM Ingredients
                        WHERE num_igd = igd.constituant) - (nv_qte * igd.quantite);
            UPDATE Ingredients SET stock = nv_stock
            WHERE num_igd = igd.constituant;
        END IF;        
    END;
/

-- Un client ne peut venir manger dans le restaurant que si le nombre maximum de couverts n’a pas été dépassé (200 couverts par service)

CREATE OR REPLACE TRIGGER max_couverts
    BEFORE INSERT ON Commandes
    FOR EACH ROW
DECLARE
    nb_couverts number(3);
BEGIN
    SELECT COUNT(num_commande) INTO nb_couverts
    FROM Commandes
    WHERE date_commande = :new.date_commande AND service = :new.service;

    IF nb_couverts > 200 THEN
        raise_application_error(-20001, 'Le nombre maximum de couverts a ete atteint, aucune nouvelle commande ne peut etre passee.');
    END IF;
END;
/   

-- Chaque entrée, chaque plat et chaque dessert contient au moins un ingrédient

    -- Il y a une dépendance cyclique car dans la table Composition, num_carte est une clé étrangère de Carte(num_carte)
    -- donc il faudrait créer les tuples de la table Carte avant de leur associer des ingrédients dans la table Composition.
    -- Mais la contrainte empêcherait par exemple l'insertion de nouveaux EPD (dans Carte) si ceux-ci ne sont pas déjà dans
    -- la table Composition, ce qui est donc impossible.
    -- Pour cela, il faudrait créér les tables avec une des deux contraintes puis la désactiver (DISABLE CONSTRAINT)
    -- pour créér la deuxième et enfin réactiver la première (ENABLE CONSTRAINT).

ALTER TABLE Composition
    DISABLE CONSTRAINT fk_composition_carte;

ALTER TABLE Carte
    ADD CONSTRAINT composition_EPD
    CHECK (num_carte IN (SELECT num_carte FROM Composition));

ALTER TABLE Composition
    ENABLE CONSTRAINT fk_composition_carte;

-- Une commande est forcément associée à au moins une boisson ou un EPD commandé.

    -- Il s'agit aussi d'une dépendance cyclique.

ALTER TABLE Est_Commande
    DISABLE CONSTRAINT fk_est_commande_commandes;

ALTER TABLE A_Boire
    DISABLE CONSTRAINT fk_a_boire_commandes;

ALTER TABLE Commandes
    ADD CONSTRAINT commande_eat_or_drink
    CHECK (num_commande IN (SELECT num_commande FROM Est_Commande UNION
                            SELECT num_commande FROM A_Boire));

ALTER TABLE Est_Commande
    ENABLE CONSTRAINT fk_est_commande_commandes;

ALTER TABLE A_Boire
    ENABLE CONSTRAINT fk_a_boire_commandes;

-- Certaines boissons ne sont vendues que pour un volume donné.
-- Il faut donc vérifier que nb_unites soit un multiple de ce volume.

    -- Le vin est vendu soit au verre (14 cL) soit à la bouteille (75 cL). Le nombre d'unités (en L) doit donc être
    -- un flottant P tel que P = v * 0.17 + b * 0.75 avec v et b deux entiers <=> (P%0.75)%0.17 doit être égal à 0.

    -- La quantité de bière vendue est de 25cL ou 50cL.
    -- Les sirops sont vendus par dose de 25cL.

    -- L'eau (plate ou gazeuse) est vendue en petite bouteille (33cL) ou en grande bouteille (75cL).

    -- Dans un café, il y a 8g de grains de café pour un expresso, 16g pour un double-expresso.

    -- Le champagne n'est vendu que par bouteille, soit 75cL.

    -- Un alcool fort (de type a_fort) est vendu par dose de 4cL.

CREATE OR REPLACE TRIGGER unites_boissons
    BEFORE INSERT OR UPDATE ON A_Boire
    FOR EACH ROW
DECLARE
    t_boisson varchar(10);
BEGIN
    SELECT type_boisson INTO t_boisson
    FROM Boissons
    WHERE Boissons.num_boisson = :new.num_boisson;

    IF ((t_boisson = 'vin') AND (MOD(:new.nb_unites, 0.75) MOD 0.14 != 0))
        OR (((t_boisson = 'biere') OR (t_boisson = 'sirop')) AND (MOD(:new.nb_unites, 0.25) != 0))
        OR ((t_boisson = 'eau') AND (MOD(:new.nb_unites, 0.75) MOD 0.33 != 0))
        OR ((t_boisson = 'cafe') AND (MOD(:new.nb_unites, 8) != 0))
        OR ((t_boisson = 'champagne') AND (MOD(:new.nb_unites, 0.75) != 0))
        OR ((t_boisson = 'a_fort') AND (MOD(:new.nb_unites, 0.04) != 0)) THEN
        raise_application_error(-20002, 'Le nombre d unites n est pas correct');
    END IF;
END;
/

-- Exemple d'insertion d'une commande de vin pour tester le trigger 'unites_boissons' :
-- Cas 1 : insertion validée pour un nombre d'unités de 1.64 correspondant à 2 bouteilles de 75 cL et 1 verre de 14 cL de vin Chateauneuf du Pape Rouge
INSERT INTO a_boire VALUES (1, 20, 1.64);

-- Cas 2 : echec de l'insertion grâce au trigger pour un nombre d'unités de 0.88 de vin Chateauneuf du Pape Rouge
INSERT INTO a_boire VALUES (1, 20, 0.88);


-- Créer la procédure à exécuter pour augmenter les stocks d'un ingrédient,
-- lors de la réception des commandes passées aux fournisseurs par exemple.

CREATE OR REPLACE PROCEDURE augmenter_stock(num_ingredient IN NUMBER, nb_unites IN NUMBER)
IS
BEGIN
    UPDATE Ingredients SET stock = stock + nb_unites
    WHERE num_igd = num_ingredient;
END;
/


-- REQUETES

-- Combien de bouteilles de vin ont été vendues le samedi 14 octobre 2023 ?
-- Pour rappel, une bouteille de vin a une contenance de 75 cL et un verre de vin est de contenance 17 cL.

DECLARE
    CURSOR c1 IS SELECT * FROM A_boire;
    drink_type varchar(15) := '0';
    nb_tot_bouteilles number := 0;
BEGIN
    -- Calcul du nombre de bouteilles vendues
    FOR tuple IN c1 LOOP
        SELECT b.type_boisson INTO drink_type
        FROM Boissons B
        WHERE B.num_boisson = tuple.num_boisson;
        IF drink_type = 'vin' AND mod(tuple.nb_unites, 0.75) = 0 THEN
            nb_tot_bouteilles := nb_tot_bouteilles + (tuple.nb_unites/0.75);
        END IF;
    END LOOP;
    -- Affichage du nombre de bouteilles vendues
	IF nb_tot_bouteilles = 0 THEN        
    	DBMS_OUTPUT.PUT_LINE('Aucune bouteille de vin n a été vendue.');
	ELSIF nb_tot_bouteilles = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Il y a eu 1 bouteille de vin vendue.');
	ELSE
        DBMS_OUTPUT.PUT_LINE('Il y a eu '||nb_tot_bouteilles||' bouteilles de vin vendues.');
	END IF;
END;
/

-- Quels sont les noms des clients qui ont réservé une table le vendredi 21 avril 2023 ?

SELECT nom_client
FROM Commandes
WHERE date_commande = TO_DATE('Fri-21-04-2023', 'DY-DD-MM-YYYY')
AND nom_client IS NOT NULL;

-- Quels sont les desserts dont le prix est inférieur ou égal à 8 euros ?

SELECT nom_carte
FROM CARTE
WHERE typeEPD = 'D'
AND prix_carte <= 8;

-- Quels sont les serveurs qui n'ont pas travaillé le 7 novembre 2023 ?

SELECT num_serveur
FROM Serveurs
WHERE num_serveur NOT IN (SELECT S.num_serveur
                            FROM Serveurs S, Commandes C
                            WHERE S.num_serveur = C.num_serveur)
							AND C.date_commande = TO_DATE('Tue-07-11-2023', 'DY-DD-MM-YYYY');

-- Quels sont les serveurs qui ont servis tous les plats (tous les EPD) ?
-- <=> les serveurs tel que, quelque soit l'EPD, ils l'ont déjà servi
-- <=> les serveurs tel que, quelque soit l'EPD de la carte, il existe une commande de cet EPD servie par ce serveur
-- <=> les serveurs tel qu'il n'existe pas d'EPD tel qu'il n'existe pas de commande de cet EPD servie par ce serveur

SELECT S.num_serveur, S.nom_serveur, S.prenom_serveur
FROM Serveurs S
WHERE NOT EXISTS (SELECT * FROM Carte C
                WHERE NOT EXISTS (SELECT * FROM Est_Commande EC, Commandes Co
                                WHERE C.num_carte = EC.num_carte
                                AND Co.num_commande = EC.num_commande
                                AND S.num_serveur = Co.num_serveur));

-- Quels sont boissons qui ont été commandés par tous les clients le mardi 19 décembre 2023 pendant le service du midi ?
-- <=> les boissons tel que, quelque soit le client (associé à une commande) du mardi 19 décembre 2023 midi, il l'a commandé
-- <=> les boissons tel que, quelque soit le client du mardi 19 décembre 2023 midi, il existe une commande de cette boisson par ce client
-- <=> les boissons tel qu'il n'existe pas de client du mardi 19 décembre 2023 midi tel qu'il n'existe pas de commande de cette boissons par ce client 

SELECT B.num_boisson, B.type_boisson
FROM Boissons B
WHERE NOT EXISTS (SELECT * FROM Commandes C
                    WHERE C.date_commande = TO_DATE('Tue-19-12-2023', 'DY-DD-MM-YYYY')
                    AND C.service = 'M'
                    AND NOT EXISTS (SELECT * FROM A_Boire AB
                                    WHERE AB.num_commande = C.num_commande
                                    AND AB.num_boisson = B.num_boisson));

-- Quels sont les EPD qui contiennent des œufs, du gluten, du lactose, des fruits à coque, du poisson, des fruits de mer ou de céleri ?

SELECT nom_carte as plat, nom_igd as ingredient
FROM Carte C, Ingredients I, Composition Co
WHERE Co.num_carte = C.num_carte
AND Co.num_igd = I.num_igd
AND I.nom_igd IN ('oeuf', 'celeri')
UNION
SELECT distinct(nom_carte) as plat, 'gluten' as ingredient
FROM Carte C, Ingredients I, Composition Co
WHERE Co.num_carte = C.num_carte
AND Co.num_igd = I.num_igd
AND I.nom_igd IN ('farine', 'levure', 'pain', 'pate lasagne', 'biscuit cuillere', 'speculoos', 'glace chocolat',
                                                                                                'poudre cacao')
UNION
SELECT distinct(nom_carte) as plat, 'lactose' as ingredient
FROM Carte C, Ingredients I, Composition Co
WHERE Co.num_carte = C.num_carte
AND Co.num_igd = I.num_igd
AND I.nom_igd IN ('lait', 'beurre', 'creme', 'chevre', 'mozzarella', 'emmental', 'mascarpone', 'parmesan',
                                                                                                    'feta')
UNION
SELECT distinct(nom_carte) as plat, 'fruits à coque' as ingredient
FROM Carte C, Ingredients I, Composition Co
WHERE Co.num_carte = C.num_carte
AND Co.num_igd = I.num_igd
AND I.nom_igd IN ('noix', 'speculoos', 'biscuit cuillere', 'glace chocolat')
UNION
SELECT distinct(nom_carte) as plat, 'poisson/fruit de mer' as ingredient
FROM Carte C, Ingredients I, Composition Co
WHERE Co.num_carte = C.num_carte
AND Co.num_igd = I.num_igd
AND I.nom_igd IN ('raie', 'saumon fume', 'sole', 'st pierre', 'thon rouge', 'poulpe', 'couteau', 'crevette',
                                                                                'st jacques', 'langoustine');

-- Retourner les ingrédients dont le stock est inférieur à 2 kg ou 2 L, ainsi que leur fournisseur.

SELECT I.num_igd, I.nom_igd, F.nom_fournisseur, F.num_tel
FROM Ingredients I, Fournisseurs F
WHERE I.num_fournisseur = F.num_fournisseur
AND (I.stock < 2
AND ((I.unite = 'kg') OR (I.unite = 'L')));

-- Quel est le cout de production de chaque EPD ?

SELECT C.num_carte, C.nom_carte, SUM(I.prix_igd * Co.nb_unites) AS cout_production
FROM Carte C, Composition Co, Ingredients I
WHERE C.num_carte = Co.num_carte
AND Co.num_igd = I.num_igd
GROUP BY C.num_carte, C.nom_carte;

-- Quelle est la moyenne de la marge, la marge minimale et la marge maximale des entrées ? des plats ? des desserts ?

SELECT C.typeEPD, ROUND(AVG(VMC.marge), 3) as moyenne_marge, MIN(VMC.marge) as min_marge, MAX(VMC.marge) as max_marge
FROM vue_marge_carte VMC, Carte C
WHERE VMC.num_carte = C.num_carte
GROUP BY C.typeEPD;

-- Pour chaque serveur, combien de clients ont-ils servis le samedi 18 novembre 2023 pendant le service du soir ?

SELECT S.num_serveur, COUNT(C.num_commande) AS nb_commandes_servies
FROM Serveurs S
LEFT JOIN Commandes C ON S.num_serveur = C.num_serveur
    AND C.service = 'S'
    AND C.date_commande = TO_DATE('Sat-18-11-2023', 'DY-DD-MM-YYYY')
GROUP BY S.num_serveur
ORDER BY S.num_serveur;



-- VUES

-- Créer la vue vue_marge_carte contenant la marge de chaque EPD.

CREATE OR REPLACE VIEW vue_marge_carte AS
SELECT C.num_carte, C.nom_carte, (C.prix_carte - SUM(I.prix_igd * Co.nb_unites)) AS marge
FROM Carte C, Composition Co, Ingredients I
WHERE C.num_carte = Co.num_carte
AND Co.num_igd = I.num_igd
GROUP BY C.num_carte, C.nom_carte, C.prix_carte
ORDER BY C.num_carte;

-- Créer la vue vue_marge_boissons contenant la marge de chaque boisson.

CREATE OR REPLACE VIEW vue_marge_boissons AS
SELECT B.num_boisson, B.nom_boisson, (B.prix_boisson_vente - B.prix_boisson_achat) AS marge
FROM Boissons B
ORDER BY B.num_boisson;


-- Créer la vue vue_nb_clients_serveurs, stockant le nombre de clients servis par serveurs la veille

CREATE OR REPLACE VIEW vue_nb_clients_servis AS
SELECT S.num_serveur, COUNT(C.num_commande) AS nb_commandes_servies
FROM Serveurs S
LEFT JOIN Commandes C ON S.num_serveur = C.num_serveur
    AND C.date_commande = TO_DATE('Sat-18-11-2023', 'DY-DD-MM-YYYY')
GROUP BY S.num_serveur
ORDER BY S.num_serveur;

-- Créer la vue vue_achat_fournisseurs pour y stocker les ingrédients à racheter 
-- Les ingrédients à racheter sont ceux qui respectent les conditions suivantes :
        -- s'il s'agit de levure, de câpres, de morilles, de truffes, de café soluble ou de poudre de cacao,
            -- la quantité doit être supérieure ou égale à 2 kg.
        -- s'il s'agit de feta, de parmesan, de mozzarella, de mascarpone, de chèvre, d'ail ou de noix, 
            -- la quantité doit être supérieure ou égale à 3 kg.
        -- s'il s'agit de farine, de beurre, de lait ou de crème, il en faut au minimum 4 kg ou 4 L.
        -- s'il s'agit de pain, de poulet, de filet mignon ou de boeuf, il en faut au minimum 7.5 kg.
        -- s'il s'agit de pommes de terre, il en faut au minimum 18 kg.
        -- s'il s'agit des oeufs, il en faut au minimum 90.
        -- pour les autres ingrédients, la quantité doit être supérieure ou égale à 5 kg.

        -- on ne peut pas commander plus de 2 kg de fruits et légumes qui ne sont pas de saison :
        -- fraises, framboises, myrtilles, cerises, abricots, figues, tomates, courgettes, aubergines, asperges

CREATE OR REPLACE VIEW vue_a_acheter AS
SELECT
    I.num_igd, I.nom_igd,
    CASE
        WHEN I.nom_igd IN ('levure', 'capres', 'morille', 'truffe noire', 'cafe soluble', 'poudre cacao')
            AND I.stock < 2
                THEN 2 - I.stock
        WHEN I.nom_igd IN ('feta', 'parmesan', 'mozzarella', 'mascarpone', 'chevre', 'ail', 'noix')
            AND I.stock < 3
                THEN 3 - I.stock
        WHEN I.nom_igd IN ('farine', 'beurre', 'lait', 'creme')
            AND I.stock < 4
                THEN 4 - I.stock
        WHEN I.nom_igd IN ('pain', 'poulet', 'filet mignon', 'boeuf')
            AND I.stock < 7.5
                THEN 7.5 - I.stock
        WHEN I.nom_igd = 'pdt' AND I.stock < 18
                THEN 18 - I.stock
        WHEN I.nom_igd = 'oeuf' AND I.stock < 90
                THEN 90 - I.stock
        ELSE
            CASE WHEN stock < 5 THEN 5 - stock ELSE 0 END
    END AS qte_a_acheter,
    F.nom_fournisseur, F.num_tel, F.ville
FROM Ingredients I, Fournisseurs F
WHERE I.num_fournisseur = F.num_fournisseur
ORDER BY F.nom_fournisseur;


CREATE OR REPLACE VIEW vue_achats_fournisseurs AS
SELECT *
FROM vue_a_acheter
WHERE qte_a_acheter != 0;

-- Créer la vue vue_compo_pour_serveurs contenant les ingrédients composant chaque EPD

CREATE OR REPLACE VIEW vue_compo_pour_serveurs AS
SELECT I.nom_igd, C.nom_carte, C.typeEPD
FROM Ingredients I, Carte C, Composition Co
WHERE I.num_igd = Co.num_igd
AND Co.num_carte = C.num_carte
ORDER BY C.num_carte;

-- Créer la vue vue_nb_commande_EPD stockant pour chaque EPD, son nombre de commandes

CREATE OR REPLACE VIEW vue_nb_commande_EPD AS
SELECT C.num_carte, C.nom_carte, COUNT(EC.num_carte) as nb_commande
FROM Carte C LEFT JOIN Est_Commande EC
			ON EC.num_carte = C.num_carte
GROUP BY C.num_carte, C.nom_carte;

-- UTILISATEURS

CREATE USER Gerant IDENTIFIED BY "0000";
GRANT ALL PRIVILEGES ON * TO Gerant;

CREATE USER Responsable_serveur IDENTIFIED BY "1234";
GRANT ALL PRIVILEGES ON Serveurs TO Responsable_serveur;
GRANT ALL PRIVILEGES ON Commandes TO Responsable_serveur;
GRANT ALL PRIVILEGES ON A_Boire TO Responsable_serveur;
GRANT ALL PRIVILEGES ON Est_Commande TO Responsable_serveur;
GRANT ALL PRIVILEGES ON Boissons TO Responsable_serveur;
GRANT SELECT ON Fournisseurs TO Responsable_serveur;
GRANT SELECT ON Ingredients TO Responsable_serveur;
GRANT SELECT ON Carte TO Responsable_serveur;
GRANT SELECT ON vue_recette_semaine TO Responsable_serveur;
GRANT SELECT ON vue_marge_carte TO Responsable_serveur;
GRANT SELECT ON vue_marge_boissons TO Responsable_serveur;
GRANT SELECT ON vue_nb_clients_servis TO Responsable_serveur;

CREATE USER Serveur IDENTIFIED BY "9876";
GRANT ALL PRIVILEGES ON Commandes TO Serveur;
GRANT ALL PRIVILEGES ON A_Boire TO Serveur;
GRANT ALL PRIVILEGES ON Est_Commande TO Serveur;
GRANT SELECT ON Carte TO Serveur;
GRANT SELECT ON Boissons TO Serveur;
GRANT SELECT ON vue_compo_pour_serveurs TO Serveur;
GRANT SELECT ON vue_nb_clients_servis TO Serveur;
GRANT SELECT ON vue_marge_carte TO Serveur;
GRANT SELECT ON vue_marge_boissons TO Serveur;

CREATE USER Cuisinier IDENTIFIED BY "7643";
GRANT ALL PRIVILEGES ON Carte TO Cuisinier;
GRANT ALL PRIVILEGES ON Composition TO Cuisinier;
GRANT SELECT ON Fournisseurs TO Cuisinier;
GRANT SELECT ON Boissons TO Cuisinier;
GRANT SELECT ON vue_nb_commande_EPD TO Cuisinier;
GRANT SELECT ON vue_marge_carte TO Cuisinier;
GRANT SELECT ON vue_marge_boissons TO Cuisinier;

-- Méta-données

SELECT table_name, constraint_name, constraint_type, search_condition
FROM user_constraints
ORDER BY table_name, constraint_type;


SELECT table_name, trigger_name, trigger_type, triggering_event
FROM user_triggers
ORDER BY table_name;


SELECT DISTINCT DTP.table_name, DTP.grantee AS utilisateur_acces_lecture
FROM dba_tab_privs DTP
WHERE DTP.privilege = 'SELECT'
ORDER BY DTP.table_name, tp.grantee;


SELECT utc.table_name AS view_name, utc.column_name, utc.data_type
FROM user_tab_columns utc
JOIN user_views uv ON utc.table_name = uv.view_name
ORDER BY utc.table_name, utc.column_id;

CREATE OR REPLACE TRIGGER maj_stocks
AFTER INSERT OR UPDATE OR DELETE ON Est_Commande
FOR EACH ROW
DECLARE
    quantite_composee number := 0;
BEGIN
    IF inserting THEN
        SELECT nb_EPD * nb_unites INTO quantite_composee
        FROM Composition
        WHERE num_carte = :NEW.num_carte;
        UPDATE Ingredients SET stock = stock - v_quantite_composee
        WHERE num_igd IN (SELECT num_igd
                            FROM Composition
                            WHERE num_carte = :NEW.num_carte);
    ELSIF deleting THEN
        SELECT nb_EPD * nb_unites INTO v_quantite_composee
        FROM Composition
        WHERE num_carte = :OLD.num_carte;
        UPDATE Ingredients SET stock = stock + v_quantite_composee
        WHERE num_igd IN (SELECT num_igd
                            FROM Composition
                            WHERE num_carte = :OLD.num_carte);
    ELSIF updating THEN
        IF :NEW.nb_EPD > :OLD.nb_EPD THEN
            SELECT nb_EPD * nb_unites INTO v_quantite_composee
            FROM Composition
            WHERE num_carte = :NEW.num_carte;
            UPDATE Ingredients SET stock = stock - (v_quantite_composee * (:NEW.nb_EPD - :OLD.nb_EPD))
            WHERE num_igd IN (SELECT num_igd
                                FROM Composition
                                WHERE num_carte = :NEW.num_carte);
        ELSE
            SELECT nb_EPD * nb_unites INTO v_quantite_composee
            FROM Composition
            WHERE num_carte = :NEW.num_carte;
            UPDATE Ingredients SET stock = stock + (v_quantite_composee * (:OLD.nb_EPD - :NEW.nb_EPD))
            WHERE num_igd IN (SELECT num_igd
                                FROM Composition
                                WHERE num_carte = :NEW.num_carte);
        END IF;
    END IF;
END;
/
