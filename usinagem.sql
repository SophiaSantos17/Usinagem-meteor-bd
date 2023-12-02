CREATE DATABASE usinagem_meteor;
USE usinagem_meteor; 


-- Controle de Produção de Peças 

CREATE TABLE pecas(
	pk_ID_peca 		int NOT NULL UNIQUE,
    descricao_peca 	varchar(200) NOT NULL,
    material 		varchar(100) NOT NULL,
	peso 			decimal(5,2) NOT NULL,
	dimensao 		varchar(30),
		
    PRIMARY KEY(pk_ID_peca)
);

CREATE TABLE maquinas(
	pk_ID_maquina 		int NOT NULL UNIQUE,
	nome_maquina 		varchar(100) NOT NULL,
	descricao 			varchar(200) NOT NULL,
	capacidade_max 		FLOAT NOT NULL,
	ultima_manutencao 	date NOT NULL,
    
    PRIMARY KEY(pk_ID_maquina)
);

CREATE TABLE ordens_producao(
	pk_ID_Ordem 			int NOT NULL UNIQUE,
	fk_ID_peca 				int NOT NULL UNIQUE,
	qntd_a_ser_produzida 	int NOT NULL,
	data_inicio 			date NOT NULL,
	data_conclusao 			date NOT NULL,
    status_da_ordem 		varchar(100) NOT NULL,
    
    PRIMARY KEY(pk_ID_Ordem),
    FOREIGN KEY(fk_ID_peca) REFERENCES pecas(pk_ID_peca)
);

CREATE TABLE operadores(
	pk_ID_operador 		int NOT NULL UNIQUE,
    nome_operador 		varchar(100) NOT NULL,
    especializacao 		varchar(100) NOT NULL,
    disponibilidade 	varchar(100) NOT NULL,
    historico_producao 	int NOT NULL,
    
    PRIMARY KEY(pk_ID_operador)
);


-- Manutenção de Equipamentos

CREATE TABLE equipamentos(
	pk_ID_equipamento 	int NOT NULL UNIQUE,
	nome_equipamento 	varchar(100) NOT NULL,
	descricao 			varchar(300) NOT NULL,
	data_aquisicao 		date NOT NULL,
	vida_util_restante 	int NOT NULL,
    
    PRIMARY KEY(pk_ID_equipamento)
);

CREATE TABLE manutencoes_programadas(
	pk_ID_manutencao 		int NOT NULL UNIQUE,
	fk_ID_equipamento 		int NOT NULL UNIQUE,
	tipo_manutencao 		varchar(100) NOT NULL,
	data_programada 		date NOT NULL,
	responsavel_manutencao 	varchar(100) NOT NULL,
    
    PRIMARY KEY(pk_id_manutencao),
    FOREIGN KEY(fk_id_equipamento) REFERENCES equipamentos(pk_ID_equipamento)
);

CREATE TABLE historico_manutencoes(
	pk_ID_manutencao int NOT NULL UNIQUE,
	fk_ID_equipamento int NOT NULL UNIQUE,
	fk_ID_manutencao int NOT NULL,
	data_da_manutencao date NOT NULL,
	custos_manutencao FLOAT,
    
    PRIMARY KEY(pk_ID_manutencao),
    FOREIGN KEY(fk_ID_equipamento) REFERENCES equipamentos(pk_ID_equipamento),
    FOREIGN KEY(fk_ID_manutencao) REFERENCES manutencoes_programadas(pk_ID_manutencao)
);


-- Controle de Qualidade de Peças

CREATE TABLE inspecoes(
	pk_ID_inspecao int NOT NULL UNIQUE,
	ID_peca_inspecionada int NOT NULL UNIQUE,
	data_inspecao date NOT NULL,
	resultado_inspecao varchar(100)NOT NULL,
	observacoes varchar(300),
    
    PRIMARY KEY(pk_ID_inspecao)
);

CREATE TABLE rejeicoes(
	pk_ID_rejeicao int NOT NULL UNIQUE,
	ID_peca_rejeitada int NOT NULL UNIQUE,
	motivo_rejeicao varchar(300) NOT NULL,
	data_rejeicao date NOT NULL,
	acoes_corretivas varchar(300),
    
    PRIMARY KEY(pk_ID_rejeicao)
);

CREATE TABLE aceitacoes(
	pk_ID_aceitacao int NOT NULL UNIQUE,
	ID_peca_aceita int NOT NULL UNIQUE,
	data_aceitacao date NOT NULL,
	destino_peca varchar(100) NOT NULL,
	observacoes varchar(200) NOT NULL,
    
    PRIMARY KEY(pk_ID_aceitacao)
);


-- Gerenciamento de Estoque de Matérias Primas

CREATE TABLE materias_primas(
	pk_ID_materia_prima int NOT NULL UNIQUE,
	descricao_materia_prima varchar(300) NOT NULL,
	fornecedor varchar(100) NOT NULL,
	qntd_estoque int NOT NULL,
	data_ultima_compra date NOT NULL,
    
    PRIMARY KEY(pk_ID_materia_prima)
);

CREATE TABLE fornecedores(
	pk_ID_fornecedor int NOT NULL UNIQUE,
	nome_fornecedor varchar(100) NOT NULL,
	endereco varchar(200) NOT NULL,
	contato int NOT NULL,
	avalicao_do_fornecedor varchar(300) NOT NULL,
    
    PRIMARY KEY(pk_ID_fornecedor)
);