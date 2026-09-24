CREATE DATABASE sistema_desaparecidoss;
USE sistema_desaparecidoss;

CREATE TABLE Usuarios (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    senha VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),
    role ENUM('USUARIO', 'ADMIN') NOT NULL DEFAULT 'USUARIO'
);

CREATE TABLE Estados (
    idEstados INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sigla CHAR(2) NOT NULL 
);

INSERT INTO estados (nome, sigla) VALUES
('Acre', 'AC'),
('Alagoas', 'AL'),
('Amapá', 'AP'),
('Amazonas', 'AM'),
('Bahia', 'BA'),
('Ceará', 'CE'),
('Distrito Federal', 'DF'),
('Espírito Santo', 'ES'),
('Goiás', 'GO'),
('Maranhão', 'MA'),
('Mato Grosso', 'MT'),
('Mato Grosso do Sul', 'MS'),
('Minas Gerais', 'MG'),
('Pará', 'PA'),
('Paraíba', 'PB'),
('Paraná', 'PR'),
('Pernambuco', 'PE'),
('Piauí', 'PI'),
('Rio de Janeiro', 'RJ'),
('Rio Grande do Norte', 'RN'),
('Rio Grande do Sul', 'RS'),
('Rondônia', 'RO'),
('Roraima', 'RR'),
('Santa Catarina', 'SC'),
('São Paulo', 'SP'),
('Sergipe', 'SE'),
('Tocantins', 'TO');

CREATE TABLE Cidades (
    idCidades INT AUTO_INCREMENT PRIMARY KEY,
    estado_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,

    CONSTRAINT fk_cidades_estado
        FOREIGN KEY (estado_id)
        REFERENCES Estados(idEstados)
);

CREATE TABLE boletim_ocorrencia (
    idboletim_ocorrencia INT AUTO_INCREMENT PRIMARY KEY,
    numero_bo VARCHAR(50),
    data_registro DATETIME,
    orgao_registro VARCHAR(150),
    delegacia VARCHAR(150),
    descricao TEXT
);

CREATE TABLE Desaparecidos (
    idDesaparecidos INT AUTO_INCREMENT PRIMARY KEY,
    boletim_ocorrencia_id INT,
    usuario_id INT,
    nome VARCHAR(100) NOT NULL,
    nome_social VARCHAR(45),
    data_nascimento DATE,
    sexo ENUM('MASCULINO', 'FEMININO', 'OUTRO'),
    altura DECIMAL(5 , 2 ),
    peso DECIMAL(5 , 2 ),
    cor_olhos VARCHAR(45),
    cor_cabelo VARCHAR(45),
    cor_pele VARCHAR(45),
    ultima_roupa TEXT,
    caracteristicas TEXT,
    descricao TEXT,
    foto_url VARCHAR(500),
    data_desaparecimento DATETIME,
    cidade_id INT,
    status ENUM('PENDENTE', 'ATIVO', 'ENCONTRADO', 'REJEITADO', 'ARQUIVADO') NOT NULL DEFAULT 'PENDENTE',
    CONSTRAINT fk_desaparecidos_boletim FOREIGN KEY (boletim_ocorrencia_id)
        REFERENCES boletim_ocorrencia (idboletim_ocorrencia),
    CONSTRAINT fk_desaparecidos_usuario FOREIGN KEY (usuario_id)
        REFERENCES Usuarios (idUsuario),
    CONSTRAINT fk_desaparecidos_cidade FOREIGN KEY (cidade_id)
        REFERENCES Cidades (idCidades)
);

CREATE TABLE Avistamentos (
    idAvistamento INT AUTO_INCREMENT PRIMARY KEY,

    desaparecidos_id INT NOT NULL,
    usuario_id INT NOT NULL,
    cidade_id INT NOT NULL,

    endereco VARCHAR(255),
    data_avistamento DATETIME,
    descricao TEXT,

    CONSTRAINT fk_avistamentos_desaparecido
        FOREIGN KEY (desaparecidos_id)
        REFERENCES Desaparecidos(idDesaparecidos),

    CONSTRAINT fk_avistamentos_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES Usuarios(idUsuario),

    CONSTRAINT fk_avistamentos_cidade
        FOREIGN KEY (cidade_id)
        REFERENCES Cidades(idCidades)
);

CREATE TABLE Alertas (
    idAlertas INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT NOT NULL,
    estado_id INT NOT NULL,
    cidade_id INT NOT NULL,

    descricao TEXT,

    CONSTRAINT fk_alertas_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES Usuarios(idUsuario),

    CONSTRAINT fk_alertas_estado
        FOREIGN KEY (estado_id)
        REFERENCES Estados(idEstados),

    CONSTRAINT fk_alertas_cidade
        FOREIGN KEY (cidade_id)
        REFERENCES Cidades(idCidades)
);

CREATE TABLE Notificacoes (
    idNotificacoes INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT NOT NULL,
    alerta_id INT NOT NULL,

    mensagem TEXT,

    CONSTRAINT fk_notificacoes_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES Usuarios(idUsuario),

    CONSTRAINT fk_notificacoes_alerta
        FOREIGN KEY (alerta_id)
        REFERENCES Alertas(idAlertas)
);

CREATE TABLE Denuncias (
    idDenuncias INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT NOT NULL,
    desaparecidos_id INT NOT NULL,
    avistamento_id INT,

    descricao TEXT,
    data_denuncia DATETIME,

    CONSTRAINT fk_denuncias_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES Usuarios(idUsuario),

    CONSTRAINT fk_denuncias_desaparecido
        FOREIGN KEY (desaparecidos_id)
        REFERENCES Desaparecidos(idDesaparecidos),

    CONSTRAINT fk_denuncias_avistamento
        FOREIGN KEY (avistamento_id)
        REFERENCES Avistamentos(idAvistamento)
);

CREATE TABLE Solicitacoes_reencontro (
    idSolicitacao INT AUTO_INCREMENT PRIMARY KEY,

    desaparecido_id INT NOT NULL,
    usuario_id INT NOT NULL,

    descricao TEXT,

    status ENUM(
        'PENDENTE',
        'APROVADA',
        'REJEITADA'
    ) NOT NULL DEFAULT 'PENDENTE',

    administrador_id INT NULL,

    data_solicitacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_analise DATETIME NULL,

    CONSTRAINT fk_reencontro_desaparecido
        FOREIGN KEY (desaparecido_id)
        REFERENCES Desaparecidos(idDesaparecidos),

    CONSTRAINT fk_reencontro_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES Usuarios(idUsuario),

    CONSTRAINT fk_reencontro_administrador
        FOREIGN KEY (administrador_id)
        REFERENCES Usuarios(idUsuario)
);

CREATE TABLE Historico_desaparecido (
    idHistorico INT AUTO_INCREMENT PRIMARY KEY,

    desaparecido_id INT NOT NULL,
    usuario_id INT NULL,

    acao ENUM(
        'CADASTRO',
        'APROVACAO',
        'REJEICAO',
        'SOLICITACAO_REENCONTRO',
        'REENCONTRO_APROVADO',
        'REENCONTRO_REJEITADO',
        'ARQUIVAMENTO'
    ) NOT NULL,

    descricao TEXT,

    data_acao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_historico_desaparecido
        FOREIGN KEY (desaparecido_id)
        REFERENCES Desaparecidos(idDesaparecidos),

    CONSTRAINT fk_historico_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES Usuarios(idUsuario)
);

CREATE TABLE Mensagens_contato (
    idMensagens_contato INT AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(100),
    email VARCHAR(120),
    assunto VARCHAR(150),
    mensagem TEXT
);

CREATE TABLE Parceiros (
    idParceiros INT AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(100),
    tipo ENUM(
        'ONG',
        'EMPRESA',
        'ORGAO_PUBLICO',
        'POLICIA',
        'OUTRO'
    ),
    telefone VARCHAR(20),
    email VARCHAR(120),
    descricao TEXT,
    data_cadastro DATETIME
);
