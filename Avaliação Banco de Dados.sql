CREATE DATABASE EscolaDB

USE EscolaDB

CREATE TABLE Alunos(
	Num_Aluno INT PRIMARY KEY,
	Nome_Aluno VARCHAR(100),
	SobreNome_Aluno VARCHAR(100),
	id_Grade_Horaria INT
	FOREIGN KEY (id_Grade_Horaria) REFERENCES Grade_Horaria(id_Grade_Horaria)
)

CREATE TABLE Grade_Horaria(
	id_Grade_Horaria INT PRIMARY KEY,
	Primeira_Aula VARCHAR(100),
	Segunda_Aula VARCHAR(100),
	Terceira_Aula VARCHAR(100)
)

CREATE TABLE Salas(
	id_Sala INT PRIMARY KEY,
	Materia VARCHAR(100)
)

CREATE TABLE Professores(
	id_Professor INT PRIMARY KEY,
	Nome_Professor VARCHAR(100),
	SobreNome_Professor VARCHAR(100),
	id_Sala INT
	FOREIGN KEY (id_Sala) REFERENCES Salas(id_Sala)
)

CREATE TABLE Provas(
	id_Prova INT PRIMARY KEY,
	Materia VARCHAR(100),
	Num_Aluno INT,
	Nota INT,
	Status VARCHAR(100)
	FOREIGN KEY (Num_Aluno) REFERENCES Alunos(Num_Aluno)
)



INSERT INTO Salas(id_Sala, Materia)
VALUES
	(1, 'Matem�tica'),
	(2, 'Portugu�s'),
	(3, 'Geografia'),
	(4, 'Hist�ria'),
	(5, 'Biologia'),
	(6, 'Qu�mica'),
	(7, 'F�sica')

INSERT INTO Professores(id_Professor, Nome_Professor, SobreNome_Professor, id_Sala)
VALUES
	(1, 'Gabriel', 'Carvalho', 2),
	(2, 'Antonio', 'Pereira', 7),
	(3, 'Daniel', 'Moraes', 4),
	(4, 'Victor', 'Vieira', 6),
	(5, 'Emerson', 'Pereira', 5),
	(6, 'Jo�o', 'Carvalho', 1),
	(7, 'Danilo', 'Moraes', 3)

ALTER TABLE Professores
ADD Sal�rio INT

UPDATE Professores
SET Sal�rio = 2200
WHERE id_Professor = 3

SELECT *
FROM Professores

INSERT INTO Grade_Horaria(id_Grade_Horaria, Primeira_Aula, Segunda_Aula, Terceira_Aula)
VALUES
	(1, 'Matem�tica', 'Qu�mica', 'F�sica'),
	(2, 'Portugu�s', 'Hist�ria', 'Geografia'),
	(3, 'Biologia', 'Portugu�s', 'Qu�mica')

INSERT INTO Alunos(Num_Aluno, Nome_Aluno, SobreNome_Aluno, id_Grade_Horaria)
VALUES
	(1, 'Guilherme', 'Fusuma', 1),
	(2, 'Matheus', 'Leite', 1),
	(3, 'Marcio', 'Felipe', 1),
	(4, 'Victor', 'Antonio', 2),
	(5, 'Carlos', 'Eduardo', 2),
	(6, 'Pedro', 'Odake', 2),
	(7, 'Alexis', 'Daniel', 3),
	(8, 'Edgar', 'Gomes', 3),
	(9, 'Leandro', 'Yuuki', 3)

INSERT INTO Provas(id_Prova, Materia, Num_Aluno, Nota)
VALUES
	(1, 'Matem�tica', 1, 10),
	(2, 'Matem�tica', 2, 2),
	(3, 'Matem�tica', 3, 5),
	(4, 'Matem�tica', 4, 7),
	(5, 'Matem�tica', 5, 8),
	(6, 'Matem�tica', 6, 2),
	(7, 'Matem�tica', 7, 8),
	(8, 'Matem�tica', 8, 6),
	(9, 'Matem�tica', 9, 2),
	(10, 'Portugu�s', 1, 10),
	(11, 'Portugu�s', 9, 2),
	(12, 'Portugu�s', 2, 2),
	(13, 'Portugu�s', 3, 5),
	(14, 'Portugu�s', 4, 7),
	(15, 'Portugu�s', 5, 8),
	(16, 'Portugu�s', 6, 2),
	(17, 'Portugu�s', 7, 8),
	(18, 'Portugu�s', 8, 6)

--Views
--Seleciona as mat�rias da primeira aula
CREATE OR ALTER VIEW VW_Primeira_aula
AS
SELECT
	id_Grade_Horaria,
	id_Sala,
	Materia
FROM Grade_Horaria G
INNER JOIN Salas S ON S.Materia = G.Primeira_Aula

--Seleciona as mat�rias da segunda aula
CREATE OR ALTER VIEW VW_Segunda_aula
AS
SELECT
	id_Grade_Horaria,
	id_Sala,
	Materia
FROM Grade_Horaria G
INNER JOIN Salas S ON S.Materia = G.Segunda_Aula

--Seleciona as mat�rias da terceira aula
CREATE OR ALTER VIEW VW_Terceira_aula
AS
SELECT
	id_Grade_Horaria,
	id_Sala,
	Materia
FROM Grade_Horaria G
INNER JOIN Salas S ON S.Materia = G.Terceira_Aula

SELECT *
FROM VW_Primeira_aula

SELECT *
FROM VW_segunda_aula

SELECT *
FROM VW_Terceira_aula


--Subqueries
SELECT 
	Nome_Professor,
	SobreNome_Professor
FROM Professores
WHERE id_Sala IN (
	SELECT
		id_Sala
	FROM VW_Primeira_aula
)

--CTEs
WITH Reprova��es_Aluno (id_Aluno, Qtd_Provas) AS
	(SELECT
		Num_Aluno,
		COUNT(Status)
	FROM Provas
	WHERE Status = 'Reprovado'
	GROUP BY Num_Aluno
	)
SELECT * FROM Reprova��es_Aluno

--Window Functions
SELECT
	id_Professor,
	Nome_Professor,
	Sal�rio,
	RANK() OVER (ORDER BY Sal�rio DESC) AS Rank
FROM Professores
--Agrupa os alunos caso eles possuam notas acima da m�dia ou notas abaixo da m�dia
SELECT 
	Num_Aluno,
	AVG(Nota) m�dia_da_nota,
	NTILE(2) OVER(ORDER BY AVG(Nota) DESC) AS Grupo
FROM Provas
GROUP BY Num_Aluno

--Procedure e Loop

--Procedure que ir� avaliar se a nota est� abaixo da m�dia ou n�o
CREATE OR ALTER PROCEDURE Avaliar_Notas
AS
DECLARE @Prova_Atual INT = 1
DECLARE @Max_Provas INT
SET @Max_Provas = (SELECT COUNT(*) FROM Provas)
--Roda para cada prova
WHILE @Prova_Atual <= @Max_Provas
BEGIN
	DECLARE @Nota INT
	SET @NOTA = (SELECT Nota FROM Provas WHERE id_Prova = @Prova_Atual)
	--Se a nota for menor que a m�dia
	IF @NOTA < 6
	BEGIN
		--Muda o status para Reprovado
		UPDATE Provas
		SET Status = 'Reprovado'
		WHERE id_Prova = @Prova_Atual
	END
	--Se a nota for maior que a m�dia
	IF @NOTA >= 6
	BEGIN
		UPDATE Provas
		--Muda o status para Aprovado
		SET Status = 'Aprovado'
		WHERE id_Prova = @Prova_Atual
	END
	--Adiciona o incremento na variavel
	SET @Prova_Atual = @Prova_Atual + 1
END;

EXEC Avaliar_Notas

SELECT *
FROM Provas

--Functions
--Consegue a quantidade de provas que o aluno foi Reprovado
CREATE OR ALTER FUNCTION Provas_Reprovado(@id_Aluno INT)
RETURNS INT
AS
BEGIN
	DECLARE @Qtd INT
	SET @Qtd = (SELECT
	COUNT(*)
	FROM Provas
	WHERE Num_Aluno = @id_Aluno AND Status = 'Reprovado'
	)
	RETURN @Qtd
END
GO

SELECT dbo.Provas_Reprovado(6) AS Provas_Abaixo_da_M�dia


--Triggers

ALTER TABLE Alunos
ADD Notas_Abaixo_da_Media INT

--Atualiza a tabela alunos
CREATE OR ALTER TRIGGER Atualizar_Aluno
ON Provas
AFTER INSERT
AS
BEGIN
	--Atualiza as notas
	EXEC Avaliar_Notas

	DECLARE @aluno_Atual INT = 1
	DECLARE @Max_Alunos INT
	SET @Max_Alunos = (SELECT COUNT(*) FROM Alunos)

	--Roda para cada aluno
	WHILE @aluno_Atual <= @Max_Alunos
	BEGIN
		--Encontra a quantidade de provas em que o aluno foi reprovado
		DECLARE @Qtd INT = (SELECT COUNT(*) FROM Provas WHERE Num_Aluno = @aluno_Atual AND Status = 'Reprovado')
		UPDATE Alunos
		SET Notas_Abaixo_da_Media = @Qtd
		WHERE Num_Aluno = @aluno_Atual
		SET @aluno_Atual = @aluno_Atual + 1
	END
END
GO

SELECT *
FROM Alunos
SELECT *
FROM Provas
--checar se funciona
INSERT INTO Provas(id_Prova, Materia, Num_Aluno, Nota)
VALUES
	(20, 'F�sica', 8, 2)

