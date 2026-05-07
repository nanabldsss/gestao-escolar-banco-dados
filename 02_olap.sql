SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS fato_desempenho, fato_financeira, fato_folha_pagamento,
dim_aluno, dim_curso, dim_disciplina, dim_professor, dim_tempo, 
dim_forma_pagamento, dim_funcionario;

SET FOREIGN_KEY_CHECKS = 1;


use gestao_escolar;

CREATE TABLE dim_aluno (
    sk_aluno INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno_origem INT,
    nome_aluno VARCHAR(50),
    sobrenome_aluno VARCHAR(70),
    cpf CHAR(11),
    data_nascimento DATE,
    sexo enum("Feminino","Masculino") DEFAULT "Feminino",
    cor enum("Amarela","Branca","Indigena","Negra","Parda"),
    cidade VARCHAR(100),
    estado CHAR(2),
    status_matricula enum("Ativo", "Trancado", "Formado", "Evadido")
);

INSERT INTO dim_aluno (id_aluno_origem, nome_aluno, sobrenome_aluno, cpf, data_nascimento, sexo, cor, cidade, estado, status_matricula)
SELECT 
    a.pk_aluno, a.nome_aluno, a.sobrenome_aluno, a.cpf, a.data_nasc, a.sexo, a.cor, a.cidade, a.estado, m.status_matricula
FROM tb_alunos a
JOIN tb_matricula m ON a.pk_aluno = m.fk_aluno;


CREATE TABLE dim_curso (
    sk_curso INT PRIMARY KEY AUTO_INCREMENT,
    id_curso_origem INT,
    nome_curso VARCHAR(100)
);

INSERT INTO dim_curso (id_curso_origem, nome_curso)
SELECT pk_curso, nome_curso FROM tb_cursos;

CREATE TABLE dim_disciplina (
    sk_disciplina INT PRIMARY KEY AUTO_INCREMENT,
    id_disc_origem INT,
    nome_disciplina VARCHAR(100),
    carga_horaria_disciplina INT
);

INSERT INTO dim_disciplina (id_disc_origem, nome_disciplina, carga_horaria_disciplina)
SELECT pk_disciplinas, nome_disc, carga_horaria FROM tb_disciplinas;

CREATE TABLE dim_professor (
    sk_professor INT PRIMARY KEY AUTO_INCREMENT,
    id_prof_origem INT,
    nome_professor VARCHAR(50),
    sobrenome_professor VARCHAR(70),
    cargo VARCHAR(50)
);

INSERT INTO dim_professor (id_prof_origem, nome_professor, sobrenome_professor, cargo)
SELECT 
    p.pk_prof, f.nome_func, f.sobrenome, "Professor"
FROM tb_professores p
JOIN tb_funcionarios f ON p.fk_funcionarios = f.pk_funcionarios;

CREATE TABLE dim_tempo (
    sk_tempo INT PRIMARY KEY AUTO_INCREMENT,
    data_completa DATE UNIQUE,
    ano INT,
    semestre INT,
    mes INT,
    nome_mes VARCHAR(20)
);

INSERT IGNORE INTO dim_tempo (data_completa, ano, semestre, mes, nome_mes)
SELECT DISTINCT 
    data_pagamento, YEAR(data_pagamento), IF(MONTH(data_pagamento) <= 6, 1, 2), MONTH(data_pagamento), MONTHNAME(data_pagamento)
FROM tb_pagamentos;

CREATE TABLE dim_forma_pagamento (
    sk_forma_pagto INT PRIMARY KEY AUTO_INCREMENT,
    tipo_pagto enum("Pix", "Crédito", "Débito", "Boleto")
);

INSERT INTO dim_forma_pagamento (tipo_pagto)
SELECT DISTINCT tipo_pagto FROM tb_pagamentos;

CREATE TABLE dim_funcionario (
    sk_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    id_func_origem INT,
    nome_func VARCHAR(50),
    sobrenome_func VARCHAR(70),
    cargo VARCHAR(50),
    status_func enum("Ativo", "Afastado", "Desligado")
);

INSERT INTO dim_funcionario (id_func_origem, nome_func, sobrenome_func, cargo, status_func)
SELECT 
    f.pk_funcionarios, f.nome_func, f.sobrenome, c.nome_cargo, f.status_func
FROM tb_funcionarios f
JOIN tb_cargos c ON f.fk_cargo = c.pk_cargo;

-- ACADEMICO
CREATE TABLE fato_desempenho (
    sk_fato_desempenho INT PRIMARY KEY AUTO_INCREMENT,
    sk_aluno INT,
    sk_disciplina INT,
    sk_professor INT,
    sk_tempo INT,
    nota_a1 DECIMAL(4,2),
    nota_a2 DECIMAL(4,2),
    nota_final DECIMAL(4,2), 
    total_faltas INT,
    status_resultado enum("Aprovado","Reprovado","AF"), 
    taxa_frequencia DECIMAL(5,2),
    
    FOREIGN KEY (sk_aluno) REFERENCES dim_aluno(sk_aluno),
    FOREIGN KEY (sk_disciplina) REFERENCES dim_disciplina(sk_disciplina),
    FOREIGN KEY (sk_professor) REFERENCES dim_professor(sk_professor),
    FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo)
);

INSERT INTO fato_desempenho (
    sk_aluno, sk_disciplina, sk_professor, sk_tempo, 
    nota_a1, nota_a2, nota_final, 
    total_faltas, taxa_frequencia, status_resultado
)
SELECT 
    da.sk_aluno, 
    dd.sk_disciplina, 
    dp.sk_professor, 
    n.nota_a1, 
    n.nota_a2, 
    (IFNULL(n.nota_a1, 0) + IFNULL(n.nota_a2, 0)) AS nota_final,
    n.faltas,
    ((dd.carga_horaria_disciplina - n.faltas) / dd.carga_horaria_disciplina * 100) AS freq,
    CASE 
        WHEN ((dd.carga_horaria_disciplina - n.faltas) / dd.carga_horaria_disciplina * 100) < 75 THEN 'Reprovado'
        WHEN (IFNULL(n.nota_a1, 0) + IFNULL(n.nota_a2, 0)) < 5.75 THEN 'AF'
        ELSE 'Aprovado'
    END AS status_resultado
FROM tb_notas n
JOIN tb_matricula mat ON n.fk_matricula = mat.pk_matricula
JOIN tb_turmas t ON n.fk_turma = t.pk_turma
JOIN dim_aluno da ON mat.fk_aluno = da.id_aluno_origem
JOIN dim_disciplina dd ON t.fk_disciplinas = dd.id_disc_origem
JOIN dim_professor dp ON t.fk_professor = dp.id_prof_origem;


-- FINANCEIRO
CREATE TABLE fato_financeira (
    sk_fato_financeira INT PRIMARY KEY AUTO_INCREMENT,
    sk_aluno INT,
    sk_curso INT,
    sk_forma_pagto INT,
    sk_tempo INT,
    valor_mensalidade DECIMAL(10,2),
    valor_pago DECIMAL(10,2),
    status_mensalidade enum("Pendente", "Pago", "Atrasado", "Cancelado"),
    
    FOREIGN KEY (sk_aluno) REFERENCES dim_aluno(sk_aluno),
    FOREIGN KEY (sk_curso) REFERENCES dim_curso(sk_curso),
    FOREIGN KEY (sk_forma_pagto) REFERENCES dim_forma_pagamento(sk_forma_pagto),
    FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo)
);

INSERT INTO fato_financeira (sk_aluno, sk_curso, sk_forma_pagto, sk_tempo, valor_mensalidade, valor_pago, status_mensalidade)
SELECT 
    da.sk_aluno, dc.sk_curso, dfp.sk_forma_pagto, dt.sk_tempo,
    m.valor_mensalidade, p.valor_pagto, m.status_mensalidade
FROM tb_pagamentos p
JOIN tb_mensalidades m ON p.fk_mensalidade = m.pk_mensalidade
JOIN tb_contratos_educacionais ce ON m.fk_contrato = ce.pk_contrato
JOIN tb_matricula mat ON ce.fk_matricula = mat.pk_matricula
JOIN dim_aluno da ON mat.fk_aluno = da.id_aluno_origem
JOIN dim_curso dc ON mat.fk_cursos = dc.id_curso_origem
JOIN dim_forma_pagamento dfp ON p.tipo_pagto = dfp.tipo_pagto
JOIN dim_tempo dt ON DATE(p.data_pagamento) = dt.data_completa;

-- RH
CREATE TABLE fato_folha_pagamento (
    sk_fato_folha INT PRIMARY KEY AUTO_INCREMENT,
    sk_funcionario INT,
    sk_tempo INT,
    salario_bruto DECIMAL(10,2),
    valor_descontos DECIMAL(10,2),
    valor_liquido DECIMAL(10,2),
    
    FOREIGN KEY (sk_funcionario) REFERENCES dim_funcionario(sk_funcionario),
    FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo)
);


INSERT INTO fato_folha_pagamento (
    sk_funcionario, 
    sk_tempo, 
    salario_bruto, 
    valor_descontos, 
    valor_liquido
)
SELECT 
    df.sk_funcionario, 1,
    f.salario_bruto, 
    (f.salario_bruto - fp.valor_liquido) AS valor_descontos, 
    fp.valor_liquido
FROM tb_folha_pagamento fp
JOIN tb_funcionarios f ON fp.fk_funcionarios = f.pk_funcionarios
JOIN dim_funcionario df ON f.pk_funcionarios = df.id_func_origem;

-- FINANCEIRO
SELECT SUM(valor_pagto) AS OLTP_Financeiro FROM tb_pagamentos;
SELECT SUM(valor_pago) AS OLAP_Financeiro FROM fato_financeira;

-- RH
SELECT SUM(valor_liquido) AS OLTP_RH FROM tb_folha_pagamento;
SELECT SUM(valor_liquido) AS OLAP_RH FROM fato_folha_pagamento;

-- ACADEMICO - NOTAS
SELECT 
    (SELECT SUM(IFNULL(nota_a1, 0) + IFNULL(nota_a2, 0)) FROM tb_notas) AS total_pontos_oltp,
    (SELECT SUM(nota_final) FROM fato_desempenho) AS total_pontos_olap;

-- ACADEMICO - FALTAS
SELECT 
    (SELECT SUM(faltas) FROM tb_notas) AS total_faltas_oltp,
    (SELECT SUM(total_faltas) FROM fato_desempenho) AS total_faltas_olap;

-- ACADEMICO - MÉDIA
SELECT 
    (SELECT AVG(IFNULL(nota_a1, 0) + IFNULL(nota_a2, 0)) FROM tb_notas) AS media_oltp,
    (SELECT AVG(nota_final) FROM fato_desempenho) AS media_olap;

-- INDEX    
CREATE INDEX idx_fato_financeira_aluno ON fato_financeira (sk_aluno);
CREATE INDEX idx_fato_desempenho_status ON fato_desempenho (status_resultado);
CREATE INDEX idx_fato_desempenho_aluno ON fato_desempenho (sk_aluno);


-- EXPLAINs
EXPLAIN 
SELECT 
    a.nome_aluno, 
    d.nome_disciplina, 
    f.nota_final
FROM fato_desempenho f
JOIN dim_aluno a ON f.sk_aluno = a.sk_aluno
JOIN dim_disciplina d ON f.sk_disciplina = d.sk_disciplina
WHERE f.status_resultado = 'AF';


EXPLAIN
SELECT 
    c.nome_curso, 
    SUM(f.valor_pago) AS total_recebido
FROM fato_financeira f
JOIN dim_curso c ON f.sk_curso = c.sk_curso
GROUP BY c.nome_curso;    
    

