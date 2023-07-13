create database eccomerce;
use eccomerce;
create table produto(
idProduto int auto_increment primary key,
categoria enum('Livros','Jogos','Eletronicos'),
valor float,
descricao varchar(60),
nome varchar(20)
);

create table fornecedor(
idFornecedor int auto_increment primary key,
razaoSocial varchar(30),
CNPJ varchar(11) not null,
endereco varchar(30)
);


create table estoque(
idEstoque int auto_increment primary key,
endereco varchar(40) not null,
uf char(3)
);

create table disp(
idDisp int auto_increment primary key,
quantidade float,
dispEstoque int,
dispProduct int,
dispFornecedor int,
constraint fk_disp_produto foreign key (dispProduct) references produto(idProduto),
constraint fk_disp_fornecedor foreign key (dispFornecedor) references fornecedor(idFornecedor),
constraint fk_disp_estoque foreign key (dispEstoque) references estoque(idEstoque)
);


create table cliente(
idCliente int auto_increment primary key,
Nome varchar(30),
CPF char(9),
enderecoCli varchar(30)
);


create table pedido(
idPedido int auto_increment primary key,
pedidoStatus enum ('Processando','Em separação','Saiu Para Entrega','Concluido'),
valorFrete float,
valor float,
cliente int,
constraint fk_pedido_cliente foreign key (cliente) references cliente(idCliente)
);

create table entrega (
idEntrega int auto_increment primary key,
situacao enum('Saiu Para Entrega','Entregue','Separado','Cancelado') default 'Separado',
codRastreio int,
pedido int,
constraint fk_pedido_entrega foreign key (pedido) references pedido(idPedido)
);

create table pagamento(
idPagamento int auto_increment primary key,
tipo enum('Credito','Boleto','Pix'),
pagStatus enum ('Em analise','Aprovado','Recusado'),
pedidoVinc int,
constraint fk_pedido_pagamento foreign key (pedidoVinc) references pedido(idPedido)
);
create table revendedor (
idRevendedor int auto_increment primary key,
razaoSocial varchar(30),
CNPJ varchar(11)
);

create table orcamento(
idOrcamento int auto_increment primary key,
revendedor int,
produto int,
quantidade int,
constraint fk_produto_orca foreign key (produto) references produto(idProduto),
constraint fk_revendedor_orc foreign key (revendedor) references revendedor(idRevendedor)
);

-- preenchendo tabelas
-- produto
insert into produto(idProduto,categoria,valor,descricao,nome) values 
		(1,'Livros',30.50,'Livro de filosofia','Sobre a Ira'),
        (2,'Livros',29.99,'Livro de Direito','A Lei'),
        (3,'Jogos',300.50,'Jogo PS5','Spiderman'),
        (4,'Jogos',350,'Jogo Nintendo','Zelda'),
        (5,'Eletronicos',1000.50,'Smartphone','Samsung A99');

-- fornecedor
insert into fornecedor (idFornecedor,razaoSocial,CNPJ,endereco) values
		(1,'Samsung',101010,'Rua Liberdade'),
        (2,'Apple',111111,'Rua São Francisco'),
        (3,'Nova Fronteira',121212,'Rua São João'),
        (4,'Intriseca',131313,'Rua São João'),
        (5,'Sony',141414,'Rua LIberdade');

-- estoque 
insert into estoque (idEstoque,endereco,uf) values
			(1,'rua São João','SP'),
            (2,'rua Liberdade','SP'),
			(3,'AV Angelica','SP'),
			(4,'Tres Corações','MG');
            
--  disponibiliza
insert into disp (idDisp,quantidade,dispEstoque,dispProduct,dispFornecedor) values
		(1,100,1,1,4),
        (2,100,1,2,2),
        (3,100,4,3,3),
        (4,100,1,1,5);
-- cliente
insert into cliente (idCliente,Nome,CPF,enderecoCli) values
		(1,'fulano',12345678,'almd das couves'),
        (2,'cicrano',87654321,'almd dos morros'),
        (3,'beltrano',11223344,'almd das couves'),
        (4,'Chunda',88776655,'almd das couves');

-- pedido
insert into pedido (idPedido,pedidoStatus,valorFrete,valor,cliente) values
		(1,'Concluido',10.00,40.50,1),
        (2,'Concluido',10.00,40.50,2),
        (3,'Processando',9.00,309.50,3);

-- entrega
insert into entrega (idEntrega,situacao,codRastreio,pedido) values 
		(1,'Separado',111,1),
		(2,'Separado',222,2),
        (3,'Entregue',333,3);

	
-- pagamento
insert into pagamento (idPagamento,tipo,pagStatus,pedidoVinc) values
			(1,'Pix','Aprovado',1),
            (2,'Pix','Aprovado',2),
            (3,'Credito','Aprovado',3);

           
-- revendedor
insert into revendedor(idRevendedor,razaoSocial,CNPJ) values
		(1,'171 ltda',1111),
        (2,'AG ota ltda',2222),
        (3,'ceo zé ltda',3333),
        (4,'Épou',4444);

-- orcamento
insert into orcamento (idOrcamento,revendedor,produto,quantidade)values
			(1,1,3,100),
            (2,2,4,100),
            (3,3,1,100),
            (4,4,5,100);




-- ATUALIZANDO O STATUS DA ENTREGA
DELIMITER //
CREATE TRIGGER atualização_entrega
ON entrega
BEFORE DELETE ON entrega
FOR EACH ROW
BEGIN
when situacao='Separado' insert into entrega (situacao) values 
		('Entregue');
END 
DELIMITER //;


-- atualizando orçamento de revendedor
DELIMITER //
CREATE TRIGGER atualização_ORCAMENTO
ON orcamento
BEFORE UPDATE ON orcamento
FOR EACH ROW
BEGIN
SET new.quantidade=new.quantidade+100;
END 
DELIMITER //;