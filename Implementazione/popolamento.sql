TRUNCATE TABLE FOTOGRAFIA_ANALOGICA, COLLEZIONE, MANIFESTO, 
               PELLICOLA, MATERIALE_FISICO, MATERIALE_DIGITALE, 
               BIGLIETTO, INVITO, PROGRAMMAZIONE_FILM, 
               PROIEZIONE, MOSTRA, RASSEGNA, INCONTRO_CAST,
               RECITAZIONE, REGIA, PRESTITO_CULTURALE, RICHIESTA_PRESTITO,
               VERIFICA, RESTAURO, BENE_CULTURALE, FILM, 
               ATTORE, REGISTA, EVENTO, SALA, SEDE,
               TECNICO, TEAM, ENTE, UTENTE_PUBBLICO,
               ARCHIVISTA, RESTAURATORE, RESPONSABILE_EVENTI,
               SEZIONE, MAGAZZINO, ARCHIVIO
RESTART IDENTITY CASCADE;

-- ============================================
-- STAFF
-- ============================================

INSERT INTO ARCHIVISTA (Nome, Cognome, Email) VALUES
('Mario', 'Rossi', 'mario.rossi@cineteca.it'),
('Laura', 'Bianchi', 'laura.bianchi@cineteca.it'),
('Giuseppe', 'Verdi', 'giuseppe.verdi@cineteca.it');

INSERT INTO RESTAURATORE (Nome, Cognome, Email) VALUES
('Anna', 'Ferrari', 'anna.ferrari@cineteca.it'),
('Marco', 'Colombo', 'marco.colombo@cineteca.it'),
('Giulia', 'Romano', 'giulia.romano@cineteca.it');

INSERT INTO RESPONSABILE_EVENTI (Nome, Cognome, Email) VALUES
('Paolo', 'Esposito', 'paolo.esposito@cineteca.it'),
('Francesca', 'Marino', 'francesca.marino@cineteca.it');

INSERT INTO TEAM (Nome) VALUES
('Team Restauro A'),
('Team Restauro B'),
('Team Proiezioni');


INSERT INTO TECNICO (Nome, Cognome, Email, Team) VALUES
('Luca', 'Ricci', 'luca.ricci@cineteca.it', 1),
('Sara', 'Gallo', 'sara.gallo@cineteca.it', 1),
('Andrea', 'Costa', 'andrea.costa@cineteca.it', 2),
('Elena', 'Greco', 'elena.greco@cineteca.it', 3),
('Matteo', 'Bruno', 'matteo.bruno@cineteca.it', 3);

-- ============================================
-- SEDI E SALE
-- ============================================

INSERT INTO SEDE (NomeSede, Via, NrCivico, Cap, Provincia, Citta) VALUES
('Casa del Cinema', 'Largo Marcello Mastroianni', '1', '00197', 'Roma', 'Roma'),
('Palazzo delle Esposizioni', 'Via Nazionale', '194', '00184', 'Roma', 'Roma');

INSERT INTO SALA (NumeroSala, IdSede, NomeSede, NrPostiFila, NrFile) VALUES
(1, 1, 'Casa del Cinema', 20, 10),
(2, 1, 'Casa del Cinema', 15, 8),
(3, 1, 'Casa del Cinema', 15, 10),
(4, 1, 'Casa del Cinema', 20, 10),
(5, 1, 'Casa del Cinema', 30, 5),
(6, 1, 'Casa del Cinema', 10, 5);

-- ============================================
-- MAGAZZINO E ARCHIVI
-- ============================================

INSERT INTO MAGAZZINO (Nome, Tipologia) VALUES
('Magazzino Cineteca', 'magazzino materiali fisici');


INSERT INTO SEZIONE (Magazzino, TipoMateriale, TemperaturaMedia, UmiditaMedia ) VALUES
(1, 'pellicola', 3, 33),
(1, 'manifesto', 15, 50),
(1, 'collezioneFotografica', 13, 42);

INSERT INTO ARCHIVIO (Localizzazione, LivelloAccesso, Backup, Tipo) VALUES
('Server Primario - Roma', 'Pubblico', 'Giornaliero', 'SSD RAID'),
('Cloud Storage AWS', 'Ristretto', 'Continuo', 'Cloud');

-- ============================================
-- REGISTI E ATTORI
-- ============================================

INSERT INTO REGISTA (CodiceFiscale, Nome, Cognome, Nazionalita, DataDiNascita) VALUES
('FLLFDR20D03L219W', 'Federico', 'Fellini', 'Italiana', '1920-01-20'),
('VSCNLC06L14E205L', 'Luchino', 'Visconti', 'Italiana', '1906-11-02'),
('RSSRRT18B26H501Y', 'Roberto', 'Rossellini', 'Italiana', '1906-05-08'),
('ANTNMC12A19A783Z', 'Michelangelo', 'Antonioni', 'Italiana', '1912-09-29'),
('PLNPPR22C15E715K', 'Pier Paolo', 'Pasolini', 'Italiana', '1922-03-05'),
('TRNTRR31E01L219X', 'Giuseppe', 'Tornatore', 'Italiana', '1956-05-27'),
('SRRLLN48R10L736M', 'Paolo', 'Sorrentino', 'Italiana', '1970-05-31');

INSERT INTO ATTORE (CodiceFiscale, Nome, Cognome, DataDiNascita) VALUES
('MSTMRC24D28H294P', 'Marcello', 'Mastroianni', '1924-09-28'),
('LRNSPH34L20G273N', 'Sophia', 'Loren', '1934-09-20'),
('EKBANN21A30Z133Y', 'Anita', 'Ekberg', '1931-09-29'),
('CRDFRC50A05H501K', 'Claudia', 'Cardinale', '1938-04-15'),
('MRNTTT40C15L219R', 'Toto', 'Meroni', '1898-02-15'),
('VTTMRC25H07F205S', 'Vittorio', 'Gassman', '1922-09-01'),
('MNNGNN32B15H501L', 'Anna', 'Magnani', '1908-03-07'),
('SRVSRN74M15L736K', 'Servillo', 'Toni', '1959-01-25');

-- ============================================
-- FILM 
-- ============================================

INSERT INTO FILM (Titolo, AnnoProduzione, Durata, Categoria, Paese, Genere, LinguaOriginale) VALUES
('La dolce vita', 1960, 174, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('8½', 1963, 138, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Roma città aperta', 1945, 103, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Ladri di biciclette', 1948, 89, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Il gattopardo', 1963, 186, 'lungometraggio', 'Italia', 'Storico', 'Italiano'),
('Novecento', 1976, 317, 'lungometraggio', 'Italia', 'Storico', 'Italiano'),
('Cinema Paradiso', 1988, 155, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('La grande bellezza', 2013, 142, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Il postino', 1994, 108, 'lungometraggio', 'Italia', 'Romantico', 'Italiano'),
('La vita è bella', 1997, 116, 'lungometraggio', 'Italia', 'Commedia', 'Italiano'),
('L''avventura', 1960, 143, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Accattone', 1961, 117, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Amarcord', 1973, 123, 'lungometraggio', 'Italia', 'Commedia', 'Italiano'),
('Il conformista', 1970, 113, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Rocco e i suoi fratelli', 1960, 177, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Umberto D.', 1952, 89, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Bellissima', 1951, 108, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano'),
('Il sorpasso', 1962, 105, 'lungometraggio', 'Italia', 'Commedia', 'Italiano'),
('Divorzio all''italiana', 1961, 105, 'lungometraggio', 'Italia', 'Commedia', 'Italiano'),
('La strada', 1954, 108, 'lungometraggio', 'Italia', 'Drammatico', 'Italiano');

-- ============================================
-- REGIA
-- ============================================

INSERT INTO REGIA (Film, Regista) VALUES
(1, 1),  -- La dolce vita - Fellini
(2, 1),  -- 8½ - Fellini
(3, 3),  -- Roma città aperta - Rossellini
(5, 2),  -- Il gattopardo - Visconti
(7, 6),  -- Cinema Paradiso - Tornatore
(8, 7),  -- La grande bellezza - Sorrentino
(11, 4), -- L'avventura - Antonioni
(12, 5), -- Accattone - Pasolini
(13, 1), -- Amarcord - Fellini
(15, 2), -- Rocco e i suoi fratelli - Visconti
(20, 1); -- La strada - Fellini

-- ============================================
-- RECITAZIONE
-- ============================================

INSERT INTO RECITAZIONE (Film, Attore) VALUES
(1, 1),  -- La dolce vita - Mastroianni
(1, 3),  -- La dolce vita - Ekberg
(2, 1),  -- 8½ - Mastroianni
(3, 7),  -- Roma città aperta - Magnani
(5, 4),  -- Il gattopardo - Cardinale
(8, 8),  -- La grande bellezza - Servillo
(11, 1), -- L'avventura - Mastroianni
(13, 1), -- Amarcord - Mastroianni
(15, 1), -- Rocco - Mastroianni
(15, 7); -- Rocco - Magnani

-- ============================================
-- BENI CULTURALI
-- ============================================

INSERT INTO BENE_CULTURALE (Film, DisponibilitaPrestito) VALUES
(1, TRUE),  -- La dolce vita
(1, TRUE),  -- La dolce vita (copia digitale)
(2, TRUE),  -- 8½
(3, FALSE), -- Roma città aperta (in restauro)
(5, TRUE),  -- Il gattopardo
(7, TRUE),  -- Cinema Paradiso
(8, TRUE),  -- La grande bellezza
(11, TRUE), -- L'avventura
(13, TRUE), -- Amarcord
(15, FALSE),-- Rocco (prestato)
(20, TRUE); -- La strada -> tutte pellicole


-- ============================================
-- MATERIALI FISICI 
-- ============================================

INSERT INTO MATERIALE_FISICO (IdBene, StatoConservazione, Collocazione) VALUES
(1, 'buono', 1),        -- La dolce vita - pellicola
(3, 'eccellente', 1),   -- 8½ - pellicola
(4, 'critico', 1),      -- Roma città aperta - pellicola (in restauro)
(5, 'soddisfacente', 1),-- Il gattopardo - pellicola
(7, 'eccellente', 1),   -- La grande bellezza - pellicola
(9, 'buono', 1),        -- Amarcord - pellicola
(10, 'critico', 1),     -- Rocco - pellicola (prestato)
(11, 'eccellente', 1);  -- La strada - pellicola

INSERT INTO PELLICOLA (IdBene, Millimetri) VALUES
(1, '35mm'),
(3, '35mm'),
(4, '35mm'),
(5, '70mm'), 
(7, '35mm'),
(9, '35mm'),
(10, '35mm');

INSERT INTO MANIFESTO(IdBene, Paese, Lingua, Formato, Autore, Provenienza, DataAcquisizione, Anno) VALUES
(4, 'Italia', 'Italiano', '50x70', 'Pippo pluto', 'cinema locale', '1999-10-02', 1950),
(10, 'Svezia', 'Inglese', '70x100', 'Pippo pluto', 'cinema locale', '1999-10-02', 2000),
(11, 'Italia', 'Italiano', '50x70', 'Pippo pluto', 'cinema locale', '1999-10-02', 1950);


-- ============================================
-- 10. MATERIALI DIGITALI
-- ============================================

INSERT INTO MATERIALE_DIGITALE (IdBene, Nome, TipoMateriale, Estensione, Risoluzione, 
                                PathFile, Dimensione, DataDigitalizzazione, Archivio) VALUES
(2, 'la_dolce_vita_4k', 'filmDigitale', 'mp4', '4K', 
 '/films/fellini/la_dolce_vita_4k.mp4', '85GB', '2020-03-15', 1),
(6, 'cinema_paradiso_hd', 'filmDigitale', 'mkv', '1080p',
 '/films/tornatore/cinema_paradiso.mkv', '12GB', '2018-06-20', 1),
(8, 'la_grande_bellezza_4k', 'filmDigitale', 'mp4', '4K',
 '/films/sorrentino/la_grande_bellezza.mp4', '65GB', '2019-11-10', 1);

-- ============================================
-- 11. VERIFICHE E RESTAURI
-- ============================================

-- Verifiche periodiche
INSERT INTO VERIFICA (IdMateriale, DataVerifica, LivelloRiscontrato, 
                     DichiarazioneDati, InterventoConsigliato, ArchivistaResponsabile) VALUES
(4, '2026-01-15', 'critico', 'Pellicola presenta deterioramento', 
 'Restauro urgente necessario', 1),
(10, '2026-02-20', 'critico', 'Graffi profondi su diverse sezioni',
 'Restauro digitale e pulizia', 2),
(1, '2026-03-10', 'buono', 'Condizioni stabili', 'Monitoraggio', 1),
(5, '2026-03-15', 'soddisfacente', 'Lieve ossidazione', 'Pulizia preventiva', 2);

-- Restauri attivi
INSERT INTO RESTAURO (Materiale, TipoIntervento, DataFine, Restauratore, Esito, TeamSupporto, Verifica) VALUES
(4, 'Restauro digitale completo', '2026-01-30', 1, NULL, 1, 1),
(10, 'Pulizia e digitalizzazione', '2026-02-15', 2, NULL, 2, 2);

-- ============================================
-- 12. UTENTI PUBBLICI ED ENTI
-- ============================================

INSERT INTO UTENTE_PUBBLICO (Nome, Cognome, CodiceFiscale, Email) VALUES
('Giovanni', 'Neri', 'NREGNN75M15H501A', 'g.neri@email.it'),
('Maria', 'Gialli', 'GLLMRA80A45F205B', 'm.gialli@email.it'),
('Luca', 'Verdi', 'VRDLCU85C10L219C', 'l.verdi@email.it');

-- Ente fittizio
INSERT INTO ENTE (CredenzialiUtente, Email, Denominazione, Telefono, Via, NrCivico, Cap, Provincia, Citta,
                 Piva, Tipologia, CodiceFiscaleRappresentante, NomeRappresentante, CognomeRappresentante, TelefonoRappresentante) VALUES
(1, 'info@festivalroma.it', 'Festa del Cinema di Roma', '06123456', 'Via del Corso', '300', '00186', 
 'Roma', 'Roma', '12345678901', 'Festival', 'RSSMRA70A01H501Z', 'Mario', 'Rossi', '3331234567'),
(2, 'direzione@cinetecabologna.it', 'Cineteca di Bologna', '051987654', 'Via Riva Reno', '72', '40122',
 'Bologna', 'Bologna', '98765432109', 'Cineteca', 'BNCLRA75B15A944W', 'Laura', 'Bianchi', '3339876543');

-- ============================================
-- 13. RICHIESTE E PRESTITI
-- ============================================

-- Richieste accettate
INSERT INTO RICHIESTA_PRESTITO (BeneCulturale, Richiedente, ArchivistaResponsabile, DataInvio, 
                               Documentazione, StatoRichiesta, FormatoRichiesto, 
                               DataPrevistaProiezione, Luogo) VALUES
(10, 1, 1, '2026-01-10', 'Lettera ufficiale Festival', 'accettata', 'pellicola',
 '2026-03-20', 'Auditorium Parco della Musica'),
(6, 2, 2, '2026-02-05', 'Richiesta istituzionale', 'accettata', 'filmDigitale',
 '2026-04-15', 'Cineteca Bologna');

-- Richieste in attesa
INSERT INTO RICHIESTA_PRESTITO (BeneCulturale, Richiedente, DataInvio, 
                               Documentazione, StatoRichiesta, FormatoRichiesto,
                               DataPrevistaProiezione, Luogo) VALUES
(1, 3, '2026-03-01', 'Evento culturale universitario', 'inElaborazione', 'filmDigitale',
 '2026-05-10', 'Università La Sapienza');

-- Richiesta rifiutata
INSERT INTO RICHIESTA_PRESTITO (BeneCulturale, Richiedente, ArchivistaResponsabile, DataInvio,
                               Documentazione, StatoRichiesta, MotivazioneRifiuto, FormatoRichiesto,
                               DataPrevistaProiezione, Luogo) VALUES
(4, 3, 1, '2026-02-20', 'Richiesta standard', 'rifiutata', 
 'Materiale in stato critico, attualmente in restauro', 'pellicola',
 '2026-04-01', 'Festival Cinema Venezia');

-- Prestiti attivi
INSERT INTO PRESTITO_CULTURALE (Richiesta, Quota, DataInizio, DataFine, StatoPrestito) VALUES
(1, 500.00, '2026-03-15', '2026-03-25', 'attivo'),
(2, 200.00, '2026-04-10', '2026-04-20', 'attivo');

-- ============================================
-- 14. EVENTI
-- ============================================

INSERT INTO EVENTO (Titolo, DataInizio, DataFine, OrarioInizio, OrarioFine, Accesso, Sede) VALUES
('Retrospettiva Fellini', '2026-04-01', '2026-04-30', '15:00', '22:00', 'pubblico', 1),
('Mostra: 100 anni di Cinema Italiano', '2026-12-01', '2026-12-30', '10:00', '20:00', 'pubblico', 2),
('Serata speciale: La dolce vita', '2026-04-15', '2026-04-15', '15:30', '23:00', 'riservato', 1),
('Rassegna Neorealismo', '2026-06-01', '2026-06-15', '17:00', '21:00', 'pubblico', 2),
('Incontro con Sorrentino', '2026-05-20', '2026-05-20', '18:00', '20:00', 'pubblico', 2),
('Proiezione2', '2026-05-21', '2026-05-21', '15:00', '23:00', 'pubblico', 1),
('Proiezione3', '2026-05-28', '2026-05-28', '15:30', '23:00', 'riservato', 1);

-- Proiezioni
INSERT INTO PROIEZIONE (IdEvento, Nome, Descrizione, TecnicoAssistente, BeneCulturale, NumeroSala, IdSede) VALUES
(3, 'La dolce vita - Proiezione speciale', 
 'Proiezione della copia restaurata in 4K', 4, 2, 1, 1),
(6, 'Proiezione1', 
 'Proiezione.....', 4, 2, 2, 1),
(7, 'Proiezione2', 
 'Proiezione .....', 4, 2, 3, 1);

-- Mostre
INSERT INTO MOSTRA (IdEvento, Nome, Descrizione) VALUES
(2, 'Cent anni di cinema', 'Esposizione di manifesti storici e fotografie');

-- Rassegne
INSERT INTO RASSEGNA (IdEvento, Nome, Descrizione) VALUES
(4, 'Il Neorealismo italiano', 'Ciclo dedicato ai capolavori del dopoguerra');

-- Incontri
INSERT INTO INCONTRO_CAST (IdEvento, Nome, Descrizione) VALUES
(5, 'Paolo Sorrentino racconta', 'Incontro con il regista premio Oscar');

-- Programmazione film per eventi
INSERT INTO PROGRAMMAZIONE_FILM (Evento, Film) VALUES
(1, 1),  -- Retrospettiva Fellini - La dolce vita
(1, 2),  -- Retrospettiva Fellini - 8½
(1, 13), -- Retrospettiva Fellini - Amarcord
(4, 3),  -- Rassegna Neorealismo - Roma città aperta
(4, 4);  -- Rassegna Neorealismo - Ladri di biciclette

-- Inviti per incontro
INSERT INTO INVITO (Incontro, Regista, Attore) VALUES
(5, 7, NULL),  -- Sorrentino invitato
(5, NULL, 8);  -- Servillo invitato

-- ============================================
-- 15. BIGLIETTI
-- ============================================

-- Biglietti venduti per la proiezione
INSERT INTO BIGLIETTO (Proiezione, Cliente, DataAcquisto, NumeroPosto, Fila, Prezzo) VALUES
(3, 1, '2026-02-01', 1, 5, 12.00),
(3, 1, '2026-02-01', 2, 5, 12.00),
(3, 2, '2026-02-05', 10, 3, 12.00),
(3, 3, '2026-02-10', 15, 7, 12.00),
(3, 3, '2026-02-10', 16, 7, 12.00);
INSERT INTO BIGLIETTO (Proiezione, Cliente, DataAcquisto, NumeroPosto, Fila, Prezzo) VALUES
(7, 1, '2026-02-28', 1, 1, 12.00),
(7, 1, '2026-02-28', 2, 1, 12.00),
(7, 1, '2026-02-28', 3, 1, 12.00),
(7, 1, '2026-02-28', 4, 1, 12.00),
(7, 1, '2026-02-28', 5, 1, 12.00),
(7, 1, '2026-02-28', 6, 1, 12.00),
(7, 1, '2026-02-28', 7, 1, 12.00),
(7, 1, '2026-02-28', 8, 1, 12.00),
(7, 1, '2026-02-28', 9, 1, 12.00),
(7, 1, '2026-02-28', 10, 1, 12.00),
(7, 1, '2026-02-28', 11, 1, 12.00),
(7, 1, '2026-02-28', 12, 1, 12.00),
(7, 1, '2026-02-28', 13, 1, 12.00),
(7, 1, '2026-02-28', 14, 1, 12.00),
(7, 1, '2026-02-28', 15, 1, 12.00),
(7, 1, '2026-02-28', 1, 2, 12.00),
(7, 1, '2026-02-28', 2, 2, 12.00),
(7, 1, '2026-02-28', 3, 2, 12.00),
(7, 1, '2026-02-28', 4, 2, 12.00),
(7, 1, '2026-02-28', 5, 2, 12.00),
(7, 1, '2026-02-28', 6, 2, 12.00),
(7, 1, '2026-02-28', 7, 2, 12.00),
(7, 1, '2026-02-28', 8, 2, 12.00),
(7, 1, '2026-02-28', 9, 2, 12.00),
(7, 1, '2026-02-28', 10, 2, 12.00),
(7, 1, '2026-02-28', 11, 2, 12.00),
(7, 1, '2026-02-28', 12, 2, 12.00),
(7, 1, '2026-02-28', 13, 2, 12.00),
(7, 1, '2026-02-28', 14, 2, 12.00),
(7, 1, '2026-02-28', 15, 2, 12.00),
(7, 1, '2026-02-28', 1, 3, 12.00),
(7, 1, '2026-02-28', 2, 3, 12.00),
(7, 1, '2026-02-28', 3, 3, 12.00),
(7, 1, '2026-02-28', 4, 3, 12.00),
(7, 1, '2026-02-28', 5, 3, 12.00),
(7, 1, '2026-02-28', 6, 3, 12.00),
(7, 1, '2026-02-28', 7, 3, 12.00),
(7, 1, '2026-02-28', 8, 3, 12.00),
(7, 1, '2026-02-28', 9, 3, 12.00),
(7, 1, '2026-02-28', 10, 3, 12.00),
(7, 1, '2026-02-28', 11, 3, 12.00),
(7, 1, '2026-02-28', 12, 3, 12.00),
(7, 1, '2026-02-28', 13, 3, 12.00),
(7, 1, '2026-02-28', 14, 3, 12.00),
(7, 1, '2026-02-28', 15, 3, 12.00),
(7, 1, '2026-02-28', 1, 4, 12.00),
(7, 1, '2026-02-28', 2, 4, 12.00),
(7, 1, '2026-02-28', 3, 4, 12.00),
(7, 1, '2026-02-28', 4, 4, 12.00),
(7, 1, '2026-02-28', 5, 4, 12.00),
(7, 1, '2026-02-28', 6, 4, 12.00),
(7, 1, '2026-02-28', 7, 4, 12.00),
(7, 1, '2026-02-28', 8, 4, 12.00),
(7, 1, '2026-02-28', 9, 4, 12.00),
(7, 1, '2026-02-28', 10, 4, 12.00),
(7, 1, '2026-02-28', 11, 4, 12.00),
(7, 1, '2026-02-28', 12, 4, 12.00),
(7, 1, '2026-02-28', 13, 4, 12.00),
(7, 1, '2026-02-28', 14, 4, 12.00),
(7, 1, '2026-02-28', 15, 4, 12.00),
(7, 1, '2026-02-28', 1, 5, 12.00),
(7, 1, '2026-02-28', 2, 5, 12.00),
(7, 1, '2026-02-28', 3, 5, 12.00),
(7, 1, '2026-02-28', 4, 5, 12.00),
(7, 1, '2026-02-28', 5, 5, 12.00),
(7, 1, '2026-02-28', 6, 5, 12.00),
(7, 1, '2026-02-28', 7, 5, 12.00),
(7, 1, '2026-02-28', 8, 5, 12.00),
(7, 1, '2026-02-28', 9, 5, 12.00),
(7, 1, '2026-02-28', 10, 5, 12.00),
(7, 1, '2026-02-28', 11, 5, 12.00),
(7, 1, '2026-02-28', 12, 5, 12.00),
(7, 1, '2026-02-28', 13, 5, 12.00),
(7, 1, '2026-02-28', 14, 5, 12.00),
(7, 1, '2026-02-28', 15, 5, 12.00),
(7, 1, '2026-02-28', 1, 6, 12.00),
(7, 1, '2026-02-28', 2, 6, 12.00),
(7, 1, '2026-02-28', 3, 6, 12.00),
(7, 1, '2026-02-28', 4, 6, 12.00),
(7, 1, '2026-02-28', 5, 6, 12.00),
(7, 1, '2026-02-28', 6, 6, 12.00),
(7, 1, '2026-02-28', 7, 6, 12.00),
(7, 1, '2026-02-28', 8, 6, 12.00),
(7, 1, '2026-02-28', 9, 6, 12.00),
(7, 1, '2026-02-28', 10, 6, 12.00),
(7, 1, '2026-02-28', 11, 6, 12.00),
(7, 1, '2026-02-28', 12, 6, 12.00),
(7, 1, '2026-02-28', 13, 6, 12.00),
(7, 1, '2026-02-28', 14, 6, 12.00),
(7, 1, '2026-02-28', 15, 6, 12.00),
(7, 1, '2026-02-28', 1, 7, 12.00),
(7, 1, '2026-02-28', 2, 7, 12.00),
(7, 1, '2026-02-28', 3, 7, 12.00),
(7, 1, '2026-02-28', 4, 7, 12.00),
(7, 1, '2026-02-28', 5, 7, 12.00),
(7, 1, '2026-02-28', 6, 7, 12.00),
(7, 1, '2026-02-28', 7, 7, 12.00),
(7, 1, '2026-02-28', 8, 7, 12.00),
(7, 1, '2026-02-28', 9, 7, 12.00),
(7, 1, '2026-02-28', 10, 7, 12.00),
(7, 1, '2026-02-28', 11, 7, 12.00),
(7, 1, '2026-02-28', 12, 7, 12.00),
(7, 1, '2026-02-28', 13, 7, 12.00),
(7, 1, '2026-02-28', 14, 7, 12.00),
(7, 1, '2026-02-28', 15, 7, 12.00),
(7, 1, '2026-02-28', 1, 8, 12.00),
(7, 1, '2026-02-28', 2, 8, 12.00),
(7, 1, '2026-02-28', 3, 8, 12.00),
(7, 1, '2026-02-28', 4, 8, 12.00),
(7, 1, '2026-02-28', 5, 8, 12.00),
(7, 1, '2026-02-28', 6, 8, 12.00),
(7, 1, '2026-02-28', 7, 8, 12.00),
(7, 1, '2026-02-28', 8, 8, 12.00),
(7, 1, '2026-02-28', 9, 8, 12.00),
(7, 1, '2026-02-28', 10, 8, 12.00),
(7, 1, '2026-02-28', 11, 8, 12.00),
(7, 1, '2026-02-28', 12, 8, 12.00),
(7, 1, '2026-02-28', 13, 8, 12.00),
(7, 1, '2026-02-28', 14, 8, 12.00),
(7, 1, '2026-02-28', 15, 8, 12.00),
(7, 1, '2026-02-28', 1, 9, 12.00),
(7, 1, '2026-02-28', 2, 9, 12.00),
(7, 1, '2026-02-28', 3, 9, 12.00),
(7, 1, '2026-02-28', 4, 9, 12.00),
(7, 1, '2026-02-28', 5, 9, 12.00),
(7, 1, '2026-02-28', 6, 9, 12.00),
(7, 1, '2026-02-28', 7, 9, 12.00),
(7, 1, '2026-02-28', 8, 9, 12.00),
(7, 1, '2026-02-28', 9, 9, 12.00),
(7, 1, '2026-02-28', 10, 9, 12.00),
(7, 1, '2026-02-28', 11, 9, 12.00),
(7, 1, '2026-02-28', 12, 9, 12.00),
(7, 1, '2026-02-28', 13, 9, 12.00),
(7, 1, '2026-02-28', 14, 9, 12.00),
(7, 1, '2026-02-28', 15, 9, 12.00),
(7, 1, '2026-02-28', 1, 10, 12.00),
(7, 1, '2026-02-28', 2, 10, 12.00),
(7, 1, '2026-02-28', 3, 10, 12.00),
(7, 1, '2026-02-28', 4, 10, 12.00),
(7, 1, '2026-02-28', 5, 10, 12.00),
(7, 1, '2026-02-28', 6, 10, 12.00),
(7, 1, '2026-02-28', 7, 10, 12.00),
(7, 1, '2026-02-28', 8, 10, 12.00),
(7, 1, '2026-02-28', 9, 10, 12.00),
(7, 1, '2026-02-28', 10, 10, 12.00),
(7, 1, '2026-02-28', 11, 10, 12.00),
(7, 1, '2026-02-28', 12, 10, 12.00); 


