USE [master]
GO
/****** Object:  Database [p1g2]    Script Date: 12/06/2020 23:52:16 ******/
CREATE DATABASE [p1g2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'p1g2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\p1g2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'p1g2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\p1g2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [p1g2] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [p1g2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [p1g2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [p1g2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [p1g2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [p1g2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [p1g2] SET ARITHABORT OFF 
GO
ALTER DATABASE [p1g2] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [p1g2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [p1g2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [p1g2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [p1g2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [p1g2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [p1g2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [p1g2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [p1g2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [p1g2] SET  ENABLE_BROKER 
GO
ALTER DATABASE [p1g2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [p1g2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [p1g2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [p1g2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [p1g2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [p1g2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [p1g2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [p1g2] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [p1g2] SET  MULTI_USER 
GO
ALTER DATABASE [p1g2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [p1g2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [p1g2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [p1g2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [p1g2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [p1g2] SET QUERY_STORE = OFF
GO
USE [p1g2]
GO
/****** Object:  User [p1g2]    Script Date: 12/06/2020 23:52:17 ******/
CREATE USER [p1g2] FOR LOGIN [p1g2] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [p1g2]
GO
/****** Object:  Schema [BIBLIOTECA]    Script Date: 12/06/2020 23:52:17 ******/
CREATE SCHEMA [BIBLIOTECA]
GO
/****** Object:  Schema [GESTAO_CONFERENCIAS]    Script Date: 12/06/2020 23:52:17 ******/
CREATE SCHEMA [GESTAO_CONFERENCIAS]
GO
/****** Object:  Schema [Prescricao_Medicamentos]    Script Date: 12/06/2020 23:52:17 ******/
CREATE SCHEMA [Prescricao_Medicamentos]
GO
/****** Object:  Schema [RENT_A_CAR]    Script Date: 12/06/2020 23:52:17 ******/
CREATE SCHEMA [RENT_A_CAR]
GO
/****** Object:  Schema [reservas_voo]    Script Date: 12/06/2020 23:52:17 ******/
CREATE SCHEMA [reservas_voo]
GO
/****** Object:  Schema [reservas_voos]    Script Date: 12/06/2020 23:52:17 ******/
CREATE SCHEMA [reservas_voos]
GO
/****** Object:  Schema [stock_orders]    Script Date: 12/06/2020 23:52:17 ******/
CREATE SCHEMA [stock_orders]
GO
/****** Object:  Schema [UNIVERSIDADE]    Script Date: 12/06/2020 23:52:17 ******/
CREATE SCHEMA [UNIVERSIDADE]
GO
/****** Object:  UserDefinedFunction [BIBLIOTECA].[CheckRemoveLivro]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Function [BIBLIOTECA].[CheckRemoveLivro](@isbn varchar(50)) returns bit
as
begin
	declare @date as date;
	declare @remove as bit = 1;

	declare C cursor
	for select e.data_chegada from BIBLIOTECA.Livro as l join BIBLIOTECA.Livros_Exemplares as le on l.ISBN=le.ISBN
				join BIBLIOTECA.Emprestimo as e on le.n_emprestimo=e.n_emprestimo 
				where l.ISBN = @isbn
	open C;
	fetch C into @date;

	while @@FETCH_STATUS = 0
		begin
			if @date is null
			begin
				set @remove = 0;
			end
			fetch next from  C into @date;
		end;
	close C;
	Deallocate C;

	return @remove
end
GO
/****** Object:  Table [BIBLIOTECA].[Editora]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Editora](
	[id_editora] [int] IDENTITY(1,1) NOT NULL,
	[nome_editora] [varchar](50) NOT NULL,
	[endereco] [varchar](255) NULL,
	[telefone] [decimal](9, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_editora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BIBLIOTECA].[Livro]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Livro](
	[ISBN] [varchar](50) NOT NULL,
	[titulo] [varchar](100) NOT NULL,
	[ano] [int] NOT NULL,
	[id_editora] [int] NOT NULL,
	[categoria] [varchar](75) NULL,
PRIMARY KEY CLUSTERED 
(
	[ISBN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BIBLIOTECA].[Emprestimo]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Emprestimo](
	[n_emprestimo] [int] IDENTITY(1,1) NOT NULL,
	[data_saida] [date] NOT NULL,
	[data_entrega] [date] NOT NULL,
	[data_chegada] [date] NULL,
	[funcionario] [int] NULL,
	[cliente] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[n_emprestimo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BIBLIOTECA].[Livros_Exemplares]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Livros_Exemplares](
	[numero_exemplar] [int] IDENTITY(1,1) NOT NULL,
	[n_emprestimo] [int] NOT NULL,
	[ISBN] [varchar](50) NOT NULL,
	[data_de_aquisicao] [date] NOT NULL,
	[estado] [varchar](50) NULL,
	[cota] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[numero_exemplar] ASC,
	[n_emprestimo] ASC,
	[ISBN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [BIBLIOTECA].[GetClientHistorico]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [BIBLIOTECA].[GetClientHistorico](@clienteId int) returns Table
 as
	return(select emp.n_emprestimo, data_saida,data_entrega,data_chegada,numero_exemplar,le.ISBN,titulo,ano,categoria,nome_editora,cota 
			from Biblioteca.Emprestimo as emp 
				join BIBLIOTECA.Livros_Exemplares as le on emp.n_emprestimo = le.n_emprestimo
				join BIBLIOTECA.Livro as li on le.ISBN=li.ISBN
				join BIBLIOTECA.Editora as ed on li.id_editora=ed.id_editora
			where cliente = @clienteId )
GO
/****** Object:  UserDefinedFunction [BIBLIOTECA].[listarExemplaresDeUmLivro]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BIBLIOTECA].[listarExemplaresDeUmLivro](@ISBN varchar(50)) returns Table
as
	return(select le.ISBN,le.cota,le.estado,le.numero_exemplar,le.n_emprestimo,e.data_chegada
					from BIBLIOTECA.Livros_Exemplares as le join Biblioteca.Emprestimo as e 
					on le.n_emprestimo=e.n_emprestimo
					where le.ISBN=@ISBN
					group by le.ISBN,le.cota,le.estado,le.numero_exemplar,le.n_emprestimo,e.data_chegada)
GO
/****** Object:  UserDefinedFunction [BIBLIOTECA].[ContarLivrosDisponiveis]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BIBLIOTECA].[ContarLivrosDisponiveis](@ISBN varchar(50)) returns Table
as
	return(select le.ISBN, count(*) as Disponiveis
					from BIBLIOTECA.Livros_Exemplares as le join Biblioteca.Emprestimo as e 
					on le.n_emprestimo=e.n_emprestimo
					where le.ISBN=@ISBN and e.data_chegada is not null
					Group by le.ISBN)

GO
/****** Object:  Table [BIBLIOTECA].[Cliente]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Cliente](
	[id_cliente] [int] NOT NULL,
	[morada] [varchar](255) NOT NULL,
	[mail] [varchar](100) NOT NULL,
	[nif] [decimal](9, 0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [BIBLIOTECA].[ContarLivrosEmFalta]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BIBLIOTECA].[ContarLivrosEmFalta](@id_client int) returns Table
as
	return(select count(*) as EmFalta
					from (BIBLIOTECA.Livros_Exemplares as le join Biblioteca.Emprestimo as e 
					on le.n_emprestimo=e.n_emprestimo) join Biblioteca.Cliente as c on e.cliente = c.id_cliente
					where c.id_cliente = @id_client and e.data_chegada is null
			)

GO
/****** Object:  Table [BIBLIOTECA].[Autor]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Autor](
	[id_autor] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_autor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BIBLIOTECA].[Escreve]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Escreve](
	[id_livro] [varchar](50) NOT NULL,
	[id_autor] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_livro] ASC,
	[id_autor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BIBLIOTECA].[Funcionario]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Funcionario](
	[id_funcionario] [int] NOT NULL,
	[morada] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BIBLIOTECA].[Nao_Socio]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Nao_Socio](
	[id_cliente] [int] NOT NULL,
	[forma_pagamento] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BIBLIOTECA].[Pessoa]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Pessoa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[data_nascimento] [date] NULL,
	[telefone] [decimal](9, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BIBLIOTECA].[Socio]    Script Date: 12/06/2020 23:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIBLIOTECA].[Socio](
	[comprovativo] [varchar](50) NULL,
	[id_socio] [int] NOT NULL,
	[id_cliente] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_socio] ASC,
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (71)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (72)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (73)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (74)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (75)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (76)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (77)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (78)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (79)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (80)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (81)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (82)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (83)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (84)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (85)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (86)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (87)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (88)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (89)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (90)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (91)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (92)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (93)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (94)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (95)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (96)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (97)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (98)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (99)
INSERT [BIBLIOTECA].[Autor] ([id_autor]) VALUES (100)
GO
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (1, N'0162 Valley Edge Drive', N'fmumford0@parallels.com', CAST(339451477 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (2, N'5325 Spenser Street', N'fcanty1@java.com', CAST(343304028 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (3, N'3059 Arizona Crossing', N'jleynton2@sitemeter.com', CAST(704067254 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (4, N'02936 Nelson Way', N'rnowakowski3@ox.ac.uk', CAST(999924150 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (5, N'2044 Pine View Parkway', N'amackrell4@boston.com', CAST(440653953 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (6, N'9 Manitowish Way', N'mhudspeth5@va.gov', CAST(621447256 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (7, N'09 Debra Crossing', N'kgleeton6@techcrunch.com', CAST(332716305 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (8, N'51182 Clove Park', N'tkupper7@sun.com', CAST(442003756 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (9, N'80 Veith Parkway', N'gbodd8@sogou.com', CAST(613075893 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (10, N'50117 Green Alley', N'hnorthrop9@freewebs.com', CAST(576709125 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (11, N'6461 Meadow Ridge Terrace', N'gsmalmana@hp.com', CAST(373999934 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (12, N'9603 Evergreen Plaza', N'tpepallb@time.com', CAST(493019429 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (13, N'9 Dakota Circle', N'eprobackc@yahoo.com', CAST(941313876 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (14, N'41860 Eggendart Drive', N'lmowsond@disqus.com', CAST(323462706 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (15, N'602 Sycamore Park', N'vbeddoese@census.gov', CAST(813078486 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (16, N'843 Declaration Trail', N'cgowlingf@instagram.com', CAST(126517136 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (17, N'99 2nd Parkway', N'mortzeng@opensource.org', CAST(492162624 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (18, N'14 Vahlen Place', N'jbohmanh@gmpg.org', CAST(708068578 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (19, N'4018 Pepper Wood Circle', N'rbirdisi@ovh.net', CAST(599110042 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (20, N'9 Blaine Alley', N'mhawkswoodj@paypal.com', CAST(190631577 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (21, N'46197 Hanover Place', N'grussik@dell.com', CAST(481617403 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (22, N'08437 Waywood Park', N'cwernherl@google.es', CAST(838142958 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (23, N'9439 Sutteridge Drive', N'smartinuzzim@mashable.com', CAST(716185852 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (24, N'7259 Pearson Avenue', N'aalywenn@npr.org', CAST(762010814 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (25, N'1 Pepper Wood Parkway', N'ocrokero@bbb.org', CAST(676045217 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (26, N'1 Straubel Avenue', N'mcathrallp@sakura.ne.jp', CAST(494299560 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (27, N'8126 Elmside Crossing', N'cclemmensenq@va.gov', CAST(603358664 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (28, N'8 Kensington Trail', N'gmccoyr@reverbnation.com', CAST(107212427 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (29, N'671 Forest Run Plaza', N'dnutbeans@twitter.com', CAST(719079013 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (30, N'8717 Ohio Street', N'kgauntert@usa.gov', CAST(642270997 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (31, N'9 Center Road', N'anawtonu@etsy.com', CAST(419669634 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (32, N'82654 Prairieview Street', N'fstranierov@myspace.com', CAST(864207138 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (33, N'8 Old Gate Trail', N'lmillomw@istockphoto.com', CAST(239650120 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (34, N'6345 Longview Center', N'dtantex@ucsd.edu', CAST(237392146 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (35, N'10 Blackbird Place', N'dhacardy@wikipedia.org', CAST(39235406 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (36, N'0756 Commercial Center', N'dtemlettz@about.me', CAST(860966851 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (37, N'807 Bonner Point', N'obunclark10@drupal.org', CAST(985997751 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (38, N'4059 Manley Junction', N'pnoke11@springer.com', CAST(612345034 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (39, N'2 Banding Pass', N'ypetrecz12@mediafire.com', CAST(628229626 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (40, N'72671 Debra Park', N'aspoole13@google.com.br', CAST(553446423 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (41, N'0903 Eagan Terrace', N'cwelbourn14@behance.net', CAST(373736199 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (42, N'7103 Kennedy Alley', N'privers15@csmonitor.com', CAST(939402245 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (43, N'3 Buena Vista Pass', N'lvanyatin16@latimes.com', CAST(449090616 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (44, N'51117 Messerschmidt Way', N'oleipoldt17@discuz.net', CAST(128867240 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (45, N'23005 Blackbird Drive', N'aogrowgane18@cornell.edu', CAST(158163358 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (46, N'2 Sutteridge Circle', N'asayer19@nature.com', CAST(758412583 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (47, N'35636 Bultman Point', N'tsherwen1a@techcrunch.com', CAST(590223021 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (48, N'3 Oakridge Alley', N'lpainter1b@hostgator.com', CAST(124494345 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (49, N'00709 Washington Park', N'cshapera1c@alibaba.com', CAST(495722581 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (50, N'5 Carioca Road', N'bmackeague1d@samsung.com', CAST(157417217 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (51, N'31158 Springs Plaza', N'scheverton1e@chicagotribune.com', CAST(149882423 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (52, N'012 Russell Point', N'vspridgeon1f@omniture.com', CAST(691548398 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (53, N'3 Scott Alley', N'jbernette1g@slate.com', CAST(250211563 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (54, N'6 Northland Crossing', N'flewknor1h@cocolog-nifty.com', CAST(978145652 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (55, N'0962 Mandrake Way', N'fruggieri1i@flickr.com', CAST(257139177 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (56, N'91 Hayes Crossing', N'dsubhan1j@washington.edu', CAST(504864096 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (57, N'1 Browning Parkway', N'gfigge1k@va.gov', CAST(352737842 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (58, N'90754 Doe Crossing Road', N'tzorn1l@bbc.co.uk', CAST(870679912 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (59, N'80080 Killdeer Trail', N'kanthes1m@theguardian.com', CAST(272800272 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (60, N'77150 Utah Circle', N'hwannes1n@nsw.gov.au', CAST(631303483 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (61, N'182 Sugar Center', N'bklausewitz1o@jiathis.com', CAST(765587810 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (62, N'3340 Debs Drive', N'ejameson1p@lycos.com', CAST(714826310 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (63, N'0 Sutteridge Court', N'mmebes1q@creativecommons.org', CAST(938374533 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (64, N'10502 Lyons Center', N'ngodier1r@reverbnation.com', CAST(230963518 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (65, N'570 Oneill Pass', N'fbroxup1s@reference.com', CAST(326080041 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (66, N'62 Riverside Way', N'zgliddon1t@usa.gov', CAST(732600237 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (67, N'4 Autumn Leaf Hill', N'nbillin1u@1und1.de', CAST(992400787 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (68, N'10121 Fordem Crossing', N'molivie1v@a8.net', CAST(529324831 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (69, N'47068 Meadow Valley Alley', N'pgiabuzzi1w@bbb.org', CAST(485578746 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Cliente] ([id_cliente], [morada], [mail], [nif]) VALUES (70, N'8889 Hollow Ridge Circle', N'tbeales1x@state.gov', CAST(995383813 AS Decimal(9, 0)))
GO
SET IDENTITY_INSERT [BIBLIOTECA].[Editora] ON 

INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (1, N'Bogan-Grimes', N'4 Sachtjen Court', CAST(955362012 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (2, N'Murray-Morissette', N'0705 Texas Terrace', CAST(930040562 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (3, N'Schmeler, Zemlak and Kohler', N'596 Dennis Court', CAST(927328694 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (4, N'Dibbert, Dare and Mayer', N'588 Canary Lane', CAST(908268831 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (5, N'Kuvalis Inc', N'31651 Mallard Place', CAST(919012828 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (6, N'Rolfson and Sons', N'62 Dahle Hill', CAST(926540390 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (7, N'Abernathy, Walter and Fisher', N'724 Union Lane', CAST(933456730 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (8, N'Simonis, Spinka and Wintheiser', N'086 Mcbride Road', CAST(911499579 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (9, N'Grant, Tillman and Mayert', N'3 Tennyson Point', CAST(946988801 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (10, N'Haley Inc', N'6 Buena Vista Terrace', CAST(925540548 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (11, N'Veum, Hirthe and Doyle', N'63 Holmberg Hill', CAST(994795335 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (12, N'Gulgowski-Spinka', N'48 Merchant Street', CAST(971721059 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (13, N'Kuhn-Hansen', N'9 2nd Terrace', CAST(996373771 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (14, N'Witting-Morar', N'8 Valley Edge Circle', CAST(923445900 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (15, N'Hansen-Mosciski', N'8665 Warner Terrace', CAST(985996379 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (16, N'Hilll-Hyatt', N'36 Waywood Avenue', CAST(951763122 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (17, N'Rau and Sons', N'4156 Anzinger Way', CAST(950156002 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (18, N'Torp LLC', N'644 Mayer Trail', CAST(925777299 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (19, N'Wilkinson, Tillman and Bergstrom', N'5 Merrick Way', CAST(952657513 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (20, N'Weissnat-Volkman', N'690 Kennedy Pass', CAST(906459317 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (21, N'Dibbert-Bernier', N'7 Riverside Alley', CAST(900789733 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (22, N'Kulas Group', N'2 Artisan Crossing', CAST(971675952 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (23, N'Keeling and Sons', N'07 Mallard Road', CAST(912790569 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (24, N'Lemke-Thompson', N'6 Valley Edge Drive', CAST(957953837 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (25, N'Mitchell-Schmidt', N'2291 Grover Terrace', CAST(925763284 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (26, N'Medhurst LLC', N'3 Lien Parkway', CAST(976993833 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (27, N'O''Connell Inc', N'59614 Corry Road', CAST(905328882 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (28, N'Grimes-Parker', N'351 Westport Center', CAST(936176616 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (29, N'Keebler-Herman', N'09 Surrey Point', CAST(923874273 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (30, N'VonRueden, Kuvalis and Hilll', N'5 Twin Pines Terrace', CAST(974457096 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (31, N'Jenkins-Farrell', N'49006 Ronald Regan Way', CAST(910139920 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (32, N'Kulas-Mueller', N'07 Washington Parkway', CAST(954660415 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (33, N'Crona-Mohr', N'00427 Crest Line Trail', CAST(989934269 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (34, N'Gutkowski-Romaguera', N'01249 Magdeline Point', CAST(911457309 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (35, N'Trantow, Kautzer and Tromp', N'4 Trailsway Parkway', CAST(974562922 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (36, N'Metz Group', N'18722 Spohn Plaza', CAST(994731882 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (37, N'Fadel-Weissnat', N'447 Blaine Park', CAST(941536604 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (38, N'Ortiz-Olson', N'75 Michigan Point', CAST(920751641 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (39, N'Kovacek Group', N'58 Vera Lane', CAST(966182740 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (40, N'Hackett-Huel', N'99 Katie Alley', CAST(936006281 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (41, N'Orn-Grant', N'4 Forest Run Way', CAST(913604416 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (42, N'Kohler-Will', N'6262 Ludington Crossing', CAST(903727161 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (43, N'Grant-Marvin', N'61 Pond Avenue', CAST(912713527 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (44, N'Haag, Williamson and Hoppe', N'90355 Surrey Drive', CAST(938175909 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (45, N'McCullough-Raynor', N'249 Magdeline Point', CAST(943670872 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (46, N'Funk Group', N'2 Kingsford Court', CAST(995936779 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (47, N'Shanahan Group', N'239 1st Point', CAST(950981386 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (48, N'Bins-Boyer', N'8835 Fallview Way', CAST(905411532 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (49, N'Beatty-Wintheiser', N'51912 Corscot Lane', CAST(916681823 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (50, N'Effertz, Zulauf and Kiehn', N'7 Almo Plaza', CAST(927550975 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (51, N'Schroeder LLC', N'16 Kensington Park', CAST(979613279 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (52, N'Jones, Hagenes and Mayer', N'3709 Mayer Parkway', CAST(931630945 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (53, N'Labadie LLC', N'63166 Banding Street', CAST(903561251 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (54, N'Dooley Group', N'274 Carberry Pass', CAST(975273517 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (55, N'Terry LLC', N'5378 Hollow Ridge Junction', CAST(922134457 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (56, N'Harris, Volkman and Simonis', N'1161 Lakeland Pass', CAST(933915526 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (57, N'Von Group', N'33 Scott Parkway', CAST(926589401 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (58, N'Jaskolski, Kling and Barton', N'484 Surrey Center', CAST(979961548 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (59, N'Gerlach Inc', N'57886 Kensington Point', CAST(975034823 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (60, N'Strosin, Stehr and Hettinger', N'0536 Loftsgordon Way', CAST(980484274 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (61, N'Larkin, Johnston and Bayer', N'6154 Division Parkway', CAST(927395964 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (62, N'Schimmel-Koelpin', N'010 Fairfield Terrace', CAST(980107905 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (63, N'Ryan-Kozey', N'13 Packers Circle', CAST(919385209 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (64, N'Kertzmann and Sons', N'8 Pearson Place', CAST(945883655 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (65, N'Gulgowski LLC', N'56 Meadow Valley Junction', CAST(931980827 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (66, N'Green Inc', N'8496 Randy Park', CAST(978823338 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (67, N'Feil-King', N'9 Goodland Circle', CAST(970495136 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (68, N'Klein, Watsica and Beatty', N'22 Del Mar Avenue', CAST(982436663 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (69, N'Watsica Inc', N'1 Spaight Plaza', CAST(918516040 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (70, N'Shields-Crooks', N'4 Brickson Park Alley', CAST(917600151 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (71, N'Fritsch-Dickens', N'2 Kings Lane', CAST(927188921 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (72, N'Carroll and Sons', N'51 Vidon Way', CAST(934827432 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (73, N'Beatty, Murray and Stark', N'20604 Hazelcrest Park', CAST(975431146 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (74, N'Hessel-Lemke', N'04617 Fremont Point', CAST(968973153 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (75, N'Tillman-Gibson', N'22 Reinke Road', CAST(915589703 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (76, N'Greenholt and Sons', N'98 Ridgeway Road', CAST(918747415 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (77, N'Robel, Collins and Hudson', N'490 Waxwing Road', CAST(925494254 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (78, N'Collier and Sons', N'3 Lien Center', CAST(979454497 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (79, N'Schmeler Inc', N'9083 Bonner Parkway', CAST(913723170 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (80, N'Schultz, Wolff and Dibbert', N'5 Brown Circle', CAST(919908405 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (81, N'Murphy-Huels', N'8 Luster Plaza', CAST(901153149 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (82, N'Sporer, Green and Cole', N'633 Muir Plaza', CAST(977406146 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (83, N'Mosciski, Rutherford and Considine', N'7874 Valley Edge Circle', CAST(999488756 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (84, N'Kreiger-Ullrich', N'5975 Morningstar Center', CAST(952807835 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (85, N'Ortiz-Spencer', N'739 Stephen Park', CAST(927448627 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (86, N'Jaskolski, Jenkins and Leuschke', N'7 Straubel Way', CAST(956495404 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (87, N'Jast, Krajcik and McGlynn', N'65283 Schurz Court', CAST(993639729 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (88, N'Heidenreich LLC', N'425 Crownhardt Road', CAST(964875781 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (89, N'Corwin, Zemlak and Boyer', N'7 Cambridge Plaza', CAST(922652728 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (90, N'Gerlach-Hodkiewicz', N'15 Lotheville Plaza', CAST(925093004 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (91, N'Gislason, Durgan and Mitchell', N'9 Huxley Crossing', CAST(990247033 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (92, N'Krajcik, Ratke and Kreiger', N'0333 6th Court', CAST(935291942 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (93, N'Pfeffer, Wolf and Littel', N'15802 Mockingbird Hill', CAST(914566566 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (94, N'Fisher-Schamberger', N'228 Grim Circle', CAST(991002427 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (95, N'Corwin-Tremblay', N'4906 Pleasure Parkway', CAST(900680023 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (96, N'Harvey, Beer and Bergnaum', N'0477 Warrior Alley', CAST(981261932 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (97, N'Roberts Group', N'36 Miller Center', CAST(903830853 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (98, N'Crist, Breitenberg and Quigley', N'9 Moulton Alley', CAST(952247942 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (99, N'Runte-Krajcik', N'1 Anhalt Pass', CAST(919228009 AS Decimal(9, 0)))
GO
INSERT [BIBLIOTECA].[Editora] ([id_editora], [nome_editora], [endereco], [telefone]) VALUES (100, N'Treutel, Breitenberg and Gerhold', N'7 Scoville Court', CAST(944592605 AS Decimal(9, 0)))
SET IDENTITY_INSERT [BIBLIOTECA].[Editora] OFF
GO
SET IDENTITY_INSERT [BIBLIOTECA].[Emprestimo] ON 

INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (1, CAST(N'2020-06-09' AS Date), CAST(N'2020-06-09' AS Date), CAST(N'2020-06-09' AS Date), NULL, NULL)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (2, CAST(N'2019-08-30' AS Date), CAST(N'2019-09-14' AS Date), CAST(N'2019-09-03' AS Date), 111, 16)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (3, CAST(N'2019-05-05' AS Date), CAST(N'2019-05-20' AS Date), CAST(N'2019-05-16' AS Date), 115, 44)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (4, CAST(N'2019-09-03' AS Date), CAST(N'2019-09-18' AS Date), CAST(N'2019-09-11' AS Date), 105, 54)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (5, CAST(N'2019-09-20' AS Date), CAST(N'2019-10-05' AS Date), NULL, 105, 7)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (6, CAST(N'2020-03-27' AS Date), CAST(N'2020-04-11' AS Date), CAST(N'2020-04-08' AS Date), 106, 4)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (7, CAST(N'2020-02-27' AS Date), CAST(N'2020-03-13' AS Date), CAST(N'2020-03-12' AS Date), 115, 7)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (8, CAST(N'2019-07-31' AS Date), CAST(N'2019-08-15' AS Date), CAST(N'2019-08-12' AS Date), 112, 67)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (9, CAST(N'2020-04-29' AS Date), CAST(N'2020-05-14' AS Date), NULL, 103, 44)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (10, CAST(N'2019-06-21' AS Date), CAST(N'2019-07-06' AS Date), CAST(N'2019-06-30' AS Date), 106, 47)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (11, CAST(N'2019-06-12' AS Date), CAST(N'2019-06-27' AS Date), CAST(N'2019-06-18' AS Date), 111, 50)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (12, CAST(N'2019-12-24' AS Date), CAST(N'2020-01-08' AS Date), CAST(N'2019-12-28' AS Date), 113, 30)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (13, CAST(N'2019-10-11' AS Date), CAST(N'2019-10-26' AS Date), NULL, 105, 70)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (14, CAST(N'2019-09-25' AS Date), CAST(N'2019-10-10' AS Date), NULL, 111, 28)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (15, CAST(N'2020-02-16' AS Date), CAST(N'2020-03-02' AS Date), NULL, 112, 9)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (16, CAST(N'2019-08-30' AS Date), CAST(N'2019-09-14' AS Date), NULL, 103, 8)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (17, CAST(N'2020-02-18' AS Date), CAST(N'2020-03-04' AS Date), CAST(N'2020-03-01' AS Date), 108, 48)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (18, CAST(N'2019-10-14' AS Date), CAST(N'2019-10-29' AS Date), NULL, 110, 16)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (19, CAST(N'2020-01-16' AS Date), CAST(N'2020-01-31' AS Date), CAST(N'2020-01-19' AS Date), 112, 5)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (20, CAST(N'2020-04-22' AS Date), CAST(N'2020-05-07' AS Date), CAST(N'2020-04-29' AS Date), 103, 42)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (21, CAST(N'2020-04-09' AS Date), CAST(N'2020-04-24' AS Date), CAST(N'2020-04-23' AS Date), 103, 46)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (22, CAST(N'2019-10-05' AS Date), CAST(N'2019-10-20' AS Date), CAST(N'2019-10-19' AS Date), 109, 18)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (23, CAST(N'2019-08-10' AS Date), CAST(N'2019-08-25' AS Date), NULL, 107, 46)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (24, CAST(N'2020-01-03' AS Date), CAST(N'2020-01-18' AS Date), CAST(N'2020-01-10' AS Date), 101, 23)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (25, CAST(N'2020-01-03' AS Date), CAST(N'2020-01-18' AS Date), CAST(N'2020-01-10' AS Date), 112, 41)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (26, CAST(N'2019-08-04' AS Date), CAST(N'2019-08-19' AS Date), CAST(N'2019-08-08' AS Date), 108, 26)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (27, CAST(N'2020-02-13' AS Date), CAST(N'2020-02-28' AS Date), CAST(N'2020-02-26' AS Date), 114, 43)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (28, CAST(N'2020-05-03' AS Date), CAST(N'2020-05-18' AS Date), CAST(N'2020-05-04' AS Date), 112, 57)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (29, CAST(N'2019-08-24' AS Date), CAST(N'2019-09-08' AS Date), CAST(N'2019-08-30' AS Date), 103, 24)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (30, CAST(N'2020-04-07' AS Date), CAST(N'2020-04-22' AS Date), CAST(N'2020-04-12' AS Date), 104, 21)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (31, CAST(N'2019-09-13' AS Date), CAST(N'2019-09-28' AS Date), CAST(N'2019-09-14' AS Date), 113, 21)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (32, CAST(N'2019-09-26' AS Date), CAST(N'2019-10-11' AS Date), CAST(N'2019-10-10' AS Date), 105, 5)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (33, CAST(N'2019-09-13' AS Date), CAST(N'2019-09-28' AS Date), CAST(N'2019-09-21' AS Date), 115, 66)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (34, CAST(N'2019-05-08' AS Date), CAST(N'2019-05-23' AS Date), CAST(N'2019-05-22' AS Date), 106, 42)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (35, CAST(N'2019-12-14' AS Date), CAST(N'2019-12-29' AS Date), CAST(N'2019-12-20' AS Date), 103, 46)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (36, CAST(N'2019-11-20' AS Date), CAST(N'2019-12-05' AS Date), NULL, 111, 53)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (37, CAST(N'2019-12-31' AS Date), CAST(N'2020-01-15' AS Date), CAST(N'2020-01-09' AS Date), 103, 27)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (38, CAST(N'2019-07-05' AS Date), CAST(N'2019-07-20' AS Date), NULL, 103, 1)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (39, CAST(N'2019-07-13' AS Date), CAST(N'2019-07-28' AS Date), NULL, 105, 64)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (40, CAST(N'2020-05-01' AS Date), CAST(N'2020-05-16' AS Date), CAST(N'2020-05-10' AS Date), 106, 50)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (41, CAST(N'2019-11-17' AS Date), CAST(N'2019-12-02' AS Date), NULL, 113, 16)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (42, CAST(N'2019-08-14' AS Date), CAST(N'2019-08-29' AS Date), CAST(N'2019-08-15' AS Date), 114, 37)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (43, CAST(N'2019-12-05' AS Date), CAST(N'2019-12-20' AS Date), CAST(N'2019-12-06' AS Date), 103, 51)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (44, CAST(N'2019-12-30' AS Date), CAST(N'2020-01-14' AS Date), CAST(N'2020-01-11' AS Date), 110, 30)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (45, CAST(N'2019-05-11' AS Date), CAST(N'2019-05-26' AS Date), CAST(N'2019-05-26' AS Date), 103, 12)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (46, CAST(N'2019-12-28' AS Date), CAST(N'2020-01-12' AS Date), NULL, 106, 70)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (47, CAST(N'2019-10-26' AS Date), CAST(N'2019-11-10' AS Date), CAST(N'2019-10-28' AS Date), 115, 21)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (48, CAST(N'2020-02-13' AS Date), CAST(N'2020-02-28' AS Date), CAST(N'2020-02-15' AS Date), 103, 8)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (49, CAST(N'2019-08-29' AS Date), CAST(N'2019-09-13' AS Date), CAST(N'2019-09-06' AS Date), 103, 48)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (50, CAST(N'2020-03-21' AS Date), CAST(N'2020-04-05' AS Date), CAST(N'2020-04-03' AS Date), 114, 53)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (51, CAST(N'2019-10-26' AS Date), CAST(N'2019-11-10' AS Date), CAST(N'2019-11-05' AS Date), 105, 27)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (52, CAST(N'2019-12-07' AS Date), CAST(N'2019-12-22' AS Date), CAST(N'2019-12-17' AS Date), 103, 68)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (53, CAST(N'2020-02-28' AS Date), CAST(N'2020-03-14' AS Date), CAST(N'2020-03-03' AS Date), 103, 62)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (54, CAST(N'2019-12-02' AS Date), CAST(N'2019-12-17' AS Date), CAST(N'2019-12-11' AS Date), 111, 15)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (55, CAST(N'2019-10-08' AS Date), CAST(N'2019-10-23' AS Date), CAST(N'2019-10-23' AS Date), 106, 40)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (56, CAST(N'2020-04-15' AS Date), CAST(N'2020-04-30' AS Date), NULL, 105, 5)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (57, CAST(N'2019-05-12' AS Date), CAST(N'2019-05-27' AS Date), CAST(N'2019-05-25' AS Date), 109, 30)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (58, CAST(N'2020-02-12' AS Date), CAST(N'2020-02-27' AS Date), CAST(N'2020-02-14' AS Date), 109, 41)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (59, CAST(N'2019-06-12' AS Date), CAST(N'2019-06-27' AS Date), CAST(N'2019-06-14' AS Date), 113, 34)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (60, CAST(N'2019-05-05' AS Date), CAST(N'2019-05-20' AS Date), CAST(N'2019-05-12' AS Date), 112, 34)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (61, CAST(N'2019-11-22' AS Date), CAST(N'2019-12-07' AS Date), NULL, 111, 54)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (62, CAST(N'2019-10-05' AS Date), CAST(N'2019-10-20' AS Date), CAST(N'2019-10-15' AS Date), 107, 42)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (63, CAST(N'2019-08-01' AS Date), CAST(N'2019-08-16' AS Date), CAST(N'2019-08-07' AS Date), 112, 50)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (64, CAST(N'2019-08-12' AS Date), CAST(N'2019-08-27' AS Date), CAST(N'2019-08-14' AS Date), 106, 12)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (65, CAST(N'2020-03-13' AS Date), CAST(N'2020-03-28' AS Date), CAST(N'2020-03-18' AS Date), 110, 2)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (66, CAST(N'2020-04-12' AS Date), CAST(N'2020-04-27' AS Date), CAST(N'2020-04-27' AS Date), 104, 20)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (67, CAST(N'2020-03-26' AS Date), CAST(N'2020-04-10' AS Date), CAST(N'2020-04-01' AS Date), 114, 31)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (68, CAST(N'2019-05-12' AS Date), CAST(N'2019-05-27' AS Date), CAST(N'2019-05-18' AS Date), 101, 11)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (69, CAST(N'2019-05-18' AS Date), CAST(N'2019-06-02' AS Date), NULL, 104, 1)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (70, CAST(N'2019-12-05' AS Date), CAST(N'2019-12-20' AS Date), CAST(N'2019-12-06' AS Date), 104, 49)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (71, CAST(N'2020-01-24' AS Date), CAST(N'2020-02-08' AS Date), CAST(N'2020-01-31' AS Date), 115, 22)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (72, CAST(N'2019-08-16' AS Date), CAST(N'2019-08-31' AS Date), CAST(N'2019-08-17' AS Date), 113, 23)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (73, CAST(N'2019-09-30' AS Date), CAST(N'2019-10-15' AS Date), CAST(N'2019-10-10' AS Date), 106, 69)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (74, CAST(N'2019-09-29' AS Date), CAST(N'2019-10-14' AS Date), NULL, 106, 70)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (75, CAST(N'2019-12-24' AS Date), CAST(N'2020-01-08' AS Date), NULL, 113, 57)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (76, CAST(N'2020-04-10' AS Date), CAST(N'2020-04-25' AS Date), CAST(N'2020-04-19' AS Date), 107, 35)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (77, CAST(N'2020-01-03' AS Date), CAST(N'2020-01-18' AS Date), NULL, 103, 50)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (78, CAST(N'2019-12-31' AS Date), CAST(N'2020-01-15' AS Date), NULL, 101, 70)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (79, CAST(N'2020-01-15' AS Date), CAST(N'2020-01-30' AS Date), CAST(N'2020-01-30' AS Date), 115, 59)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (80, CAST(N'2019-05-05' AS Date), CAST(N'2019-05-20' AS Date), CAST(N'2019-05-19' AS Date), 110, 38)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (81, CAST(N'2020-02-16' AS Date), CAST(N'2020-03-02' AS Date), CAST(N'2020-03-02' AS Date), 111, 68)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (82, CAST(N'2020-03-02' AS Date), CAST(N'2020-03-17' AS Date), CAST(N'2020-03-12' AS Date), 115, 66)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (83, CAST(N'2019-06-26' AS Date), CAST(N'2019-07-11' AS Date), CAST(N'2019-07-09' AS Date), 108, 60)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (84, CAST(N'2019-07-14' AS Date), CAST(N'2019-07-29' AS Date), NULL, 113, 31)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (85, CAST(N'2019-12-04' AS Date), CAST(N'2019-12-19' AS Date), CAST(N'2019-12-11' AS Date), 113, 1)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (86, CAST(N'2020-02-13' AS Date), CAST(N'2020-02-28' AS Date), CAST(N'2020-02-18' AS Date), 112, 65)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (87, CAST(N'2020-03-24' AS Date), CAST(N'2020-04-08' AS Date), NULL, 106, 24)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (88, CAST(N'2019-05-16' AS Date), CAST(N'2019-05-31' AS Date), CAST(N'2019-05-22' AS Date), 112, 21)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (89, CAST(N'2019-12-10' AS Date), CAST(N'2019-12-25' AS Date), CAST(N'2019-12-19' AS Date), 113, 37)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (90, CAST(N'2019-05-19' AS Date), CAST(N'2019-06-03' AS Date), NULL, 113, 46)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (91, CAST(N'2020-02-07' AS Date), CAST(N'2020-02-22' AS Date), CAST(N'2020-02-14' AS Date), 102, 21)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (92, CAST(N'2020-04-20' AS Date), CAST(N'2020-05-05' AS Date), NULL, 115, 23)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (93, CAST(N'2019-08-21' AS Date), CAST(N'2019-09-05' AS Date), NULL, 107, 17)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (94, CAST(N'2019-05-06' AS Date), CAST(N'2019-05-21' AS Date), NULL, 104, 39)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (95, CAST(N'2020-02-13' AS Date), CAST(N'2020-02-28' AS Date), CAST(N'2020-02-18' AS Date), 111, 7)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (96, CAST(N'2019-08-28' AS Date), CAST(N'2019-09-12' AS Date), NULL, 105, 3)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (97, CAST(N'2020-05-01' AS Date), CAST(N'2020-05-16' AS Date), CAST(N'2020-05-16' AS Date), 103, 49)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (98, CAST(N'2020-04-19' AS Date), CAST(N'2020-05-04' AS Date), CAST(N'2020-04-23' AS Date), 110, 34)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (99, CAST(N'2020-02-28' AS Date), CAST(N'2020-03-14' AS Date), NULL, 108, 66)
GO
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (100, CAST(N'2020-04-29' AS Date), CAST(N'2020-05-14' AS Date), NULL, 114, 40)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (101, CAST(N'2020-01-03' AS Date), CAST(N'2020-01-18' AS Date), CAST(N'2020-01-09' AS Date), 103, 40)
INSERT [BIBLIOTECA].[Emprestimo] ([n_emprestimo], [data_saida], [data_entrega], [data_chegada], [funcionario], [cliente]) VALUES (102, CAST(N'2020-06-10' AS Date), CAST(N'2020-06-25' AS Date), CAST(N'2020-06-10' AS Date), 101, NULL)
SET IDENTITY_INSERT [BIBLIOTECA].[Emprestimo] OFF
GO
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'012175642-4', 82)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'012175642-4', 83)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'012175642-4', 92)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'016059914-8', 97)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'017815275-7', 92)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'027071553-3', 76)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'036176734-X', 82)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'036176734-X', 84)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'036176734-X', 90)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'036176734-X', 91)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'040035185-4', 96)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'044295448-4', 88)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'058527684-6', 85)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'058527684-6', 94)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'121274815-8', 71)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'121274815-8', 77)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'135585941-7', 82)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'162020758-3', 87)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'162020758-3', 94)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'176225090-X', 72)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'176225090-X', 77)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'176225090-X', 85)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'176225090-X', 97)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'176225090-X', 98)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'187164259-0', 78)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'219467184-6', 75)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'219467184-6', 82)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'219467184-6', 98)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'249594664-X', 94)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'261261545-8', 89)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'264328182-9', 73)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'267861215-5', 81)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'267861215-5', 82)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'270679165-9', 84)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'295578735-3', 99)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'306323254-8', 84)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'306323254-8', 87)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'306323254-8', 88)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'310709179-0', 95)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'322515476-8', 83)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'322712572-2', 79)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'322712572-2', 85)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'336869802-8', 78)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'336869802-8', 80)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'336869802-8', 95)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'364734155-X', 88)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'372128928-5', 95)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'380711813-6', 78)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'380711813-6', 87)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'401899452-4', 75)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'401899452-4', 90)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'409410606-5', 87)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'409410606-5', 90)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'414534023-X', 74)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'434902596-0', 85)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'465787435-7', 79)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'510924021-3', 71)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'511611899-1', 95)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'515550891-6', 71)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'515550891-6', 85)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'519009850-8', 85)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'519009850-8', 95)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'527266416-7', 73)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'527266416-7', 94)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'554713138-5', 89)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'558462986-3', 76)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'558462986-3', 80)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'560948334-4', 87)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'571256604-4', 73)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'571256604-4', 77)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'571256604-4', 90)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'602419136-7', 78)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'602419136-7', 90)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'609326005-4', 100)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'630289158-2', 80)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'654001014-1', 85)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'716876158-7', 75)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'716876158-7', 90)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'716876158-7', 99)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'721661308-2', 71)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'755805247-5', 82)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'837853201-1', 84)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'837853201-1', 87)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'843974739-X', 85)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'843974739-X', 90)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'843974739-X', 100)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'848391936-2', 98)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'858846453-5', 83)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'877009566-3', 80)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'877009566-3', 88)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'893626169-X', 75)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'893626169-X', 89)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'893626169-X', 95)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'908021166-4', 74)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'908021166-4', 99)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'908021166-4', 100)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'939078781-5', 89)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'939078781-5', 90)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'964989004-1', 77)
INSERT [BIBLIOTECA].[Escreve] ([id_livro], [id_autor]) VALUES (N'997003180-5', 89)
GO
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (101, N'8098 Commercial Crossing')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (102, N'63 Aberg Drive')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (103, N'378 Golf Course Place')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (104, N'107 Basil Road')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (105, N'22404 American Ash Parkway')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (106, N'36521 Moland Drive')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (107, N'6211 Arizona Terrace')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (108, N'3 Mayfield Alley')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (109, N'64 Grayhawk Way')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (110, N'6270 Mifflin Alley')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (111, N'8 Melody Alley')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (112, N'94003 Coleman Plaza')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (113, N'8 Larry Crossing')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (114, N'82 Norway Maple Avenue')
INSERT [BIBLIOTECA].[Funcionario] ([id_funcionario], [morada]) VALUES (115, N'118 Village Plaza')
GO
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'008813803-8', N'Antz', 1984, 7, N'Adventure|Animation|Children|Comedy|Fantasy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'012175642-4', N'Seven Brothers (Seitsemän veljestä)', 1987, 83, N'Animation|Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'016059914-8', N'Martin Lawrence: You So Crazy', 1999, 35, N'Comedy|Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'017815275-7', N'Samurai Rebellion (Jôi-uchi: Hairyô tsuma shimatsu)', 1992, 55, N'Action|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'027071553-3', N'Light the Fuse... Sartana Is Coming', 2011, 63, N'Western')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'036176734-X', N'Life of Aleksis Kivi, The (Aleksis Kiven elämä)', 2002, 86, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'040035185-4', N'Thunder Soul', 2009, 62, N'Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'044295448-4', N'My Dear Secretary', 1997, 39, N'Comedy|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'058527684-6', N'Lakota Woman: Siege at Wounded Knee', 1987, 49, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'086374800-7', N'Great K & A Train Robbery, The', 2007, 87, N'Action|Western')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'094399689-9', N'Cheeky Girls', 2001, 57, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'096362400-8', N'You Are God (Jestes Bogiem)', 2006, 75, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'121274815-8', N'Guess Who', 1996, 46, N'Comedy|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'135585941-7', N'I''ll Be Home For Christmas', 2008, 40, N'Comedy|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'155712163-X', N'Three-Step Dance', 1993, 3, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'162020758-3', N'Alien Outpost', 1998, 1, N'Action|Sci-Fi|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'176225090-X', N'Hellgate', 1998, 92, N'Horror|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'187164259-0', N'Nun, The (La religieuse)', 2013, 9, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'217645125-2', N'Mighty Quinn, The', 1996, 69, N'Crime|Mystery')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'219467184-6', N'Hurt', 2002, 35, N'Drama|Horror|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'239394472-9', N'Putin''s Kiss', 1993, 42, N'Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'249594664-X', N'Fierce People', 1986, 31, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'256726317-9', N'Crimson Gold (Talaye sorgh)', 2008, 61, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'261261545-8', N'Gremlins', 2006, 10, N'Comedy|Horror')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'262106437-X', N'Past Midnight', 2007, 58, N'Horror|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'264328182-9', N'Beautiful People', 1996, 91, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'267861215-5', N'Mansome', 2007, 61, N'Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'270679165-9', N'I''ll Be There', 1998, 85, N'Comedy|Musical|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'275281380-5', N'Vampire Apocalypse', 1967, 81, N'Comedy|Horror')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'277190839-5', N'Vigilante', 2000, 46, N'Action|Crime|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'295578735-3', N'Stage Fright (Deliria)', 2006, 30, N'Horror')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'306323254-8', N'Samurai III: Duel on Ganryu Island (a.k.a. Bushido) (Miyamoto Musashi kanketsuhen: kettô Ganryûjima)', 2005, 36, N'Action|Adventure|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'310709179-0', N'Wolf', 2011, 5, N'Drama|Horror|Romance|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'322515476-8', N'Safe Place, A', 2000, 73, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'322712572-2', N'Santa Clause 2, The', 2005, 38, N'Children|Comedy|Fantasy|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'325615181-7', N'Out of the Blue', 2006, 79, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'336869802-8', N'Dog''s Life, A', 1970, 20, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'361836584-5', N'Ice Age Columbus: Who Were the First Americans?', 2008, 55, N'Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'364734155-X', N'Double Trouble', 1984, 17, N'Action|Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'367257956-4', N'Visiting Hours', 2011, 96, N'Horror')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'372128928-5', N'Hangover Part III, The', 2012, 33, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'380711813-6', N'Pandora and the Flying Dutchman', 2012, 82, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'387786343-4', N'Jew Süss (Jud Süß)', 1991, 20, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'401899452-4', N'Judy Moody and the Not Bummer Summer', 1994, 23, N'Children|Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'407751023-6', N'Breezy', 2003, 76, N'Drama|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'409410606-5', N'Expendables 2, The', 2011, 4, N'Action|Adventure')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'414534023-X', N'Fourth State, The (Die vierte Macht)', 1992, 37, N'Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'434004976-X', N'Christmas Carol, A (Scrooge)', 1998, 23, N'Drama|Fantasy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'434902596-0', N'Happy-Go-Lucky', 2009, 18, N'Comedy|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'438419427-7', N'The Call of the Wild', 1975, 66, N'Adventure|Children')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'442893150-6', N'Lord of Illusions', 1992, 54, N'Horror')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'465787435-7', N'And Now a Word from Our Sponsor', 1999, 5, N'Comedy|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'477620914-4', N'Goldengirl', 1999, 60, N'(no genres listed)')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'485792594-X', N'Griffin & Phoenix', 2004, 44, N'Comedy|Drama|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'510924021-3', N'One Chance', 1993, 54, N'Comedy|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'511611899-1', N'Inherit the Wind', 1990, 46, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'515550891-6', N'Shiver (Eskalofrío)', 2011, 36, N'Horror|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'519009850-8', N'Guard Post, The (G.P. 506)', 2010, 47, N'Horror')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'527266416-7', N'Sons and Lovers', 1998, 71, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'533204159-4', N'American Bandits: Frank and Jesse James', 2012, 37, N'Western')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'539176915-9', N'Comedy of Innocence (Comédie de l''innocence)', 2011, 64, N'Drama|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'541571540-1', N'Clara''s Heart', 2007, 82, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'554713138-5', N'Disaster Movie', 1992, 74, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'558462986-3', N'Family Man, The', 1992, 45, N'Comedy|Drama|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'560948334-4', N'Dear Pillow', 2001, 83, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'571256604-4', N'Despicable Me', 2006, 74, N'Animation|Children|Comedy|Crime')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'573093024-0', N'Bohemian Eyes (Boheemi elää - Matti Pellonpää)', 2012, 87, N'Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'589718060-1', N'Boris Godunov', 1996, 11, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'601817932-6', N'Perrier''s Bounty', 1999, 38, N'Action|Comedy|Crime|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'602419136-7', N'Transylmania', 1996, 47, N'Comedy|Horror')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'609326005-4', N'Stretch', 1984, 44, N'Action|Comedy|Crime')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'616744628-8', N'Fourth World War, The', 2003, 86, N'Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'630289158-2', N'Onibaba', 2007, 92, N'Drama|Horror|War')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'653251232-X', N'For Those in Peril', 1996, 42, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'654001014-1', N'Cell 211 (Celda 211)', 1994, 69, N'Action|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'676501613-9', N'Ice Quake', 2011, 35, N'Action|Sci-Fi|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'691286229-2', N'My Winnipeg', 2002, 90, N'Documentary|Fantasy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'715244854-X', N'In the Cut', 1998, 36, N'Crime|Drama|Mystery|Romance|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'716876158-7', N'King Lear', 2006, 17, N'Comedy|Drama|Sci-Fi')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'721568816-X', N'Grouse', 2007, 70, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'721661308-2', N'Misunderstood', 2009, 93, N'Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'755805247-5', N'Belles of St. Trinian''s, The', 1989, 86, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'765988378-X', N'House of the Dead, The', 2003, 37, N'Action|Horror')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'767725989-8', N'Jack and Jill', 2012, 47, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'778668298-8', N'Challenge to Lassie', 2004, 71, N'Children|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'801299815-7', N'Two Brothers (Deux frères)', 1995, 9, N'Adventure|Children|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'837853201-1', N'Angelus', 2001, 26, N'Comedy|Drama')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'843974739-X', N'Tyler Perry''s Daddy''s Little Girls', 1995, 17, N'Comedy|Romance')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'848391936-2', N'Kevin Nealon: Now Hear Me Out!', 1988, 96, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'858846453-5', N'Body of Lies', 2006, 64, N'Action|Drama|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'873126060-8', N'Beverly Hillbillies, The', 2011, 9, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'877009566-3', N'Sherman''s March', 2008, 89, N'Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'893626169-X', N'Pete Seeger: The Power of Song', 1997, 7, N'Documentary')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'895547484-9', N'Michael Jackson''s This Is It', 1993, 69, N'Documentary|Musical|IMAX')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'908021166-4', N'Under the Rainbow', 1984, 100, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'939078781-5', N'Perfectly Normal', 1994, 64, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'964989004-1', N'One Body Too Many', 2006, 7, N'Comedy|Horror|Mystery')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'969135878-6', N'Pretty Poison', 1995, 18, N'Comedy|Crime|Romance|Thriller')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'990989864-0', N'Monkey Business', 1998, 76, N'Comedy')
INSERT [BIBLIOTECA].[Livro] ([ISBN], [titulo], [ano], [id_editora], [categoria]) VALUES (N'997003180-5', N'If Lucy Fell', 1990, 73, N'Comedy|Romance')
GO
SET IDENTITY_INSERT [BIBLIOTECA].[Livros_Exemplares] ON 

INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (1, 1, N'602419136-7', CAST(N'2017-07-01' AS Date), N'New', N'NQM.34693')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (2, 2, N'767725989-8', CAST(N'2018-09-19' AS Date), N'New', N'AYD.88574')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (3, 3, N'256726317-9', CAST(N'2017-07-01' AS Date), N'Bad', N'COK.37995')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (4, 4, N'560948334-4', CAST(N'2017-09-28' AS Date), N'Bad', N'UNC.26598')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (5, 5, N'219467184-6', CAST(N'2017-05-11' AS Date), N'New', N'JGU.76453')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (6, 6, N'267861215-5', CAST(N'2017-10-26' AS Date), N'Good', N'BLQ.72564')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (7, 7, N'539176915-9', CAST(N'2018-01-20' AS Date), N'Good', N'VSX.98389')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (8, 8, N'485792594-X', CAST(N'2017-10-19' AS Date), N'Bad', N'YHH.05149')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (9, 9, N'372128928-5', CAST(N'2018-03-24' AS Date), N'Good', N'JVV.59243')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (10, 10, N'270679165-9', CAST(N'2017-11-06' AS Date), N'Average', N'QZV.12639')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (11, 11, N'691286229-2', CAST(N'2017-01-18' AS Date), N'Bad', N'NAL.04334')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (12, 12, N'438419427-7', CAST(N'2018-07-15' AS Date), N'Average', N'LTV.05696')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (13, 13, N'908021166-4', CAST(N'2017-01-15' AS Date), N'Good', N'UJP.05307')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (14, 14, N'027071553-3', CAST(N'2017-12-02' AS Date), N'Good', N'RAP.68848')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (15, 15, N'716876158-7', CAST(N'2018-05-11' AS Date), N'New', N'RUA.62615')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (16, 16, N'264328182-9', CAST(N'2017-02-22' AS Date), N'New', N'TNL.26808')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (17, 17, N'755805247-5', CAST(N'2018-01-28' AS Date), N'Good', N'WKG.66306')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (18, 18, N'364734155-X', CAST(N'2017-10-21' AS Date), N'Good', N'SSQ.49002')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (19, 19, N'485792594-X', CAST(N'2018-06-14' AS Date), N'New', N'TAN.43577')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (20, 20, N'560948334-4', CAST(N'2018-01-10' AS Date), N'Bad', N'RIL.38989')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (21, 21, N'256726317-9', CAST(N'2018-04-01' AS Date), N'Bad', N'GOL.37179')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (22, 22, N'261261545-8', CAST(N'2018-01-08' AS Date), N'New', N'OCJ.30935')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (23, 23, N'616744628-8', CAST(N'2017-04-08' AS Date), N'Good', N'WOZ.02431')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (24, 24, N'239394472-9', CAST(N'2018-01-10' AS Date), N'Average', N'TXP.26444')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (25, 102, N'162020758-3', CAST(N'2018-04-02' AS Date), N'New', N'QUV.01794')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (26, 26, N'267861215-5', CAST(N'2018-12-07' AS Date), N'Good', N'HSC.94770')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (27, 27, N'908021166-4', CAST(N'2017-03-06' AS Date), N'Good', N'TED.97147')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (28, 28, N'997003180-5', CAST(N'2017-01-08' AS Date), N'New', N'OUW.82613')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (29, 29, N'264328182-9', CAST(N'2018-12-24' AS Date), N'New', N'XBX.18661')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (30, 30, N'755805247-5', CAST(N'2018-02-13' AS Date), N'Average', N'WLC.14578')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (31, 31, N'893626169-X', CAST(N'2018-02-06' AS Date), N'Average', N'LAO.64883')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (32, 32, N'096362400-8', CAST(N'2017-05-10' AS Date), N'Good', N'JXX.64933')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (33, 33, N'691286229-2', CAST(N'2017-12-11' AS Date), N'Average', N'NKN.80367')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (34, 34, N'261261545-8', CAST(N'2017-08-08' AS Date), N'Bad', N'QNR.09360')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (35, 35, N'510924021-3', CAST(N'2017-04-10' AS Date), N'Good', N'NEN.31251')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (36, 36, N'964989004-1', CAST(N'2017-08-13' AS Date), N'New', N'ZMJ.77783')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (37, 37, N'176225090-X', CAST(N'2018-11-20' AS Date), N'Good', N'AZK.27918')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (38, 38, N'873126060-8', CAST(N'2017-05-19' AS Date), N'Good', N'KWR.57118')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (39, 39, N'511611899-1', CAST(N'2018-03-17' AS Date), N'Bad', N'WHT.04392')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (40, 40, N'017815275-7', CAST(N'2018-04-20' AS Date), N'Average', N'EIP.10057')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (41, 41, N'295578735-3', CAST(N'2017-03-09' AS Date), N'Bad', N'VIH.25151')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (42, 42, N'997003180-5', CAST(N'2018-01-05' AS Date), N'Good', N'LPW.48050')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (43, 43, N'409410606-5', CAST(N'2017-05-12' AS Date), N'Bad', N'HQB.99667')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (44, 44, N'676501613-9', CAST(N'2017-09-21' AS Date), N'Average', N'ZTR.12825')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (45, 45, N'716876158-7', CAST(N'2017-07-06' AS Date), N'Average', N'HEY.69327')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (46, 46, N'155712163-X', CAST(N'2017-05-03' AS Date), N'Average', N'RQH.11345')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (47, 47, N'837853201-1', CAST(N'2017-12-01' AS Date), N'Average', N'DSL.44755')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (48, 48, N'755805247-5', CAST(N'2017-08-29' AS Date), N'New', N'PXJ.65386')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (49, 49, N'261261545-8', CAST(N'2018-06-02' AS Date), N'New', N'RON.20742')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (50, 50, N'176225090-X', CAST(N'2018-09-07' AS Date), N'Good', N'BAP.41852')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (51, 51, N'616744628-8', CAST(N'2017-10-08' AS Date), N'Bad', N'CRV.10787')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (52, 52, N'571256604-4', CAST(N'2017-07-03' AS Date), N'New', N'BDR.10171')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (53, 53, N'877009566-3', CAST(N'2018-07-29' AS Date), N'New', N'KZP.28353')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (54, 54, N'249594664-X', CAST(N'2018-12-26' AS Date), N'New', N'AQZ.30173')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (55, 55, N'843974739-X', CAST(N'2018-07-09' AS Date), N'Bad', N'QYE.13612')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (56, 56, N'908021166-4', CAST(N'2018-11-24' AS Date), N'Good', N'FGH.25377')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (57, 57, N'877009566-3', CAST(N'2018-06-25' AS Date), N'Good', N'IBU.14007')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (58, 58, N'407751023-6', CAST(N'2018-09-10' AS Date), N'Good', N'GBT.04863')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (59, 59, N'442893150-6', CAST(N'2018-03-27' AS Date), N'Good', N'BUB.46742')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (60, 60, N'755805247-5', CAST(N'2017-01-26' AS Date), N'New', N'WKX.00490')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (61, 61, N'264328182-9', CAST(N'2018-07-09' AS Date), N'Good', N'XJH.38606')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (62, 62, N'589718060-1', CAST(N'2017-01-01' AS Date), N'Average', N'UBG.00009')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (63, 63, N'571256604-4', CAST(N'2018-02-01' AS Date), N'Bad', N'PND.17799')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (64, 64, N'877009566-3', CAST(N'2017-05-06' AS Date), N'Good', N'IQN.35434')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (65, 65, N'858846453-5', CAST(N'2017-03-06' AS Date), N'Bad', N'KVA.71208')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (66, 66, N'539176915-9', CAST(N'2018-04-28' AS Date), N'New', N'QEP.45428')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (67, 67, N'510924021-3', CAST(N'2017-03-25' AS Date), N'Good', N'FRO.34744')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (68, 68, N'336869802-8', CAST(N'2018-12-29' AS Date), N'Average', N'AOE.62968')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (69, 69, N'609326005-4', CAST(N'2017-05-29' AS Date), N'Good', N'LTA.76456')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (70, 70, N'653251232-X', CAST(N'2018-07-04' AS Date), N'Average', N'NGO.85181')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (71, 71, N'721661308-2', CAST(N'2018-01-31' AS Date), N'New', N'JWS.86538')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (72, 72, N'653251232-X', CAST(N'2017-01-31' AS Date), N'Good', N'ZTU.48338')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (73, 73, N'012175642-4', CAST(N'2017-06-29' AS Date), N'Good', N'MXX.39238')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (74, 74, N'322712572-2', CAST(N'2017-04-01' AS Date), N'Good', N'OJS.15495')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (75, 75, N'270679165-9', CAST(N'2017-06-12' AS Date), N'Average', N'NVX.92082')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (76, 76, N'058527684-6', CAST(N'2017-05-21' AS Date), N'Average', N'VVB.78855')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (77, 77, N'367257956-4', CAST(N'2018-03-21' AS Date), N'Average', N'CDO.83276')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (78, 78, N'654001014-1', CAST(N'2018-01-19' AS Date), N'Average', N'JGN.64708')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (79, 79, N'609326005-4', CAST(N'2018-01-26' AS Date), N'New', N'KRC.48827')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (80, 80, N'477620914-4', CAST(N'2018-09-29' AS Date), N'New', N'DEV.12967')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (81, 81, N'858846453-5', CAST(N'2018-12-07' AS Date), N'New', N'DHA.50434')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (82, 82, N'755805247-5', CAST(N'2018-12-23' AS Date), N'Average', N'KSZ.65689')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (83, 83, N'364734155-X', CAST(N'2017-04-07' AS Date), N'Bad', N'POL.49886')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (84, 84, N'858846453-5', CAST(N'2017-12-03' AS Date), N'Good', N'KZF.09511')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (85, 85, N'325615181-7', CAST(N'2018-03-30' AS Date), N'Average', N'RPD.10792')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (86, 86, N'721568816-X', CAST(N'2017-10-07' AS Date), N'Average', N'BAI.44094')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (87, 87, N'573093024-0', CAST(N'2017-05-15' AS Date), N'Good', N'LLH.13240')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (88, 88, N'409410606-5', CAST(N'2017-10-21' AS Date), N'New', N'WXQ.42848')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (89, 89, N'094399689-9', CAST(N'2018-07-21' AS Date), N'Bad', N'BTS.94146')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (90, 90, N'008813803-8', CAST(N'2018-10-31' AS Date), N'New', N'SDN.53437')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (91, 91, N'691286229-2', CAST(N'2017-11-30' AS Date), N'Good', N'MHZ.55422')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (92, 92, N'325615181-7', CAST(N'2018-08-03' AS Date), N'Good', N'ZFI.98456')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (93, 93, N'893626169-X', CAST(N'2017-07-17' AS Date), N'Average', N'IGB.24090')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (94, 94, N'715244854-X', CAST(N'2017-11-22' AS Date), N'Bad', N'ZZS.22845')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (95, 95, N'239394472-9', CAST(N'2017-10-01' AS Date), N'Bad', N'MFQ.91250')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (96, 96, N'721568816-X', CAST(N'2017-04-16' AS Date), N'New', N'JOG.62530')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (97, 97, N'407751023-6', CAST(N'2018-06-26' AS Date), N'Average', N'TPN.49746')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (98, 98, N'964989004-1', CAST(N'2018-08-20' AS Date), N'New', N'BEA.33432')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (99, 99, N'135585941-7', CAST(N'2018-05-19' AS Date), N'Bad', N'TZK.18443')
GO
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (100, 100, N'267861215-5', CAST(N'2018-06-11' AS Date), N'Good', N'JUE.63164')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (101, 1, N'609326005-4', CAST(N'2017-03-11' AS Date), N'New', N'REL.69174')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (102, 2, N'016059914-8', CAST(N'2017-04-26' AS Date), N'Average', N'FFU.10219')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (103, 3, N'155712163-X', CAST(N'2018-08-20' AS Date), N'Bad', N'RAG.19367')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (104, 4, N'239394472-9', CAST(N'2018-12-30' AS Date), N'Good', N'IXZ.86535')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (105, 5, N'008813803-8', CAST(N'2018-02-22' AS Date), N'Good', N'MVX.40178')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (106, 6, N'044295448-4', CAST(N'2018-08-11' AS Date), N'Good', N'ICH.53273')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (107, 7, N'401899452-4', CAST(N'2018-07-19' AS Date), N'New', N'MNJ.18222')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (108, 8, N'843974739-X', CAST(N'2017-03-26' AS Date), N'New', N'NZM.47995')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (109, 9, N'477620914-4', CAST(N'2018-05-30' AS Date), N'New', N'QCA.77375')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (110, 10, N'721661308-2', CAST(N'2017-07-03' AS Date), N'Good', N'RPQ.52693')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (111, 11, N'295578735-3', CAST(N'2017-04-11' AS Date), N'Good', N'JJH.14999')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (112, 12, N'848391936-2', CAST(N'2018-01-14' AS Date), N'Average', N'MCT.09944')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (113, 13, N'716876158-7', CAST(N'2018-09-10' AS Date), N'Average', N'PNF.30644')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (114, 14, N'135585941-7', CAST(N'2017-04-25' AS Date), N'New', N'BEZ.26329')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (115, 15, N'176225090-X', CAST(N'2018-05-08' AS Date), N'Good', N'LCW.57046')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (116, 16, N'873126060-8', CAST(N'2017-04-13' AS Date), N'New', N'CSY.35309')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (117, 17, N'767725989-8', CAST(N'2018-01-17' AS Date), N'New', N'YIH.01889')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (118, 18, N'336869802-8', CAST(N'2017-07-12' AS Date), N'Average', N'UNA.37251')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (119, 19, N'877009566-3', CAST(N'2018-05-11' AS Date), N'Average', N'UHY.05474')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (120, 20, N'654001014-1', CAST(N'2018-12-09' AS Date), N'New', N'LEK.98694')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (121, 21, N'755805247-5', CAST(N'2017-12-02' AS Date), N'Good', N'ALR.28734')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (122, 22, N'539176915-9', CAST(N'2017-09-16' AS Date), N'New', N'RHP.37785')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (123, 23, N'409410606-5', CAST(N'2017-04-06' AS Date), N'New', N'TEI.79266')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (124, 102, N'465787435-7', CAST(N'2017-04-19' AS Date), N'Good', N'DUG.04245')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (125, 25, N'654001014-1', CAST(N'2018-12-27' AS Date), N'Good', N'TGI.01296')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (126, 26, N'058527684-6', CAST(N'2017-02-27' AS Date), N'New', N'ZWY.00343')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (127, 27, N'539176915-9', CAST(N'2018-08-24' AS Date), N'Bad', N'PVE.66886')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (128, 28, N'275281380-5', CAST(N'2017-01-17' AS Date), N'Bad', N'WAH.76917')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (129, 29, N'560948334-4', CAST(N'2018-03-13' AS Date), N'Good', N'LKJ.06743')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (130, 30, N'873126060-8', CAST(N'2017-08-15' AS Date), N'Bad', N'WCK.63786')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (131, 31, N'716876158-7', CAST(N'2018-09-01' AS Date), N'New', N'LXN.55138')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (132, 32, N'477620914-4', CAST(N'2018-05-19' AS Date), N'Good', N'KDO.12041')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (133, 33, N'602419136-7', CAST(N'2018-08-20' AS Date), N'Bad', N'EDY.37336')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (134, 34, N'036176734-X', CAST(N'2018-08-03' AS Date), N'New', N'XKL.32167')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (135, 35, N'541571540-1', CAST(N'2018-07-13' AS Date), N'Bad', N'KWA.54394')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (136, 36, N'715244854-X', CAST(N'2018-07-31' AS Date), N'Average', N'RZP.73447')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (137, 37, N'837853201-1', CAST(N'2018-09-19' AS Date), N'Average', N'XJP.19981')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (138, 38, N'295578735-3', CAST(N'2017-10-26' AS Date), N'New', N'LAA.44341')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (139, 39, N'187164259-0', CAST(N'2017-04-22' AS Date), N'Average', N'MCK.10524')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (140, 40, N'036176734-X', CAST(N'2017-06-09' AS Date), N'Good', N'NAD.15751')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (141, 41, N'155712163-X', CAST(N'2018-09-18' AS Date), N'Good', N'WXO.90234')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (142, 42, N'409410606-5', CAST(N'2017-01-29' AS Date), N'New', N'HDC.24805')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (143, 43, N'121274815-8', CAST(N'2017-07-02' AS Date), N'Average', N'KQB.52007')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (144, 44, N'997003180-5', CAST(N'2017-08-19' AS Date), N'Bad', N'XLB.54652')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (145, 45, N'858846453-5', CAST(N'2017-04-30' AS Date), N'New', N'BUF.45382')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (146, 46, N'249594664-X', CAST(N'2018-12-24' AS Date), N'Bad', N'JJN.90468')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (147, 47, N'477620914-4', CAST(N'2018-08-04' AS Date), N'Bad', N'LTQ.64747')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (148, 48, N'589718060-1', CAST(N'2017-01-28' AS Date), N'Average', N'RXQ.14473')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (149, 49, N'755805247-5', CAST(N'2018-12-14' AS Date), N'Good', N'SHK.96961')
INSERT [BIBLIOTECA].[Livros_Exemplares] ([numero_exemplar], [n_emprestimo], [ISBN], [data_de_aquisicao], [estado], [cota]) VALUES (150, 50, N'407751023-6', CAST(N'2017-10-29' AS Date), N'New', N'MYN.65259')
SET IDENTITY_INSERT [BIBLIOTECA].[Livros_Exemplares] OFF
GO
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (51, N'diners-club-carte-blanche')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (52, N'jcb')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (53, N'maestro')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (54, N'diners-club-enroute')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (55, N'jcb')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (56, N'mastercard')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (57, N'jcb')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (58, N'china-unionpay')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (59, N'diners-club-carte-blanche')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (60, N'jcb')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (61, N'switch')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (62, N'jcb')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (63, N'jcb')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (64, N'jcb')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (65, N'americanexpress')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (66, N'instapayment')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (67, N'visa-electron')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (68, N'jcb')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (69, N'diners-club-carte-blanche')
INSERT [BIBLIOTECA].[Nao_Socio] ([id_cliente], [forma_pagamento]) VALUES (70, N'mastercard')
GO
SET IDENTITY_INSERT [BIBLIOTECA].[Pessoa] ON 

INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (1, N'Rina', N'McAlindon', CAST(N'2003-09-08' AS Date), CAST(988247615 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (2, N'Hilton', N'Haskayne', CAST(N'2008-02-25' AS Date), CAST(962726455 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (3, N'Ken', N'Beamond', CAST(N'1987-09-23' AS Date), CAST(995923940 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (4, N'Blaire', N'Rawlyns', CAST(N'1978-06-08' AS Date), CAST(928721076 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (5, N'Samuel', N'Iacobetto', CAST(N'1997-04-12' AS Date), CAST(998643705 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (6, N'Paxton', N'Bonde', CAST(N'1987-10-27' AS Date), CAST(906787835 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (7, N'Callie', N'Schuler', CAST(N'2002-11-14' AS Date), CAST(911705801 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (8, N'Eryn', N'Bloxam', CAST(N'1983-09-16' AS Date), CAST(918917715 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (9, N'Sheffield', N'Warboys', CAST(N'2005-10-27' AS Date), CAST(952491351 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (10, N'Abey', N'Yosifov', CAST(N'1985-01-26' AS Date), CAST(959123600 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (11, N'Percival', N'Lightoller', CAST(N'1988-01-20' AS Date), CAST(924220437 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (12, N'Parker', N'Grzelewski', CAST(N'1984-04-21' AS Date), CAST(976934423 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (13, N'Tony', N'Geeves', CAST(N'1975-11-23' AS Date), CAST(909396236 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (14, N'Xena', N'Jeenes', CAST(N'2000-08-25' AS Date), CAST(901987688 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (15, N'Ollie', N'Willan', CAST(N'1993-12-11' AS Date), CAST(938814718 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (16, N'Cassie', N'Crowson', CAST(N'1986-10-14' AS Date), CAST(902283959 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (17, N'Hobey', N'Kupisz', CAST(N'2002-12-18' AS Date), CAST(974750206 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (18, N'Nataline', N'Crame', CAST(N'1972-04-18' AS Date), CAST(934537893 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (19, N'Selie', N'Ramirez', CAST(N'1999-05-07' AS Date), CAST(999467042 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (20, N'Camella', N'Ayscough', CAST(N'1997-09-08' AS Date), CAST(972318471 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (21, N'Hilton', N'Klassman', CAST(N'1973-11-15' AS Date), CAST(909681190 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (22, N'Marga', N'Grevile', CAST(N'2006-12-21' AS Date), CAST(971409589 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (23, N'Gerik', N'Brewitt', CAST(N'2009-01-23' AS Date), CAST(948107543 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (24, N'Virge', N'Schulter', CAST(N'1994-02-05' AS Date), CAST(907556963 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (25, N'Loren', N'Blaylock', CAST(N'1979-11-15' AS Date), CAST(986136531 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (26, N'Tibold', N'Heustice', CAST(N'1975-03-16' AS Date), CAST(934528131 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (27, N'Sara', N'McKerley', CAST(N'2005-11-09' AS Date), CAST(924937030 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (28, N'Doll', N'Pettengell', CAST(N'1972-04-25' AS Date), CAST(988747026 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (29, N'Ken', N'Hardi', CAST(N'1971-10-31' AS Date), CAST(942134712 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (30, N'Rad', N'Renyard', CAST(N'2003-09-08' AS Date), CAST(984190180 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (31, N'Bing', N'MacDavitt', CAST(N'1973-11-09' AS Date), CAST(949335004 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (32, N'Arleyne', N'Proctor', CAST(N'1973-03-31' AS Date), CAST(966827518 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (33, N'Wang', N'Hellwich', CAST(N'1984-02-28' AS Date), CAST(920615444 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (34, N'Derry', N'Roney', CAST(N'1985-08-17' AS Date), CAST(967223670 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (35, N'Angil', N'Worthing', CAST(N'1970-12-27' AS Date), CAST(986565835 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (36, N'Auguste', N'Taillant', CAST(N'1983-07-05' AS Date), CAST(960391779 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (37, N'Veronike', N'Laroze', CAST(N'1988-02-25' AS Date), CAST(970868997 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (38, N'Myrtle', N'Tolemache', CAST(N'2007-10-12' AS Date), CAST(917515761 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (39, N'Marsh', N'Mary', CAST(N'1985-10-15' AS Date), CAST(954703936 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (40, N'Roxy', N'Clowsley', CAST(N'2001-11-10' AS Date), CAST(965640323 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (41, N'Gwenny', N'Pounds', CAST(N'2009-06-02' AS Date), CAST(904605389 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (42, N'Benjy', N'Koppens', CAST(N'1974-03-15' AS Date), CAST(900762181 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (43, N'Tess', N'Dikelin', CAST(N'2008-12-09' AS Date), CAST(949033896 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (44, N'Roosevelt', N'Gladman', CAST(N'2006-02-06' AS Date), CAST(908180608 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (45, N'Farah', N'Gumery', CAST(N'1977-09-19' AS Date), CAST(947318544 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (46, N'Kristal', N'Ivison', CAST(N'1978-06-27' AS Date), CAST(985250543 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (47, N'Rhody', N'Kollasch', CAST(N'1984-10-05' AS Date), CAST(933493496 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (48, N'Cornie', N'Proswell', CAST(N'1983-09-12' AS Date), CAST(961967666 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (49, N'Sascha', N'Spearing', CAST(N'2007-08-16' AS Date), CAST(919249806 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (50, N'Minnaminnie', N'Warrior', CAST(N'1999-11-28' AS Date), CAST(951451766 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (51, N'Woodman', N'Elvey', CAST(N'1987-09-09' AS Date), CAST(987930861 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (52, N'Fifine', N'Goldsberry', CAST(N'2008-08-09' AS Date), CAST(969386655 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (53, N'Pedro', N'Wiggin', CAST(N'2006-02-19' AS Date), CAST(915615841 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (54, N'Worthington', N'Drage', CAST(N'1992-06-15' AS Date), CAST(942621335 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (55, N'Germayne', N'Klementz', CAST(N'1992-01-04' AS Date), CAST(935595957 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (56, N'Ursulina', N'Hellyar', CAST(N'2009-04-01' AS Date), CAST(931057699 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (57, N'Sherrie', N'Matuska', CAST(N'1976-05-31' AS Date), CAST(956661863 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (58, N'Marja', N'Filippov', CAST(N'1978-03-01' AS Date), CAST(930047028 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (59, N'Britte', N'Aldington', CAST(N'1997-02-16' AS Date), CAST(981386263 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (60, N'Eolande', N'Glenny', CAST(N'1986-11-28' AS Date), CAST(945074572 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (61, N'Karl', N'Allington', CAST(N'1996-04-18' AS Date), CAST(973655157 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (62, N'Elli', N'Yetton', CAST(N'1976-10-17' AS Date), CAST(909721097 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (63, N'Jacenta', N'McGaffey', CAST(N'2007-11-24' AS Date), CAST(913927913 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (64, N'Roley', N'Heaker', CAST(N'1978-12-25' AS Date), CAST(990351063 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (65, N'Alphonso', N'Ghidotti', CAST(N'1993-07-22' AS Date), CAST(921494422 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (66, N'Petronia', N'Kernell', CAST(N'1982-02-26' AS Date), CAST(952591058 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (67, N'Clair', N'Haddeston', CAST(N'1998-12-22' AS Date), CAST(915689032 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (68, N'Dorothee', N'Pakenham', CAST(N'1997-05-07' AS Date), CAST(925883760 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (69, N'Kareem', N'Rosenfelt', CAST(N'1979-05-06' AS Date), CAST(939600689 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (70, N'Rodolphe', N'Roads', CAST(N'2006-05-01' AS Date), CAST(976987116 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (71, N'Jamima', N'Folkard', CAST(N'1976-11-25' AS Date), CAST(958841865 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (72, N'Eldin', N'Dybald', CAST(N'1985-10-04' AS Date), CAST(936494962 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (73, N'Alane', N'Durtnal', CAST(N'1975-06-12' AS Date), CAST(932334880 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (74, N'Beverie', N'Kelsow', CAST(N'1975-10-06' AS Date), CAST(900776617 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (75, N'Pippa', N'Milkin', CAST(N'1971-09-22' AS Date), CAST(910898624 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (76, N'Cthrine', N'Boyle', CAST(N'2009-12-28' AS Date), CAST(986719962 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (77, N'Isa', N'Paprotny', CAST(N'1994-08-26' AS Date), CAST(957434946 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (78, N'Kennedy', N'Flipek', CAST(N'1988-12-08' AS Date), CAST(937480628 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (79, N'Tabbie', N'Worledge', CAST(N'1989-06-15' AS Date), CAST(908719709 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (80, N'Broddie', N'Oliphand', CAST(N'1993-05-08' AS Date), CAST(908901136 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (81, N'Yale', N'Zamorrano', CAST(N'2005-09-24' AS Date), CAST(988216851 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (82, N'Burlie', N'Gribbins', CAST(N'1981-04-14' AS Date), CAST(923890323 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (83, N'Noelani', N'Christofe', CAST(N'1975-12-28' AS Date), CAST(969697278 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (84, N'Laural', N'Stronough', CAST(N'1994-10-29' AS Date), CAST(962684636 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (85, N'Wilone', N'Giacaponi', CAST(N'2004-12-04' AS Date), CAST(969902017 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (86, N'Carl', N'Aleksahkin', CAST(N'1992-09-28' AS Date), CAST(935881153 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (87, N'Oberon', N'Roby', CAST(N'1985-10-08' AS Date), CAST(959263584 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (88, N'Theodoric', N'Costar', CAST(N'1990-12-11' AS Date), CAST(932903067 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (89, N'Gianni', N'Lammas', CAST(N'2009-05-25' AS Date), CAST(908819428 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (90, N'Ann', N'Woollends', CAST(N'1996-08-28' AS Date), CAST(938808364 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (91, N'Melina', N'Prewer', CAST(N'1974-08-22' AS Date), CAST(995715539 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (92, N'Silas', N'Shepherdson', CAST(N'2001-04-18' AS Date), CAST(995510277 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (93, N'Charleen', N'Tomblin', CAST(N'2009-12-30' AS Date), CAST(987586397 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (94, N'Roi', N'Bellis', CAST(N'2006-10-22' AS Date), CAST(931270588 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (95, N'Hill', N'Coppo', CAST(N'1992-01-08' AS Date), CAST(912882652 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (96, N'Isidor', N'McCathy', CAST(N'1985-02-25' AS Date), CAST(915584432 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (97, N'Juline', N'Brien', CAST(N'1999-03-01' AS Date), CAST(934934879 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (98, N'Marvin', N'Croasdale', CAST(N'1997-04-22' AS Date), CAST(995073925 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (99, N'Carolynn', N'Sabathier', CAST(N'1998-01-01' AS Date), CAST(935201424 AS Decimal(9, 0)))
GO
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (100, N'Evvie', N'Van''t Hoff', CAST(N'1977-10-26' AS Date), CAST(934294882 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (101, N'Laurence', N'Hundley', CAST(N'2008-06-11' AS Date), CAST(961048495 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (102, N'Eugenia', N'Poolman', CAST(N'1975-02-10' AS Date), CAST(904530893 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (103, N'Ringo', N'Bedburrow', CAST(N'1974-03-09' AS Date), CAST(909998588 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (104, N'Hew', N'Apple', CAST(N'2004-05-20' AS Date), CAST(963856064 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (105, N'Janenna', N'McClelland', CAST(N'2006-08-11' AS Date), CAST(920286689 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (106, N'Marie-jeanne', N'Hedaux', CAST(N'1990-05-02' AS Date), CAST(911669039 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (107, N'Piper', N'Jiranek', CAST(N'1984-01-09' AS Date), CAST(955712308 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (108, N'Gabriela', N'Thurling', CAST(N'1992-11-01' AS Date), CAST(975811709 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (109, N'Heda', N'Cheston', CAST(N'2003-11-27' AS Date), CAST(952194568 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (110, N'Sophie', N'Berrow', CAST(N'1977-09-05' AS Date), CAST(949862000 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (111, N'Halimeda', N'McCobb', CAST(N'1994-04-08' AS Date), CAST(903273685 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (112, N'Viviana', N'Lunny', CAST(N'1991-06-23' AS Date), CAST(900552601 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (113, N'Nert', N'Staveley', CAST(N'2008-03-15' AS Date), CAST(914733688 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (114, N'Hillary', N'Gyrgorwicx', CAST(N'1976-04-13' AS Date), CAST(978132460 AS Decimal(9, 0)))
INSERT [BIBLIOTECA].[Pessoa] ([id], [first_name], [last_name], [data_nascimento], [telefone]) VALUES (115, N'Patricia', N'Grzegorecki', CAST(N'1973-06-12' AS Date), CAST(917129270 AS Decimal(9, 0)))
SET IDENTITY_INSERT [BIBLIOTECA].[Pessoa] OFF
GO
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 105, 37)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 2176, 60)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 3214, 69)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 6658, 3)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 9037, 23)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 9967, 14)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 10562, 21)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 13219, 10)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 13509, 9)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 15112, 36)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 15330, 5)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 17068, 24)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 19879, 65)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 20711, 66)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 21631, 6)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 21978, 37)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 27490, 12)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 30985, 70)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 41093, 56)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 42700, 15)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 44871, 6)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 45211, 6)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 48001, 41)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 50007, 7)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 51466, 56)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 53187, 41)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 55503, 1)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 57050, 15)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 58115, 11)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 59732, 14)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 59804, 19)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 60344, 5)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 60641, 54)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 63594, 64)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 69210, 64)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 71377, 7)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 72917, 45)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 73753, 52)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 82990, 68)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 85870, 31)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 87949, 37)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 88705, 59)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 89042, 69)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 90636, 37)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 91553, 60)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'False', 91926, 56)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 96124, 57)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 96211, 57)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 98612, 57)
INSERT [BIBLIOTECA].[Socio] ([comprovativo], [id_socio], [id_cliente]) VALUES (N'True', 99080, 36)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idxSearchLTitulo]    Script Date: 12/06/2020 23:52:18 ******/
CREATE NONCLUSTERED INDEX [idxSearchLTitulo] ON [BIBLIOTECA].[Livro]
(
	[titulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idxSearchCliente]    Script Date: 12/06/2020 23:52:18 ******/
CREATE NONCLUSTERED INDEX [idxSearchCliente] ON [BIBLIOTECA].[Pessoa]
(
	[first_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [BIBLIOTECA].[Autor]  WITH CHECK ADD FOREIGN KEY([id_autor])
REFERENCES [BIBLIOTECA].[Pessoa] ([id])
GO
ALTER TABLE [BIBLIOTECA].[Cliente]  WITH CHECK ADD FOREIGN KEY([id_cliente])
REFERENCES [BIBLIOTECA].[Pessoa] ([id])
GO
ALTER TABLE [BIBLIOTECA].[Emprestimo]  WITH CHECK ADD FOREIGN KEY([cliente])
REFERENCES [BIBLIOTECA].[Cliente] ([id_cliente])
GO
ALTER TABLE [BIBLIOTECA].[Emprestimo]  WITH CHECK ADD FOREIGN KEY([funcionario])
REFERENCES [BIBLIOTECA].[Funcionario] ([id_funcionario])
GO
ALTER TABLE [BIBLIOTECA].[Escreve]  WITH CHECK ADD FOREIGN KEY([id_autor])
REFERENCES [BIBLIOTECA].[Autor] ([id_autor])
GO
ALTER TABLE [BIBLIOTECA].[Escreve]  WITH CHECK ADD FOREIGN KEY([id_livro])
REFERENCES [BIBLIOTECA].[Livro] ([ISBN])
GO
ALTER TABLE [BIBLIOTECA].[Funcionario]  WITH CHECK ADD FOREIGN KEY([id_funcionario])
REFERENCES [BIBLIOTECA].[Pessoa] ([id])
GO
ALTER TABLE [BIBLIOTECA].[Livro]  WITH CHECK ADD FOREIGN KEY([id_editora])
REFERENCES [BIBLIOTECA].[Editora] ([id_editora])
GO
ALTER TABLE [BIBLIOTECA].[Livros_Exemplares]  WITH CHECK ADD FOREIGN KEY([n_emprestimo])
REFERENCES [BIBLIOTECA].[Emprestimo] ([n_emprestimo])
GO
ALTER TABLE [BIBLIOTECA].[Livros_Exemplares]  WITH CHECK ADD FOREIGN KEY([ISBN])
REFERENCES [BIBLIOTECA].[Livro] ([ISBN])
GO
ALTER TABLE [BIBLIOTECA].[Nao_Socio]  WITH CHECK ADD FOREIGN KEY([id_cliente])
REFERENCES [BIBLIOTECA].[Cliente] ([id_cliente])
GO
ALTER TABLE [BIBLIOTECA].[Socio]  WITH CHECK ADD FOREIGN KEY([id_cliente])
REFERENCES [BIBLIOTECA].[Cliente] ([id_cliente])
GO
ALTER TABLE [BIBLIOTECA].[Cliente]  WITH CHECK ADD CHECK  (([nif]>(0)))
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[CreateAutor]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [BIBLIOTECA].[CreateAutor] (@first_Name varchar(100), @last_Name varchar(100), @nas_Data date = null, @telemovel decimal(9,0) = null)
as
	begin Transaction
	declare @pessoaId as int;
	exec BIBLIOTECA.CreatePessoa @firstName = @first_Name,@lastName=@last_Name,@nasData=@nas_Data,@tele=@telemovel,@id=@pessoaId out;
	insert into BIBLIOTECA.Autor values (@pessoaId)
	if @@ERROR !=0
		rollback tran
	else
		commit tran
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[CreateCliente]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [BIBLIOTECA].[CreateCliente] (@first_Name varchar(100), @last_Name varchar(100), @nas_Data date = null, @telemovel decimal(9,0) = null, @morada varchar(255), @mail varchar(100), @nif decimal(9,0), @id int out)
as
	begin Transaction
	declare @pessoaId as int;
	exec BIBLIOTECA.CreatePessoa @firstName = @first_Name,@lastName=@last_Name,@nasData=@nas_Data,@tele=@telemovel,@id=@pessoaId out;
	insert into BIBLIOTECA.Cliente (id_cliente,mail,morada,nif) values (@pessoaId,@mail,@morada,@nif)
	set @id = @pessoaId;
	if @@ERROR !=0
		rollback tran
	else
		commit tran
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[CreateEditora]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [BIBLIOTECA].[CreateEditora] (@nome varchar(50), @morada varchar(255)=null,@telefone decimal(9,0)=null)
as
	insert into BIBLIOTECA.Editora(nome_editora,endereco,telefone) values (@nome,@morada,@telefone)
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[CreateEmprestimo]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [BIBLIOTECA].[CreateEmprestimo] (@n_emprestimo int out, @funcionario int, @cliente int)
as
	insert into BIBLIOTECA.Emprestimo(data_saida,data_entrega,data_chegada,funcionario,cliente) values (GETDATE(),(GETDATE()+15),null,@funcionario,@cliente);
	set @n_emprestimo = SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[CreateLivro]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [BIBLIOTECA].[CreateLivro] (@isbn varchar(50),@titulo varchar(100),@ano int,@editora int,@categoria varchar(75) = null,@autores varchar(30))
as
	declare C cursor
		for select value from string_split(@autores,';') where RTRIM(value) <> '';
	begin try
		begin Transaction
		declare @id as int;

		insert into BIBLIOTECA.Livro(ISBN,titulo,ano,categoria,id_editora) values (@isbn,@titulo,@ano,@categoria,@editora);

		open C;
		fetch C into @id;
		while @@FETCH_STATUS = 0
		begin
			insert into BIBLIOTECA.Escreve(id_autor,id_livro) values(@id,@isbn);
			fetch next from  C into @id;
		end
		close C;
		Deallocate C;
		commit tran
	end try
	begin catch
		rollback tran
	end catch
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[CreateLivroExemplares]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [BIBLIOTECA].[CreateLivroExemplares] (@isbn varchar(50),@quantidade int)
as
	
	begin Try
		declare @i as int = 0;
		begin Transaction
		if exists (select 1 from BIBLIOTECA.Livro where ISBN=@isbn)
		begin
			while @i < @quantidade
			begin
				--gerar uma cota aleatoria
				declare @cota as varchar(10) = char((RAND()*25+65))+char((RAND()*25+65))+char((RAND()*25+65))+'.'+char((RAND()*9+48))+char((RAND()*9+48))+char((RAND()*9+48))+char((RAND()*9+48))+char((RAND()*9+48))
				insert into BIBLIOTECA.Livros_Exemplares(n_emprestimo, ISBN,data_de_aquisicao,estado,cota) values('1',@isbn,GETDATE(),'New',@cota);
				--print @cota
				set @i=@i+1
			end
		end
		CLOSE C;
		DEALLOCATE C;
		commit tran
	end try
	begin catch
		CLOSE C;
		DEALLOCATE C;
		rollback tran
	end catch
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[CreatePessoa]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [BIBLIOTECA].[CreatePessoa] (@firstName varchar(100), @lastName varchar(100), @nasData date, @tele decimal(9,0), @id int OUT)
as
	insert into BIBLIOTECA.Pessoa (first_name,last_name,data_nascimento,telefone) values (@firstName,@lastName,@nasData,@tele);
	set @id = SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[EditarLivro]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [BIBLIOTECA].[EditarLivro] (@isbn varchar(50),@titulo varchar(100),@ano int,@editora int,@categoria varchar(75) = null,@autores varchar(30))
as
	begin try
		begin transaction

		update BIBLIOTECA.Livro set titulo=@titulo,ano=@ano,id_editora=@editora,categoria=@categoria where ISBN=@isbn;
		exec BIBLIOTECA.EditarLivroAutores @isbn,@autores

		IF @@TRANCOUNT > 0
			COMMIT TRAN;
	end try
	begin catch
		IF @@TRANCOUNT > 0
			rollback tran
	end catch
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[EditarLivroAutores]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [BIBLIOTECA].[EditarLivroAutores](@isbn varchar(50), @ids varchar(30))
as
	begin Transaction
	declare C cursor
		for select value from string_split(@ids,';') where RTRIM(value) <> '';
	BEGIN TRY
		
		declare @id as int;
		delete from BIBLIOTECA.Escreve where id_livro=@isbn;
		
		open C;
		fetch C into @id;
		while @@FETCH_STATUS = 0
		begin
			insert into BIBLIOTECA.Escreve(id_autor,id_livro) values(@id,@isbn);
			fetch next from  C into @id;
		end
		close C;
		Deallocate C;
		IF @@TRANCOUNT > 0
			commit tran
	END TRY
	BEGIN CATCH
		CLOSE C;
		DEALLOCATE C;
		IF @@TRANCOUNT > 0
			rollback tran
	END CATCH
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[EditCliente]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [BIBLIOTECA].[EditCliente] (@pessoaId int, @first_Name varchar(100), @last_Name varchar(100), @nas_Data date = null, @telemovel decimal(9,0) = null, @morada varchar(255), @mail varchar(100), @nif decimal(9,0))
as
	begin Transaction
	update BIBLIOTECA.Pessoa SET first_name=@first_Name, last_name=@last_Name, data_nascimento=@nas_Data, telefone=@telemovel
							 WHERE id=@pessoaId;
	update BIBLIOTECA.Cliente SET mail=@mail, morada=@morada, nif= @nif
							  WHERE id_cliente=@pessoaId;
	if @@ERROR !=0
	begin
		rollback tran
		return 0
	end
	else
	begin
		commit tran
		return 1
	end
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[FazerEmprestimo]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [BIBLIOTECA].[FazerEmprestimo] (@numeros_exemplares varchar(20), @id_funcionario int, @id_cliente int)
as
	
	declare C cursor
		for select value from string_split(@numeros_exemplares,';') where RTRIM(value) <> '';
	begin try
		declare @nu_emprestimo as int;
		declare @numero_exemplar as int;
		begin Transaction
		exec BIBLIOTECA.CreateEmprestimo @n_emprestimo=@nu_emprestimo out, @funcionario=@id_funcionario , @cliente=@id_cliente;

	
		open C;
		fetch C into @numero_exemplar;

		while @@FETCH_STATUS = 0
			begin
				update BIBLIOTECA.Livros_Exemplares SET n_emprestimo=@nu_emprestimo
									WHERE numero_exemplar=@numero_exemplar;
				fetch next from  C into @numero_exemplar;
			end;
		close C;
		Deallocate C;
		commit tran
	end try
	begin catch
		CLOSE C;
		DEALLOCATE C;
		rollback tran
	end catch
GO
/****** Object:  StoredProcedure [BIBLIOTECA].[FazerEntrega]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [BIBLIOTECA].[FazerEntrega] (@emprestimo int)
as
	update Biblioteca.Emprestimo set data_chegada = GETDATE() where n_emprestimo=@emprestimo;
GO
/****** Object:  Trigger [BIBLIOTECA].[DeleteLivro]    Script Date: 12/06/2020 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Trigger [BIBLIOTECA].[DeleteLivro] on [BIBLIOTECA].[Livro] instead of Delete
as
	declare @isbn as varchar(50);
	select @isbn=ISBN from deleted;
	delete from BIBLIOTECA.Escreve where id_livro=@isbn;
	delete from BIBLIOTECA.Livros_Exemplares where ISBN=@isbn;
	delete from BIBLIOTECA.Livro where ISBN=@isbn;
GO
ALTER TABLE [BIBLIOTECA].[Livro] ENABLE TRIGGER [DeleteLivro]
GO
/****** Object:  Trigger [BIBLIOTECA].[DeleteCliente]    Script Date: 12/06/2020 23:52:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Trigger [BIBLIOTECA].[DeleteCliente] on [BIBLIOTECA].[Pessoa] instead of Delete
as
	declare @id as int;
	select @id=id from deleted;
	delete from BIBLIOTECA.Socio where id_cliente=@id;
	delete from BIBLIOTECA.Nao_Socio where id_cliente=@id;
	update BIBLIOTECA.Emprestimo set cliente=null where cliente=@id
	delete from BIBLIOTECA.Cliente where id_cliente=@id
	delete from BIBLIOTECA.Autor where id_autor=@id;
	delete from BIBLIOTECA.Funcionario where id_funcionario=@id;
	delete from BIBLIOTECA.Pessoa where id=@id

GO
ALTER TABLE [BIBLIOTECA].[Pessoa] ENABLE TRIGGER [DeleteCliente]
GO
USE [master]
GO
ALTER DATABASE [p1g2] SET  READ_WRITE 
GO
