CREATE DATABASE IF NOT EXISTS VARG;
USE VARG;

CREATE TABLE IF NOT EXISTS Usuarios (
  idUsuario INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL,
  telefone VARCHAR(20) NULL,
  tipo_usuario ENUM('admin', 'usuario', 'autoridade') NOT NULL DEFAULT 'usuario',
  role ENUM('USUARIO', 'ADMIN') NOT NULL DEFAULT 'USUARIO',
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idUsuario)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Estados (
  idEstados INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Cidades (
  idCidades INT AUTO_INCREMENT PRIMARY KEY,
  estado_id INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  CONSTRAINT fk_cidades_estado
    FOREIGN KEY (estado_id)
    REFERENCES Estados (idEstados)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS boletim_ocorrencia (
  idboletim_ocorrencia INT NOT NULL AUTO_INCREMENT,
  numero_bo VARCHAR(50) NULL,
  data_registro DATETIME NULL,
  orgao_registro VARCHAR(150) NULL,
  delegacia VARCHAR(150) NULL,
  descricao TEXT NULL,
  PRIMARY KEY (idboletim_ocorrencia)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Desaparecidos (
  idDesaparecidos INT NOT NULL AUTO_INCREMENT,
  usuario_id INT NOT NULL,
  boletim_ocorrencia_id INT NULL,
  cidade_id INT NULL,
  nome VARCHAR(150) NOT NULL,
  nome_social VARCHAR(45) NULL,
  alcunha_apelido VARCHAR(50) NULL,
  data_nascimento DATE NULL,
  idade_desaparecimento INT NULL,
  sexo ENUM('MASCULINO', 'FEMININO', 'OUTRO') NULL,
  genero ENUM('Masculino', 'Feminino', 'Outro', 'Não Informado') NOT NULL DEFAULT 'Não Informado',
  cor_pele VARCHAR(45) NULL,
  cor_olhos VARCHAR(45) NULL,
  cor_cabelo VARCHAR(45) NULL,
  altura DECIMAL(5,2) NULL,
  peso DECIMAL(5,2) NULL,
  marcas_caracteristicas TEXT NULL,
  caracteristicas TEXT NULL,
  ultima_roupa TEXT NULL,
  descricao TEXT NULL,
  foto_url VARCHAR(500) NULL,
  status ENUM('PENDENTE', 'ATIVO', 'ENCONTRADO', 'REJEITADO', 'ARQUIVADO', 'Desaparecido', 'Encontrado Bem', 'Encontrado Óbito') NOT NULL DEFAULT 'PENDENTE',
  data_desaparecimento DATETIME NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idDesaparecidos),
  CONSTRAINT fk_desaparecidos_usuario
    FOREIGN KEY (usuario_id)
    REFERENCES Usuarios (idUsuario)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_desaparecidos_boletim
    FOREIGN KEY (boletim_ocorrencia_id)
    REFERENCES boletim_ocorrencia (idboletim_ocorrencia)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_desaparecidos_cidade
    FOREIGN KEY (cidade_id)
    REFERENCES Cidades (idCidades)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS detalhes_desaparecimento (
  id_detalhe INT NOT NULL AUTO_INCREMENT,
  id_desaparecido INT NOT NULL,
  data_desaparecimento DATE NOT NULL,
  hora_desaparecimento TIME NULL,
  estado_uf CHAR(2) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  bairro VARCHAR(100) NULL,
  ultimo_local_visto TEXT NULL,
  vestimentas_usadas TEXT NULL,
  circunstancias TEXT NULL,
  boletim_ocorrencia VARCHAR(50) NULL,
  PRIMARY KEY (id_detalhe),
  UNIQUE INDEX id_desaparecido_UNIQUE (id_desaparecido ASC),
  CONSTRAINT fk_detalhes_desaparecido
    FOREIGN KEY (id_desaparecido)
    REFERENCES Desaparecidos (idDesaparecidos)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Avistamentos (
  idAvistamento INT NOT NULL AUTO_INCREMENT,
  desaparecidos_id INT NOT NULL,
  usuario_id INT NULL,
  cidade_id INT NOT NULL,
  data_avistamento DATETIME NOT NULL,
  hora_avistamento TIME NULL,
  cidade VARCHAR(100) NULL,
  estado_uf CHAR(2) NULL,
  descricao_local TEXT NULL,
  endereco VARCHAR(255) NULL,
  descricao TEXT NULL,
  informacoes_adicionais TEXT NULL,
  status_pista ENUM('Pendente', 'Em Investigação', 'Confirmada', 'Descartada') NOT NULL DEFAULT 'Pendente',
  data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idAvistamento),
  CONSTRAINT fk_avistamentos_desaparecido
    FOREIGN KEY (desaparecidos_id)
    REFERENCES Desaparecidos (idDesaparecidos)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_avistamentos_usuario
    FOREIGN KEY (usuario_id)
    REFERENCES Usuarios (idUsuario)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_avistamentos_cidade
    FOREIGN KEY (cidade_id)
    REFERENCES Cidades (idCidades)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Alertas (
    idAlertas INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    estado_id INT NOT NULL,
    cidade_id INT NOT NULL,
    descricao TEXT,
    CONSTRAINT fk_alertas_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios (idUsuario),
    CONSTRAINT fk_alertas_estado FOREIGN KEY (estado_id) REFERENCES Estados (idEstados),
    CONSTRAINT fk_alertas_cidade FOREIGN KEY (cidade_id) REFERENCES Cidades (idCidades)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Notificacoes (
    idNotificacoes INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    alerta_id INT NOT NULL,
    mensagem TEXT,
    CONSTRAINT fk_notificacoes_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios (idUsuario),
    CONSTRAINT fk_notificacoes_alerta FOREIGN KEY (alerta_id) REFERENCES Alertas (idAlertas)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Denuncias (
    idDenuncias INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    desaparecidos_id INT NOT NULL,
    avistamento_id INT,
    descricao TEXT,
    data_denuncia DATETIME,
    CONSTRAINT fk_denuncias_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios (idUsuario),
    CONSTRAINT fk_denuncias_desaparecido FOREIGN KEY (desaparecidos_id) REFERENCES Desaparecidos (idDesaparecidos),
    CONSTRAINT fk_denuncias_avistamento FOREIGN KEY (avistamento_id) REFERENCES Avistamentos (idAvistamento)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Solicitacoes_reencontro (
    idSolicitacao INT AUTO_INCREMENT PRIMARY KEY,
    desaparecido_id INT NOT NULL,
    usuario_id INT NOT NULL,
    descricao TEXT,
    status ENUM('PENDENTE', 'APROVADA', 'REJEITADA') NOT NULL DEFAULT 'PENDENTE',
    administrador_id INT NULL,
    data_solicitacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_analise DATETIME NULL,
    CONSTRAINT fk_reencontro_desaparecido FOREIGN KEY (desaparecido_id) REFERENCES Desaparecidos (idDesaparecidos),
    CONSTRAINT fk_reencontro_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios (idUsuario),
    CONSTRAINT fk_reencontro_administrador FOREIGN KEY (administrador_id) REFERENCES Usuarios (idUsuario)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Historico_desaparecido (
    idHistorico INT AUTO_INCREMENT PRIMARY KEY,
    desaparecido_id INT NOT NULL,
    usuario_id INT NULL,
    acao ENUM('CADASTRO', 'APROVACAO', 'REJEICAO', 'SOLICITACAO_REENCONTRO', 'REENCONTRO_APROVADO', 'REENCONTRO_REJEITADO', 'ARQUIVAMENTO') NOT NULL,
    descricao TEXT,
    data_acao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historico_desaparecido FOREIGN KEY (desaparecido_id) REFERENCES Desaparecidos (idDesaparecidos),
    CONSTRAINT fk_historico_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios (idUsuario)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Mensagens_contato (
    idMensagens_contato INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(120),
    assunto VARCHAR(150),
    mensagem TEXT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Parceiros (
    idParceiros INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    tipo ENUM('ONG', 'EMPRESA', 'ORGAO_PUBLICO', 'POLICIA', 'OUTRO'),
    telefone VARCHAR(20),
    email VARCHAR(120),
    descricao TEXT,
    data_cadastro DATETIME
) ENGINE = InnoDB;