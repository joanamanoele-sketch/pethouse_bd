-- PetHouse - conversao de PostgreSQL para MySQL
-- Importar este arquivo pelo phpMyAdmin em um banco MySQL/MariaDB.
-- Conteudo: estrutura, dados, chaves, indices e restricoes.
-- Recomendado: MySQL 8.0.16+ ou MariaDB com suporte a CHECK.

CREATE DATABASE IF NOT EXISTS `pethouse`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pethouse`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(120) NOT NULL,
  `telefone` VARCHAR(20) DEFAULT NULL,
  `email` VARCHAR(150) DEFAULT NULL,
  `endereco` VARCHAR(255) DEFAULT NULL,
  `data_cadastro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `cliente_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `categoria` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` TEXT DEFAULT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `categoria_nome_key` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fornecedor` (
  `id_fornecedor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `cnpj` VARCHAR(18) NOT NULL,
  `telefone` VARCHAR(20) DEFAULT NULL,
  `email` VARCHAR(150) DEFAULT NULL,
  `endereco` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id_fornecedor`),
  UNIQUE KEY `fornecedor_cnpj_key` (`cnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `pet` (
  `id_pet` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `tipo` VARCHAR(50) NOT NULL,
  `raca` VARCHAR(100) DEFAULT NULL,
  `idade` SMALLINT DEFAULT NULL,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id_pet`),
  CONSTRAINT `pet_idade_check` CHECK (`idade` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `produto` (
  `id_produto` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `descricao` TEXT DEFAULT NULL,
  `preco` DECIMAL(10,2) NOT NULL,
  `categoria_id` INT NOT NULL,
  PRIMARY KEY (`id_produto`),
  CONSTRAINT `produto_preco_check` CHECK (`preco` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(30) NOT NULL DEFAULT 'pendente',
  `total` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  CONSTRAINT `pedido_status_check` CHECK (`status` IN ('pendente','pago','enviado','entregue','cancelado')),
  CONSTRAINT `pedido_total_check` CHECK (`total` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `agendamento` (
  `id_agendamento` INT NOT NULL AUTO_INCREMENT,
  `data` DATE NOT NULL,
  `horario` TIME NOT NULL,
  `tipo_procedimento` VARCHAR(100) NOT NULL,
  `status` VARCHAR(30) NOT NULL DEFAULT 'agendado',
  `pet_id` INT NOT NULL,
  PRIMARY KEY (`id_agendamento`),
  CONSTRAINT `agendamento_status_check` CHECK (`status` IN ('agendado','confirmado','concluido','cancelado'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `estoque` (
  `id_estoque` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NOT NULL DEFAULT 0,
  `estoque_minimo` INT NOT NULL DEFAULT 0,
  `produto_id` INT NOT NULL,
  `fornecedor_id` INT DEFAULT NULL,
  PRIMARY KEY (`id_estoque`),
  UNIQUE KEY `estoque_produto_id_key` (`produto_id`),
  KEY `idx_estoque_fornecedor` (`fornecedor_id`),
  CONSTRAINT `estoque_estoque_minimo_check` CHECK (`estoque_minimo` >= 0),
  CONSTRAINT `estoque_quantidade_check` CHECK (`quantidade` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `feedback` (
  `id_feedback` INT NOT NULL AUTO_INCREMENT,
  `nota` SMALLINT NOT NULL,
  `comentario` TEXT DEFAULT NULL,
  `cliente_id` INT NOT NULL,
  `pedido_id` INT NOT NULL,
  PRIMARY KEY (`id_feedback`),
  CONSTRAINT `feedback_nota_check` CHECK (`nota` BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fornecedor_produto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fornecedor_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  `preco_compra` DECIMAL(10,2) NOT NULL,
  `data_fornecimento` DATE DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fornecedor_produto` (`fornecedor_id`,`produto_id`),
  KEY `idx_fp_produto` (`produto_id`),
  CONSTRAINT `fornecedor_produto_preco_compra_check` CHECK (`preco_compra` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `item_pedido` (
  `id_item` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NOT NULL,
  `preco_unitario` DECIMAL(10,2) NOT NULL,
  `pedido_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  PRIMARY KEY (`id_item`),
  KEY `idx_item_pedido_pedido` (`pedido_id`),
  KEY `idx_item_pedido_produto` (`produto_id`),
  CONSTRAINT `item_pedido_preco_unitario_check` CHECK (`preco_unitario` >= 0),
  CONSTRAINT `item_pedido_quantidade_check` CHECK (`quantidade` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `orcamento` (
  `id_orcamento` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(30) NOT NULL DEFAULT 'aberto',
  `total` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `cliente_id` INT NOT NULL,
  `pedido_id` INT DEFAULT NULL,
  PRIMARY KEY (`id_orcamento`),
  KEY `idx_orcamento_cliente` (`cliente_id`),
  KEY `idx_orcamento_pedido` (`pedido_id`),
  CONSTRAINT `orcamento_status_check` CHECK (`status` IN ('aberto','aprovado','recusado','expirado')),
  CONSTRAINT `orcamento_total_check` CHECK (`total` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dados originais exportados do PostgreSQL.


INSERT INTO `cliente` (`id_cliente`, `nome`, `telefone`, `email`, `endereco`, `data_cadastro`) VALUES
  ('1', 'Ana Beatriz Souza', '(11) 98765-4321', 'ana.souza@email.com', 'Rua das Acacias, 120 - Vila Mariana, Sao Paulo/SP', '2026-01-15 10:30:00'),
  ('2', 'Carlos Eduardo Lima', '(11) 97654-3210', 'carlos.lima@email.com', 'Av. Paulista, 1578 - Bela Vista, Sao Paulo/SP', '2026-02-03 14:10:00'),
  ('3', 'Fernanda Oliveira', '(11) 96543-2109', 'fernanda.oliveira@email.com', 'Rua Augusta, 900 - Consolacao, Sao Paulo/SP', '2026-02-20 09:45:00'),
  ('4', 'Ricardo Mendes', '(11) 95432-1098', 'ricardo.mendes@email.com', 'Rua Oscar Freire, 455 - Pinheiros, Sao Paulo/SP', '2026-03-11 16:00:00'),
  ('5', 'Juliana Castro', '(11) 94321-0987', 'juliana.castro@email.com', 'Rua Vergueiro, 2300 - Liberdade, Sao Paulo/SP', '2026-04-07 11:20:00'),
  ('6', 'Marcos Vinicius Rocha', '(11) 93210-9876', 'marcos.rocha@email.com', 'Rua Domingos de Morais, 640 - Vila Mariana, Sao Paulo/SP', '2026-05-18 13:35:00'),
  ('7', 'Patricia Almeida', '(11) 92109-8765', 'patricia.almeida@email.com', 'Av. Brigadeiro Faria Lima, 3000 - Itaim Bibi, Sao Paulo/SP', '2026-06-25 15:50:00'),
  ('8', 'Lucas Ferreira', '(11) 91098-7654', 'lucas.ferreira@email.com', 'Rua Teodoro Sampaio, 780 - Pinheiros, Sao Paulo/SP', '2026-08-02 08:15:00');


INSERT INTO `categoria` (`id_categoria`, `nome`, `descricao`) VALUES
  ('1', 'Alimentacao', 'Racoes, saches e petiscos para caes e gatos'),
  ('2', 'Higiene e Beleza', 'Shampoos, condicionadores e escovas'),
  ('3', 'Brinquedos', 'Brinquedos e arranhadores para diversao e enriquecimento'),
  ('4', 'Acessorios', 'Coleiras, peitorais, camas e guias'),
  ('5', 'Saude e Bem-estar', 'Vermifugos, antipulgas e suplementos');


INSERT INTO `fornecedor` (`id_fornecedor`, `nome`, `cnpj`, `telefone`, `email`, `endereco`) VALUES
  ('1', 'NutriPet Alimentos Ltda', '12.345.678/0001-90', '(11) 3456-7890', 'contato@nutripet.com.br', 'Av. das Industrias, 1500 - Sao Paulo/SP'),
  ('2', 'BelaPet Cosmeticos', '23.456.789/0001-01', '(11) 3567-8901', 'vendas@belapet.com.br', 'Rua das Flores, 220 - Guarulhos/SP'),
  ('3', 'Diverte Pet Acessorios', '34.567.890/0001-12', '(19) 3678-9012', 'comercial@divertepet.com', 'Rod. Anhanguera km 98 - Campinas/SP'),
  ('4', 'VetSaude Distribuidora', '45.678.901/0001-23', '(11) 3789-0123', 'pedidos@vetsaude.com.br', 'Rua Dr. Almeida, 85 - Sao Paulo/SP');


INSERT INTO `pet` (`id_pet`, `nome`, `tipo`, `raca`, `idade`, `cliente_id`) VALUES
  ('1', 'Thor', 'Cao', 'Golden Retriever', '4', '1'),
  ('2', 'Mel', 'Gato', 'Siames', '2', '1'),
  ('3', 'Bobby', 'Cao', 'Poodle', '7', '2'),
  ('4', 'Luna', 'Gato', 'Persa', '3', '3'),
  ('5', 'Rex', 'Cao', 'Pastor Alemao', '5', '4'),
  ('6', 'Nina', 'Cao', 'Shih Tzu', '2', '5'),
  ('7', 'Pipoca', 'Coelho', 'Mini Lop', '1', '5'),
  ('8', 'Zeca', 'Cao', 'Vira-lata', '9', '6'),
  ('9', 'Mimi', 'Gato', 'SRD', '6', '7'),
  ('10', 'Bidu', 'Cao', 'Beagle', '3', '7'),
  ('11', 'Kiwi', 'Ave', 'Calopsita', '2', '8'),
  ('12', 'Fred', 'Cao', 'Bulldog Frances', '4', '8');


INSERT INTO `produto` (`id_produto`, `nome`, `descricao`, `preco`, `categoria_id`) VALUES
  ('1', 'Racao Premium Caes Adultos 15kg', 'Racao super premium sabor frango e arroz para caes adultos', '189.90', '1'),
  ('2', 'Racao Premium Gatos Castrados 10kg', 'Racao com controle de peso para gatos castrados', '159.90', '1'),
  ('3', 'Petisco Bifinho Carne 500g', 'Petisco macio sabor carne para caes', '24.90', '1'),
  ('4', 'Sache Gatos Filhotes 85g', 'Alimento umido para gatos filhotes', '4.50', '1'),
  ('5', 'Shampoo Neutro 500ml', 'Shampoo hipoalergenico para caes e gatos', '32.00', '2'),
  ('6', 'Condicionador Pelos Longos 500ml', 'Facilita o desembaraco e deixa o pelo macio', '35.50', '2'),
  ('7', 'Escova Removedora de Pelos', 'Escova com cerdas macias para remocao de pelos soltos', '29.90', '2'),
  ('8', 'Bola de Borracha Macica', 'Brinquedo resistente para caes de medio porte', '18.90', '3'),
  ('9', 'Arranhador Torre para Gatos', 'Torre com 3 andares e esconderijo', '119.00', '3'),
  ('10', 'Corda Mordedor', 'Corda de algodao trancado para brincar e limpar os dentes', '15.50', '3'),
  ('11', 'Coleira Ajustavel M', 'Coleira de nylon com fecho de seguranca, tamanho M', '39.90', '4'),
  ('12', 'Cama Pet Media', 'Cama acolchoada lavavel para caes e gatos de porte medio', '89.90', '4'),
  ('13', 'Peitoral com Guia', 'Peitoral acolchoado com guia de 1,2m', '54.90', '4'),
  ('14', 'Vermifugo Caes 4 comprimidos', 'Vermifugo de amplo espectro para caes', '49.90', '5'),
  ('15', 'Antipulgas Gatos Pipeta', 'Pipeta antipulgas e carrapatos para gatos', '69.90', '5');


INSERT INTO `pedido` (`id_pedido`, `data`, `status`, `total`, `cliente_id`) VALUES
  ('1', '2026-10-02 10:15:00', 'entregue', '239.70', '1'),
  ('2', '2026-10-05 15:40:00', 'entregue', '186.90', '2'),
  ('3', '2026-10-10 11:05:00', 'pago', '97.40', '3'),
  ('4', '2026-10-14 17:30:00', 'enviado', '150.00', '4'),
  ('5', '2026-10-16 09:20:00', 'entregue', '94.80', '5'),
  ('6', '2026-10-22 13:55:00', 'pendente', '189.70', '6'),
  ('7', '2026-10-24 16:10:00', 'entregue', '146.60', '1'),
  ('8', '2026-10-25 12:00:00', 'cancelado', '189.90', '7');


INSERT INTO `agendamento` (`id_agendamento`, `data`, `horario`, `tipo_procedimento`, `status`, `pet_id`) VALUES
  ('1', '2026-10-20', '09:00:00', 'Banho', 'concluido', '1'),
  ('2', '2026-10-21', '10:30:00', 'Tosa higienica', 'concluido', '3'),
  ('3', '2026-10-22', '14:00:00', 'Consulta veterinaria', 'concluido', '4'),
  ('4', '2026-10-23', '11:00:00', 'Banho e tosa', 'cancelado', '5'),
  ('5', '2026-10-27', '09:30:00', 'Banho', 'confirmado', '6'),
  ('6', '2026-10-27', '15:00:00', 'Vacinacao', 'confirmado', '2'),
  ('7', '2026-10-28', '10:00:00', 'Banho e tosa', 'agendado', '10'),
  ('8', '2026-10-29', '13:30:00', 'Consulta veterinaria', 'agendado', '9'),
  ('9', '2026-10-30', '16:00:00', 'Corte de unhas', 'agendado', '7'),
  ('10', '2026-11-03', '09:00:00', 'Banho', 'agendado', '12'),
  ('11', '2026-11-05', '11:30:00', 'Tosa higienica', 'agendado', '8'),
  ('12', '2026-11-10', '14:30:00', 'Check-up geral', 'agendado', '11');


INSERT INTO `estoque` (`id_estoque`, `quantidade`, `estoque_minimo`, `produto_id`, `fornecedor_id`) VALUES
  ('1', '25', '10', '1', '1'),
  ('2', '18', '8', '2', '1'),
  ('3', '60', '20', '3', '1'),
  ('4', '150', '50', '4', '1'),
  ('5', '40', '15', '5', '2'),
  ('6', '35', '15', '6', '2'),
  ('7', '22', '10', '7', '2'),
  ('8', '45', '15', '8', '3'),
  ('9', '8', '5', '9', '3'),
  ('10', '70', '25', '10', '3'),
  ('11', '30', '12', '11', '3'),
  ('12', '12', '6', '12', '3'),
  ('13', '20', '8', '13', '3'),
  ('14', '28', '10', '14', '4'),
  ('15', '4', '10', '15', '4');


INSERT INTO `feedback` (`id_feedback`, `nota`, `comentario`, `cliente_id`, `pedido_id`) VALUES
  ('1', '5', 'Entrega rapida e produtos de otima qualidade. Meu Thor adorou a racao!', '1', '1'),
  ('2', '4', 'Gostei muito, so demorou um pouco para chegar.', '2', '2'),
  ('3', '5', 'Atendimento excelente e a coleira e muito confortavel.', '5', '5'),
  ('4', '4', 'A cama e otima, as bolinhas poderiam ser um pouco maiores.', '1', '7'),
  ('5', '3', 'Produtos bons, mas o pedido veio sem a nota fiscal.', '3', '3');


INSERT INTO `fornecedor_produto` (`id`, `fornecedor_id`, `produto_id`, `preco_compra`, `data_fornecimento`) VALUES
  ('1', '1', '1', '135.00', '2026-09-10'),
  ('2', '1', '2', '112.00', '2026-09-10'),
  ('3', '1', '3', '14.50', '2026-09-10'),
  ('4', '1', '4', '2.80', '2026-09-10'),
  ('5', '2', '5', '19.00', '2026-09-15'),
  ('6', '2', '6', '21.50', '2026-09-15'),
  ('7', '2', '7', '16.00', '2026-09-15'),
  ('8', '3', '7', '17.50', '2026-09-20'),
  ('9', '3', '8', '9.50', '2026-09-20'),
  ('10', '3', '9', '75.00', '2026-09-20'),
  ('11', '3', '10', '8.00', '2026-09-20'),
  ('12', '3', '11', '22.00', '2026-09-22'),
  ('13', '3', '12', '55.00', '2026-09-22'),
  ('14', '3', '13', '32.00', '2026-09-22'),
  ('15', '4', '14', '31.00', '2026-10-01'),
  ('16', '4', '15', '45.00', '2026-10-01');


INSERT INTO `item_pedido` (`id_item`, `quantidade`, `preco_unitario`, `pedido_id`, `produto_id`) VALUES
  ('1', '1', '189.90', '1', '1'),
  ('2', '2', '24.90', '1', '3'),
  ('3', '1', '159.90', '2', '2'),
  ('4', '6', '4.50', '2', '4'),
  ('5', '1', '32.00', '3', '5'),
  ('6', '1', '35.50', '3', '6'),
  ('7', '1', '29.90', '3', '7'),
  ('8', '1', '119.00', '4', '9'),
  ('9', '2', '15.50', '4', '10'),
  ('10', '1', '39.90', '5', '11'),
  ('11', '1', '54.90', '5', '13'),
  ('12', '1', '49.90', '6', '14'),
  ('13', '2', '69.90', '6', '15'),
  ('14', '1', '89.90', '7', '12'),
  ('15', '3', '18.90', '7', '8'),
  ('16', '1', '189.90', '8', '1');


INSERT INTO `orcamento` (`id_orcamento`, `data`, `status`, `total`, `cliente_id`, `pedido_id`) VALUES
  ('1', '2026-10-01 18:00:00', 'aprovado', '239.70', '1', '1'),
  ('2', '2026-10-09 10:30:00', 'aprovado', '97.40', '3', '3'),
  ('3', '2026-10-15 14:20:00', 'aprovado', '94.80', '5', '5'),
  ('4', '2026-10-20 09:10:00', 'aberto', '320.00', '8', NULL),
  ('5', '2026-10-21 16:45:00', 'recusado', '85.00', '2', NULL);


-- Indices adicionais do banco original.
CREATE INDEX `idx_agendamento_data` ON `agendamento` (`data`, `horario`);
CREATE INDEX `idx_agendamento_pet` ON `agendamento` (`pet_id`);
CREATE INDEX `idx_feedback_cliente` ON `feedback` (`cliente_id`);
CREATE INDEX `idx_feedback_pedido` ON `feedback` (`pedido_id`);
CREATE INDEX `idx_pedido_cliente` ON `pedido` (`cliente_id`);
CREATE INDEX `idx_pet_cliente` ON `pet` (`cliente_id`);
CREATE INDEX `idx_produto_categoria` ON `produto` (`categoria_id`);

-- Relacionamentos (chaves estrangeiras).
ALTER TABLE `pet`
  ADD CONSTRAINT `fk_pet_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id_cliente`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `produto`
  ADD CONSTRAINT `fk_produto_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id_categoria`) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE `pedido`
  ADD CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id_cliente`) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE `agendamento`
  ADD CONSTRAINT `fk_agendamento_pet` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id_pet`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `estoque`
  ADD CONSTRAINT `fk_estoque_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id_produto`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_estoque_fornecedor` FOREIGN KEY (`fornecedor_id`) REFERENCES `fornecedor` (`id_fornecedor`) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE `feedback`
  ADD CONSTRAINT `fk_feedback_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id_cliente`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_feedback_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id_pedido`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `fornecedor_produto`
  ADD CONSTRAINT `fk_fp_fornecedor` FOREIGN KEY (`fornecedor_id`) REFERENCES `fornecedor` (`id_fornecedor`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_fp_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id_produto`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `item_pedido`
  ADD CONSTRAINT `fk_item_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id_pedido`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_item_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id_produto`) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE `orcamento`
  ADD CONSTRAINT `fk_orcamento_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id_cliente`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_orcamento_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id_pedido`) ON UPDATE CASCADE ON DELETE SET NULL;

SET FOREIGN_KEY_CHECKS = 1;
