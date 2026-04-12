create database gestao_escolar;
use gestao_escolar;

/* 1 - ACADEMICO
   2 - FINANCEIRO
   3 - RH
*/   

-- 1
CREATE TABLE tb_alunos (
  pk_aluno int PRIMARY KEY NOT NULL,
  nome_aluno VARCHAR(50) NOT NULL,
  sobrenome_aluno VARCHAR(70) NOT NULL,
  data_nasc date NOT NULL,
  email_inst VARCHAR(100) UNIQUE NOT NULL,
  cpf CHAR(11) UNIQUE,
  sexo enum("Feminino","Masculino") DEFAULT 'Feminino',
  cor enum("Amarela","Branca","Indigena","Negra","Parda") NOT NULL,
  endereco VARCHAR(150) NOT NULL,
  numero VARCHAR(10) COMMENT 'Se houver',
  complemento VARCHAR(50) COMMENT 'Se houver',
  bairro VARCHAR(100) NOT NULL,
  cidade VARCHAR(100) NOT NULL COMMENT 'Transformar em UPPERCASE',
  estado CHAR(2) NOT NULL,
  data_ultimo_acesso date
);

INSERT INTO tb_alunos(pk_aluno,nome_aluno,sobrenome_aluno,data_nasc,email_inst,cpf,sexo,cor,endereco,numero,complemento,bairro,cidade,estado,data_ultimo_acesso) VALUES
(10,"Felipe","Santana","2006-02-20","felipe.santana@facul.edu.br","12345678901","Masculino","Negra","Rua José Quintino","44",null,"Jardim Bonfiglioli","São Paulo","SP","2026-03-27"),
(11,"Maria","Luiza","2003-10-03","maria.luiza@facul.edu.br","01234567890","Feminino","Branca","Avenida Mario Peixoto","1020","Bloco 2 Apt 22","Vila Leopoldina","São Paulo","SP","2026-03-10"),
(12,"Kerolin","Nicole","1999-05-10","kerolin.nicole@facul.edu.br","11223344556","Feminino","Parda","Avenida Irlanda","2444","Fundos","Vila Ré","São Paulo","SP","2025-11-30"),
(13,"João","Santos","2007-06-16","joao.santos@facul.edu.br","66554433221","Masculino","Negra","Rua Tapajós","21",null,"Vila Luzia","São Paulo","SP","2026-02-11"),
(14,"Matheus","Soares","2001-12-30","matheus.soares@facul.edu.br","01020304056","Masculino","Indigena","Avenida Mario Peixoto","602",null,"Vila Leopoldina","São Paulo","SP","2025-08-20"),
(15,"Sophia","Barreto","1995-10-23","sophia.barreto@facul.edu.br","10203040501","Feminino","Branca","Rua da Independência","S/N","Lote 03","Jardim Camargo Velho","São Paulo","SP","2026-01-12"),
(16,"Letícia","Silva","2002-04-04","leticia.silva@facul.edu.br","13245768906",default,"Negra","Alameda São Joaquim","50","2º Andar","Itaim Paulista","São Paulo","SP","2025-02-26");

select * from tb_alunos;

UPDATE tb_alunos 
SET cidade = UPPER(cidade);

-- 1
CREATE TABLE tb_cursos (
  pk_curso int PRIMARY KEY AUTO_INCREMENT,
  nome_curso VARCHAR(100) NOT NULL,
  carga_horaria_total int
);

INSERT INTO tb_cursos(nome_curso,carga_horaria_total) VALUES
("Análise e Desenvolvimento de Sistemas", 2600),
("Administração", 4000),
("Biomedicina", 6200),
("Ciências da Computação", 6400),
("Gestão de Tecnologia da Informação", 3100),
("Logística", 5000),
("Marketing", 4800),
("Publicidade e Propaganda", 5600);

select * from tb_cursos;

-- 1
CREATE TABLE tb_disciplinas (
  pk_disciplinas int PRIMARY KEY AUTO_INCREMENT,
  nome_disc VARCHAR(100) NOT NULL,
  carga_horaria int
);

INSERT INTO tb_disciplinas(nome_disc,carga_horaria) VALUES
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

select * from tb_disciplinas;

-- 1
CREATE TABLE tb_salas (
  pk_salas int PRIMARY KEY NOT NULL,
  bloco_sala enum("A", "B", "C", "D"),
  tipo_sala enum("LAB", "SALA"),
  num_sala int
);

INSERT INTO tb_salas(pk_salas,bloco_sala,tipo_sala,num_sala) VALUES
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

select * from tb_salas;

-- 3
CREATE TABLE tb_funcionarios (
  pk_funcionarios int PRIMARY KEY NOT NULL,
  nome_func VARCHAR(50) NOT NULL,
  sobrenome VARCHAR(70) NOT NULL,
  cpf_func CHAR(11) UNIQUE NOT NULL,
  data_admissao date NOT NULL,
  cargo VARCHAR(50) NOT NULL,
  salario_bruto decimal(10,2) CHECK (salario_bruto > 0),
  status_func enum("Ativo", "Afastado", "Desligado")
);

INSERT INTO tb_funcionarios(pk_funcionarios,nome_func,sobrenome,cpf_func,data_admissao,cargo,salario_bruto,status_func) VALUES
(1000,"Mario","Costa","11111111111","2013-09-25","Professor",7200.00,"Ativo"),
(2020, "Beatriz", "Souza", "66666666666", "2020-08-01", "Professor", 6200.00, "Ativo"),
(2340, "Cláudia", "Antunes", "23423423422", "2021-02-15", "Coordenadora de Curso", 9200.00, "Ativo"),
(2702, "Fernando", "Costa", "34534534533", "2022-08-01", "Analista de Suporte TI", 4500.00, "Ativo"),
(1356, "Ana", "Carolina", "44444444444", "2016-05-22", "Professor", 6800.00, "Ativo"),
(1108, "Reginaldo", "Rossi", "33333333333", "2014-02-10", "Professor", 7500.00, "Ativo"),
(3350, "Patrícia", "Lopes", "45645645644", "2023-01-20", "Secretária Acadêmica", 3800.00, "Ativo"),
(1555, "Sérgio", "Reis", "55555555555", "2018-03-15", "Professor", 7100.00, "Ativo"),
(1633, "Jorge", "Oliveira", "56756756755", "2019-11-12", "Técnico de Laboratório", 3200.00, "Ativo"),
(2301, "Marcos", "Pontes", "77777777777", "2021-01-10", "Professor", 7900.00, "Ativo"),
(1249, "Antônio", "Souza", "22222222222", "2015-11-20", "Bibliotecário", 2900.00, "Desligado"),
(2809, "Helena", "Tanaka", "88888888888", "2022-11-20", "Professor", 6500.00, "Ativo");

select * from tb_funcionarios;

-- 1 e 3
CREATE TABLE tb_professores (
  pk_prof int PRIMARY KEY NOT NULL,
  fk_funcionarios int NOT NULL,
  matricula_prof int UNIQUE NOT NULL,
  email_prof VARCHAR(100) UNIQUE
);

INSERT INTO tb_professores (pk_prof,fk_funcionarios,matricula_prof,email_prof) VALUES
(100, 1000, 90, "mario.costa_prof@facul.edu"),
(101, 1108, 91, "reginaldo.rossi_prof@facul.edu"),
(102, 1356, 92, "ana.carolina_prof@facul.edu"),
(103, 1555, 93, "sergio.reis_prof@facul.edu"),
(104, 2020, 94, "beatriz.souza_prof@facul.edu"),
(105, 2301, 95, "marcos.pontes_prof@facul.edu"),
(106, 2809, 96, "helena.tanaka_prof@facul.edu");

select * from tb_professores;

-- 1
CREATE TABLE tb_matricula (
  pk_matricula int PRIMARY KEY NOT NULL,
  fk_aluno int NOT NULL,
  fk_cursos int NOT NULL,
  data_matricula date,
  data_conclusao date COMMENT 'Preencher após formação',
  status_matricula enum("Ativo", "Trancado", "Formado", "Evadido")
);

INSERT INTO tb_matricula (pk_matricula,fk_aluno,fk_cursos,data_matricula,data_conclusao,status_matricula) VALUES
(8, 10, 1, "2024-02-05", null, "Ativo"),        
(9, 11, 3, "2024-02-05", null, "Ativo"),        
(4, 12, 4, "2023-08-10", null, "Ativo"),         
(11, 13, 1, "2024-02-06", null, "Ativo"),         
(1, 14, 2, "2022-02-15", null, "Trancado"),     
(16, 15, 6, "2024-02-10", "2025-12-20", "Formado"), 
(5, 16, 8, "2023-08-15", null, "Ativo");       

select * from tb_matricula;

-- 1
CREATE TABLE tb_grade_curricular (
  fk_disciplinas int NOT NULL,
  fk_cursos int NOT NULL,
  semestre_sugerido int
);

INSERT INTO tb_grade_curricular (fk_disciplinas,fk_cursos,semestre_sugerido) VALUES
-- ADS
(1, 1, 1), -- Engenharia de Software
(2, 1, 1), -- Modelagem de Negócios e Requisitos
(3, 1, 2), -- Banco de Dados

-- Administração
(4, 2, 2), -- Gestão da Produção
(5, 2, 3), -- Gestão de Vendas
(6, 2, 1), -- Introdução a Administração

-- Biomedicina
(7, 3, 4), -- Hematologia Clínica
(8, 3, 3), -- Microbiologia Médica
(9, 3, 2), -- Imunologia

-- Ciências da Computação
(10, 4, 2), -- Sistemas Operacionais
(11, 4, 1), -- Teoria da Computação
(3, 4, 3),  -- Banco de Dados

-- Gestão de TI 
(12, 5, 2), -- Gestão de Projetos
(13, 5, 3), -- Governança de TI
(1, 5, 1),  -- Engenharia de Software

-- Logística 
(14, 6, 4), -- Logística Reversa
(15, 6, 2), -- Gestão de Estoques e Armazenagem
(4, 6, 1),  -- Gestão da Produção 

-- Marketing
(16, 7, 1), -- Pesquisa de Mercado
(17, 7, 2), -- Marketing Digital
(5, 7, 3),  -- Gestão de Vendas 

-- Publicidade e Propaganda
(18, 8, 2), -- Direção de Arte
(19, 8, 3), -- Planejamento de Mídia
(17, 8, 1); -- Marketing Digital

select * from tb_grade_curricular;


-- 1
CREATE TABLE tb_turmas (
  pk_turma int PRIMARY KEY NOT NULL,
  fk_disciplinas int NOT NULL,
  fk_professor int NOT NULL,
  fk_salas int NOT NULL,
  ano int,
  semestre enum("1", "2")
);

INSERT INTO tb_turmas (pk_turma,fk_disciplinas,fk_professor,fk_salas,ano,semestre) VALUES
-- Turmas de TI (Laboratórios Bloco A)
(1, 1, 100, 20, 2024, "1"), -- Engenharia de Software com Mário Costa no LAB 1
(2, 2, 101, 21, 2024, "1"), -- Modelagem de Requisitos com Reginaldo Rossi no LAB 2
(3, 3, 102, 22, 2024, "1"), -- Banco de Dados com Ana Carolina no LAB 3

-- Turmas de Saúde/Biomedicina (Laboratórios Bloco D)
(4, 7, 103, 30, 2024, "1"), -- Hematologia com Sérgio Reis no LAB D1
(5, 8, 104, 31, 2024, "1"), -- Microbiologia com Beatriz Souza no LAB D2

-- Turmas de Gestão e Marketing (Salas Bloco B e C)
(6, 6, 105, 24, 2024, "1"), -- Introdução à Administração com Marcos Pontes na Sala 100
(7, 17, 106, 27, 2024, "1"), -- Marketing Digital com Helena Tanaka na Sala 101
(8, 12, 100, 25, 2024, "1"), -- Gestão de Projetos com Mário Costa na Sala 102

-- Turmas Específicas
(9, 18, 102, 28, 2024, "1"), -- Direção de Arte com Ana Carolina na Sala 103
(10, 15, 101, 26, 2024, "1"); -- Gestão de Estoques com Reginaldo Rossi na Sala 104

select * from tb_turmas;

-- 1
CREATE TABLE tb_notas (
  pk_nota_matricula int PRIMARY KEY AUTO_INCREMENT,
  fk_matricula int NOT NULL,
  fk_turma int NOT NULL,
  nota_a2 decimal(4,2) CHECK (nota_a2 BETWEEN 0 and 5),
  nota_a1 decimal(4,2) CHECK (nota_a1 BETWEEN 0 and 5),
  faltas int DEFAULT 0 CHECK (faltas >= 0),
  status_disciplina enum("Cursando", "Aprovado", "Reprovado", "AF") DEFAULT "Cursando"
);

INSERT INTO tb_notas (fk_matricula,fk_turma,nota_a2,nota_a1,faltas,status_disciplina) VALUES
-- FELIPE (Matrícula 8)
(8, 1, 3.50, 4.50, 2, "Aprovado"),   
(8, 3, 3.00, null, 4, "Cursando"),  

-- MARIA LUIZA (Matrícula 9)
(9, 4, 4.00, 4.00, 5, "Aprovado"),  
(9, 5, 5.00, 5.00, 15, "Reprovado"), 

-- JOÃO (Matrícula 11)
(11, 2, 2.50, null, 3, "Cursando"),  
(11, 1, 2.00, 1.50, 6, "Reprovado"), 

-- KEROLIN (Matrícula 4)
(4, 3, 4.80, null, 1, "Cursando"),   

-- LETÍCIA (Matrícula 5)
(5, 7, 3.00, 2.75, 14, "Aprovado"),  
(5, 9, 4.00, null, 2, "Cursando");

select * from tb_notas;

-- 1
CREATE TABLE tb_frequencia (
  pk_frequencia int PRIMARY KEY AUTO_INCREMENT,
  fk_nota_matricula int NOT NULL,
  data_aula date,
  presenca boolean DEFAULT true
);

INSERT INTO tb_frequencia (fk_nota_matricula,data_aula,presenca) VALUES
-- Felipe em Engenharia de Software
(1, "2024-02-10", true),
(1, "2024-02-17", true),
(1, "2024-02-24", false),

-- Felipe em Banco de Dados
(2, "2024-02-12", true),
(2, "2024-02-19", true),

-- Maria Luiza em Hematologia
(3, "2024-02-11", true),
(3, "2024-02-18", true),

-- Maria Luiza em Microbiologia
(4, "2024-02-13", false),
(4, "2024-02-20", false),
(4, "2024-02-27", false),

-- João em Modelagem de Requisitos
(5, "2024-03-04", true),
(5, "2024-03-11", true),

-- João em Engenharia de Software
(6, "2024-03-05", true),
(6, "2024-03-12", false),

-- Kerolin em Banco de Dados
(7, "2024-02-12", true),
(7, "2024-02-19", true),

-- Letícia em Marketing Digital
(8, "2024-03-06", true),
(8, "2024-03-13", true),

-- Letícia em Direção de Arte
(9, "2024-03-07", true),
(9, "2024-03-14", true);

select * from tb_frequencia;

-- 2
CREATE TABLE tb_contratos_educacionais (
  pk_contrato int PRIMARY KEY AUTO_INCREMENT,
  fk_matricula int NOT NULL,
  data_inicio date,
  data_fim date CHECK (data_fim > data_inicio),
  valor_total decimal(10,2) CHECK (valor_total > 0)
);

INSERT INTO tb_contratos_educacionais(fk_matricula,data_inicio,data_fim,valor_total) VALUES
-- Felipe (Matrícula 8 - ADS)
(8, "2024-02-05", "2024-12-20", 5200.00),

-- Maria Luiza (Matrícula 9 - Biomedicina)
(9, "2024-02-05", "2024-12-20", 12400.00),

-- Kerolin (Matrícula 4 - CC)
(4, "2023-08-10", "2024-07-10", 12800.00),

-- João (Matrícula 11 - ADS)
(11, "2024-02-06", "2024-12-20", 5200.00),

-- Matheus (Matrícula 1 - ADM)
(1, "2022-02-15", "2022-12-15", 8000.00),

-- Sophia (Matrícula 16 - Logística)
(16, "2025-02-10", "2025-12-20", 10000.00),

-- Letícia (Matrícula 5 - Publicidade)
(5, "2023-08-15", "2024-07-15", 11200.00);

select * from tb_contratos_educacionais;

-- 2
CREATE TABLE tb_mensalidades (
  pk_mensalidade int PRIMARY KEY AUTO_INCREMENT,
  fk_contrato int NOT NULL,
  num_parcela int,
  valor_mensalidade decimal(10,2) CHECK (valor_mensalidade > 0),
  data_vencimento date,
  status_mensalidade enum("Pendente", "Pago", "Atrasado", "Cancelado")
);

INSERT INTO tb_mensalidades (fk_contrato, num_parcela, valor_mensalidade, data_vencimento, status_mensalidade) VALUES
-- Mensalidades do contrato 1 (Felipe - ADS)
(1, 1, 520.00, "2024-02-10", "Pago"),
(1, 2, 520.00, "2024-03-10", "Pago"),
(1, 3, 520.00, "2024-04-10", "Pendente"),

-- Mensalidades do contrato 2 (Maria Luiza - Biomedicina)
(2, 1, 1033.33, "2024-02-10", "Pago"),
(2, 2, 1033.33, "2024-03-10", "Pago"),
(2, 3, 1033.33, "2024-04-10", "Atrasado"),

-- Mensalidades do contrato 3 (Kerolin - CC)
(3, 1, 1066.66, "2023-09-10", "Pago"),
(3, 2, 1066.66, "2023-10-10", "Pago"),

-- Mensalidades do contrato 4 (João - ADS)
(4, 1, 520.00, "2024-03-10", "Pago"),
(4, 2, 520.00, "2024-04-10", "Pendente"),

-- Mensalidades do contrato 5 (Matheus - ADM - Trancado)
(5, 1, 666.66, "2022-03-10", "Pago"),
(5, 2, 666.66, "2022-04-10", "Cancelado"),

-- Mensalidades do contrato 6 (Sophia - Logística - Formada)
(6, 1, 833.33, "2025-03-10", "Pago"),
(6, 2, 833.33, "2025-04-10", "Pago"),

-- Mensalidades do contrato 7 (Letícia - Publicidade)
(7, 1, 933.33, "2023-09-10", "Pago"),
(7, 2, 933.33, "2023-10-10", "Pago"),
(7, 3, 933.33, "2023-11-10", "Pago");

select * from tb_mensalidades;

-- 2
CREATE TABLE tb_pagamentos (
  pk_pagto int PRIMARY KEY AUTO_INCREMENT,
  fk_mensalidade int NOT NULL,
  data_pagamento datetime,
  valor_pagto decimal(10,2),
  tipo_pagto enum("Pix", "Crédito", "Débito", "Boleto")
);

INSERT INTO tb_pagamentos (fk_mensalidade, data_pagamento, valor_pagto, tipo_pagto) VALUES
-- Pagamentos do Felipe (Matrícula 8)
(1, "2024-02-08 14:33:22", 520.00, "Pix"),
(2, "2024-03-09 10:12:20", 520.00, "Boleto"),

-- Pagamentos da Maria Luiza (Matrícula 9)
(7, "2024-02-10 16:49:55", 1033.33, "Débito"),
(8, "2024-03-10 09:01:00", 1033.33, "Pix"),

-- Pagamentos da Kerolin (Matrícula 4)
(10, "2023-09-05 11:20:24", 1066.66, "Crédito"),

-- Pagamento do João (Matrícula 11)
(12, "2024-03-07 19:11:11", 520.00, "Pix"),

-- Pagamento do Matheus (Matrícula 1)
(13, "2022-03-10 13:15:58", 666.66, "Boleto"),

-- Pagamentos da Sophia (Matrícula 16)
(15, "2025-03-08 08:40:01", 833.33, "Pix"),
(16, "2025-04-10 15:40:06", 833.33, "Pix"),

-- Pagamento da Letícia (Matrícula 5)
(17, "2023-09-10 10:03:38", 933.33, "Débito");

select * from tb_pagamentos;

-- 2 e 3
CREATE TABLE tb_folha_pagamento (
  pk_folha int PRIMARY KEY AUTO_INCREMENT,
  fk_funcionarios int NOT NULL,
  mes_pagto int CHECK (mes_pagto BETWEEN 1 and 12),
  ano_pagto int,
  valor_liquido decimal(10,2) CHECK (valor_liquido > 0),
  data_pagto date NOT NULL
);

INSERT INTO tb_folha_pagamento (fk_funcionarios, mes_pagto, ano_pagto, valor_liquido, data_pagto) VALUES
-- Mário Costa (Salário 7200.00)
(1000, 4, 2026, 5600.00, "2026-04-05"),

-- Beatriz Souza (Salário 6200.00)
(2020, 4, 2026, 4850.00, "2026-04-05"),

-- Cláudia Antunes (Salário 9200.00)
(2340, 4, 2026, 7100.00, "2026-04-05"),

-- Fernando Costa (Salário 4500.00)
(2702, 4, 2026, 3700.00, "2026-04-05"),

-- Ana Carolina (Salário 6800.00)
(1356, 4, 2026, 5300.00, "2026-04-05"),

-- Reginaldo Rossi (Salário 7500.00)
(1108, 4, 2026, 5850.00, "2026-04-05"),

-- Patrícia Lopes (Salário 3800.00)
(3350, 4, 2026, 3150.00, "2026-04-05"),

-- Sérgio Reis (Salário 7100.00)
(1555, 4, 2026, 5500.00, "2026-04-05"),

-- Jorge Oliveira (Salário 3200.00)
(1633, 4, 2026, 2700.00, "2026-04-05"),

-- Marcos Pontes (Salário 7900.00)
(2301, 4, 2026, 6150.00, "2026-04-05"),

-- Helena Tanaka (Salário 6500.00)
(2809, 4, 2026, 5100.00, "2026-04-05");

select * from tb_folha_pagamento;

ALTER TABLE tb_professores ADD CONSTRAINT fk_prof_func FOREIGN KEY (fk_funcionarios) REFERENCES tb_funcionarios (pk_funcionarios);
ALTER TABLE tb_matricula ADD CONSTRAINT fk_matricula_aluno FOREIGN KEY (fk_aluno) REFERENCES tb_alunos (pk_aluno);
ALTER TABLE tb_matricula ADD CONSTRAINT fk_matricula_curso FOREIGN KEY (fk_cursos) REFERENCES tb_cursos (pk_curso);
ALTER TABLE tb_grade_curricular ADD CONSTRAINT fk_grade_curricular_disciplinas FOREIGN KEY (fk_disciplinas) REFERENCES tb_disciplinas (pk_disciplinas);
ALTER TABLE tb_grade_curricular ADD CONSTRAINT fk_grade_curricular_curso FOREIGN KEY (fk_cursos) REFERENCES tb_cursos (pk_curso);
ALTER TABLE tb_turmas ADD CONSTRAINT fk_turmas_prof FOREIGN KEY (fk_professor) REFERENCES tb_professores (pk_prof);
ALTER TABLE tb_turmas ADD CONSTRAINT fk_turmas_disciplinas FOREIGN KEY (fk_disciplinas) REFERENCES tb_disciplinas (pk_disciplinas);
ALTER TABLE tb_turmas ADD CONSTRAINT fk_turmas_salas FOREIGN KEY (fk_salas) REFERENCES tb_salas (pk_salas);
ALTER TABLE tb_notas ADD CONSTRAINT fk_notas_matricula FOREIGN KEY (fk_matricula) REFERENCES tb_matricula (pk_matricula);
ALTER TABLE tb_notas ADD CONSTRAINT fk_notas_turma FOREIGN KEY (fk_turma) REFERENCES tb_turmas (pk_turma);
ALTER TABLE tb_frequencia ADD CONSTRAINT fk_frequencia_nota_matricula FOREIGN KEY (fk_nota_matricula) REFERENCES tb_notas (pk_nota_matricula);
ALTER TABLE tb_contratos_educacionais ADD CONSTRAINT fk_contratos_educacionais_matricula FOREIGN KEY (fk_matricula) REFERENCES tb_matricula (pk_matricula);
ALTER TABLE tb_mensalidades ADD CONSTRAINT fk_mensalidades_contrato FOREIGN KEY (fk_contrato) REFERENCES tb_contratos_educacionais (pk_contrato);
ALTER TABLE tb_pagamentos ADD CONSTRAINT fk_pagamentos_mensalidade FOREIGN KEY (fk_mensalidade) REFERENCES tb_mensalidades (pk_mensalidade);
ALTER TABLE tb_folha_pagamento ADD CONSTRAINT fk_folha_pagamento_funcionarios FOREIGN KEY (fk_funcionarios) REFERENCES tb_funcionarios (pk_funcionarios);