SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS 
tb_frequencia, tb_pagamentos, tb_mensalidades, 
tb_folha_pagamento, tb_notas, tb_turmas, 
tb_grade_curricular, tb_contratos_educacionais, 
tb_matricula, tb_professores, tb_funcionarios, 
tb_cargos, tb_salas, tb_disciplinas, 
tb_cursos, tb_alunos;

DROP VIEW IF EXISTS vw_cursos_carga_horaria, vw_contratos_valores;

SET FOREIGN_KEY_CHECKS = 1;

create database gestao_escolar;
use gestao_escolar;

-- ACADEMICO
CREATE TABLE tb_alunos (
  pk_aluno int PRIMARY KEY NOT NULL,
  nome_aluno VARCHAR(50) NOT NULL,
  sobrenome_aluno VARCHAR(70) NOT NULL,
  data_nasc date NOT NULL,
  email_inst VARCHAR(100) UNIQUE NOT NULL,
  cpf CHAR(11) UNIQUE,
  sexo enum("Feminino","Masculino") DEFAULT 'Feminino',
  cor enum("Amarela","Branca","Indigena","Negra","Parda") NOT NULL,
  logradouro VARCHAR(150) NOT NULL,
  numero VARCHAR(10) COMMENT 'Se houver',
  complemento VARCHAR(50) COMMENT 'Se houver',
  bairro VARCHAR(100) NOT NULL,
  cidade VARCHAR(100) NOT NULL COMMENT 'Transformar em UPPERCASE',
  estado CHAR(2) NOT NULL,
  data_ultimo_acesso date
);

INSERT IGNORE INTO tb_alunos(pk_aluno,nome_aluno,sobrenome_aluno,data_nasc,email_inst,cpf,sexo,cor,logradouro,numero,complemento,bairro,cidade,estado,data_ultimo_acesso) VALUES
(10,"Felipe","Santana","2006-02-20","felipe.santana@facul.edu.br","12345678901","Masculino","Negra","Rua José Quintino","44",null,"Jardim Bonfiglioli","São Paulo","SP","2026-03-27"),
(11,"Maria","Luiza","2003-10-03","maria.luiza@facul.edu.br","01234567890","Feminino","Branca","Avenida Mario Peixoto","1020","Bloco 2 Apt 22","Vila Leopoldina","São Paulo","SP","2026-03-10"),
(12,"Kerolin","Nicole","1999-05-10","kerolin.nicole@facul.edu.br","11223344556","Feminino","Parda","Avenida Irlanda","2444","Fundos","Vila Ré","São Paulo","SP","2025-11-30"),
(13,"João","Santos","2007-06-16","joao.santos@facul.edu.br","66554433221","Masculino","Negra","Rua Tapajós","21",null,"Vila Luzia","São Paulo","SP","2026-02-11"),
(14,"Matheus","Soares","2001-12-30","matheus.soares@facul.edu.br","01020304056","Masculino","Indigena","Avenida Mario Peixoto","602",null,"Vila Leopoldina","São Paulo","SP","2025-08-20"),
(15,"Sophia","Barreto","1995-10-23","sophia.barreto@facul.edu.br","10203040501","Feminino","Branca","Rua da Independência","S/N","Lote 03","Jardim Camargo Velho","São Paulo","SP","2026-01-12"),
(16,"Letícia","Silva","2002-04-04","leticia.silva@facul.edu.br","13245768906",default,"Negra","Alameda São Joaquim","50","2º Andar","Itaim Paulista","São Paulo","SP","2025-02-26");

SELECT "Alunos" AS Tabela, COUNT(*) AS Total FROM tb_alunos;

-- CORREÇÃO PÓS 1ª ENTREGA

ALTER TABLE tb_alunos 
CHANGE COLUMN endereco logradouro VARCHAR(150) NOT NULL;

UPDATE tb_alunos 
SET cidade = UPPER(cidade);


-- ACADEMICO
CREATE TABLE tb_cursos (
  pk_curso int PRIMARY KEY AUTO_INCREMENT,
  nome_curso VARCHAR(100) NOT NULL
);

INSERT IGNORE INTO tb_cursos(nome_curso) VALUES
("Análise e Desenvolvimento de Sistemas"),
("Administração"),
("Biomedicina"),
("Ciências da Computação"),
("Gestão de Tecnologia da Informação"),
("Logística"),
("Marketing"),
("Publicidade e Propaganda");

SELECT "Cursos" AS Tabela, COUNT(*) AS Total FROM tb_cursos;

-- CORREÇÃO PÓS 1ª ENTREGA

ALTER TABLE tb_cursos DROP COLUMN carga_horaria_total;

-- ACADEMICO
CREATE TABLE tb_disciplinas (
  pk_disciplinas int PRIMARY KEY AUTO_INCREMENT,
  nome_disc VARCHAR(100) NOT NULL,
  carga_horaria int
);

INSERT IGNORE INTO tb_disciplinas(nome_disc,carga_horaria) VALUES
("Engenharia de Software", 60),
("Modelagem de Negócios e Requisitos", 60),
("Banco de Dados", 60),
("Gestão da Produção", 40),
("Gestão de Vendas", 50),
("Introdução a Administração", 60),
("Hematologia Clínica", 40),
("Microbiologia Médica", 60),
("Imunologia", 70),
("Sistemas Operacionais", 60),
("Teoria da Computação", 40),
("Gestão de Projetos", 60),
("Governança de TI", 40),
("Logística Reversa", 50),
("Gestão de Estoques e Armazenagem", 40),
("Pesquisa de Mercado", 40),
("Marketing Digital", 60),
("Direção de Arte", 40),
("Planejamento de Mídia", 50);

SELECT "Disciplinas" AS Tabela, COUNT(*) AS Total FROM tb_disciplinas;

-- CORREÇÃO PÓS 1ª ENTREGA

CREATE VIEW vw_cursos_carga_horaria AS
SELECT c.pk_curso,c.nome_curso,
SUM(d.carga_horaria) AS 
carga_horaria_calculada
FROM tb_cursos c
JOIN tb_grade_curricular g ON c.pk_curso = g.fk_cursos
JOIN tb_disciplinas d ON g.fk_disciplinas = d.pk_disciplinas
GROUP BY c.pk_curso, c.nome_curso;

SELECT * FROM vw_cursos_carga_horaria ORDER BY carga_horaria_calculada DESC;

-- ACADEMICO
CREATE TABLE tb_salas (
  pk_salas int PRIMARY KEY NOT NULL,
  bloco_sala enum("A", "B", "C", "D"),
  tipo_sala enum("LAB", "SALA"),
  num_sala int
);

INSERT IGNORE INTO tb_salas(pk_salas,bloco_sala,tipo_sala,num_sala) VALUES
(20, "A", "LAB", 1),
(21, "A", "LAB", 2),
(22, "A", "LAB", 3),
(23, "A", "LAB", 4),

(24, "B", "SALA", 100),
(25, "B", "SALA", 102),
(26, "B", "SALA", 104),

(27, "C", "SALA", 101),
(28, "C", "SALA", 103),
(29, "C", "SALA", 105),

(30, "D", "LAB", 1),
(31, "D", "LAB", 2),
(32, "D", "LAB", 3);

SELECT "Salas" AS Tabela, COUNT(*) AS Total FROM tb_salas;

-- TABELA CRIADA PÓS CORREÇÃO DA 1ª ENTREGA
CREATE TABLE tb_cargos (
    pk_cargo INT PRIMARY KEY AUTO_INCREMENT,
    nome_cargo VARCHAR(50) NOT NULL UNIQUE
);    

INSERT IGNORE INTO tb_cargos (nome_cargo) VALUES 
('Professor'),
('Coordenadora de Curso'), 
('Analista de Suporte TI'), 
('Secretária Acadêmica'),
('Técnico de Laboratório'), 
('Bibliotecário');

SELECT "Cargos" AS Tabela, COUNT(*) AS Total FROM tb_cargos;

-- RH
CREATE TABLE tb_funcionarios (
  pk_funcionarios int PRIMARY KEY NOT NULL,
  fk_cargo int,
  nome_func VARCHAR(50) NOT NULL,
  sobrenome VARCHAR(70) NOT NULL,
  cpf_func CHAR(11) UNIQUE NOT NULL,
  data_admissao date NOT NULL,
  salario_bruto decimal(10,2) CHECK (salario_bruto > 0),
  status_func enum("Ativo", "Afastado", "Desligado")
);

INSERT IGNORE INTO tb_funcionarios(pk_funcionarios,nome_func,sobrenome,cpf_func,data_admissao,salario_bruto,status_func) VALUES
(1000,"Mario","Costa","11111111111","2013-09-25",7200.00,"Ativo"),
(2020, "Beatriz", "Souza", "66666666666", "2020-08-01", 6200.00, "Ativo"),
(2340, "Cláudia", "Antunes", "23423423422", "2021-02-15", 9200.00, "Ativo"),
(2702, "Fernando", "Costa", "34534534533", "2022-08-01", 4500.00, "Ativo"),
(1356, "Ana", "Carolina", "44444444444", "2016-05-22", 6800.00, "Ativo"),
(1108, "Reginaldo", "Rossi", "33333333333", "2014-02-10", 7500.00, "Ativo"),
(3350, "Patrícia", "Lopes", "45645645644", "2023-01-20",3800.00, "Ativo"),
(1555, "Sérgio", "Reis", "55555555555", "2018-03-15", 7100.00, "Ativo"),
(1633, "Jorge", "Oliveira", "56756756755", "2019-11-12", 3200.00, "Ativo"),
(2301, "Marcos", "Pontes", "77777777777", "2021-01-10", 7900.00, "Ativo"),
(1249, "Antônio", "Souza", "22222222222", "2015-11-20", 2900.00, "Desligado"),
(2809, "Helena", "Tanaka", "88888888888", "2022-11-20", 6500.00, "Ativo");

SELECT "Funcionários", COUNT(*) FROM tb_funcionarios;

-- CORREÇÃO PÓS 1ª ENTREGA

ALTER TABLE tb_funcionarios ADD COLUMN fk_cargo int;

UPDATE tb_funcionarios f
JOIN tb_cargos c ON f.cargo = c.nome_cargo
SET f.fk_cargo = c.pk_cargo;

ALTER TABLE tb_funcionarios DROP COLUMN cargo;

ALTER TABLE tb_funcionarios 
MODIFY COLUMN fk_cargo INT NOT NULL;

ALTER TABLE tb_funcionarios 
ADD CONSTRAINT fk_func_cargo 
FOREIGN KEY (fk_cargo) REFERENCES tb_cargos(pk_cargo) 
ON DELETE RESTRICT;



-- ACADEMICO e RH
CREATE TABLE tb_professores (
  pk_prof int PRIMARY KEY NOT NULL,
  fk_funcionarios int NOT NULL,
  matricula_prof int UNIQUE NOT NULL,
  email_prof VARCHAR(100) UNIQUE
);

INSERT IGNORE INTO tb_professores (pk_prof,fk_funcionarios,matricula_prof,email_prof) VALUES
(100, 1000, 90, "mario.costa_prof@facul.edu"),
(101, 1108, 91, "reginaldo.rossi_prof@facul.edu"),
(102, 1356, 92, "ana.carolina_prof@facul.edu"),
(103, 1555, 93, "sergio.reis_prof@facul.edu"),
(104, 2020, 94, "beatriz.souza_prof@facul.edu"),
(105, 2301, 95, "marcos.pontes_prof@facul.edu"),
(106, 2809, 96, "helena.tanaka_prof@facul.edu");

SELECT "Professores" AS Tabela, COUNT(*) AS Total FROM tb_professores;


-- CORREÇÃO PÓS 1ª ENTREGA

ALTER TABLE tb_professores DROP FOREIGN KEY fk_prof_func;
ALTER TABLE tb_professores ADD CONSTRAINT fk_prof_func 
FOREIGN KEY (fk_funcionarios) REFERENCES tb_funcionarios (pk_funcionarios) ON DELETE RESTRICT;

-- ACADEMICO
CREATE TABLE tb_matricula (
  pk_matricula int PRIMARY KEY NOT NULL,
  fk_aluno int NOT NULL,
  fk_cursos int NOT NULL,
  data_matricula date,
  data_conclusao date COMMENT 'Preencher após formação',
  status_matricula enum("Ativo", "Trancado", "Formado", "Evadido")
);

INSERT IGNORE INTO tb_matricula (pk_matricula,fk_aluno,fk_cursos,data_matricula,data_conclusao,status_matricula) VALUES
(8, 10, 1, "2024-02-05", null, "Ativo"),        
(9, 11, 3, "2024-02-05", null, "Ativo"),        
(4, 12, 4, "2023-08-10", null, "Ativo"),         
(11, 13, 1, "2024-02-06", null, "Ativo"),         
(1, 14, 2, "2022-02-15", null, "Trancado"),     
(16, 15, 6, "2024-02-10", "2025-12-20", "Formado"), 
(5, 16, 8, "2023-08-15", null, "Ativo");       

SELECT "Matrículas", COUNT(*) FROM tb_matricula;

ALTER TABLE tb_matricula ADD CONSTRAINT fk_matricula_aluno FOREIGN KEY (fk_aluno) REFERENCES tb_alunos (pk_aluno);
ALTER TABLE tb_matricula ADD CONSTRAINT fk_matricula_curso FOREIGN KEY (fk_cursos) REFERENCES tb_cursos (pk_curso);

-- ACADEMICO
CREATE TABLE tb_grade_curricular (
  fk_disciplinas int NOT NULL,
  fk_cursos int NOT NULL,
  semestre_sugerido int
);

INSERT IGNORE INTO tb_grade_curricular (fk_disciplinas,fk_cursos,semestre_sugerido) VALUES
-- ADS
(1, 1, 1),
(2, 1, 1),
(3, 1, 2), 

(4, 2, 2), 
(5, 2, 3), 
(6, 2, 1), 

(7, 3, 4), 
(8, 3, 3),
(9, 3, 2), 

(10, 4, 2),
(11, 4, 1),
(3, 4, 3), 

(12, 5, 2),
(13, 5, 3), 
(1, 5, 1), 

(14, 6, 4),
(15, 6, 2),
(4, 6, 1), 

(16, 7, 1),
(17, 7, 2),
(5, 7, 3), 

(18, 8, 2),
(19, 8, 3), 
(17, 8, 1); 

SELECT "Grade Curricular" AS Tabela, COUNT(*) AS Total FROM tb_grade_curricular;

ALTER TABLE tb_grade_curricular ADD CONSTRAINT fk_grade_curricular_disciplinas FOREIGN KEY (fk_disciplinas) REFERENCES tb_disciplinas (pk_disciplinas);
ALTER TABLE tb_grade_curricular ADD CONSTRAINT fk_grade_curricular_curso FOREIGN KEY (fk_cursos) REFERENCES tb_cursos (pk_curso);

-- CORREÇÃO PÓS 1ª ENTREGA
ALTER TABLE tb_grade_curricular 
ADD PRIMARY KEY (fk_disciplinas, fk_cursos);


-- ACADEMICO
CREATE TABLE tb_turmas (
  pk_turma int PRIMARY KEY NOT NULL,
  fk_disciplinas int NOT NULL,
  fk_professor int NOT NULL,
  fk_salas int NOT NULL,
  ano int not null check (ano >= 2000 and ano < 2100),
  semestre enum("1", "2")
);

INSERT IGNORE INTO tb_turmas (pk_turma,fk_disciplinas,fk_professor,fk_salas,ano,semestre) VALUES
(1, 1, 100, 20, 2024, "1"),
(2, 2, 101, 21, 2024, "1"),
(3, 3, 102, 22, 2024, "1"),


(4, 7, 103, 30, 2024, "1"),
(5, 8, 104, 31, 2024, "1"), 


(6, 6, 105, 24, 2024, "1"),
(7, 17, 106, 27, 2024, "1"),
(8, 12, 100, 25, 2024, "1"),


(9, 18, 102, 28, 2024, "1"),
(10, 15, 101, 26, 2024, "1");

SELECT "Turmas" AS Tabela, COUNT(*) AS Total FROM tb_turmas;

ALTER TABLE tb_turmas ADD CONSTRAINT fk_turmas_prof FOREIGN KEY (fk_professor) REFERENCES tb_professores (pk_prof);
ALTER TABLE tb_turmas ADD CONSTRAINT fk_turmas_disciplinas FOREIGN KEY (fk_disciplinas) REFERENCES tb_disciplinas (pk_disciplinas);
ALTER TABLE tb_turmas ADD CONSTRAINT fk_turmas_salas FOREIGN KEY (fk_salas) REFERENCES tb_salas (pk_salas);

-- CORREÇÃO PÓS 1ª ENTREGA
ALTER TABLE tb_turmas 
ADD CONSTRAINT uq_prof_sala_periodo 
UNIQUE (fk_professor, fk_salas, ano, semestre);

ALTER TABLE tb_turmas 
MODIFY COLUMN ano int not null check (ano >= 2000 and ano < 2100);

-- ACADEMICO
CREATE TABLE tb_notas (
  pk_nota_matricula int PRIMARY KEY AUTO_INCREMENT,
  fk_matricula int NOT NULL,
  fk_turma int NOT NULL,
  nota_a2 decimal(4,2) CHECK (nota_a2 BETWEEN 0 and 5),
  nota_a1 decimal(4,2) CHECK (nota_a1 BETWEEN 0 and 5),
  faltas int DEFAULT 0 CHECK (faltas >= 0),
  status_disciplina enum("Cursando", "Aprovado", "Reprovado", "AF") DEFAULT "Cursando"
);

INSERT IGNORE INTO tb_notas (fk_matricula,fk_turma,nota_a2,nota_a1,faltas,status_disciplina) VALUES
(8, 1, 3.50, 4.50, 2, "Aprovado"),   
(8, 3, 3.00, null, 4, "Cursando"),  

(9, 4, 4.00, 4.00, 5, "Aprovado"),  
(9, 5, 5.00, 5.00, 15, "Reprovado"), 

(11, 2, 2.50, null, 3, "Cursando"),  
(11, 1, 2.00, 1.50, 6, "Reprovado"), 

(4, 3, 4.80, null, 1, "Cursando"),   

(5, 7, 3.00, 2.75, 14, "Aprovado"),  
(5, 9, 4.00, null, 2, "Cursando");

SELECT "Notas" AS Tabela, COUNT(*) AS Total FROM tb_notas;

ALTER TABLE tb_notas ADD CONSTRAINT fk_notas_turma FOREIGN KEY (fk_turma) REFERENCES tb_turmas (pk_turma);

-- CORREÇÃO PÓS 1ª ENTREGA

ALTER TABLE tb_notas DROP FOREIGN KEY fk_notas_matricula;
ALTER TABLE tb_notas ADD CONSTRAINT fk_notas_matricula 
FOREIGN KEY (fk_matricula) REFERENCES tb_matricula (pk_matricula) ON DELETE RESTRICT;

-- ACADEMICO
CREATE TABLE tb_frequencia (
  pk_frequencia int PRIMARY KEY AUTO_INCREMENT,
  fk_nota_matricula int NOT NULL,
  data_aula date,
  presenca boolean DEFAULT true
);

INSERT IGNORE INTO tb_frequencia (fk_nota_matricula,data_aula,presenca) VALUES
(1, "2024-02-10", true),
(1, "2024-02-17", true),
(1, "2024-02-24", false),

(2, "2024-02-12", true),
(2, "2024-02-19", true),

(3, "2024-02-11", true),
(3, "2024-02-18", true),

(4, "2024-02-13", false),
(4, "2024-02-20", false),
(4, "2024-02-27", false),

(5, "2024-03-04", true),
(5, "2024-03-11", true),

(6, "2024-03-05", true),
(6, "2024-03-12", false),

(7, "2024-02-12", true),
(7, "2024-02-19", true),

(8, "2024-03-06", true),
(8, "2024-03-13", true),

(9, "2024-03-07", true),
(9, "2024-03-14", true);

SELECT "Frequencia" AS Tabela, COUNT(*) AS Total FROM tb_frequencia;

-- CORREÇÃO PÓS 1ª ENTREGA
ALTER TABLE tb_frequencia 
ADD CONSTRAINT uq_presenca_dia UNIQUE (fk_nota_matricula, data_aula);

ALTER TABLE tb_frequencia DROP FOREIGN KEY fk_frequencia_nota_matricula;
ALTER TABLE tb_frequencia ADD CONSTRAINT fk_frequencia_nota_matricula 
FOREIGN KEY (fk_nota_matricula) REFERENCES tb_notas (pk_nota_matricula) ON DELETE RESTRICT;

-- FINANCEIRO
CREATE TABLE tb_contratos_educacionais (
  pk_contrato int PRIMARY KEY AUTO_INCREMENT,
  fk_matricula int NOT NULL,
  data_inicio date,
  data_fim date CHECK (data_fim > data_inicio)
);

INSERT IGNORE INTO tb_contratos_educacionais(fk_matricula,data_inicio,data_fim) VALUES
(8, "2024-02-05", "2024-12-20"),

(9, "2024-02-05", "2024-12-20"),

(4, "2023-08-10", "2024-07-10"),

(11, "2024-02-06", "2024-12-20"),

(1, "2022-02-15", "2022-12-15"),

(16, "2025-02-10", "2025-12-20"),

(5, "2023-08-15", "2024-07-15");

SELECT "Contratos Educacionais" AS Tabela, COUNT(*) AS Total FROM tb_contratos_educacionais;

-- CORREÇÃO PÓS 1ª ENTREGA

ALTER TABLE tb_contratos_educacionais DROP COLUMN valor_total;

ALTER TABLE tb_contratos_educacionais DROP FOREIGN KEY fk_contratos_educacionais_matricula;
ALTER TABLE tb_contratos_educacionais ADD CONSTRAINT fk_contratos_educacionais_matricula 
FOREIGN KEY (fk_matricula) REFERENCES tb_matricula (pk_matricula) ON DELETE RESTRICT;

-- FINANCEIRO
CREATE TABLE tb_mensalidades (
  pk_mensalidade int PRIMARY KEY AUTO_INCREMENT,
  fk_contrato int NOT NULL,
  num_parcela int,
  valor_mensalidade decimal(10,2) CHECK (valor_mensalidade > 0),
  data_vencimento date,
  status_mensalidade enum("Pendente", "Pago", "Atrasado", "Cancelado")
);

INSERT IGNORE INTO tb_mensalidades (fk_contrato, num_parcela, valor_mensalidade, data_vencimento, status_mensalidade) VALUES

(1, 1, 520.00, "2024-02-10", "Pago"),
(1, 2, 520.00, "2024-03-10", "Pago"),
(1, 3, 520.00, "2024-04-10", "Pendente"),

(2, 1, 1033.33, "2024-02-10", "Pago"),
(2, 2, 1033.33, "2024-03-10", "Pago"),
(2, 3, 1033.33, "2024-04-10", "Atrasado"),

(3, 1, 1066.66, "2023-09-10", "Pago"),
(3, 2, 1066.66, "2023-10-10", "Pago"),

(4, 1, 520.00, "2024-03-10", "Pago"),
(4, 2, 520.00, "2024-04-10", "Pendente"),

(5, 1, 666.66, "2022-03-10", "Pago"),
(5, 2, 666.66, "2022-04-10", "Cancelado"),

(6, 1, 833.33, "2025-03-10", "Pago"),
(6, 2, 833.33, "2025-04-10", "Pago"),

(7, 1, 933.33, "2023-09-10", "Pago"),
(7, 2, 933.33, "2023-10-10", "Pago"),
(7, 3, 933.33, "2023-11-10", "Pago");

SELECT "Mensalidades", COUNT(*) FROM tb_mensalidades;


-- CORREÇÃO PÓS 1ª ENTREGA

CREATE VIEW vw_contratos_valores AS
SELECT con.pk_contrato, con.fk_matricula, a.nome_aluno,
SUM(m.valor_mensalidade) AS 
valor_total_calculado
FROM tb_contratos_educacionais con
JOIN tb_mensalidades m ON con.pk_contrato = m.fk_contrato
JOIN tb_matricula mat ON con.fk_matricula = mat.pk_matricula
JOIN tb_alunos a ON mat.fk_aluno = a.pk_aluno
GROUP BY con.pk_contrato, con.fk_matricula, a.nome_aluno;


SELECT pk_contrato AS 
contrato_id,nome_aluno,
CONCAT("R$ ", FORMAT(valor_total_calculado, 2, "pt_BR")) AS 
investimento_total
FROM vw_contratos_valores
WHERE valor_total_calculado > 0
ORDER BY valor_total_calculado DESC;

ALTER TABLE tb_mensalidades DROP FOREIGN KEY fk_mensalidades_contrato;
ALTER TABLE tb_mensalidades ADD CONSTRAINT fk_mensalidades_contrato 
FOREIGN KEY (fk_contrato) REFERENCES tb_contratos_educacionais (pk_contrato) ON DELETE RESTRICT;
	

-- FINANCEIRO
CREATE TABLE tb_pagamentos (
  pk_pagto int PRIMARY KEY AUTO_INCREMENT,
  fk_mensalidade int NOT NULL,
  data_pagamento datetime,
  valor_pagto decimal(10,2) NOT NULL CHECK (valor_pagto > 0),
  tipo_pagto enum("Pix", "Crédito", "Débito", "Boleto")
);

INSERT IGNORE INTO tb_pagamentos (fk_mensalidade, data_pagamento, valor_pagto, tipo_pagto) VALUES
-- Pagamentos do Felipe (Matrícula 8)
(1, "2024-02-08 14:33:22", 520.00, "Pix"),
(2, "2024-03-09 10:12:20", 520.00, "Boleto"),

-- Pagamentos da Maria Luiza (Matrícula 9)
(7, "2024-02-10 16:49:55", 1033.33, "Débito"),
(8, "2024-03-10 09:01:00", 1033.33, "Pix"),
(10, "2023-09-05 11:20:24", 1066.66, "Crédito"),
(12, "2024-03-07 19:11:11", 520.00, "Pix"),
(13, "2022-03-10 13:15:58", 666.66, "Boleto"),
(15, "2025-03-08 08:40:01", 833.33, "Pix"),
(16, "2025-04-10 15:40:06", 833.33, "Pix"),
(17, "2023-09-10 10:03:38", 933.33, "Débito");

SELECT "Pagamentos", COUNT(*) FROM tb_pagamentos;

-- CORREÇÃO PÓS 1ª ENTREGA

ALTER TABLE tb_pagamentos
MODIFY COLUMN valor_pagto decimal(10,2) NOT NULL CHECK (valor_pagto > 0);

ALTER TABLE tb_pagamentos DROP FOREIGN KEY fk_pagamentos_mensalidade;
ALTER TABLE tb_pagamentos ADD CONSTRAINT fk_pagamentos_mensalidade 
FOREIGN KEY (fk_mensalidade) REFERENCES tb_mensalidades (pk_mensalidade) ON DELETE RESTRICT;

-- FINANCEIRO e RH
CREATE TABLE tb_folha_pagamento (
  pk_folha int PRIMARY KEY AUTO_INCREMENT,
  fk_funcionarios int NOT NULL,
  mes_pagto int CHECK (mes_pagto BETWEEN 1 and 12),
  ano_pagto int,
  valor_liquido DECIMAL(10,2) NOT NULL CHECK (valor_liquido > 0),
  data_pagto date NOT NULL
);

INSERT IGNORE INTO tb_folha_pagamento (fk_funcionarios, mes_pagto, ano_pagto, valor_liquido, data_pagto) VALUES
(1000, 4, 2026, 5600.00, "2026-04-05"),
(2020, 4, 2026, 4850.00, "2026-04-05"),
(2340, 4, 2026, 7100.00, "2026-04-05"),
(2702, 4, 2026, 3700.00, "2026-04-05"),
(1356, 4, 2026, 5300.00, "2026-04-05"),
(1108, 4, 2026, 5850.00, "2026-04-05"),
(3350, 4, 2026, 3150.00, "2026-04-05"),
(1555, 4, 2026, 5500.00, "2026-04-05"),
(1633, 4, 2026, 2700.00, "2026-04-05"),
(2301, 4, 2026, 6150.00, "2026-04-05"),
(2809, 4, 2026, 5100.00, "2026-04-05");

SELECT "Folha Pagamento" AS Tabela, COUNT(*) AS Total FROM tb_folha_pagamento;

-- CORREÇÃO PÓS 1ª ENTREGA

ALTER TABLE tb_folha_pagamento 
MODIFY COLUMN valor_liquido DECIMAL(10,2) NOT NULL CHECK (valor_liquido > 0);

ALTER TABLE tb_folha_pagamento DROP FOREIGN KEY fk_folha_pagamento_funcionarios;
ALTER TABLE tb_folha_pagamento ADD CONSTRAINT fk_folha_pagamento_funcionarios 
FOREIGN KEY (fk_funcionarios) REFERENCES tb_funcionarios (pk_funcionarios) ON DELETE RESTRICT;

