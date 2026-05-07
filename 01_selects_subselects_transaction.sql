-- SELECTs, SUBSELECTs e ROLLBACK / COMMIT

use gestao_escolar;

SELECT nome_aluno, sobrenome_aluno, cidade FROM tb_alunos;


SELECT nome_aluno, sobrenome_aluno
FROM tb_alunos
WHERE pk_aluno IN (
    SELECT fk_aluno
    FROM tb_matricula m
    JOIN tb_contratos_educacionais c ON m.pk_matricula = c.fk_matricula
    GROUP BY fk_aluno
    HAVING COUNT(pk_contrato) >= 1
);


SELECT pk_prof, matricula_prof, email_prof FROM tb_professores;

SELECT pk_prof, email_prof 
FROM tb_professores 
WHERE pk_prof IN (
    SELECT fk_professor 
    FROM tb_turmas 
    GROUP BY fk_professor 
    HAVING COUNT(pk_turma) > 1
);

SELECT fk_contrato, num_parcela, valor_mensalidade, data_vencimento, status_mensalidade FROM tb_mensalidades;


START TRANSACTION;
INSERT INTO tb_mensalidades (fk_contrato, num_parcela, valor_mensalidade, data_vencimento, status_mensalidade) 
VALUES (1, 4, 520.00, '2024-05-10', 'Pendente');
ROLLBACK;
SELECT * FROM tb_mensalidades WHERE fk_contrato = 1 AND num_parcela = 4;


START TRANSACTION;
INSERT INTO tb_mensalidades (fk_contrato, num_parcela, valor_mensalidade, data_vencimento, status_mensalidade) 
VALUES (1, 4, 520.00, '2024-05-10', 'Pendente');
COMMIT;
SELECT * FROM tb_mensalidades WHERE fk_contrato = 1 AND num_parcela = 4;
