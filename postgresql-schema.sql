-- phpMyAdmin SQL Dump

-- version 5.2.1

-- https://www.phpmyadmin.net/

--

-- Host: 127.0.0.1

-- Tempo de geração: 04/06/2026 às 23:04

-- Versão do servidor: 10.4.32-MariaDB

-- Versão do PHP: 8.2.12

--

-- Banco de dados: `helping_hands`

--

DECLARE v_id_doador   INT UNSIGNED;

DECLARE v_id_confirmacao INT UNSIGNED;

DECLARE v_id_cupom    INT UNSIGNED;

SELECT id_donativo, id_doador INTO v_id_donativo, v_id_doador
    FROM agendamentos_doacao WHERE id_agendamento = p_id_agendamento;

UPDATE agendamentos_doacao SET status_agendamento = 'RECEBIDO'
   WHERE id_agendamento = p_id_agendamento;

UPDATE donativos SET status_donativo = 'CONCLUIDO'
   WHERE id_donativo = v_id_donativo;

INSERT INTO confirmacoes_recebimento(id_agendamento,nota,comentario,item_corresponde_descricao)
    VALUES(p_id_agendamento, p_nota, p_comentario, p_item_corresponde);

SELECT id_cupom INTO v_id_cupom FROM cupons
   WHERE status_cupom='DISPONIVEL' AND validade>=CURRENT_DATE
   ORDER BY id_cupom LIMIT 1;

IF v_id_cupom IS NOT NULL THEN
    INSERT INTO cupons_doador(id_cupom,id_doador,id_donativo,id_confirmacao)
      VALUES(v_id_cupom, v_id_doador, v_id_donativo, v_id_confirmacao);

END IF;

END$$

DELIMITER;

-- --------------------------------------------------------

--
-- Estrutura para tabela `admin_mensagens`
--

CREATE TABLE `admin_mensagens` (
  `id_admin_mensagem` int(10) UNSIGNED NOT NULL,
  `id_admin` int(10) UNSIGNED NOT NULL,
  `id_usuario_destino` int(10) UNSIGNED NOT NULL,
  `direcao` enum('ADMIN_PARA_USUARIO','USUARIO_PARA_ADMIN') NOT NULL DEFAULT 'ADMIN_PARA_USUARIO',
  `assunto` varchar(150) DEFAULT NULL,
  `conteudo` varchar(1000) NOT NULL,
  `lida` tinyint(1) NOT NULL DEFAULT 0,
  `criada_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `admin_mensagens`

--

INSERT INTO admin_mensagens (id_admin_mensagem, id_admin, id_usuario_destino, direcao, assunto, conteudo, lida, criada_em) VALUES
(1, 4, 1, 'ADMIN_PARA_USUARIO', 'Bem-vindo', 'Seja bem-vindo à plataforma Helping Hands!', 1, '2026-06-01 13:00:00'),
(2, 4, 6, 'ADMIN_PARA_USUARIO', 'Bem-vindo', 'Seja bem-vindo ao Helping Hands! Faça suas primeiras doações.', 1, '2026-06-01 13:42:06');

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamentos_doacao`
--

CREATE TABLE `agendamentos_doacao` (
  `id_agendamento` int(10) UNSIGNED NOT NULL,
  `id_donativo` int(10) UNSIGNED NOT NULL,
  `id_doador` int(10) UNSIGNED NOT NULL,
  `id_instituicao` int(10) UNSIGNED NOT NULL,
  `id_necessidade` int(10) UNSIGNED DEFAULT NULL,
  `id_interesse` bigint(20) UNSIGNED DEFAULT NULL,
  `id_interesse_donativo` bigint(20) UNSIGNED DEFAULT NULL,
  `id_usuario_criador_agendamento` int(10) UNSIGNED DEFAULT NULL,
  `doador_confirmou_agendamento` tinyint(1) NOT NULL DEFAULT 0,
  `instituicao_confirmou_agendamento` tinyint(1) NOT NULL DEFAULT 0,
  `confirmado_agendamento_em` datetime DEFAULT NULL,
  `data_agendada` datetime DEFAULT NULL,
  `local_entrega` varchar(255) DEFAULT NULL,
  `status_agendamento` enum('SOLICITADO','ACEITO','AGENDADO','CANCELADO','RECEBIDO','CONCLUIDO') NOT NULL DEFAULT 'SOLICITADO',
  `observacao` varchar(500) DEFAULT NULL,
  `doador_confirmou_entrega` tinyint(1) NOT NULL DEFAULT 0,
  `doador_confirmou_em` datetime DEFAULT NULL,
  `observacao_confirmacao_doador` varchar(500) DEFAULT NULL,
  `instituicao_confirmou_recebimento` tinyint(1) NOT NULL DEFAULT 0,
  `instituicao_confirmou_em` datetime DEFAULT NULL,
  `observacao_confirmacao_instituicao` text DEFAULT NULL,
  `alerta_1_dia_enviado` tinyint(1) NOT NULL DEFAULT 0,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `agendamentos_doacao`

--

INSERT INTO agendamentos_doacao (id_agendamento, id_donativo, id_doador, id_instituicao, id_necessidade, id_interesse, id_interesse_donativo, id_usuario_criador_agendamento, doador_confirmou_agendamento, instituicao_confirmou_agendamento, confirmado_agendamento_em, data_agendada, local_entrega, status_agendamento, observacao, doador_confirmou_entrega, doador_confirmou_em, observacao_confirmacao_doador, instituicao_confirmou_recebimento, instituicao_confirmou_em, observacao_confirmacao_instituicao, alerta_1_dia_enviado, criado_em, atualizado_em) VALUES
(1, 2, 1, 1, NULL, NULL, NULL, NULL, 1, 1, '2026-06-02 00:21:32', '2026-06-03 12:07:24', 'Sede da Instituição Esperança', 'RECEBIDO', 'Entrega combinada via chat.', 1, '2026-06-01 13:14:15', 'entreguei ontem de manhã', 1, '2026-06-02 00:37:24', 'teste', 0, '2026-06-01 12:07:24', '2026-06-04 20:18:53'),
(2, 3, 1, 1, 7, 1, NULL, NULL, 1, 1, '2026-06-02 00:21:32', '2026-06-01 14:00:00', 'Na sede', 'RECEBIDO', 'Entrega presencial na sede.', 1, '2026-06-01 13:44:35', 'Doei na data informada', 1, '2026-06-02 00:37:16', 'tests', 0, '2026-06-01 13:43:16', '2026-06-04 20:18:53'),
(3, 4, 1, 3, 8, 2, NULL, NULL, 1, 1, '2026-06-02 00:21:32', '2026-06-03 10:40:00', 'Passaremos para coletar', 'RECEBIDO', 'Passaremos no seu endereço para coletar.', 1, '2026-06-01 22:42:33', 'Passaram aqui e coletaram o feijão.', 1, '2026-06-02 03:25:01', 'confirmar', 0, '2026-06-01 22:41:27', '2026-06-04 20:18:53'),
(4, 2, 1, 3, NULL, NULL, NULL, NULL, 1, 1, '2026-06-02 00:21:32', '2026-06-23 10:40:00', 'Na sede', 'RECEBIDO', 'Irei na sede deixar os donativos', 1, '2026-06-01 23:42:06', 'Entrega efetivada', 1, '2026-06-02 03:24:46', 'recebi', 0, '2026-06-01 23:38:24', '2026-06-04 20:18:53'),
(5, 5, 1, 1, NULL, NULL, 1, NULL, 1, 1, '2026-06-02 00:21:32', '2026-06-23 03:44:00', 'Na sede', 'RECEBIDO', 'TESTE', 1, '2026-06-01 23:42:14', 'Entrega efetivada', 1, '2026-06-02 00:37:08', 'teste', 0, '2026-06-01 23:40:29', '2026-06-04 20:18:53'),
(6, 12, 2, 2, NULL, NULL, NULL, NULL, 1, 1, '2026-06-02 02:53:38', '2026-06-16 10:29:00', 'Minha casa', 'RECEBIDO', 'Vão buscar na minha casa', 1, '2026-06-02 19:41:02', 'entreguei', 1, '2026-06-02 19:42:34', 'recebemos', 0, '2026-06-02 02:53:09', '2026-06-04 20:18:53'),
(7, 15, 2, 3, 10, 11, NULL, NULL, 1, 1, '2026-06-02 03:26:13', '2026-06-02 03:25:00', 'teste', 'RECEBIDO', 'teste', 1, '2026-06-02 19:41:14', 'entreguei', 1, '2026-06-02 19:44:39', 'recebemos', 0, '2026-06-02 03:25:34', '2026-06-04 20:18:53');

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento_alteracoes`
--

CREATE TABLE `agendamento_alteracoes` (
  `id_alteracao` bigint(20) UNSIGNED NOT NULL,
  `id_agendamento` int(10) UNSIGNED NOT NULL,
  `id_usuario_solicitante` int(10) UNSIGNED NOT NULL,
  `data_agendada_nova` datetime DEFAULT NULL,
  `local_entrega_novo` varchar(255) DEFAULT NULL,
  `observacao_nova` text DEFAULT NULL,
  `status_alteracao` enum('PENDENTE','CONFIRMADA','RECUSADA','CANCELADA') NOT NULL DEFAULT 'PENDENTE',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `respondido_em` datetime DEFAULT NULL,
  `id_usuario_resposta` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

-- --------------------------------------------------------

--
-- Estrutura para tabela `avaliacoes_doacao`
--

CREATE TABLE `avaliacoes_doacao` (
  `id_avaliacao` bigint(20) UNSIGNED NOT NULL,
  `id_agendamento` int(10) UNSIGNED NOT NULL,
  `nota` int(11) NOT NULL,
  `comentario` text DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `avaliacoes_doacao`

--

INSERT INTO avaliacoes_doacao (id_avaliacao, id_agendamento, nota, comentario, criado_em) VALUES
(1, 5, 4, 'teste', '2026-06-02 00:37:08'),
(2, 2, 5, 'tests', '2026-06-02 00:37:17'),
(3, 1, 5, 'teste', '2026-06-02 00:37:24'),
(4, 4, 5, 'recebi', '2026-06-02 03:24:46'),
(5, 3, 5, 'confirmar', '2026-06-02 03:25:01'),
(6, 6, 5, 'recebemos', '2026-06-02 19:42:34'),
(7, 7, 5, 'recebemos', '2026-06-02 19:44:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `categorias_atendimento`
--

CREATE TABLE `categorias_atendimento` (
  `id_categoria_atendimento` int(10) UNSIGNED NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `categorias_atendimento`

--

INSERT INTO categorias_atendimento (id_categoria_atendimento, nome, descricao, ativo) VALUES
(1, 'Assistência Social', 'Atendimento a famílias e pessoas em vulnerabilidade', 1),
(2, 'Educação', 'Projetos educacionais e apoio escolar', 1),
(3, 'Saúde', 'Apoio à saúde e cuidados básicos', 1),
(4, 'Moradia', 'Acolhimento e apoio habitacional', 1),
(5, 'Infância e Juventude', 'Atendimento a crianças e adolescentes', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `categorias_donativo`
--

CREATE TABLE `categorias_donativo` (
  `id_categoria` int(10) UNSIGNED NOT NULL,
  `nome` varchar(80) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `exige_validade` tinyint(1) NOT NULL DEFAULT 0,
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `categorias_donativo`

--

INSERT INTO categorias_donativo (id_categoria, nome, descricao, exige_validade, ativo) VALUES
(1, 'Alimentos', 'Itens alimentícios não vencidos e em condições adequadas', 1, 1),
(2, 'Roupas', 'Roupas e calçados em condições de uso', 0, 1),
(3, 'Móveis', 'Móveis reutilizáveis', 0, 1),
(4, 'Higiene', 'Produtos de higiene pessoal e limpeza', 1, 1),
(5, 'Eletrônicos', 'Equipamentos eletrônicos em funcionamento', 0, 1),
(6, 'Material Escolar', 'Materiais escolares novos ou em bom estado', 0, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `confirmacoes_recebimento`
--

CREATE TABLE `confirmacoes_recebimento` (
  `id_confirmacao` int(10) UNSIGNED NOT NULL,
  `id_agendamento` int(10) UNSIGNED NOT NULL,
  `nota` tinyint(3) UNSIGNED NOT NULL,
  `comentario` varchar(500) DEFAULT NULL,
  `item_corresponde_descricao` tinyint(1) NOT NULL DEFAULT 1,
  `confirmado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `confirmacoes_recebimento`

--

INSERT INTO confirmacoes_recebimento (id_confirmacao, id_agendamento, nota, comentario, item_corresponde_descricao, confirmado_em) VALUES
(1, 1, 5, 'Item recebido em bom estado.', 1, '2026-06-01 12:08:33'),
(2, 2, 5, 'Tudo certo', 1, '2026-06-01 13:45:47'),
(3, 3, 5, 'Passamos e coletamos os feijões', 1, '2026-06-01 22:43:12'),
(4, 4, 5, 'Recebemos', 1, '2026-06-01 23:43:17'),
(5, 5, 5, 'Confirmamos a doação', 1, '2026-06-01 23:56:41'),
(6, 6, 5, 'recebemos', 1, '2026-06-02 19:42:34'),
(7, 7, 5, 'recebemos', 1, '2026-06-02 19:44:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `conversas`
--

CREATE TABLE `conversas` (
  `id_conversa` int(10) UNSIGNED NOT NULL,
  `id_doador` int(10) UNSIGNED NOT NULL,
  `id_instituicao` int(10) UNSIGNED NOT NULL,
  `id_donativo` int(10) UNSIGNED DEFAULT NULL,
  `status_conversa` enum('ABERTA','ENCERRADA') NOT NULL DEFAULT 'ABERTA',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `encerrada_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `conversas`

--

INSERT INTO conversas (id_conversa, id_doador, id_instituicao, id_donativo, status_conversa, criado_em, atualizado_em, encerrada_em) VALUES
(1, 1, 1, 2, 'ENCERRADA', '2026-06-01 12:07:24', '2026-06-04 20:18:53', '2026-06-01 23:36:32'),
(2, 1, 1, 3, 'ENCERRADA', '2026-06-01 13:39:47', '2026-06-04 20:18:53', '2026-06-01 23:36:20'),
(3, 1, 3, 4, 'ABERTA', '2026-06-01 22:38:15', '2026-06-04 20:18:53', NULL),
(4, 1, 1, 5, 'ENCERRADA', '2026-06-01 23:14:17', '2026-06-04 20:18:53', '2026-06-01 23:35:53'),
(5, 1, 3, 2, 'ENCERRADA', '2026-06-01 23:42:06', '2026-06-04 20:18:53', '2026-06-01 23:49:56'),
(6, 1, 2, 6, 'ABERTA', '2026-06-02 00:07:43', '2026-06-04 20:18:53', NULL),
(7, 1, 2, 7, 'ABERTA', '2026-06-02 00:17:30', '2026-06-04 20:18:53', NULL),
(8, 1, 2, 8, 'ENCERRADA', '2026-06-02 00:23:48', '2026-06-04 20:18:53', '2026-06-02 00:53:50'),
(9, 1, 1, 9, 'ABERTA', '2026-06-02 00:25:14', '2026-06-04 20:18:53', NULL),
(10, 2, 1, 10, 'ABERTA', '2026-06-02 00:50:17', '2026-06-04 20:18:53', NULL),
(11, 2, 1, 11, 'ABERTA', '2026-06-02 00:50:19', '2026-06-04 20:18:53', NULL),
(12, 2, 2, 12, 'ENCERRADA', '2026-06-02 02:48:41', '2026-06-04 20:18:53', '2026-06-02 19:42:50'),
(13, 2, 1, 13, 'ABERTA', '2026-06-02 02:59:28', '2026-06-04 20:18:53', NULL),
(14, 2, 3, 14, 'ABERTA', '2026-06-02 03:23:53', '2026-06-04 20:18:53', NULL),
(15, 2, 3, 15, 'ABERTA', '2026-06-02 03:23:55', '2026-06-04 20:18:53', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `cupons`
--

CREATE TABLE `cupons` (
  `id_cupom` int(10) UNSIGNED NOT NULL,
  `id_parceiro` int(10) UNSIGNED NOT NULL,
  `titulo` varchar(120) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `codigo` varchar(40) NOT NULL,
  `percentual_desconto` decimal(5,2) DEFAULT NULL,
  `valor_desconto` decimal(10,2) DEFAULT NULL,
  `validade` date NOT NULL,
  `regras_uso` varchar(500) DEFAULT NULL,
  `status_cupom` enum('DISPONIVEL','UTILIZADO','VENCIDO','CANCELADO') NOT NULL DEFAULT 'DISPONIVEL',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `cupons`

--

INSERT INTO cupons (id_cupom, id_parceiro, titulo, descricao, codigo, percentual_desconto, valor_desconto, validade, regras_uso, status_cupom, criado_em) VALUES
(1, 1, 'Desconto Solidário', '10% de desconto em compras no comércio parceiro.', 'HH10-SOLIDARIO', 10.00, NULL, '2026-12-31', 'Válido para uma utilização por CPF.', 'DISPONIVEL', '2026-06-01 12:07:24');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cupons_doador`
--

CREATE TABLE `cupons_doador` (
  `id_cupom_doador` int(10) UNSIGNED NOT NULL,
  `id_cupom` int(10) UNSIGNED NOT NULL,
  `id_doador` int(10) UNSIGNED NOT NULL,
  `id_donativo` int(10) UNSIGNED NOT NULL,
  `id_confirmacao` int(10) UNSIGNED NOT NULL,
  `status_uso` enum('DISPONIVEL','UTILIZADO','VENCIDO','CANCELADO') NOT NULL DEFAULT 'DISPONIVEL',
  `liberado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `utilizado_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `cupons_doador`

--

INSERT INTO cupons_doador (id_cupom_doador, id_cupom, id_doador, id_donativo, id_confirmacao, status_uso, liberado_em, utilizado_em) VALUES
(1, 1, 1, 2, 1, 'DISPONIVEL', '2026-06-01 12:08:33', NULL),
(2, 1, 1, 3, 2, 'DISPONIVEL', '2026-06-01 13:45:47', NULL),
(3, 1, 1, 4, 3, 'DISPONIVEL', '2026-06-01 22:43:12', NULL),
(4, 1, 1, 2, 4, 'DISPONIVEL', '2026-06-01 23:43:17', NULL),
(5, 1, 1, 5, 5, 'DISPONIVEL', '2026-06-01 23:56:41', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `doacoes_monetarias_pix`
--

CREATE TABLE `doacoes_monetarias_pix` (
  `id_doacao_pix` int(10) UNSIGNED NOT NULL,
  `id_doador` int(10) UNSIGNED DEFAULT NULL,
  `id_instituicao` int(10) UNSIGNED NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `chave_pix` varchar(255) NOT NULL,
  `codigo_copia_cola` text DEFAULT NULL,
  `status_doacao` enum('PENDENTE','CONFIRMADA_MANUALMENTE','CANCELADA') NOT NULL DEFAULT 'PENDENTE',
  `comprovante_url` varchar(255) DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `confirmado_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

-- --------------------------------------------------------

--
-- Estrutura para tabela `doadores`
--

CREATE TABLE `doadores` (
  `id_doador` int(10) UNSIGNED NOT NULL,
  `id_usuario` int(10) UNSIGNED NOT NULL,
  `nome_completo` varchar(120) NOT NULL,
  `cpf` char(11) NOT NULL,
  `data_nascimento` date DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `doadores`

--

INSERT INTO doadores (id_doador, id_usuario, nome_completo, cpf, data_nascimento, criado_em, atualizado_em) VALUES
(1, 1, 'Julio Cesar', '00000000001', '1990-01-01', '2026-06-01 12:07:24', '2026-06-01 12:07:24'),
(2, 6, 'Pedro', '03125083109', '1994-04-16', '2026-06-02 00:48:37', '2026-06-02 00:48:37');

-- --------------------------------------------------------

--
-- Estrutura para tabela `donativos`
--

CREATE TABLE `donativos` (
  `id_donativo` int(10) UNSIGNED NOT NULL,
  `id_doador` int(10) UNSIGNED NOT NULL,
  `id_categoria` int(10) UNSIGNED NOT NULL,
  `titulo` varchar(150) NOT NULL,
  `descricao` varchar(800) NOT NULL,
  `estado_conservacao` enum('NOVO','BOM','COM_MARCAS_DE_USO','NECESSITA_REPARO') NOT NULL DEFAULT 'BOM',
  `status_donativo` enum('DISPONIVEL','RESERVADO','AGENDADO','CONCLUIDO','CANCELADO') NOT NULL DEFAULT 'DISPONIVEL',
  `data_validade` date DEFAULT NULL,
  `condicoes_armazenamento` varchar(255) DEFAULT NULL,
  `forma_entrega` enum('RETIRADA_NO_LOCAL','ENTREGA_DOADOR','A_COMBINAR') NOT NULL DEFAULT 'A_COMBINAR',
  `id_endereco_retirada` int(10) UNSIGNED DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `donativos`

--

INSERT INTO donativos (id_donativo, id_doador, id_categoria, titulo, descricao, estado_conservacao, status_donativo, data_validade, condicoes_armazenamento, forma_entrega, id_endereco_retirada, criado_em, atualizado_em) VALUES
(2, 1, 2, 'Roupas infantis', 'Roupas em bom estado de conservação.', 'BOM', 'CONCLUIDO', NULL, NULL, 'RETIRADA_NO_LOCAL', 1, '2026-06-01 12:07:24', '2026-06-04 20:18:53'),
(3, 1, 6, 'Doação para necessidade: Material Escolar', 'Quero doar', 'BOM', 'CONCLUIDO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-01 13:39:47', '2026-06-04 20:18:53'),
(4, 1, 1, 'Doação para necessidade: Alimentos', 'Tenho 3 pacotes de feijão', 'BOM', 'CONCLUIDO', '2026-06-30', 'local seco e arejado', 'A_COMBINAR', NULL, '2026-06-01 22:38:15', '2026-06-04 20:18:53'),
(5, 1, 1, 'Cesta básica', 'Tenho duas cestas básicas para doar', 'NOVO', 'CONCLUIDO', '2026-06-30', 'Em local seco e arejado', 'RETIRADA_NO_LOCAL', 1, '2026-06-01 22:49:21', '2026-06-04 20:18:53'),
(6, 1, 1, 'Doação para necessidade: Alimentos', 'Quero doar — ref: mansões pôr do sol', 'BOM', 'RESERVADO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 00:07:43', '2026-06-04 20:18:53'),
(7, 1, 1, 'Doação para necessidade: Alimentos', 'TESTE — ref: TESTE', 'BOM', 'RESERVADO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 00:17:30', '2026-06-04 20:18:53'),
(8, 1, 4, 'Doação para necessidade: Higiene', 'Quero doar três pacotes — ref: em casa', 'BOM', 'RESERVADO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 00:23:48', '2026-06-04 20:18:53'),
(9, 1, 2, 'Doação para necessidade: Roupas', 'Tenho roupas — ref: teste', 'BOM', 'RESERVADO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 00:25:14', '2026-06-04 20:18:53'),
(10, 2, 2, 'Doação para necessidade: Roupas', 'Quero doar — ref: em casa', 'BOM', 'RESERVADO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 00:50:17', '2026-06-04 20:18:53'),
(11, 2, 2, 'Doação para necessidade: Roupas', 'Quero doar — ref: em casa', 'BOM', 'RESERVADO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 00:50:19', '2026-06-04 20:18:53'),
(12, 2, 4, 'Papel higiênico', 'Tenho 5 pacotes para doação', 'NOVO', 'CONCLUIDO', '2026-06-04', 'Em ambiente limpo e arejado', 'RETIRADA_NO_LOCAL', 5, '2026-06-02 02:47:56', '2026-06-04 20:18:53'),
(13, 2, 2, 'Doação para necessidade: Roupas', 'tenho interesse em doar três cobertores — ref: buscar em casa', 'BOM', 'RESERVADO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 02:59:28', '2026-06-04 20:18:53'),
(14, 2, 3, 'Doação para necessidade: Móveis', 'teste — ref: teste', 'BOM', 'RESERVADO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 03:23:53', '2026-06-04 20:18:53'),
(15, 2, 3, 'Doação para necessidade: Móveis', 'teste — ref: teste', 'BOM', 'CONCLUIDO', NULL, NULL, 'A_COMBINAR', NULL, '2026-06-02 03:23:55', '2026-06-04 20:18:53'),
(16, 1, 2, 'Agasalhos adultos', '10 peças em bom estado, tamanhos M e G.', 'BOM', 'DISPONIVEL', NULL, NULL, 'A_COMBINAR', 1, '2026-06-04 10:00:00', '2026-06-04 20:18:53'),
(17, 1, 1, 'Arroz e feijão', '5 kg de arroz e 3 kg de feijão dentro da validade.', 'NOVO', 'DISPONIVEL', '2026-12-31', 'Local seco e arejado', 'RETIRADA_NO_LOCAL', 1, '2026-06-04 10:05:00', '2026-06-04 20:18:53'),
(18, 2, 6, 'Kit material escolar', 'Cadernos, lápis e canetas novos.', 'NOVO', 'DISPONIVEL', NULL, NULL, 'A_COMBINAR', 5, '2026-06-04 10:10:00', '2026-06-04 20:18:53');

-- --------------------------------------------------------

--
-- Estrutura para tabela `donativo_fotos`
--

CREATE TABLE `donativo_fotos` (
  `id_foto` int(10) UNSIGNED NOT NULL,
  `id_donativo` int(10) UNSIGNED NOT NULL,
  `caminho_arquivo` varchar(255) NOT NULL,
  `texto_alternativo` varchar(180) DEFAULT NULL,
  `ordem` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

-- --------------------------------------------------------

--
-- Estrutura para tabela `email_logs`
--

CREATE TABLE `email_logs` (
  `id_email_log` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` int(10) UNSIGNED DEFAULT NULL,
  `email_destino` varchar(180) NOT NULL,
  `assunto` varchar(220) NOT NULL,
  `corpo` text NOT NULL,
  `status_envio` enum('PENDENTE','ENVIADO','ERRO') NOT NULL DEFAULT 'PENDENTE',
  `erro` text DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `enviado_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `email_logs`

--

INSERT INTO email_logs (id_email_log, id_usuario, email_destino, assunto, corpo, status_envio, erro, criado_em, enviado_em) VALUES
(1, 6, 'cesarjulio557@hotmail.com', 'Recuperação de senha — Helping Hands', '<h2>Recuperação de senha — Helping Hands</h2><p>Olá, Pedro.</p><p><a href="http://localhost/helping-hands/redefinir-senha.php?uid=6&token=bb3dd92ff1052bb5926bdcdf7247c1f8b2bc413fcd211efad2af8a709432412d">Clique aqui para redefinir sua senha.</a></p><p>Este link expira em 2 horas. Se você não solicitou, ignore este e-mail.</p>', 'PENDENTE', NULL, '2026-06-04 17:53:10', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `enderecos`
--

CREATE TABLE `enderecos` (
  `id_endereco` int(10) UNSIGNED NOT NULL,
  `id_usuario` int(10) UNSIGNED NOT NULL,
  `cep` char(8) NOT NULL,
  `logradouro` varchar(180) NOT NULL,
  `numero` varchar(20) NOT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  `bairro` varchar(100) NOT NULL,
  `cidade` varchar(100) NOT NULL,
  `estado` char(2) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `principal` tinyint(1) NOT NULL DEFAULT 1,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `enderecos`

--

INSERT INTO enderecos (id_endereco, id_usuario, cep, logradouro, numero, complemento, bairro, cidade, estado, latitude, longitude, principal, criado_em, atualizado_em) VALUES
(1, 1, '72900000', 'Rua do Doador', '100', NULL, 'Centro', 'Águas Lindas de Goiás', 'GO', NULL, NULL, 1, '2026-06-01 12:07:24', '2026-06-04 20:18:53'),
(2, 2, '72900000', 'Avenida Solidária', '200', 'Sede', 'Centro', 'Águas Lindas de Goiás', 'GO', NULL, NULL, 1, '2026-06-01 12:07:24', '2026-06-04 20:18:53'),
(3, 3, '72915502', 'QB 5', '4', NULL, 'Mansões Pôr do Sol', 'Águas Lindas de Goiás', 'GO', NULL, NULL, 1, '2026-06-01 12:20:24', '2026-06-04 20:18:53'),
(4, 5, '72915502', 'Quadra B 5', '5', 'Bloco B apto 304', 'Mansões Pôr do Sol', 'Águas Lindas de Goiás', 'GO', NULL, NULL, 1, '2026-06-01 22:34:29', '2026-06-04 20:18:53'),
(5, 6, '72915502', 'Quadra B 5', '5', 'Apto 304', 'Mansões Pôr do Sol', 'Águas Lindas de Goiás', 'GO', NULL, NULL, 1, '2026-06-02 00:48:37', '2026-06-04 20:18:53');

-- --------------------------------------------------------

--
-- Estrutura para tabela `historico_acoes`
--

CREATE TABLE `historico_acoes` (
  `id_historico` bigint(20) UNSIGNED NOT NULL,
  `numero_protocolo` bigint(20) UNSIGNED NOT NULL,
  `tipo` varchar(80) NOT NULL,
  `id_usuario_abertura` int(10) UNSIGNED DEFAULT NULL,
  `id_usuario_destino` int(10) UNSIGNED DEFAULT NULL,
  `id_donativo` int(10) UNSIGNED DEFAULT NULL,
  `id_necessidade` int(10) UNSIGNED DEFAULT NULL,
  `id_agendamento` int(10) UNSIGNED DEFAULT NULL,
  `nome_doador` varchar(200) DEFAULT NULL,
  `nome_recebedor` varchar(200) DEFAULT NULL,
  `teve_chat` tinyint(1) NOT NULL DEFAULT 0,
  `titulo` varchar(180) NOT NULL,
  `descricao` varchar(1000) NOT NULL,
  `acao_finalizadora` tinyint(1) NOT NULL DEFAULT 0,
  `finalizado_em` datetime DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `historico_acoes`

--

INSERT INTO historico_acoes (id_historico, numero_protocolo, tipo, id_usuario_abertura, id_usuario_destino, id_donativo, id_necessidade, id_agendamento, nome_doador, nome_recebedor, teve_chat, titulo, descricao, acao_finalizadora, finalizado_em, criado_em) VALUES
(1, 202606011839472942, 'INTERESSE_NECESSIDADE', 1, 2, 3, 7, NULL, NULL, NULL, 0, 'Interesse em necessidade', 'Doador demonstrou interesse em doar item solicitado pela instituição.', 0, NULL, '2026-06-01 13:39:47'),
(2, 202606011841348158, 'VALIDACAO_ADMIN', 4, 3, NULL, NULL, NULL, NULL, NULL, 0, 'Instituição aprovada', 'Administrador aprovou o cadastro da instituição.', 0, NULL, '2026-06-01 13:41:34'),
(3, 202606011842066378, 'CHAT_ADMIN', 4, 2, NULL, NULL, NULL, NULL, NULL, 0, 'Chat administrativo', 'Administrador enviou mensagem administrativa.', 0, NULL, '2026-06-01 13:42:06'),
(4, 202606011843168503, 'AGENDAMENTO_NECESSIDADE', 2, 1, 3, 7, 2, NULL, NULL, 0, 'Agendamento de necessidade', 'Instituição atribuiu agendamento ao doador interessado.', 0, NULL, '2026-06-01 13:43:16'),
(5, 202606011844355831, 'CONFIRMACAO_DOADOR', 1, NULL, 3, 7, 2, NULL, NULL, 0, 'Confirmação de doação', 'Doador informou que realizou a entrega do item.', 0, NULL, '2026-06-01 13:44:35'),
(6, 202606011845474463, 'CONFIRMACAO_RECEBIMENTO', 2, 1, 3, 7, 2, 'Julio Cesar', 'Instituição Esperança', 1, 'Recebimento confirmado', 'Instituição confirmou o recebimento e o item foi encerrado.', 1, '2026-06-01 18:45:47', '2026-06-01 13:45:47'),
(63, 202606030041029986, 'CONFIRMACAO_ENTREGA', 6, 3, 12, NULL, 6, 'Pedro', 'Congo Esperança', 1, 'Doação informada pelo doador', 'O doador informou que realizou a entrega. Aguardando confirmação de recebimento.', 0, NULL, '2026-06-02 19:41:02'),
(64, 202606030041144535, 'CONFIRMACAO_ENTREGA', 6, 5, 15, NULL, 7, 'Pedro', 'Anjos Felizes', 1, 'Doação informada pelo doador', 'O doador informou que realizou a entrega. Aguardando confirmação de recebimento.', 0, NULL, '2026-06-02 19:41:14'),
(65, 202606030042344960, 'CONFIRMACAO_RECEBIMENTO', 3, 6, 12, NULL, 6, 'Pedro', 'Congo Esperança', 1, 'Recebimento confirmado pela instituição', 'A instituição confirmou o recebimento. Protocolo finalizado.', 1, '2026-06-03 00:42:34', '2026-06-02 19:42:34'),
(66, 202606030042503165, 'CHAT_ADMIN_USUARIO', 3, NULL, 12, NULL, NULL, NULL, NULL, 1, 'Chat encerrado', 'Usuário encerrou uma conversa e o chat foi arquivado no histórico.', 1, '2026-06-03 00:42:50', '2026-06-02 19:42:50'),
(67, 202606030044395744, 'CONFIRMACAO_RECEBIMENTO', 5, 6, 15, NULL, 7, 'Pedro', 'Anjos Felizes', 1, 'Recebimento confirmado pela instituição', 'A instituição confirmou o recebimento. Protocolo finalizado.', 1, '2026-06-03 00:44:39', '2026-06-02 19:44:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `instituicao_categorias_atendimento`
--

CREATE TABLE `instituicao_categorias_atendimento` (
  `id_instituicao` int(10) UNSIGNED NOT NULL,
  `id_categoria_atendimento` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `instituicao_categorias_atendimento`

--

INSERT INTO instituicao_categorias_atendimento (id_instituicao, id_categoria_atendimento) VALUES
(1, 1),
(1, 5);

-- --------------------------------------------------------

--
-- Estrutura para tabela `instituicoes`
--

CREATE TABLE `instituicoes` (
  `id_instituicao` int(10) UNSIGNED NOT NULL,
  `id_usuario` int(10) UNSIGNED NOT NULL,
  `nome_fantasia` varchar(150) NOT NULL,
  `razao_social` varchar(180) NOT NULL,
  `cnpj` char(14) NOT NULL,
  `descricao` text DEFAULT NULL,
  `missao` text DEFAULT NULL,
  `horario_funcionamento` varchar(150) DEFAULT NULL,
  `chave_pix` varchar(255) DEFAULT NULL,
  `esta_verificada` tinyint(1) NOT NULL DEFAULT 0,
  `status_validacao` enum('PENDENTE','APROVADA','REPROVADA','SUSPENSA') NOT NULL DEFAULT 'PENDENTE',
  `motivo_validacao` text DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `instituicoes`

--

INSERT INTO instituicoes (id_instituicao, id_usuario, nome_fantasia, razao_social, cnpj, descricao, missao, horario_funcionamento, chave_pix, esta_verificada, status_validacao, motivo_validacao, criado_em, atualizado_em) VALUES
(1, 2, 'Instituição Esperança', 'Instituição Esperança de Apoio Social', '00000000000100', 'Instituição de apoio social voltada a famílias em vulnerabilidade.', 'Promover acolhimento, dignidade e apoio material à comunidade.', 'Segunda a sexta, 08h às 17h', 'pix@instituicaoesperanca.org', 1, 'APROVADA', NULL, '2026-06-01 12:07:24', '2026-06-04 20:18:53'),
(2, 3, 'Congo Esperança', 'Congo Esperança SA', '12345678912340', 'Somos uma ONG de assistência social.', 'Ajudar famílias em situação de vulnerabilidade.', NULL, '123456789', 1, 'APROVADA', NULL, '2026-06-01 12:20:24', '2026-06-04 20:18:53'),
(3, 5, 'Anjos Felizes', 'Anjos Felizes Lar de Idosos Ltda', '12345678900000', 'Lar de idosos e assistência à terceira idade.', NULL, NULL, '123456789', 1, 'APROVADA', NULL, '2026-06-01 22:34:29', '2026-06-04 20:18:53');

-- --------------------------------------------------------

--
-- Estrutura para tabela `interesses_donativo`
--

CREATE TABLE `interesses_donativo` (
  `id_interesse_donativo` bigint(20) UNSIGNED NOT NULL,
  `id_donativo` int(10) UNSIGNED NOT NULL,
  `id_instituicao` int(10) UNSIGNED NOT NULL,
  `id_agendamento` int(10) UNSIGNED DEFAULT NULL,
  `numero_protocolo` bigint(20) UNSIGNED NOT NULL,
  `mensagem` varchar(800) DEFAULT NULL,
  `status_interesse` enum('ABERTO','AGENDADO','CANCELADO','CONCLUIDO') NOT NULL DEFAULT 'ABERTO',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `interesses_donativo`

--

INSERT INTO interesses_donativo (id_interesse_donativo, id_donativo, id_instituicao, id_agendamento, numero_protocolo, mensagem, status_interesse, criado_em, atualizado_em) VALUES
(1, 5, 1, 5, 202606020414174019, 'Interesse — ref: Mansões pôr do sol', 'CONCLUIDO', '2026-06-01 23:14:17', '2026-06-02 00:37:08'),
(2, 12, 2, NULL, 202606020748412629, 'tenho interesse — ref: busco no local', 'ABERTO', '2026-06-02 02:48:41', '2026-06-02 02:48:41');

-- --------------------------------------------------------

--
-- Estrutura para tabela `interesses_necessidade`
--

CREATE TABLE `interesses_necessidade` (
  `id_interesse` bigint(20) UNSIGNED NOT NULL,
  `id_necessidade` int(10) UNSIGNED NOT NULL,
  `id_doador` int(10) UNSIGNED NOT NULL,
  `id_donativo` int(10) UNSIGNED DEFAULT NULL,
  `id_agendamento` int(10) UNSIGNED DEFAULT NULL,
  `numero_protocolo` bigint(20) UNSIGNED NOT NULL,
  `mensagem` varchar(800) DEFAULT NULL,
  `status_interesse` enum('ABERTO','AGENDADO','CANCELADO','CONCLUIDO') NOT NULL DEFAULT 'ABERTO',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `interesses_necessidade`

--

INSERT INTO interesses_necessidade (id_interesse, id_necessidade, id_doador, id_donativo, id_agendamento, numero_protocolo, mensagem, status_interesse, criado_em, atualizado_em) VALUES
(1, 7, 1, 3, 2, 202606011839472942, 'Quero doar', 'CONCLUIDO', '2026-06-01 13:39:47', '2026-06-02 00:37:17'),
(2, 8, 1, 4, 3, 202606020338155463, 'Tenho 3 pacotes de feijão', 'CONCLUIDO', '2026-06-01 22:38:15', '2026-06-02 03:25:01'),
(3, 6, 1, 6, NULL, 202606020507432547, 'Quero doar — ref: mansões pôr do sol', 'ABERTO', '2026-06-02 00:07:43', '2026-06-02 00:07:43'),
(4, 6, 1, 7, NULL, 202606020517304915, 'TESTE — ref: TESTE', 'ABERTO', '2026-06-02 00:17:30', '2026-06-02 00:17:30'),
(5, 9, 1, 8, NULL, 202606020523487623, 'Quero doar três pacotes — ref: em casa', 'ABERTO', '2026-06-02 00:23:48', '2026-06-02 00:23:48'),
(6, 5, 1, 9, NULL, 202606020525142563, 'Tenho roupas — ref: teste', 'ABERTO', '2026-06-02 00:25:14', '2026-06-02 00:25:14'),
(7, 5, 2, 10, NULL, 202606020550177729, 'quero doar — ref: em casa', 'ABERTO', '2026-06-02 00:50:17', '2026-06-02 00:50:17'),
(8, 5, 2, 11, NULL, 202606020550191609, 'quero doar — ref: em casa', 'ABERTO', '2026-06-02 00:50:19', '2026-06-02 00:50:19'),
(9, 5, 2, 13, NULL, 202606020759287782, 'interesse em três cobertores — ref: buscar em casa', 'ABERTO', '2026-06-02 02:59:28', '2026-06-02 02:59:28'),
(10, 10, 2, 14, NULL, 202606020823537699, 'teste — ref: teste', 'ABERTO', '2026-06-02 03:23:53', '2026-06-02 03:23:53'),
(11, 10, 2, 15, 7, 202606020823556667, 'teste — ref: teste', 'CONCLUIDO', '2026-06-02 03:23:55', '2026-06-02 19:44:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `logs_auditoria`
--

CREATE TABLE `logs_auditoria` (
  `id_log` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` int(10) UNSIGNED DEFAULT NULL,
  `acao` varchar(120) NOT NULL,
  `entidade` varchar(80) NOT NULL,
  `id_entidade` int(10) UNSIGNED DEFAULT NULL,
  `detalhes` longtext DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

-- --------------------------------------------------------

--
-- Estrutura para tabela `mensagens`
--

CREATE TABLE `mensagens` (
  `id_mensagem` int(10) UNSIGNED NOT NULL,
  `id_conversa` int(10) UNSIGNED NOT NULL,
  `id_usuario_remetente` int(10) UNSIGNED NOT NULL,
  `conteudo` varchar(1000) NOT NULL,
  `lida` tinyint(1) NOT NULL DEFAULT 0,
  `enviada_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `mensagens`

--

INSERT INTO mensagens (id_mensagem, id_conversa, id_usuario_remetente, conteudo, lida, enviada_em) VALUES
(1, 1, 2, 'Olá! Temos interesse nas roupas infantis. Podemos combinar a retirada?', 1, '2026-06-01 12:07:24'),
(2, 1, 1, 'Claro. Podemos combinar para esta semana.', 1, '2026-06-01 12:07:24'),
(3, 1, 2, 'oi', 1, '2026-06-01 12:29:53'),
(4, 1, 2, 'opa', 1, '2026-06-01 13:22:14'),
(5, 1, 1, 'marcar entrega', 1, '2026-06-01 13:23:17'),
(6, 2, 1, 'O doador demonstrou interesse em atender a necessidade "lápis". Protocolo: 202606011839472942.', 1, '2026-06-01 13:39:47'),
(7, 2, 2, 'opa', 1, '2026-06-01 13:40:09'),
(8, 2, 1, 'oii', 1, '2026-06-01 13:44:17'),
(9, 2, 1, 'O doador informou que a doação do item "Material Escolar" foi realizada. A instituição deve validar o recebimento.', 1, '2026-06-01 13:44:35'),
(10, 3, 1, 'O doador demonstrou interesse em atender a necessidade "feijão". Protocolo: 202606020338155463.', 1, '2026-06-01 22:38:15'),
(11, 3, 1, 'O doador informou que a doação do item "Alimentos" foi realizada. A instituição deve validar o recebimento. Obs: Passaram aqui e coletaram o feijão.', 1, '2026-06-01 22:42:33'),
(12, 4, 2, 'A instituição demonstrou interesse no item "Cesta básica". Protocolo: 202606020414174019.', 1, '2026-06-01 23:14:17'),
(13, 4, 1, 'Que bom! Vamos agendar.', 1, '2026-06-01 23:22:43'),
(14, 4, 1, 'olá', 1, '2026-06-01 23:33:54'),
(15, 4, 2, 'A instituição agendou a entrega do item "Cesta básica".', 1, '2026-06-01 23:40:29'),
(16, 5, 1, 'O doador informou que a doação do item "Roupas infantis" foi realizada. Obs: Entrega efetivada', 1, '2026-06-01 23:42:06'),
(17, 4, 1, 'O doador informou que a doação do item "Cesta básica" foi realizada. Obs: Entrega efetivada', 1, '2026-06-01 23:42:14'),
(18, 5, 5, 'Recebemos', 1, '2026-06-01 23:43:40'),
(19, 6, 1, 'O doador demonstrou interesse em atender a necessidade "Arroz". Protocolo: 202606020507432547.', 1, '2026-06-02 00:07:43'),
(20, 6, 3, 'vamos marcar', 1, '2026-06-02 00:08:47'),
(21, 7, 1, 'O doador demonstrou interesse em atender a necessidade "Arroz". Protocolo: 202606020517304915.', 1, '2026-06-02 00:17:30'),
(22, 7, 3, 'opa', 1, '2026-06-02 00:17:55'),
(23, 8, 1, 'O doador demonstrou interesse em atender a necessidade "papel". Protocolo: 202606020523487623.', 1, '2026-06-02 00:23:48'),
(24, 9, 1, 'O doador demonstrou interesse em atender a necessidade "Cobertores". Protocolo: 202606020525142563.', 1, '2026-06-02 00:25:14'),
(25, 10, 6, 'O doador demonstrou interesse em atender a necessidade "Cobertores". Protocolo: 202606020550177729.', 0, '2026-06-02 00:50:17'),
(26, 11, 6, 'O doador demonstrou interesse em atender a necessidade "Cobertores". Protocolo: 202606020550191609.', 0, '2026-06-02 00:50:19'),
(27, 12, 3, 'A instituição demonstrou interesse no item "Papel higiênico". Protocolo: 202606020748412629.', 1, '2026-06-02 02:48:41'),
(28, 13, 6, 'O doador demonstrou interesse em atender a necessidade "Cobertores". Protocolo: 202606020759287782.', 0, '2026-06-02 02:59:28'),
(29, 14, 6, 'O doador demonstrou interesse em atender a necessidade "cama". Protocolo: 202606020823537699.', 1, '2026-06-02 03:23:53'),
(30, 15, 6, 'O doador demonstrou interesse em atender a necessidade "cama". Protocolo: 202606020823556667.', 1, '2026-06-02 03:23:55'),
(31, 12, 6, 'O doador informou que a entrega do item "Papel higiênico" foi realizada. Confirme o recebimento. Obs: entreguei', 1, '2026-06-02 19:41:02'),
(32, 14, 6, 'O doador informou que a entrega do item "Móveis" foi realizada. Confirme o recebimento. Obs: entreguei', 1, '2026-06-02 19:41:14'),
(33, 12, 3, 'já finalizamos por aqui', 1, '2026-06-02 19:42:48');

-- --------------------------------------------------------

--
-- Estrutura para tabela `necessidades_instituicao`
--

CREATE TABLE `necessidades_instituicao` (
  `id_necessidade` int(10) UNSIGNED NOT NULL,
  `id_instituicao` int(10) UNSIGNED NOT NULL,
  `id_categoria` int(10) UNSIGNED NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `prioridade` enum('BAIXA','MEDIA','ALTA','URGENTE') NOT NULL DEFAULT 'MEDIA',
  `status_necessidade` enum('ATIVA','ATENDIDA','REMOVIDA') NOT NULL DEFAULT 'ATIVA',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `necessidades_instituicao`

--

INSERT INTO necessidades_instituicao (id_necessidade, id_instituicao, id_categoria, descricao, prioridade, status_necessidade, criado_em, atualizado_em) VALUES
(2, 1, 2, 'Roupas infantis em bom estado', 'ALTA', 'ATIVA', '2026-06-01 12:07:24', '2026-06-04 20:18:53'),
(3, 1, 4, 'Produtos de higiene pessoal', 'MEDIA', 'ATIVA', '2026-06-01 12:07:24', '2026-06-04 20:18:53'),
(4, 1, 5, 'Carrinhos de brinquedo', 'ALTA', 'ATIVA', '2026-06-01 12:14:52', '2026-06-04 20:18:53'),
(5, 1, 2, 'Cobertores', 'URGENTE', 'ATIVA', '2026-06-01 12:15:08', '2026-06-04 20:18:53'),
(7, 1, 6, 'Lápis e cadernos', 'URGENTE', 'ATENDIDA', '2026-06-01 13:21:59', '2026-06-04 20:18:53'),
(8, 3, 1, 'Feijão', 'URGENTE', 'ATENDIDA', '2026-06-01 22:36:50', '2026-06-04 20:18:53'),
(9, 2, 4, 'Papel higiênico', 'URGENTE', 'ATIVA', '2026-06-02 00:22:43', '2026-06-04 20:18:53'),
(10, 3, 3, 'Cama e colchão', 'ALTA', 'ATIVA', '2026-06-02 03:23:28', '2026-06-04 20:18:53'),
(11, 1, 1, 'Alimentos não perecíveis', 'URGENTE', 'ATIVA', '2026-06-04 10:00:00', '2026-06-04 20:18:53'),
(12, 2, 2, 'Cobertores e agasalhos', 'ALTA', 'ATIVA', '2026-06-04 10:00:00', '2026-06-04 20:18:53'),
(13, 3, 6, 'Material escolar', 'MEDIA', 'ATIVA', '2026-06-04 10:00:00', '2026-06-04 20:18:53');

-- --------------------------------------------------------

--
-- Estrutura para tabela `parceiros`
--

CREATE TABLE `parceiros` (
  `id_parceiro` int(10) UNSIGNED NOT NULL,
  `nome_empresa` varchar(150) NOT NULL,
  `cnpj` char(14) DEFAULT NULL,
  `endereco` varchar(255) DEFAULT NULL,
  `contato` varchar(120) NOT NULL,
  `status_parceiro` enum('ATIVO','INATIVO','SUSPENSO') NOT NULL DEFAULT 'ATIVO',
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `parceiros`

--

INSERT INTO parceiros (id_parceiro, nome_empresa, cnpj, endereco, contato, status_parceiro, criado_em, atualizado_em) VALUES
(1, 'Comércio Parceiro Local', '11111111000111', 'Centro, Águas Lindas de Goiás - GO', 'parcerias@comerciolocal.test', 'ATIVO', '2026-06-01 12:07:24', '2026-06-01 12:07:24');

-- --------------------------------------------------------

--
-- Estrutura para tabela `perfis_usuario`
--

CREATE TABLE `perfis_usuario` (
  `id_perfil` tinyint(3) UNSIGNED NOT NULL,
  `nome` varchar(30) NOT NULL,
  `descricao` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `perfis_usuario`

--

INSERT INTO perfis_usuario (id_perfil, nome, descricao) VALUES
(1, 'DOADOR', 'Pessoa física que cadastra donativos'),
(2, 'INSTITUICAO', 'Entidade apta a receber doações'),
(3, 'ADMIN', 'Perfil administrativo do sistema');

-- --------------------------------------------------------

--
-- Estrutura para tabela `protocolos`
--

CREATE TABLE `protocolos` (
  `id_protocolo` bigint(20) UNSIGNED NOT NULL,
  `numero_protocolo` bigint(20) UNSIGNED NOT NULL,
  `tipo` enum('VALIDACAO_ADMIN','BANIMENTO_ADMIN','CHAT_ADMIN','ALTERACAO_CADASTRAL','ABERTURA_DOACAO','CHAT_ADMIN_USUARIO','INTERESSE_NECESSIDADE','AGENDAMENTO_NECESSIDADE','CANCELAMENTO_AGENDAMENTO','CONFIRMACAO_DOADOR','CONFIRMACAO_RECEBIMENTO','INTERESSE_DONATIVO','AGENDAMENTO_DONATIVO_DOADOR','CONFIRMACAO_ENTREGA','ADMIN_CONTROLE_USUARIO','ADMIN_CRIOU_SECUNDARIO','BANIMENTO_ADMIN') NOT NULL,
  `id_usuario_abertura` int(10) UNSIGNED DEFAULT NULL,
  `id_usuario_relacionado` int(10) UNSIGNED DEFAULT NULL,
  `id_donativo` int(10) UNSIGNED DEFAULT NULL,
  `id_necessidade` int(10) UNSIGNED DEFAULT NULL,
  `id_agendamento` int(10) UNSIGNED DEFAULT NULL,
  `descricao` varchar(800) NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `protocolos`

--

INSERT INTO protocolos (id_protocolo, numero_protocolo, tipo, id_usuario_abertura, id_usuario_relacionado, id_donativo, id_necessidade, id_agendamento, descricao, criado_em) VALUES
(1, 202606011839472942, 'INTERESSE_NECESSIDADE', 1, 2, 3, 7, NULL, 'Doador demonstrou interesse em doar item solicitado pela instituição.', '2026-06-01 13:39:47'),
(2, 202606011841348158, 'VALIDACAO_ADMIN', 4, 3, NULL, NULL, NULL, 'Administrador aprovou o cadastro da instituição.', '2026-06-01 13:41:34'),
(3, 202606011842066378, 'CHAT_ADMIN', 4, 2, NULL, NULL, NULL, 'Administrador enviou mensagem administrativa.', '2026-06-01 13:42:06'),
(4, 202606011843168503, 'AGENDAMENTO_NECESSIDADE', 2, 1, 3, 7, 2, 'Instituição atribuiu agendamento ao doador interessado.', '2026-06-01 13:43:16'),
(5, 202606011844355831, 'CONFIRMACAO_DOADOR', 1, NULL, 3, 7, 2, 'Doador informou que realizou a entrega do item.', '2026-06-01 13:44:35'),
(6, 202606011845474463, 'CONFIRMACAO_RECEBIMENTO', 2, 1, 3, 7, 2, 'Instituição confirmou o recebimento e o item foi encerrado.', '2026-06-01 13:45:47'),
(65, 202606030042344960, 'CONFIRMACAO_RECEBIMENTO', 3, 6, 12, NULL, 6, 'A instituição confirmou o recebimento. Protocolo finalizado.', '2026-06-02 19:42:34'),
(67, 202606030044395744, 'CONFIRMACAO_RECEBIMENTO', 5, 6, 15, NULL, 7, 'A instituição confirmou o recebimento. Protocolo finalizado.', '2026-06-02 19:44:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `recuperacao_senha_tentativas`
--

CREATE TABLE `recuperacao_senha_tentativas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(254) NOT NULL,
  `ip` varchar(45) NOT NULL DEFAULT '',
  `tentativa_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `recuperacao_senha_tentativas`

--

INSERT INTO recuperacao_senha_tentativas (id, email, ip, tentativa_em) VALUES
(1, 'cesarjulio557@hotmail.com', '::1', '2026-06-04 17:53:07');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tokens_email`
--

CREATE TABLE `tokens_email` (
  `id_token` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` int(10) UNSIGNED NOT NULL,
  `tipo` enum('VALIDACAO_CONTA','RECUPERACAO_SENHA') NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `usado` tinyint(1) NOT NULL DEFAULT 0,
  `expira_em` datetime NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `usado_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `tokens_email`

--

INSERT INTO tokens_email (id_token, id_usuario, tipo, token_hash, usado, expira_em, criado_em, usado_em) VALUES
(1, 6, 'RECUPERACAO_SENHA', '$2y$10$UuooIitkEDGO0KSn0wUjqeMpaSf92IT2B4/Z9HZIsGvmdg2Jqh.3C', 0, '2026-06-04 19:53:08', '2026-06-04 17:53:08', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(10) UNSIGNED NOT NULL,
  `id_perfil` tinyint(3) UNSIGNED NOT NULL,
  `nome` varchar(120) NOT NULL,
  `email` varchar(120) NOT NULL,
  `email_confirmado` tinyint(1) NOT NULL DEFAULT 0,
  `senha_hash` varchar(255) NOT NULL,
  `nivel_admin` enum('MASTER','SECUNDARIO') DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `foto_url` varchar(255) DEFAULT NULL,
  `status_usuario` enum('ATIVO','PENDENTE','BLOQUEADO','INATIVO','BANIDO') NOT NULL DEFAULT 'PENDENTE',
  `banido_ate` datetime DEFAULT NULL,
  `motivo_banimento` text DEFAULT NULL,
  `motivo_status` varchar(500) DEFAULT NULL,
  `atualizado_por_admin` int(10) UNSIGNED DEFAULT NULL,
  `aceite_termos` tinyint(1) NOT NULL DEFAULT 0,
  `aceite_lgpd` tinyint(1) NOT NULL DEFAULT 0,
  `data_aceite_lgpd` datetime DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

--

-- Despejando dados para a tabela `usuarios`

--

INSERT INTO usuarios (id_usuario, id_perfil, nome, email, email_confirmado, senha_hash, nivel_admin, telefone, foto_url, status_usuario, banido_ate, motivo_banimento, motivo_status, atualizado_por_admin, aceite_termos, aceite_lgpd, data_aceite_lgpd, criado_em, atualizado_em) VALUES
(1, 1, 'Julio Cesar', 'doador@helpinghands.test', 1, '$2y$10$cpM4E7c0K72Qy/apsKf5b.EME3MOqxXLG1mvCYVIdg.b8HsXpPDMS', NULL, '(61) 99999-0000', NULL, 'ATIVO', NULL, NULL, NULL, NULL, 1, 1, '2026-06-01 12:07:24', '2026-06-01 12:07:24', '2026-06-04 17:59:00'),
(2, 2, 'Instituição Esperança', 'instituicao@helpinghands.test', 1, '$2y$10$cpM4E7c0K72Qy/apsKf5b.EME3MOqxXLG1mvCYVIdg.b8HsXpPDMS', NULL, '(61) 3333-0000', NULL, 'ATIVO', NULL, NULL, NULL, NULL, 1, 1, '2026-06-01 12:07:24', '2026-06-01 12:07:24', '2026-06-04 17:59:00'),
(3, 2, 'Congo Esperança', 'congoesperanca@hotmail.com', 1, '$2y$10$cpM4E7c0K72Qy/apsKf5b.EME3MOqxXLG1mvCYVIdg.b8HsXpPDMS', NULL, '61982913886', NULL, 'ATIVO', NULL, NULL, NULL, NULL, 1, 1, '2026-06-01 12:20:24', '2026-06-01 12:20:24', '2026-06-04 17:59:00'),
(4, 3, 'Administrador', 'admin@helpinghands.test', 1, '$2y$10$cpM4E7c0K72Qy/apsKf5b.EME3MOqxXLG1mvCYVIdg.b8HsXpPDMS', 'MASTER', '(61) 0000-0000', NULL, 'ATIVO', NULL, NULL, NULL, NULL, 1, 1, '2026-06-01 12:47:41', '2026-06-01 12:47:41', '2026-06-04 17:59:00'),
(5, 2, 'Anjos Felizes', 'anjosfelizes15@hotmail.com', 1, '$2y$10$cpM4E7c0K72Qy/apsKf5b.EME3MOqxXLG1mvCYVIdg.b8HsXpPDMS', NULL, '61982913886', NULL, 'ATIVO', NULL, NULL, NULL, NULL, 1, 1, '2026-06-01 22:34:29', '2026-06-01 22:34:29', '2026-06-04 17:59:00'),
(6, 1, 'Pedro', 'cesarjulio557@hotmail.com', 1, '$2y$10$cpM4E7c0K72Qy/apsKf5b.EME3MOqxXLG1mvCYVIdg.b8HsXpPDMS', NULL, '61982913886', NULL, 'ATIVO', NULL, NULL, NULL, NULL, 1, 1, '2026-06-02 00:48:37', '2026-06-02 00:48:37', '2026-06-04 17:59:00'),
(7, 3, 'Moderador', 'moderador@helpinghands.test', 1, '$2y$10$cpM4E7c0K72Qy/apsKf5b.EME3MOqxXLG1mvCYVIdg.b8HsXpPDMS', 'SECUNDARIO', '', NULL, 'ATIVO', NULL, NULL, NULL, NULL, 1, 1, '2026-06-04 10:00:00', '2026-06-04 10:00:00', '2026-06-04 17:59:00');

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_admin_usuarios`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_admin_usuarios` (
`id_usuario` int(10) unsigned
,`nome` varchar(120)
,`email` varchar(120)
,`telefone` varchar(20)
,`status_usuario` enum('ATIVO','PENDENTE','BLOQUEADO','INATIVO','BANIDO')
,`motivo_status` varchar(500)
,`banido_ate` datetime
,`nivel_admin` enum('MASTER','SECUNDARIO')
,`criado_em` datetime
,`perfil` varchar(30)
,`id_instituicao` int(10) unsigned
,`nome_fantasia` varchar(150)
,`cnpj` char(14)
,`status_validacao` enum('PENDENTE','APROVADA','REPROVADA','SUSPENSA')
,`motivo_validacao` text
,`esta_verificada` tinyint(1)
,`id_doador` int(10) unsigned
,`cpf` char(11)
)

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_cupons_doador`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_cupons_doador` (
`id_cupom_doador` int(10) unsigned
,`id_doador` int(10) unsigned
,`nome_empresa` varchar(150)
,`titulo` varchar(120)
,`descricao` varchar(255)
,`codigo` varchar(40)
,`percentual_desconto` decimal(5,2)
,`valor_desconto` decimal(10,2)
,`validade` date
,`status_uso` enum('DISPONIVEL','UTILIZADO','VENCIDO','CANCELADO')
,`liberado_em` datetime
,`donativo_origem` varchar(150)
)

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_donativos_publicos`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_donativos_publicos` (
`id_donativo` int(10) unsigned
,`titulo` varchar(150)
,`categoria` varchar(80)
,`descricao` varchar(800)
,`estado_conservacao` enum('NOVO','BOM','COM_MARCAS_DE_USO','NECESSITA_REPARO')
,`status_donativo` enum('DISPONIVEL','RESERVADO','AGENDADO','CONCLUIDO','CANCELADO')
,`nome_doador` varchar(120)
,`cidade` varchar(100)
,`estado` char(2)
,`criado_em` datetime
)

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_instituicoes_busca`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_instituicoes_busca` (
`id_instituicao` int(10) unsigned
,`nome_fantasia` varchar(150)
,`descricao` text
,`horario_funcionamento` varchar(150)
,`esta_verificada` tinyint(1)
,`status_validacao` enum('PENDENTE','APROVADA','REPROVADA','SUSPENSA')
,`email` varchar(120)
,`telefone` varchar(20)
,`cidade` varchar(100)
,`estado` char(2)
,`latitude` decimal(10,8)
,`longitude` decimal(11,8)
,`categorias_atendimento` mediumtext
,`necessidades_ativas` mediumtext
)

-- --------------------------------------------------------

--
-- Estrutura para view `vw_admin_usuarios`
--
DROP TABLE IF EXISTS `vw_admin_usuarios`

CREATE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW vw_admin_usuarios  AS SELECT u.id_usuario AS id_usuario, u.nome AS nome, u.email AS email, u.telefone AS telefone, u.status_usuario AS status_usuario, u.motivo_status AS motivo_status, u.banido_ate AS banido_ate, u.nivel_admin AS nivel_admin, u.criado_em AS criado_em, p.nome AS perfil, i.id_instituicao AS id_instituicao, i.nome_fantasia AS nome_fantasia, i.cnpj AS cnpj, i.status_validacao AS status_validacao, i.motivo_validacao AS motivo_validacao, i.esta_verificada AS esta_verificada, d.id_doador AS id_doador, d.cpf AS cpf FROM (((usuarios u join perfis_usuario p on(p.id_perfil = u.id_perfil)) left join instituicoes i on(i.id_usuario = u.id_usuario)) left join doadores d on(d.id_usuario = u.id_usuario));

-- --------------------------------------------------------

--
-- Estrutura para view `vw_cupons_doador`
--
DROP TABLE IF EXISTS `vw_cupons_doador`

CREATE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW vw_cupons_doador  AS SELECT cd.id_cupom_doador AS id_cupom_doador, dor.id_doador AS id_doador, p.nome_empresa AS nome_empresa, c.titulo AS titulo, c.descricao AS descricao, c.codigo AS codigo, c.percentual_desconto AS percentual_desconto, c.valor_desconto AS valor_desconto, c.validade AS validade, cd.status_uso AS status_uso, cd.liberado_em AS liberado_em, d.titulo AS donativo_origem FROM ((((cupons_doador cd join cupons c on(c.id_cupom = cd.id_cupom)) join parceiros p on(p.id_parceiro = c.id_parceiro)) join doadores dor on(dor.id_doador = cd.id_doador)) join donativos d on(d.id_donativo = cd.id_donativo));

-- --------------------------------------------------------

--
-- Estrutura para view `vw_donativos_publicos`
--
DROP TABLE IF EXISTS `vw_donativos_publicos`

CREATE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW vw_donativos_publicos  AS SELECT d.id_donativo AS id_donativo, d.titulo AS titulo, c.nome AS categoria, d.descricao AS descricao, d.estado_conservacao AS estado_conservacao, d.status_donativo AS status_donativo, u.nome AS nome_doador, e.cidade AS cidade, e.estado AS estado, d.criado_em AS criado_em FROM ((((donativos d join categorias_donativo c on(c.id_categoria = d.id_categoria)) join doadores dor on(dor.id_doador = d.id_doador)) join usuarios u on(u.id_usuario = dor.id_usuario)) left join enderecos e on(e.id_endereco = d.id_endereco_retirada)) WHERE d.status_donativo in ('DISPONIVEL','RESERVADO','AGENDADO');

-- --------------------------------------------------------

--
-- Estrutura para view `vw_instituicoes_busca`
--
DROP TABLE IF EXISTS `vw_instituicoes_busca`

CREATE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW vw_instituicoes_busca  AS SELECT i.id_instituicao AS id_instituicao, i.nome_fantasia AS nome_fantasia, i.descricao AS descricao, i.horario_funcionamento AS horario_funcionamento, i.esta_verificada AS esta_verificada, i.status_validacao AS status_validacao, u.email AS email, u.telefone AS telefone, e.cidade AS cidade, e.estado AS estado, e.latitude AS latitude, e.longitude AS longitude, group_concat(distinct ca.nome order by ca.nome ASC separator ', ') AS categorias_atendimento, group_concat(distinct ni.descricao order by ni.prioridade DESC separator '; ') AS necessidades_ativas FROM (((((instituicoes i join usuarios u on(u.id_usuario = i.id_usuario)) left join enderecos e on(e.id_usuario = u.id_usuario and e.principal = 1)) left join instituicao_categorias_atendimento ica on(ica.id_instituicao = i.id_instituicao)) left join categorias_atendimento ca on(ca.id_categoria_atendimento = ica.id_categoria_atendimento)) left join necessidades_instituicao ni on(ni.id_instituicao = i.id_instituicao and ni.status_necessidade = 'ATIVA')) GROUP BY i.id_instituicao, i.nome_fantasia, i.descricao, i.horario_funcionamento, i.esta_verificada, i.status_validacao, u.email, u.telefone, e.cidade, e.estado, e.latitude, e.longitude;

--

-- Índices para tabelas despejadas

--

--
-- Índices de tabela `admin_mensagens`
--
ALTER TABLE `admin_mensagens`
  ADD PRIMARY KEY (`id_admin_mensagem`),
  ADD KEY `idx_admin_msg_destino_lida` (`id_usuario_destino`,`lida`),
  ADD KEY `idx_admin_msg_admin` (`id_admin`)

--

-- Índices de tabela `agendamentos_doacao`

--

ALTER TABLE agendamentos_doacao
  ADD PRIMARY KEY (id_agendamento),
  ADD KEY fk_agenda_doador (id_doador),
  ADD KEY fk_agenda_instituicao (id_instituicao),
  ADD KEY idx_agenda_status (status_agendamento),
  ADD KEY idx_agenda_donativo (id_donativo),
  ADD KEY idx_agenda_doador_confirmou (doador_confirmou_entrega);

--

-- Índices de tabela `agendamento_alteracoes`

--

ALTER TABLE agendamento_alteracoes
  ADD PRIMARY KEY (id_alteracao),
  ADD KEY idx_alt_agendamento (id_agendamento),
  ADD KEY idx_alt_status (status_alteracao);

--

-- Índices de tabela `avaliacoes_doacao`

--

ALTER TABLE avaliacoes_doacao
  ADD PRIMARY KEY (id_avaliacao),
  ADD UNIQUE KEY uk_avaliacao_agendamento (id_agendamento);

--

-- Índices de tabela `categorias_atendimento`

--

ALTER TABLE categorias_atendimento
  ADD PRIMARY KEY (id_categoria_atendimento),
  ADD UNIQUE KEY nome (nome);

--

-- Índices de tabela `categorias_donativo`

--

ALTER TABLE categorias_donativo
  ADD PRIMARY KEY (id_categoria),
  ADD UNIQUE KEY nome (nome);

--

-- Índices de tabela `confirmacoes_recebimento`

--

ALTER TABLE confirmacoes_recebimento
  ADD PRIMARY KEY (id_confirmacao),
  ADD UNIQUE KEY id_agendamento (id_agendamento);

--

-- Índices de tabela `conversas`

--

ALTER TABLE conversas
  ADD PRIMARY KEY (id_conversa),
  ADD KEY fk_conversas_instituicao (id_instituicao),
  ADD KEY fk_conversas_donativo (id_donativo),
  ADD KEY idx_conversas_partes (id_doador,id_instituicao);

--

-- Índices de tabela `cupons`

--

ALTER TABLE cupons
  ADD PRIMARY KEY (id_cupom),
  ADD UNIQUE KEY codigo (codigo),
  ADD KEY fk_cupons_parceiros (id_parceiro),
  ADD KEY idx_cupons_status_validade (status_cupom,validade);

--

-- Índices de tabela `cupons_doador`

--

ALTER TABLE cupons_doador
  ADD PRIMARY KEY (id_cupom_doador),
  ADD KEY fk_cupom_doador_cupom (id_cupom),
  ADD KEY fk_cupom_doador_donativo (id_donativo),
  ADD KEY fk_cupom_doador_confirmacao (id_confirmacao),
  ADD KEY idx_cupons_doador_status (id_doador,status_uso);

--

-- Índices de tabela `doacoes_monetarias_pix`

--

ALTER TABLE doacoes_monetarias_pix
  ADD PRIMARY KEY (id_doacao_pix),
  ADD KEY fk_pix_doador (id_doador),
  ADD KEY idx_pix_instituicao_status (id_instituicao,status_doacao);

--

-- Índices de tabela `doadores`

--

ALTER TABLE doadores
  ADD PRIMARY KEY (id_doador),
  ADD UNIQUE KEY id_usuario (id_usuario),
  ADD UNIQUE KEY cpf (cpf);

--

-- Índices de tabela `donativos`

--

ALTER TABLE donativos
  ADD PRIMARY KEY (id_donativo),
  ADD KEY fk_donativos_endereco (id_endereco_retirada),
  ADD KEY idx_donativos_status (status_donativo),
  ADD KEY idx_donativos_categoria (id_categoria),
  ADD KEY idx_donativos_doador (id_doador);

--

-- Índices de tabela `donativo_fotos`

--

ALTER TABLE donativo_fotos
  ADD PRIMARY KEY (id_foto),
  ADD KEY idx_fotos_donativo (id_donativo);

--

-- Índices de tabela `email_logs`

--

ALTER TABLE email_logs
  ADD PRIMARY KEY (id_email_log),
  ADD KEY idx_email_usuario (id_usuario),
  ADD KEY idx_email_status (status_envio);

--

-- Índices de tabela `enderecos`

--

ALTER TABLE enderecos
  ADD PRIMARY KEY (id_endereco),
  ADD KEY fk_enderecos_usuarios (id_usuario),
  ADD KEY idx_enderecos_cidade_estado (cidade,estado),
  ADD KEY idx_enderecos_geo (latitude,longitude);

--

-- Índices de tabela `historico_acoes`

--

ALTER TABLE historico_acoes
  ADD PRIMARY KEY (id_historico),
  ADD KEY idx_hist_protocolo (numero_protocolo),
  ADD KEY idx_hist_tipo (tipo),
  ADD KEY idx_hist_finalizado (finalizado_em),
  ADD KEY idx_hist_usuario_abertura (id_usuario_abertura),
  ADD KEY idx_hist_usuario_destino (id_usuario_destino);

--

-- Índices de tabela `instituicao_categorias_atendimento`

--

ALTER TABLE instituicao_categorias_atendimento
  ADD PRIMARY KEY (id_instituicao,id_categoria_atendimento),
  ADD KEY fk_inst_cat_categoria (id_categoria_atendimento);

--

-- Índices de tabela `instituicoes`

--

ALTER TABLE instituicoes
  ADD PRIMARY KEY (id_instituicao),
  ADD UNIQUE KEY id_usuario (id_usuario),
  ADD UNIQUE KEY cnpj (cnpj);

--

-- Índices de tabela `interesses_donativo`

--

ALTER TABLE interesses_donativo
  ADD PRIMARY KEY (id_interesse_donativo),
  ADD KEY idx_int_donativo_donativo (id_donativo),
  ADD KEY idx_int_donativo_instituicao (id_instituicao),
  ADD KEY idx_int_donativo_status (status_interesse);

--

-- Índices de tabela `interesses_necessidade`

--

ALTER TABLE interesses_necessidade
  ADD PRIMARY KEY (id_interesse),
  ADD KEY idx_interesse_necessidade (id_necessidade),
  ADD KEY idx_interesse_doador (id_doador),
  ADD KEY idx_interesse_status (status_interesse);

--

-- Índices de tabela `logs_auditoria`

--

ALTER TABLE logs_auditoria
  ADD PRIMARY KEY (id_log),
  ADD KEY fk_logs_usuario (id_usuario),
  ADD KEY idx_logs_entidade (entidade,id_entidade),
  ADD KEY idx_logs_data (criado_em);

--

-- Índices de tabela `mensagens`

--

ALTER TABLE mensagens
  ADD PRIMARY KEY (id_mensagem),
  ADD KEY fk_mensagens_usuario (id_usuario_remetente),
  ADD KEY idx_mensagens_conversa_data (id_conversa,enviada_em);

--

-- Índices de tabela `necessidades_instituicao`

--

ALTER TABLE necessidades_instituicao
  ADD PRIMARY KEY (id_necessidade),
  ADD KEY fk_necessidades_instituicoes (id_instituicao),
  ADD KEY fk_necessidades_categorias (id_categoria),
  ADD KEY idx_necessidades_prioridade (prioridade),
  ADD KEY idx_necessidades_status (status_necessidade);

--

-- Índices de tabela `parceiros`

--

ALTER TABLE parceiros
  ADD PRIMARY KEY (id_parceiro),
  ADD UNIQUE KEY cnpj (cnpj);

--

-- Índices de tabela `perfis_usuario`

--

ALTER TABLE perfis_usuario
  ADD PRIMARY KEY (id_perfil),
  ADD UNIQUE KEY nome (nome);

--

-- Índices de tabela `protocolos`

--

ALTER TABLE protocolos
  ADD PRIMARY KEY (id_protocolo),
  ADD UNIQUE KEY numero_protocolo (numero_protocolo),
  ADD KEY idx_protocolos_tipo_data (tipo,criado_em),
  ADD KEY idx_protocolos_usuario_abertura (id_usuario_abertura),
  ADD KEY idx_protocolos_usuario_relacionado (id_usuario_relacionado),
  ADD KEY idx_protocolos_numero (numero_protocolo);

--

-- Índices de tabela `recuperacao_senha_tentativas`

--

ALTER TABLE recuperacao_senha_tentativas
  ADD PRIMARY KEY (id),
  ADD KEY idx_email_tent (email,tentativa_em),
  ADD KEY idx_ip_tent (ip,tentativa_em);

--

-- Índices de tabela `tokens_email`

--

ALTER TABLE tokens_email
  ADD PRIMARY KEY (id_token),
  ADD KEY idx_token_usuario_tipo (id_usuario,tipo),
  ADD KEY idx_token_expira (expira_em);

--

-- Índices de tabela `usuarios`

--

ALTER TABLE usuarios
  ADD PRIMARY KEY (id_usuario),
  ADD UNIQUE KEY email (email),
  ADD KEY fk_usuarios_perfis (id_perfil),
  ADD KEY fk_usuarios_admin_atualizacao (atualizado_por_admin);

--

-- AUTO_INCREMENT para tabelas despejadas

--

--
-- AUTO_INCREMENT de tabela `admin_mensagens`
--
ALTER TABLE `admin_mensagens`
  MODIFY `id_admin_mensagem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3

--

-- AUTO_INCREMENT de tabela `agendamentos_doacao`

--

ALTER TABLE agendamentos_doacao
  MODIFY id_agendamento int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--

-- AUTO_INCREMENT de tabela `agendamento_alteracoes`

--

ALTER TABLE agendamento_alteracoes
  MODIFY id_alteracao bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--

-- AUTO_INCREMENT de tabela `avaliacoes_doacao`

--

ALTER TABLE avaliacoes_doacao
  MODIFY id_avaliacao bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--

-- AUTO_INCREMENT de tabela `categorias_atendimento`

--

ALTER TABLE categorias_atendimento
  MODIFY id_categoria_atendimento int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--

-- AUTO_INCREMENT de tabela `categorias_donativo`

--

ALTER TABLE categorias_donativo
  MODIFY id_categoria int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--

-- AUTO_INCREMENT de tabela `confirmacoes_recebimento`

--

ALTER TABLE confirmacoes_recebimento
  MODIFY id_confirmacao int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--

-- AUTO_INCREMENT de tabela `conversas`

--

ALTER TABLE conversas
  MODIFY id_conversa int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--

-- AUTO_INCREMENT de tabela `cupons`

--

ALTER TABLE cupons
  MODIFY id_cupom int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--

-- AUTO_INCREMENT de tabela `cupons_doador`

--

ALTER TABLE cupons_doador
  MODIFY id_cupom_doador int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--

-- AUTO_INCREMENT de tabela `doacoes_monetarias_pix`

--

ALTER TABLE doacoes_monetarias_pix
  MODIFY id_doacao_pix int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--

-- AUTO_INCREMENT de tabela `doadores`

--

ALTER TABLE doadores
  MODIFY id_doador int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--

-- AUTO_INCREMENT de tabela `donativos`

--

ALTER TABLE donativos
  MODIFY id_donativo int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--

-- AUTO_INCREMENT de tabela `donativo_fotos`

--

ALTER TABLE donativo_fotos
  MODIFY id_foto int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--

-- AUTO_INCREMENT de tabela `email_logs`

--

ALTER TABLE email_logs
  MODIFY id_email_log bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--

-- AUTO_INCREMENT de tabela `enderecos`

--

ALTER TABLE enderecos
  MODIFY id_endereco int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--

-- AUTO_INCREMENT de tabela `historico_acoes`

--

ALTER TABLE historico_acoes
  MODIFY id_historico bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--

-- AUTO_INCREMENT de tabela `instituicoes`

--

ALTER TABLE instituicoes
  MODIFY id_instituicao int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--

-- AUTO_INCREMENT de tabela `interesses_donativo`

--

ALTER TABLE interesses_donativo
  MODIFY id_interesse_donativo bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--

-- AUTO_INCREMENT de tabela `interesses_necessidade`

--

ALTER TABLE interesses_necessidade
  MODIFY id_interesse bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--

-- AUTO_INCREMENT de tabela `logs_auditoria`

--

ALTER TABLE logs_auditoria
  MODIFY id_log bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--

-- AUTO_INCREMENT de tabela `mensagens`

--

ALTER TABLE mensagens
  MODIFY id_mensagem int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--

-- AUTO_INCREMENT de tabela `necessidades_instituicao`

--

ALTER TABLE necessidades_instituicao
  MODIFY id_necessidade int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--

-- AUTO_INCREMENT de tabela `parceiros`

--

ALTER TABLE parceiros
  MODIFY id_parceiro int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--

-- AUTO_INCREMENT de tabela `perfis_usuario`

--

ALTER TABLE perfis_usuario
  MODIFY id_perfil tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--

-- AUTO_INCREMENT de tabela `protocolos`

--

ALTER TABLE protocolos
  MODIFY id_protocolo bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--

-- AUTO_INCREMENT de tabela `recuperacao_senha_tentativas`

--

ALTER TABLE recuperacao_senha_tentativas
  MODIFY id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--

-- AUTO_INCREMENT de tabela `tokens_email`

--

ALTER TABLE tokens_email
  MODIFY id_token bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--

-- AUTO_INCREMENT de tabela `usuarios`

--

ALTER TABLE usuarios
  MODIFY id_usuario int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--

-- Restrições para tabelas despejadas

--

--
-- Restrições para tabelas `admin_mensagens`
--
ALTER TABLE `admin_mensagens`
  ADD CONSTRAINT `fk_admin_msg_admin` FOREIGN KEY (`id_admin`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_admin_msg_destino` FOREIGN KEY (`id_usuario_destino`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE

--

-- Restrições para tabelas `agendamentos_doacao`

--

ALTER TABLE agendamentos_doacao
  ADD CONSTRAINT fk_agenda_doador FOREIGN KEY (id_doador) REFERENCES doadores (id_doador),
  ADD CONSTRAINT fk_agenda_donativo FOREIGN KEY (id_donativo) REFERENCES donativos (id_donativo),
  ADD CONSTRAINT fk_agenda_instituicao FOREIGN KEY (id_instituicao) REFERENCES instituicoes (id_instituicao);

--

-- Restrições para tabelas `confirmacoes_recebimento`

--

ALTER TABLE confirmacoes_recebimento
  ADD CONSTRAINT fk_confirmacao_agendamento FOREIGN KEY (id_agendamento) REFERENCES agendamentos_doacao (id_agendamento) ON DELETE CASCADE;

--

-- Restrições para tabelas `conversas`

--

ALTER TABLE conversas
  ADD CONSTRAINT fk_conversas_doador FOREIGN KEY (id_doador) REFERENCES doadores (id_doador),
  ADD CONSTRAINT fk_conversas_donativo FOREIGN KEY (id_donativo) REFERENCES donativos (id_donativo),
  ADD CONSTRAINT fk_conversas_instituicao FOREIGN KEY (id_instituicao) REFERENCES instituicoes (id_instituicao);

--

-- Restrições para tabelas `cupons`

--

ALTER TABLE cupons
  ADD CONSTRAINT fk_cupons_parceiros FOREIGN KEY (id_parceiro) REFERENCES parceiros (id_parceiro);

--

-- Restrições para tabelas `cupons_doador`

--

ALTER TABLE cupons_doador
  ADD CONSTRAINT fk_cupom_doador_confirmacao FOREIGN KEY (id_confirmacao) REFERENCES confirmacoes_recebimento (id_confirmacao),
  ADD CONSTRAINT fk_cupom_doador_cupom FOREIGN KEY (id_cupom) REFERENCES cupons (id_cupom),
  ADD CONSTRAINT fk_cupom_doador_doador FOREIGN KEY (id_doador) REFERENCES doadores (id_doador),
  ADD CONSTRAINT fk_cupom_doador_donativo FOREIGN KEY (id_donativo) REFERENCES donativos (id_donativo);

--

-- Restrições para tabelas `doacoes_monetarias_pix`

--

ALTER TABLE doacoes_monetarias_pix
  ADD CONSTRAINT fk_pix_doador FOREIGN KEY (id_doador) REFERENCES doadores (id_doador),
  ADD CONSTRAINT fk_pix_instituicao FOREIGN KEY (id_instituicao) REFERENCES instituicoes (id_instituicao);

--

-- Restrições para tabelas `doadores`

--

ALTER TABLE doadores
  ADD CONSTRAINT fk_doadores_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE;

--

-- Restrições para tabelas `donativos`

--

ALTER TABLE donativos
  ADD CONSTRAINT fk_donativos_categorias FOREIGN KEY (id_categoria) REFERENCES categorias_donativo (id_categoria),
  ADD CONSTRAINT fk_donativos_doadores FOREIGN KEY (id_doador) REFERENCES doadores (id_doador),
  ADD CONSTRAINT fk_donativos_endereco FOREIGN KEY (id_endereco_retirada) REFERENCES enderecos (id_endereco);

--

-- Restrições para tabelas `donativo_fotos`

--

ALTER TABLE donativo_fotos
  ADD CONSTRAINT fk_fotos_donativos FOREIGN KEY (id_donativo) REFERENCES donativos (id_donativo) ON DELETE CASCADE;

--

-- Restrições para tabelas `enderecos`

--

ALTER TABLE enderecos
  ADD CONSTRAINT fk_enderecos_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE;

--

-- Restrições para tabelas `instituicao_categorias_atendimento`

--

ALTER TABLE instituicao_categorias_atendimento
  ADD CONSTRAINT fk_inst_cat_categoria FOREIGN KEY (id_categoria_atendimento) REFERENCES categorias_atendimento (id_categoria_atendimento),
  ADD CONSTRAINT fk_inst_cat_instituicao FOREIGN KEY (id_instituicao) REFERENCES instituicoes (id_instituicao) ON DELETE CASCADE;

--

-- Restrições para tabelas `instituicoes`

--

ALTER TABLE instituicoes
  ADD CONSTRAINT fk_instituicoes_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE;

--

-- Restrições para tabelas `logs_auditoria`

--

ALTER TABLE logs_auditoria
  ADD CONSTRAINT fk_logs_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE SET NULL;

--

-- Restrições para tabelas `mensagens`

--

ALTER TABLE mensagens
  ADD CONSTRAINT fk_mensagens_conversas FOREIGN KEY (id_conversa) REFERENCES conversas (id_conversa) ON DELETE CASCADE,
  ADD CONSTRAINT fk_mensagens_usuario FOREIGN KEY (id_usuario_remetente) REFERENCES usuarios (id_usuario);

--

-- Restrições para tabelas `necessidades_instituicao`

--

ALTER TABLE necessidades_instituicao
  ADD CONSTRAINT fk_necessidades_categorias FOREIGN KEY (id_categoria) REFERENCES categorias_donativo (id_categoria),
  ADD CONSTRAINT fk_necessidades_instituicoes FOREIGN KEY (id_instituicao) REFERENCES instituicoes (id_instituicao) ON DELETE CASCADE;

--

-- Restrições para tabelas `tokens_email`

--

ALTER TABLE tokens_email
  ADD CONSTRAINT fk_tokens_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE;

--

-- Restrições para tabelas `usuarios`

--

ALTER TABLE usuarios
  ADD CONSTRAINT fk_usuarios_admin_atualizacao FOREIGN KEY (atualizado_por_admin) REFERENCES usuarios (id_usuario) ON DELETE SET NULL,
  ADD CONSTRAINT fk_usuarios_perfis FOREIGN KEY (id_perfil) REFERENCES perfis_usuario (id_perfil);