INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_bennys', 'Benny\'s', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_bennys', 'Benny\'s', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_bennys', 'Benny\'s', 1)
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('bennys', 0, 'recrue', 'Recrue', 20, '', ''),
('bennys', 1, 'novice', 'Novice', 30, '', ''),
('bennys', 2, 'experimenter', 'Expérimenter', 40, '', ''),
('bennys', 3, 'medecin_chef', "Chef d'Atelier", 60, '', ''),
('bennys', 4, 'boss', 'Directeur', 80, '', '');

INSERT INTO `jobs` (name, label) VALUES
	('bennys','Benny\'s')
;

INSERT INTO `items` (name, label) VALUES
	('kitreparation','Kit de Réparation'),
	('kitnettoyage','Kit de Nettoyage')
;