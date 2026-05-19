:ON ERROR EXIT
USE [master];
GO
IF DB_ID(N'gestion_produits') IS NOT NULL
BEGIN
    ALTER DATABASE [gestion_produits] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [gestion_produits];
END
GO
CREATE DATABASE [gestion_produits] COLLATE French_CI_AS;
GO
USE [gestion_produits];
GO

CREATE TABLE [dbo].[appartenir] (
    [id_produit] NVARCHAR(50) NOT NULL,
    [id_commande] INT NOT NULL,
    [quantite] INT CONSTRAINT [DF_appartenir_quantite] DEFAULT ((1)) NULL
);
GO

CREATE TABLE [dbo].[auteur] (
    [id_auteur] INT IDENTITY(1,1) NOT NULL,
    [nom] NVARCHAR(100) NULL,
    [description] NVARCHAR(100) NULL
);
GO

CREATE TABLE [dbo].[classer] (
    [id_produit] NVARCHAR(50) NOT NULL,
    [id_genre] INT NOT NULL
);
GO

CREATE TABLE [dbo].[commande] (
    [id_commande] INT IDENTITY(1,1) NOT NULL,
    [date_commande] DATETIME2(0) NULL,
    [quantite] INT NULL,
    [id_utilisateur] INT NOT NULL
);
GO

CREATE TABLE [dbo].[consulter] (
    [id_utilisateur] INT NOT NULL,
    [id_produit] NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE [dbo].[fournir] (
    [id_produit] NVARCHAR(50) NOT NULL,
    [id_fournisseur] INT NOT NULL
);
GO

CREATE TABLE [dbo].[fournisseur] (
    [id_fournisseur] INT IDENTITY(1,1) NOT NULL,
    [nom] NVARCHAR(100) NULL,
    [adresse] NVARCHAR(100) NULL,
    [email] NVARCHAR(100) NULL,
    [telephone] NVARCHAR(20) NULL
);
GO

CREATE TABLE [dbo].[genre] (
    [id_genre] INT IDENTITY(1,1) NOT NULL,
    [nom] NVARCHAR(100) NULL
);
GO

CREATE TABLE [dbo].[historique] (
    [id_historique] INT IDENTITY(1,1) NOT NULL,
    [date_action] DATETIME2(0) CONSTRAINT [DF_historique_date_action] DEFAULT (sysdatetime()) NULL,
    [action] NVARCHAR(255) NULL
);
GO

CREATE TABLE [dbo].[marque] (
    [id_marque] INT IDENTITY(1,1) NOT NULL,
    [nom] NVARCHAR(100) NULL
);
GO

CREATE TABLE [dbo].[migrations] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [version] NVARCHAR(255) NOT NULL,
    [class] NVARCHAR(255) NOT NULL,
    [group] NVARCHAR(255) NOT NULL,
    [namespace] NVARCHAR(255) NOT NULL,
    [time] INT NOT NULL,
    [batch] INT NOT NULL
);
GO

CREATE TABLE [dbo].[panier_item] (
    [id_panier_item] INT IDENTITY(1,1) NOT NULL,
    [id_utilisateur] INT NOT NULL,
    [id_produit] NVARCHAR(50) NOT NULL,
    [quantite] INT CONSTRAINT [DF_panier_item_quantite] DEFAULT ((1)) NOT NULL,
    [created_at] DATETIME2(0) NULL,
    [updated_at] DATETIME2(0) NULL
);
GO

CREATE TABLE [dbo].[produit] (
    [id_produit] NVARCHAR(50) NOT NULL,
    [nom] NVARCHAR(100) NULL,
    [description] NVARCHAR(255) NULL,
    [prix] DECIMAL(10,2) NULL,
    [stock] INT NULL,
    [image] NVARCHAR(255) NULL
);
GO

CREATE TABLE [dbo].[produit_livre] (
    [id_produit] NVARCHAR(50) NOT NULL,
    [nb_pages] INT NULL,
    [id_auteur] INT NULL
);
GO

CREATE TABLE [dbo].[produit_vetement] (
    [id_produit] NVARCHAR(50) NOT NULL,
    [taille] NVARCHAR(50) NULL,
    [couleur] NVARCHAR(50) NULL,
    [matiere] NVARCHAR(50) NULL,
    [id_marque] INT NULL
);
GO

CREATE TABLE [dbo].[utilisateur] (
    [id_utilisateur] INT IDENTITY(1,1) NOT NULL,
    [nom] NVARCHAR(50) NULL,
    [prenom] NVARCHAR(50) NULL,
    [email] NVARCHAR(50) NULL,
    [mot_de_passe] NVARCHAR(255) NULL,
    [role] NVARCHAR(20) NULL
);
GO

CREATE TABLE [dbo].[sysdiagrams] (
    [name] NVARCHAR(128) NOT NULL,
    [principal_id] INT NOT NULL,
    [diagram_id] INT IDENTITY(1,1) NOT NULL,
    [version] INT NULL,
    [definition] VARBINARY(MAX) NULL
);
GO

-- Donnees: [dbo].[appartenir]
INSERT INTO [dbo].[appartenir] ([id_produit], [id_commande], [quantite]) VALUES (N'P001', 1, 1);
INSERT INTO [dbo].[appartenir] ([id_produit], [id_commande], [quantite]) VALUES (N'P001', 8, 1);
INSERT INTO [dbo].[appartenir] ([id_produit], [id_commande], [quantite]) VALUES (N'P001', 9, 1);
INSERT INTO [dbo].[appartenir] ([id_produit], [id_commande], [quantite]) VALUES (N'P001', 14, 3);
INSERT INTO [dbo].[appartenir] ([id_produit], [id_commande], [quantite]) VALUES (N'P002', 14, 1);
INSERT INTO [dbo].[appartenir] ([id_produit], [id_commande], [quantite]) VALUES (N'P004', 1, 1);
INSERT INTO [dbo].[appartenir] ([id_produit], [id_commande], [quantite]) VALUES (N'P6926afa423f43', 10, 1);
GO

-- Donnees: [dbo].[auteur]
SET IDENTITY_INSERT [dbo].[auteur] ON;
INSERT INTO [dbo].[auteur] ([id_auteur], [nom], [description]) VALUES (1, N'J.k. rowling', N'auteure britannique célèbre pour harry potter');
INSERT INTO [dbo].[auteur] ([id_auteur], [nom], [description]) VALUES (2, N'George orwell', N'romancier et essayiste anglais');
INSERT INTO [dbo].[auteur] ([id_auteur], [nom], [description]) VALUES (3, N'Victor hugo', N'écrivain français du xixe siècle');
SET IDENTITY_INSERT [dbo].[auteur] OFF;
GO

-- Donnees: [dbo].[classer]
INSERT INTO [dbo].[classer] ([id_produit], [id_genre]) VALUES (N'P001', 1);
INSERT INTO [dbo].[classer] ([id_produit], [id_genre]) VALUES (N'P002', 2);
INSERT INTO [dbo].[classer] ([id_produit], [id_genre]) VALUES (N'P003', 3);
GO

-- Donnees: [dbo].[commande]
SET IDENTITY_INSERT [dbo].[commande] ON;
INSERT INTO [dbo].[commande] ([id_commande], [date_commande], [quantite], [id_utilisateur]) VALUES (1, N'2025-10-05 10:00:00.0000000', 2, 1);
INSERT INTO [dbo].[commande] ([id_commande], [date_commande], [quantite], [id_utilisateur]) VALUES (8, N'2025-12-10 07:36:43.0000000', 1, 9);
INSERT INTO [dbo].[commande] ([id_commande], [date_commande], [quantite], [id_utilisateur]) VALUES (9, N'2025-12-10 07:37:17.0000000', 1, 9);
INSERT INTO [dbo].[commande] ([id_commande], [date_commande], [quantite], [id_utilisateur]) VALUES (10, N'2026-04-08 08:27:50.0000000', 1, 0);
INSERT INTO [dbo].[commande] ([id_commande], [date_commande], [quantite], [id_utilisateur]) VALUES (14, N'2026-04-08 09:18:24.0000000', 4, 0);
SET IDENTITY_INSERT [dbo].[commande] OFF;
GO

-- Donnees: [dbo].[consulter]
INSERT INTO [dbo].[consulter] ([id_utilisateur], [id_produit]) VALUES (0, N'P001');
INSERT INTO [dbo].[consulter] ([id_utilisateur], [id_produit]) VALUES (1, N'P001');
INSERT INTO [dbo].[consulter] ([id_utilisateur], [id_produit]) VALUES (2, N'P004');
INSERT INTO [dbo].[consulter] ([id_utilisateur], [id_produit]) VALUES (3, N'P005');
INSERT INTO [dbo].[consulter] ([id_utilisateur], [id_produit]) VALUES (4, N'P006');
INSERT INTO [dbo].[consulter] ([id_utilisateur], [id_produit]) VALUES (0, N'P019');
GO

-- Donnees: [dbo].[fournir]
INSERT INTO [dbo].[fournir] ([id_produit], [id_fournisseur]) VALUES (N'P001', 1);
INSERT INTO [dbo].[fournir] ([id_produit], [id_fournisseur]) VALUES (N'P002', 1);
INSERT INTO [dbo].[fournir] ([id_produit], [id_fournisseur]) VALUES (N'P003', 1);
INSERT INTO [dbo].[fournir] ([id_produit], [id_fournisseur]) VALUES (N'P004', 2);
INSERT INTO [dbo].[fournir] ([id_produit], [id_fournisseur]) VALUES (N'P005', 2);
INSERT INTO [dbo].[fournir] ([id_produit], [id_fournisseur]) VALUES (N'P006', 3);
GO

-- Donnees: [dbo].[fournisseur]
SET IDENTITY_INSERT [dbo].[fournisseur] ON;
INSERT INTO [dbo].[fournisseur] ([id_fournisseur], [nom], [adresse], [email], [telephone]) VALUES (1, N'Livreplus', N'12 rue du savoir, paris', N'contact@livreplus.fr', N'0123456789');
INSERT INTO [dbo].[fournisseur] ([id_fournisseur], [nom], [adresse], [email], [telephone]) VALUES (2, N'Textilpro', N'8 avenue du style, lyon', N'contact@textilpro.fr', N'0987654321');
INSERT INTO [dbo].[fournisseur] ([id_fournisseur], [nom], [adresse], [email], [telephone]) VALUES (3, N'Technoworld', N'25 rue des circuits, marseille', N'contact@technoworld.fr', N'0567891234');
SET IDENTITY_INSERT [dbo].[fournisseur] OFF;
GO

-- Donnees: [dbo].[genre]
SET IDENTITY_INSERT [dbo].[genre] ON;
INSERT INTO [dbo].[genre] ([id_genre], [nom]) VALUES (1, N'Fantastique');
INSERT INTO [dbo].[genre] ([id_genre], [nom]) VALUES (2, N'Dystopie');
INSERT INTO [dbo].[genre] ([id_genre], [nom]) VALUES (3, N'Classique');
SET IDENTITY_INSERT [dbo].[genre] OFF;
GO

-- Donnees: [dbo].[historique]
SET IDENTITY_INSERT [dbo].[historique] ON;
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (1, N'2025-10-05 11:00:00.0000000', N'Ajout du produit P001');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (2, N'2025-10-06 15:00:00.0000000', N'Modification du stock du produit P004');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (3, N'2025-10-07 16:00:00.0000000', N'Suppression d''un utilisateur test');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (4, N'2026-01-07 08:47:06.0000000', N'Suppression utilisateur 8 (Medhi Boudechicha, rôle=admin)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (5, N'2026-01-07 08:48:24.0000000', N'Création utilisateur 10 (Boudechicha Medhi, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (6, N'2026-01-07 08:49:29.0000000', N'Suppression utilisateur 7 (User Test, rôle=admin)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (7, N'2026-01-07 11:11:56.0000000', N'Création produit  (Test)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (8, N'2026-01-07 11:21:59.0000000', N'Création produit P100 (Test2)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (9, N'2026-01-07 11:31:12.0000000', N'Modification produit P100 (Test2)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (10, N'2026-01-07 11:31:33.0000000', N'Suppression produit P100 (Test2)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (11, N'2026-04-08 10:27:50.0000000', N'Création commande 10 pour utilisateur 0');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (12, N'2026-04-08 10:27:51.0000000', N'Modification produit P6926afa423f43 (Izuku midoriya)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (13, N'2026-04-08 11:03:25.0000000', N'Création utilisateur 11 (Test Codex, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (14, N'2026-04-08 11:04:16.0000000', N'Suppression utilisateur 11 (Test Codex, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (15, N'2026-04-08 11:04:16.0000000', N'Création utilisateur 12 (Test Codex, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (20, N'2026-04-08 11:09:41.0000000', N'Création commande 13 pour utilisateur 12');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (21, N'2026-04-08 11:09:41.0000000', N'Modification produit P004 (T-shirt coton)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (22, N'2026-04-08 11:10:22.0000000', N'Modification produit P004 (T-shirt coton)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (23, N'2026-04-08 11:10:22.0000000', N'Suppression commande 13 pour utilisateur 12');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (24, N'2026-04-08 11:10:22.0000000', N'Suppression utilisateur 12 (Test Codex, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (25, N'2026-04-08 11:15:51.0000000', N'Création utilisateur 13 (Test Codex, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (26, N'2026-04-08 11:16:51.0000000', N'Suppression utilisateur 13 (Test Codex, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (27, N'2026-04-08 11:18:24.0000000', N'Création commande 14 pour utilisateur 0');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (28, N'2026-04-08 11:18:24.0000000', N'Modification produit P001 (Harry potter à l''école des sorciers)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (29, N'2026-04-08 11:18:24.0000000', N'Modification produit P002 (1984)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (30, N'2026-04-08 11:24:26.0000000', N'Création utilisateur 14 (Test Codex, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (31, N'2026-04-08 11:24:55.0000000', N'Suppression utilisateur 14 (Test Codex, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (32, N'2026-04-15 10:51:39.0000000', N'Modification produit P001 (Harry potter à l''école des sorciers)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (33, N'2026-04-15 10:53:24.0000000', N'Création utilisateur 15 (Crerrar Geoff, rôle=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (34, N'2026-05-13 22:32:16.0000000', N'Suppression produit  (Test)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (35, N'2026-05-13 22:41:21.0000000', N'Création commande 15 pour utilisateur 2');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (36, N'2026-05-13 22:41:21.0000000', N'Modification produit P001 (Harry potter à l''école des sorciers)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (37, N'2026-05-13 22:43:49.0000000', N'Modification produit P001 (Harry potter à l''école des sorciers)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (38, N'2026-05-13 22:43:49.0000000', N'Suppression commande 15 pour utilisateur 2');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (39, N'2026-05-13 22:47:12.0000000', N'Création produit P1778705228268 (Pro)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (40, N'2026-05-13 22:49:09.0000000', N'Suppression produit P1778705228268 (Pro)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (41, N'2026-05-13 23:06:30.0000000', N'Création produit P007 (Casque audio nomade)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (42, N'2026-05-13 23:06:30.0000000', N'Création produit P008 (Lampe de bureau noire)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (43, N'2026-05-13 23:06:30.0000000', N'Création produit P009 (Sac a dos urbain 22l)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (44, N'2026-05-13 23:06:30.0000000', N'Création produit P010 (Sweat a capuche gris)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (45, N'2026-05-13 23:06:30.0000000', N'Création produit P011 (Gourde rigide 750 ml)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (46, N'2026-05-13 23:06:30.0000000', N'Création produit P012 (Clavier compact sans fil)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (47, N'2026-05-13 23:06:30.0000000', N'Création produit P013 (Bouilloire electrique inox 1.7 l)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (48, N'2026-05-13 23:06:30.0000000', N'Création produit P014 (Ordinateur portable 13 pouces)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (49, N'2026-05-13 23:24:38.0000000', N'Modification produit P007 (Casque audio nomade)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (50, N'2026-05-13 23:24:38.0000000', N'Modification produit P008 (Lampe de bureau noire)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (51, N'2026-05-13 23:24:38.0000000', N'Modification produit P009 (Sac a dos urbain 22l)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (52, N'2026-05-13 23:24:38.0000000', N'Modification produit P010 (Sweat a capuche gris)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (53, N'2026-05-13 23:24:38.0000000', N'Modification produit P011 (Gourde rigide 750 ml)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (54, N'2026-05-13 23:24:38.0000000', N'Modification produit P012 (Clavier compact sans fil)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (55, N'2026-05-13 23:24:38.0000000', N'Modification produit P013 (Bouilloire electrique inox 1.7 l)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (56, N'2026-05-13 23:24:38.0000000', N'Modification produit P014 (Ordinateur portable 13 pouces)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (57, N'2026-05-13 23:24:38.0000000', N'Création produit P015 (Souris optique usb)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (58, N'2026-05-13 23:24:38.0000000', N'Création produit P016 (Cle usb 64 go)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (59, N'2026-05-13 23:24:38.0000000', N'Création produit P017 (Tapis de yoga antiderapant)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (60, N'2026-05-13 23:24:38.0000000', N'Création produit P018 (Mug cafe ceramique)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (61, N'2026-05-13 23:24:38.0000000', N'Création produit P019 (Stylo bille bleu)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (62, N'2026-05-13 23:24:38.0000000', N'Création produit P020 (Poele en fonte 26 cm)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (63, N'2026-05-13 23:24:38.0000000', N'Création produit P021 (Ballon de basket indoor)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (64, N'2026-05-13 23:24:38.0000000', N'Création produit P022 (Chaussures de running legeres)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (65, N'2026-05-13 23:24:38.0000000', N'Création produit P023 (Appareil photo compact)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (66, N'2026-05-13 23:24:38.0000000', N'Création produit P024 (Plante verte en pot)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (67, N'2026-05-19 01:34:42.0000000', N'CrÃ©ation utilisateur 16 (Demo Admin, rÃ´le=admin)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (68, N'2026-05-19 01:34:42.0000000', N'CrÃ©ation utilisateur 17 (Demo User, rÃ´le=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (69, N'2026-05-19 01:39:15.0000000', N'CrÃ©ation produit PTESTCRUD (Produit test crud)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (70, N'2026-05-19 01:39:15.0000000', N'Modification produit PTESTCRUD (Produit test modifie)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (71, N'2026-05-19 01:39:15.0000000', N'Suppression produit PTESTCRUD (Produit test modifie)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (72, N'2026-05-19 01:39:15.0000000', N'CrÃ©ation utilisateur 18 (Test Crud, rÃ´le=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (73, N'2026-05-19 01:39:15.0000000', N'Suppression utilisateur 18 (Modifie Crud, rÃ´le=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (74, N'2026-05-19 01:49:04.0000000', N'CrÃ©ation produit PMVCTEST (Produit mvc)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (75, N'2026-05-19 01:49:04.0000000', N'Modification produit PMVCTEST (Produit mvc modifie)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (76, N'2026-05-19 01:49:04.0000000', N'Suppression produit PMVCTEST (Produit mvc modifie)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (77, N'2026-05-19 01:49:04.0000000', N'CrÃ©ation utilisateur 19 (Test Mvc, rÃ´le=utilisateur)');
INSERT INTO [dbo].[historique] ([id_historique], [date_action], [action]) VALUES (78, N'2026-05-19 01:49:04.0000000', N'Suppression utilisateur 19 (Modifie Mvc, rÃ´le=utilisateur)');
SET IDENTITY_INSERT [dbo].[historique] OFF;
GO

-- Donnees: [dbo].[marque]
SET IDENTITY_INSERT [dbo].[marque] ON;
INSERT INTO [dbo].[marque] ([id_marque], [nom]) VALUES (1, N'Nike');
INSERT INTO [dbo].[marque] ([id_marque], [nom]) VALUES (2, N'Adidas');
INSERT INTO [dbo].[marque] ([id_marque], [nom]) VALUES (3, N'Apple');
SET IDENTITY_INSERT [dbo].[marque] OFF;
GO

-- Donnees: [dbo].[migrations]
SET IDENTITY_INSERT [dbo].[migrations] ON;
INSERT INTO [dbo].[migrations] ([id], [version], [class], [group], [namespace], [time], [batch]) VALUES (1, N'2026-04-08-120000', N'App\Database\Migrations\CreatePanierItemTable', N'default', N'App', 1775638937, 1);
INSERT INTO [dbo].[migrations] ([id], [version], [class], [group], [namespace], [time], [batch]) VALUES (2, N'2026-04-08-121000', N'App\Database\Migrations\AddQuantiteToAppartenir', N'default', N'App', 1775639358, 2);
INSERT INTO [dbo].[migrations] ([id], [version], [class], [group], [namespace], [time], [batch]) VALUES (3, N'2026-05-13-220000', N'App\Database\Migrations\HardenCommerceData', N'default', N'App', 1778704336, 3);
SET IDENTITY_INSERT [dbo].[migrations] OFF;
GO

-- Donnees: [dbo].[produit]
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P001', N'Harry potter à l''école des sorciers', N'Roman fantastique pour enfants', 19.99, 44, N'no_image.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P002', N'1984', N'Roman dystopique et politique', 14.50, 29, N'no_image.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P003', N'Les misérables', N'Roman classique français', 18.90, 25, N'no_image.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P004', N'T-shirt coton', N'Vêtement doux et respirant', 24.99, 100, N'no_image.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P005', N'Pantalon de sport', N'Vêtement confortable pour le sport', 39.99, 80, N'no_image.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P006', N'Iphone 15', N'Smartphone dernière génération', 999.00, 15, N'iphone_15.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P007', N'Casque audio nomade', N'Casque confortable pour ecoute quotidienne avec arceau souple et son equilibre.', 79.90, 18, N'kaitlin_headphones.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P008', N'Lampe de bureau noire', N'Lampe orientable pour poste de travail, lecture ou table de chevet.', 34.90, 24, N'black_desk_lamp.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P009', N'Sac a dos urbain 22l', N'Sac polyvalent avec poche frontale, bretelles rembourrees et grand compartiment.', 49.90, 28, N'backpack.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P010', N'Sweat a capuche gris', N'Sweat molletonne coupe reguliere pour sorties, confort et mi-saison.', 54.90, 16, N'hoodie_man.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P011', N'Gourde rigide 750 ml', N'Gourde reutilisable legere pour sport, bureau ou transport quotidien.', 17.90, 35, N'polycarbonate_water_bottle.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P012', N'Clavier compact sans fil', N'Clavier compact pour bureau mobile avec frappe souple et connexion sans fil.', 69.90, 20, N'keyboard_compact.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P013', N'Bouilloire electrique inox 1.7 l', N'Bouilloire rapide avec corps inox et bec verseur large pour cuisine ou bureau.', 34.90, 14, N'electric_kettle.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P014', N'Ordinateur portable 13 pouces', N'Portable leger pour bureautique, navigation et cours a distance.', 899.00, 9, N'laptop_image.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P015', N'Souris optique usb', N'Souris filaire simple et precise pour ordinateur portable ou poste fixe.', 19.90, 32, N'computer_mice.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P016', N'Cle usb 64 go', N'Cle compacte pour sauvegarder documents, photos et fichiers de cours.', 12.90, 50, N'usb_flash_drive.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P017', N'Tapis de yoga antiderapant', N'Tapis epais et stable pour yoga, stretching ou exercices au sol.', 29.90, 21, N'yoga_mats.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P018', N'Mug cafe ceramique', N'Mug colore en ceramique pour cafe, the ou boisson chaude.', 9.90, 45, N'multicolored_coffee_mug.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P019', N'Stylo bille bleu', N'Stylo bille classique pour prise de notes, bureau ou trousse scolaire.', 2.50, 100, N'typical_ballpoint_pen.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P020', N'Poele en fonte 26 cm', N'Poele robuste pour cuisson quotidienne, saisie de viandes et plats maison.', 39.90, 17, N'cast_iron_pan.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P021', N'Ballon de basket indoor', N'Ballon de basket pour entrainement en salle et loisirs sportifs.', 24.90, 26, N'basketball_ball.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P022', N'Chaussures de running legeres', N'Chaussures respirantes pour course, marche active et entrainement.', 89.90, 13, N'running_shoes_display.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P023', N'Appareil photo compact', N'Appareil photo numerique compact pour voyages, souvenirs et sorties.', 149.90, 8, N'compact_camera.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P024', N'Plante verte en pot', N'Plante decorative en pot pour bureau, salon ou chambre.', 16.90, 30, N'potted_plant.jpg');
INSERT INTO [dbo].[produit] ([id_produit], [nom], [description], [prix], [stock], [image]) VALUES (N'P6926afa423f43', N'Izuku midoriya', N'Thème	animé
marque	bandai
couleur	izuku midoriya
style	moderne
matériau	pvc acrylonitrile butadiène styrène
dimensions du produit', 124.00, 62, N'1764143012_ac703ce80ec77a605a90.webp');
GO

-- Donnees: [dbo].[produit_livre]
INSERT INTO [dbo].[produit_livre] ([id_produit], [nb_pages], [id_auteur]) VALUES (N'P001', 340, 1);
INSERT INTO [dbo].[produit_livre] ([id_produit], [nb_pages], [id_auteur]) VALUES (N'P002', 328, 2);
INSERT INTO [dbo].[produit_livre] ([id_produit], [nb_pages], [id_auteur]) VALUES (N'P003', 520, 3);
GO

-- Donnees: [dbo].[produit_vetement]
INSERT INTO [dbo].[produit_vetement] ([id_produit], [taille], [couleur], [matiere], [id_marque]) VALUES (N'P004', N'M', N'blanc', N'coton', 1);
INSERT INTO [dbo].[produit_vetement] ([id_produit], [taille], [couleur], [matiere], [id_marque]) VALUES (N'P005', N'L', N'noir', N'polyester', 2);
INSERT INTO [dbo].[produit_vetement] ([id_produit], [taille], [couleur], [matiere], [id_marque]) VALUES (N'P010', N'M', N'gris', N'coton melange', 2);
INSERT INTO [dbo].[produit_vetement] ([id_produit], [taille], [couleur], [matiere], [id_marque]) VALUES (N'P022', N'42', N'bleu', N'mesh synthetique', 1);
GO

-- Donnees: [dbo].[utilisateur]
SET IDENTITY_INSERT [dbo].[utilisateur] ON;
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (0, N'Medhi', N'Boudechicha', N'medhiboudechich1@gmail.com', N'$2y$10$L0iqsKVWXCiXnK8J1uhA6et7QT5MLloYaWnA1DtsEJOAY44zZYEXe', N'admin');
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (1, N'Dupont', N'Jean', N'jean.dupont@example.com', N'$2y$10$ejO0js/vtIfHaMcuzUqpG.scqF6P7GT3Cba10vH1.KsyLx14BvCRK', N'admin');
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (2, N'Durand', N'Marie', N'marie.durand@example.com', N'$2y$10$/R7C2ShcGYBBh6u8eJ8eNO2qpHAubbeiygncWWkYl7w/pA2qkR8JO', N'utilisateur');
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (3, N'Martin', N'Lucas', N'lucas.martin@example.com', N'$2y$10$i69kY5RIsw9u/184btcHl.9xKXFegtUU2gtGQSkFSb2y1lVp.kZn6', N'utilisateur');
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (4, N'Bernard', N'Lea', N'lea.bernard@example.com', N'$2y$10$.m/Z8L.918/xtqA47teqbefxD0STv5..ucGxG74n2QTfJohEf9uv6', N'utilisateur');
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (9, N'Bogina', N'Enzo', N'enzobogina@gmail.com', N'$2y$10$DHW2VcHD6pG519hx1naU1efvxN8cdUa5EKQ2tc4KHYp16tyJGmbrG', N'utilisateur');
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (15, N'Geoff', N'Crerrar', N'geoff@gmail.com', N'$2y$10$eGwg50ey2B/RSQ3foZoS9OdUAmhl6ftwpgKPB2mWy1kPhjET2H8g6', N'utilisateur');
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (16, N'Admin', N'Demo', N'admin@demo.fr', N'$2y$10$J9UU54dZWi4jGfxeP26r3.SzB9vhGEbkyE/x3mKGemJyf2cDozMjK', N'admin');
INSERT INTO [dbo].[utilisateur] ([id_utilisateur], [nom], [prenom], [email], [mot_de_passe], [role]) VALUES (17, N'User', N'Demo', N'user@demo.fr', N'$2y$10$NjomsaVg2XK8DVZ4dBBJB.mml4c0YYEeLYQcMSn8q4NQySK28gEHi', N'utilisateur');
SET IDENTITY_INSERT [dbo].[utilisateur] OFF;
GO

ALTER TABLE [dbo].[appartenir] ADD CONSTRAINT [PK_appartenir] PRIMARY KEY CLUSTERED ([id_produit] ASC, [id_commande] ASC);
ALTER TABLE [dbo].[auteur] ADD CONSTRAINT [PK_auteur] PRIMARY KEY CLUSTERED ([id_auteur] ASC);
ALTER TABLE [dbo].[classer] ADD CONSTRAINT [PK_classer] PRIMARY KEY CLUSTERED ([id_produit] ASC, [id_genre] ASC);
ALTER TABLE [dbo].[commande] ADD CONSTRAINT [PK_commande] PRIMARY KEY CLUSTERED ([id_commande] ASC);
ALTER TABLE [dbo].[consulter] ADD CONSTRAINT [PK_consulter] PRIMARY KEY CLUSTERED ([id_utilisateur] ASC, [id_produit] ASC);
ALTER TABLE [dbo].[fournir] ADD CONSTRAINT [PK_fournir] PRIMARY KEY CLUSTERED ([id_produit] ASC, [id_fournisseur] ASC);
ALTER TABLE [dbo].[fournisseur] ADD CONSTRAINT [PK_fournisseur] PRIMARY KEY CLUSTERED ([id_fournisseur] ASC);
ALTER TABLE [dbo].[genre] ADD CONSTRAINT [PK_genre] PRIMARY KEY CLUSTERED ([id_genre] ASC);
ALTER TABLE [dbo].[historique] ADD CONSTRAINT [PK_historique] PRIMARY KEY CLUSTERED ([id_historique] ASC);
ALTER TABLE [dbo].[marque] ADD CONSTRAINT [PK_marque] PRIMARY KEY CLUSTERED ([id_marque] ASC);
ALTER TABLE [dbo].[migrations] ADD CONSTRAINT [PK_migrations] PRIMARY KEY CLUSTERED ([id] ASC);
ALTER TABLE [dbo].[panier_item] ADD CONSTRAINT [PK_panier_item] PRIMARY KEY CLUSTERED ([id_panier_item] ASC);
ALTER TABLE [dbo].[produit] ADD CONSTRAINT [PK_produit] PRIMARY KEY CLUSTERED ([id_produit] ASC);
ALTER TABLE [dbo].[produit_livre] ADD CONSTRAINT [PK_produit_livre] PRIMARY KEY CLUSTERED ([id_produit] ASC);
ALTER TABLE [dbo].[produit_vetement] ADD CONSTRAINT [PK_produit_vetement] PRIMARY KEY CLUSTERED ([id_produit] ASC);
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B61FC16E8B1] PRIMARY KEY CLUSTERED ([diagram_id] ASC);
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED ([principal_id] ASC, [name] ASC);
ALTER TABLE [dbo].[utilisateur] ADD CONSTRAINT [PK_utilisateur] PRIMARY KEY CLUSTERED ([id_utilisateur] ASC);
GO

ALTER TABLE [dbo].[utilisateur] WITH CHECK ADD CONSTRAINT [CK_utilisateur_role] CHECK ([role] IS NULL OR ([role]=N'' OR [role]=N'superadmin' OR [role]=N'utilisateur' OR [role]=N'admin'));
GO

CREATE NONCLUSTERED INDEX [IX_appartenir_id_commande] ON [dbo].[appartenir] ([id_commande] ASC);
CREATE NONCLUSTERED INDEX [IX_classer_id_genre] ON [dbo].[classer] ([id_genre] ASC);
CREATE NONCLUSTERED INDEX [IX_commande_id_utilisateur] ON [dbo].[commande] ([id_utilisateur] ASC);
CREATE NONCLUSTERED INDEX [IX_consulter_id_produit] ON [dbo].[consulter] ([id_produit] ASC);
CREATE NONCLUSTERED INDEX [IX_fournir_id_fournisseur] ON [dbo].[fournir] ([id_fournisseur] ASC);
CREATE NONCLUSTERED INDEX [IX_panier_item_id_produit] ON [dbo].[panier_item] ([id_produit] ASC);
CREATE NONCLUSTERED INDEX [IX_panier_item_id_utilisateur] ON [dbo].[panier_item] ([id_utilisateur] ASC);
CREATE UNIQUE NONCLUSTERED INDEX [uniq_panier_utilisateur_produit] ON [dbo].[panier_item] ([id_utilisateur] ASC, [id_produit] ASC);
CREATE NONCLUSTERED INDEX [IX_produit_livre_id_auteur] ON [dbo].[produit_livre] ([id_auteur] ASC);
CREATE NONCLUSTERED INDEX [IX_produit_vetement_id_marque] ON [dbo].[produit_vetement] ([id_marque] ASC);
GO

ALTER TABLE [dbo].[appartenir] WITH CHECK ADD CONSTRAINT [appartenir_ibfk_1] FOREIGN KEY ([id_produit]) REFERENCES [dbo].[produit] ([id_produit]);
ALTER TABLE [dbo].[appartenir] CHECK CONSTRAINT [appartenir_ibfk_1];
ALTER TABLE [dbo].[appartenir] WITH CHECK ADD CONSTRAINT [appartenir_ibfk_2] FOREIGN KEY ([id_commande]) REFERENCES [dbo].[commande] ([id_commande]);
ALTER TABLE [dbo].[appartenir] CHECK CONSTRAINT [appartenir_ibfk_2];
ALTER TABLE [dbo].[classer] WITH CHECK ADD CONSTRAINT [classer_ibfk_1] FOREIGN KEY ([id_produit]) REFERENCES [dbo].[produit_livre] ([id_produit]);
ALTER TABLE [dbo].[classer] CHECK CONSTRAINT [classer_ibfk_1];
ALTER TABLE [dbo].[classer] WITH CHECK ADD CONSTRAINT [classer_ibfk_2] FOREIGN KEY ([id_genre]) REFERENCES [dbo].[genre] ([id_genre]);
ALTER TABLE [dbo].[classer] CHECK CONSTRAINT [classer_ibfk_2];
ALTER TABLE [dbo].[commande] WITH CHECK ADD CONSTRAINT [commande_ibfk_1] FOREIGN KEY ([id_utilisateur]) REFERENCES [dbo].[utilisateur] ([id_utilisateur]);
ALTER TABLE [dbo].[commande] CHECK CONSTRAINT [commande_ibfk_1];
ALTER TABLE [dbo].[consulter] WITH CHECK ADD CONSTRAINT [consulter_ibfk_1] FOREIGN KEY ([id_utilisateur]) REFERENCES [dbo].[utilisateur] ([id_utilisateur]);
ALTER TABLE [dbo].[consulter] CHECK CONSTRAINT [consulter_ibfk_1];
ALTER TABLE [dbo].[consulter] WITH CHECK ADD CONSTRAINT [consulter_ibfk_2] FOREIGN KEY ([id_produit]) REFERENCES [dbo].[produit] ([id_produit]);
ALTER TABLE [dbo].[consulter] CHECK CONSTRAINT [consulter_ibfk_2];
ALTER TABLE [dbo].[fournir] WITH CHECK ADD CONSTRAINT [fournir_ibfk_1] FOREIGN KEY ([id_produit]) REFERENCES [dbo].[produit] ([id_produit]);
ALTER TABLE [dbo].[fournir] CHECK CONSTRAINT [fournir_ibfk_1];
ALTER TABLE [dbo].[fournir] WITH CHECK ADD CONSTRAINT [fournir_ibfk_2] FOREIGN KEY ([id_fournisseur]) REFERENCES [dbo].[fournisseur] ([id_fournisseur]);
ALTER TABLE [dbo].[fournir] CHECK CONSTRAINT [fournir_ibfk_2];
ALTER TABLE [dbo].[panier_item] WITH CHECK ADD CONSTRAINT [fk_panier_item_produit] FOREIGN KEY ([id_produit]) REFERENCES [dbo].[produit] ([id_produit]) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE [dbo].[panier_item] CHECK CONSTRAINT [fk_panier_item_produit];
ALTER TABLE [dbo].[panier_item] WITH CHECK ADD CONSTRAINT [fk_panier_item_utilisateur] FOREIGN KEY ([id_utilisateur]) REFERENCES [dbo].[utilisateur] ([id_utilisateur]) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE [dbo].[panier_item] CHECK CONSTRAINT [fk_panier_item_utilisateur];
ALTER TABLE [dbo].[produit_livre] WITH CHECK ADD CONSTRAINT [produit_livre_ibfk_1] FOREIGN KEY ([id_produit]) REFERENCES [dbo].[produit] ([id_produit]);
ALTER TABLE [dbo].[produit_livre] CHECK CONSTRAINT [produit_livre_ibfk_1];
ALTER TABLE [dbo].[produit_livre] WITH CHECK ADD CONSTRAINT [produit_livre_ibfk_2] FOREIGN KEY ([id_auteur]) REFERENCES [dbo].[auteur] ([id_auteur]);
ALTER TABLE [dbo].[produit_livre] CHECK CONSTRAINT [produit_livre_ibfk_2];
ALTER TABLE [dbo].[produit_vetement] WITH CHECK ADD CONSTRAINT [produit_vetement_ibfk_1] FOREIGN KEY ([id_produit]) REFERENCES [dbo].[produit] ([id_produit]);
ALTER TABLE [dbo].[produit_vetement] CHECK CONSTRAINT [produit_vetement_ibfk_1];
ALTER TABLE [dbo].[produit_vetement] WITH CHECK ADD CONSTRAINT [produit_vetement_ibfk_2] FOREIGN KEY ([id_marque]) REFERENCES [dbo].[marque] ([id_marque]);
ALTER TABLE [dbo].[produit_vetement] CHECK CONSTRAINT [produit_vetement_ibfk_2];
GO

CREATE   FUNCTION dbo.[fn_capitalize_first] (@value NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF @value IS NULL OR LEN(@value) = 0
        RETURN @value;

    RETURN UPPER(LEFT(@value, 1)) + LOWER(SUBSTRING(@value, 2, LEN(@value)));
END
GO

CREATE FUNCTION dbo.fn_diagramobjects() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
GO

CREATE   PROCEDURE dbo.[ps_historique_par_mot_cle]
    @p_texte NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [id_historique], [date_action], [action]
    FROM dbo.[historique]
    WHERE [action] LIKE N'%' + @p_texte + N'%'
    ORDER BY [date_action] DESC, [id_historique] DESC;
END
GO

CREATE   PROCEDURE dbo.[ps_liste_historique]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [id_historique], [date_action], [action]
    FROM dbo.[historique]
    ORDER BY [date_action] DESC, [id_historique] DESC;
END
GO

CREATE   PROCEDURE dbo.[ps_nb_commandes_utilisateur]
    @p_id_utilisateur INT,
    @p_nb_commandes INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @p_nb_commandes = COUNT(*)
    FROM dbo.[commande]
    WHERE [id_utilisateur] = @p_id_utilisateur;
END
GO

CREATE PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
GO

CREATE   PROCEDURE dbo.[sp_create_produit]
    @p_id_produit NVARCHAR(50),
    @p_nom NVARCHAR(100),
    @p_description NVARCHAR(255),
    @p_prix DECIMAL(10,2),
    @p_stock INT,
    @p_image NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.[produit] ([id_produit], [nom], [description], [prix], [stock], [image])
    VALUES (@p_id_produit, @p_nom, @p_description, @p_prix, @p_stock, @p_image);
END
GO

CREATE PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
GO

CREATE   PROCEDURE dbo.[sp_delete_produit]
    @p_id_produit NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.[produit]
    WHERE [id_produit] = @p_id_produit;
END
GO

CREATE PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
GO

CREATE   PROCEDURE dbo.[sp_get_all_produits]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.[id_produit],
        p.[nom],
        p.[prix],
        p.[stock],
        a.[nom] AS [nom_auteur]
    FROM dbo.[produit] p
    LEFT JOIN dbo.[produit_livre] pl ON pl.[id_produit] = p.[id_produit]
    LEFT JOIN dbo.[auteur] a ON a.[id_auteur] = pl.[id_auteur]
    ORDER BY p.[id_produit];
END
GO

CREATE   PROCEDURE dbo.[sp_get_produit]
    @p_id_produit NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.[id_produit],
        p.[nom],
        p.[description],
        p.[prix],
        p.[stock],
        p.[image],
        a.[nom] AS [nom_auteur]
    FROM dbo.[produit] p
    LEFT JOIN dbo.[produit_livre] pl ON pl.[id_produit] = p.[id_produit]
    LEFT JOIN dbo.[auteur] a ON a.[id_auteur] = pl.[id_auteur]
    WHERE p.[id_produit] = @p_id_produit;
END
GO

CREATE PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
GO

CREATE PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
GO

CREATE PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
GO

CREATE   PROCEDURE dbo.[sp_update_produit]
    @p_id_produit NVARCHAR(50),
    @p_nom NVARCHAR(100),
    @p_description NVARCHAR(255),
    @p_prix DECIMAL(10,2),
    @p_stock INT,
    @p_image NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.[produit]
    SET [nom] = @p_nom,
        [description] = @p_description,
        [prix] = @p_prix,
        [stock] = @p_stock,
        [image] = @p_image
    WHERE [id_produit] = @p_id_produit;
END
GO

CREATE PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
GO

CREATE   TRIGGER dbo.[format_auteur]
ON dbo.[auteur]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE a
    SET [nom] = CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom]))
    FROM dbo.[auteur] a
    INNER JOIN inserted i ON i.[id_auteur] = a.[id_auteur]
    WHERE i.[nom] IS NOT NULL
      AND a.[nom] <> CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom]));
END
GO

CREATE   TRIGGER dbo.[format_fournisseur]
ON dbo.[fournisseur]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE f
    SET [nom] = CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom]))
    FROM dbo.[fournisseur] f
    INNER JOIN inserted i ON i.[id_fournisseur] = f.[id_fournisseur]
    WHERE i.[nom] IS NOT NULL
      AND f.[nom] <> CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom]));
END
GO

CREATE   TRIGGER dbo.[format_genre]
ON dbo.[genre]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE g
    SET [nom] = CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom]))
    FROM dbo.[genre] g
    INNER JOIN inserted i ON i.[id_genre] = g.[id_genre]
    WHERE i.[nom] IS NOT NULL
      AND g.[nom] <> CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom]));
END
GO

CREATE   TRIGGER dbo.[format_marque]
ON dbo.[marque]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE m
    SET [nom] = CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom]))
    FROM dbo.[marque] m
    INNER JOIN inserted i ON i.[id_marque] = m.[id_marque]
    WHERE i.[nom] IS NOT NULL
      AND m.[nom] <> CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom]));
END
GO

CREATE   TRIGGER dbo.[format_produit]
ON dbo.[produit]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE p
    SET [nom] = CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom])),
        [description] = CONVERT(NVARCHAR(255), dbo.[fn_capitalize_first](i.[description]))
    FROM dbo.[produit] p
    INNER JOIN inserted i ON i.[id_produit] = p.[id_produit]
    WHERE (i.[nom] IS NOT NULL AND p.[nom] <> CONVERT(NVARCHAR(100), dbo.[fn_capitalize_first](i.[nom])))
       OR (i.[description] IS NOT NULL AND p.[description] <> CONVERT(NVARCHAR(255), dbo.[fn_capitalize_first](i.[description])));
END
GO

CREATE   TRIGGER dbo.[format_utilisateur]
ON dbo.[utilisateur]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE u
    SET [nom] = CONVERT(NVARCHAR(50), dbo.[fn_capitalize_first](i.[nom])),
        [prenom] = CONVERT(NVARCHAR(50), dbo.[fn_capitalize_first](i.[prenom]))
    FROM dbo.[utilisateur] u
    INNER JOIN inserted i ON i.[id_utilisateur] = u.[id_utilisateur]
    WHERE (i.[nom] IS NOT NULL AND u.[nom] <> CONVERT(NVARCHAR(50), dbo.[fn_capitalize_first](i.[nom])))
       OR (i.[prenom] IS NOT NULL AND u.[prenom] <> CONVERT(NVARCHAR(50), dbo.[fn_capitalize_first](i.[prenom])));
END
GO

CREATE   TRIGGER dbo.[hist_commande_delete]
ON dbo.[commande]
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    INSERT INTO dbo.[historique] ([date_action], [action])
    SELECT SYSDATETIME(),
           CONCAT(N'Suppression commande ', d.[id_commande], N' pour utilisateur ', d.[id_utilisateur])
    FROM deleted d;
END
GO

CREATE   TRIGGER dbo.[hist_commande_insert]
ON dbo.[commande]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    INSERT INTO dbo.[historique] ([date_action], [action])
    SELECT SYSDATETIME(),
           CONCAT(N'CrÃ©ation commande ', i.[id_commande], N' pour utilisateur ', i.[id_utilisateur])
    FROM inserted i;
END
GO

CREATE   TRIGGER dbo.[hist_produit_delete]
ON dbo.[produit]
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    INSERT INTO dbo.[historique] ([date_action], [action])
    SELECT SYSDATETIME(),
           CONCAT(N'Suppression produit ', d.[id_produit], N' (', d.[nom], N')')
    FROM deleted d;
END
GO

CREATE   TRIGGER dbo.[hist_produit_insert]
ON dbo.[produit]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    INSERT INTO dbo.[historique] ([date_action], [action])
    SELECT SYSDATETIME(),
           CONCAT(N'CrÃ©ation produit ', i.[id_produit], N' (', i.[nom], N')')
    FROM inserted i;
END
GO

CREATE   TRIGGER dbo.[hist_produit_update]
ON dbo.[produit]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    INSERT INTO dbo.[historique] ([date_action], [action])
    SELECT SYSDATETIME(),
           CONCAT(N'Modification produit ', i.[id_produit], N' (', i.[nom], N')')
    FROM inserted i;
END
GO

CREATE   TRIGGER dbo.[hist_utilisateur_delete]
ON dbo.[utilisateur]
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    INSERT INTO dbo.[historique] ([date_action], [action])
    SELECT SYSDATETIME(),
           CONCAT(N'Suppression utilisateur ', d.[id_utilisateur],
                  N' (', d.[prenom], N' ', d.[nom], N', rÃ´le=', d.[role], N')')
    FROM deleted d;
END
GO

CREATE   TRIGGER dbo.[hist_utilisateur_insert]
ON dbo.[utilisateur]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    INSERT INTO dbo.[historique] ([date_action], [action])
    SELECT SYSDATETIME(),
           CONCAT(N'CrÃ©ation utilisateur ', i.[id_utilisateur],
                  N' (', i.[prenom], N' ', i.[nom], N', rÃ´le=', i.[role], N')')
    FROM inserted i;
END
GO

CREATE   TRIGGER dbo.[sync_commande_quantite_after_delete]
ON dbo.[appartenir]
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE c
    SET [quantite] = COALESCE(x.[total_quantite], 0)
    FROM dbo.[commande] c
    INNER JOIN (SELECT DISTINCT [id_commande] FROM deleted) d ON d.[id_commande] = c.[id_commande]
    OUTER APPLY (
        SELECT SUM(a.[quantite]) AS [total_quantite]
        FROM dbo.[appartenir] a
        WHERE a.[id_commande] = c.[id_commande]
    ) x;
END
GO

CREATE   TRIGGER dbo.[sync_commande_quantite_after_insert]
ON dbo.[appartenir]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE c
    SET [quantite] = COALESCE(x.[total_quantite], 0)
    FROM dbo.[commande] c
    INNER JOIN (SELECT DISTINCT [id_commande] FROM inserted) i ON i.[id_commande] = c.[id_commande]
    OUTER APPLY (
        SELECT SUM(a.[quantite]) AS [total_quantite]
        FROM dbo.[appartenir] a
        WHERE a.[id_commande] = c.[id_commande]
    ) x;
END
GO

CREATE   TRIGGER dbo.[sync_commande_quantite_after_update]
ON dbo.[appartenir]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    WITH touched AS (
        SELECT [id_commande] FROM inserted
        UNION
        SELECT [id_commande] FROM deleted
    )
    UPDATE c
    SET [quantite] = COALESCE(x.[total_quantite], 0)
    FROM dbo.[commande] c
    INNER JOIN touched t ON t.[id_commande] = c.[id_commande]
    OUTER APPLY (
        SELECT SUM(a.[quantite]) AS [total_quantite]
        FROM dbo.[appartenir] a
        WHERE a.[id_commande] = c.[id_commande]
    ) x;
END
GO

