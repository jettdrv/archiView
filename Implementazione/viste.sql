DROP VIEW IF EXISTS VISTA_DETTAGLI_PROIEZIONE;
DROP VIEW IF EXISTS VISTA_CATALOGO;
DROP VIEW IF EXISTS VISTA_PELLICOLE;
DROP VIEW IF EXISTS VISTA_MANIFESTI;
DROP VIEW IF EXISTS VISTA_COLLEZIONI;
DROP VIEW IF EXISTS VISTA_MOSTRA_POSTI_DISPONIBILI;

DROP VIEW IF EXISTS VISTA_STORICO_RESTAURI;
DROP VIEW IF EXISTS VISTA_PRESTITI_ATTIVI;
DROP VIEW IF EXISTS VISTA_RICHIESTE_IN_ATTESA;
DROP VIEW IF EXISTS VISTA_STATO_BENI;
DROP VIEW IF EXISTS VISTA_EVENTI_IN_PROGRAMMA;
DROP VIEW IF EXISTS VISTA_RICHIESTE_IN_ATTESA;




-- Le view con le operazioni più frequenti
-- 1) Visualizzazione della programmazione delle proiezioni
CREATE VIEW VISTA_DETTAGLI_PROIEZIONE AS
SELECT 
	P.IdEvento,
	P.nome AS TitoloEvento,
	F.Titolo AS TitoloFilm,
	P.Descrizione, 	
	P.DisponibilitaBiglietti, 	
	P.NumeroSala, 
	S.NomeSede, 
	E.DataInizio AS DataProiezione,
	E.OrarioInizio AS Orario
FROM PROIEZIONE P
JOIN EVENTO E ON E.IdEvento=P.IdEvento
JOIN SEDE S ON S.IdSede = P.IdSede
JOIN BENE_CULTURALE BC ON P.BeneCulturale = BC.IdBeneCulturale
JOIN FILM F ON BC.Film = F.IdFilm
WHERE (E.DataInizio > CURRENT_DATE OR (E.DataInizio = CURRENT_DATE AND E.OrarioInizio >= CURRENT_TIME))
ORDER BY E.DataInizio, E.OrarioInizio;

-- 2) Visualizzazione del catalogo dei film 
CREATE VIEW VISTA_CATALOGO AS
SELECT
	BC.IdBeneCulturale,
	F.Titolo AS TitoloFilm,
    F.AnnoProduzione,
    F.Durata,
    F.Categoria,
    F.Paese,
    F.Genere,
    F.LinguaOriginale,
	CASE 
        WHEN P.IdBene IS NOT NULL THEN 'Pellicola'
        WHEN MD.IdBene IS NOT NULL THEN 'Digitale'
        WHEN M.IdBene IS NOT NULL THEN 'Manifesto'
        WHEN C.IdBene IS NOT NULL THEN 'Collezione'
        ELSE 'Altro'
    END AS TipoMateriale,
    BC.DisponibilitaPrestito
FROM FILM F
JOIN BENE_CULTURALE BC ON F.IdFilm=BC.Film
LEFT JOIN PELLICOLA P ON BC.IdBeneCulturale = P.IdBene
LEFT JOIN MATERIALE_DIGITALE MD ON BC.IdBeneCulturale = MD.IdBene
LEFT JOIN MANIFESTO M ON BC.IdBeneCulturale = M.IdBene
LEFT JOIN COLLEZIONE C ON BC.IdBeneCulturale = C.IdBene
ORDER BY BC.IdBeneCulturale;

-- 3) Visualizzazione del catalogo dei film e delle pellicole
CREATE VIEW VISTA_PELLICOLE AS
SELECT
	P.IdBene,
    F.Titolo AS TitoloFilm,
    F.AnnoProduzione,
    F.Durata,
    F.Categoria,
    F.Paese,
    F.Genere,
    F.LinguaOriginale,
    BC.DisponibilitaPrestito,
	P.Millimetri AS tipoPellicola
FROM FILM F
JOIN BENE_CULTURALE BC ON F.IdFilm=BC.Film
JOIN PELLICOLA P ON BC.IdBeneCulturale=P.IdBene;

-- 4) Visualizzazione del catalogo dei manifesti
CREATE VIEW VISTA_MANIFESTI AS
SELECT
	M.IdBene,
    F.Titolo AS TitoloFilm,
    F.AnnoProduzione,
	M.Lingua,
	M.Formato,
	M.Autore,
	M.Provenienza,
	M.Anno,
	BC.DisponibilitaPrestito
FROM FILM F
JOIN BENE_CULTURALE BC ON F.IdFilm=BC.Film
JOIN MANIFESTO M ON BC.IdBeneCulturale=M.IdBene;

-- 5) Visualizzazione delle collezioni di fotografie analogiche
CREATE VIEW VISTA_COLLEZIONI AS
SELECT
	C.IdBene,
    F.Titolo AS TitoloFilm,
    F.AnnoProduzione,
	C.Titolo AS TitoloCollezione,
	C.Tipologia,
	C.Descrizione,
	C.Autore,
	C.Provenienza,
	C.Anno,
	BC.DisponibilitaPrestito
FROM FILM F
JOIN BENE_CULTURALE BC ON F.IdFilm=BC.Film
JOIN COLLEZIONE C ON BC.IdBeneCulturale=C.IdBene;


--5) Una vista per mostrare i posti ancora disponibili
CREATE VIEW VISTA_MOSTRA_POSTI_DISPONIBILI AS
SELECT 
    PR.IdEvento,
    PR.Nome AS NomeProiezione,
    f AS Fila,
    p AS NumeroPosto
FROM PROIEZIONE PR
JOIN SALA S ON (PR.NumeroSala = S.NumeroSala AND PR.IdSede = S.IdSede)
CROSS JOIN LATERAL generate_series(1, S.NrFile) f
CROSS JOIN LATERAL generate_series(1, S.NrPostiFila) p
LEFT JOIN BIGLIETTO B ON (
    B.Proiezione = PR.IdEvento AND 
    B.Fila = f AND 
    B.NumeroPosto = p
)
WHERE B.IdBiglietto IS NULL;

--6) vista per i materiali fisici e il loro stato di conservazione
CREATE VIEW VISTA_STATO_BENI AS 
SELECT 
	F.Titolo AS Film,
	M.IdBene,
	M.StatoConservazione
FROM MATERIALE_FISICO M
JOIN BENE_CULTURALE BC ON BC.IdBeneCulturale = M.IdBene
JOIN FILM F ON F.IdFilm = BC.Film;

--7) Eventi in programma
CREATE VIEW VISTA_EVENTI_IN_PROGRAMMA AS
SELECT 
	E.Titolo,
	E.DataInizio,
	E.DataFine,
	E.OrarioInizio,
	E.OrarioFine,
	S.NomeSede,
	E.Accesso
FROM EVENTO E
JOIN SEDE S ON S.IdSede=E.Sede
WHERE E.DataInizio>=CURRENT_DATE
ORDER BY E.DataInizio;

--8) tutti i restauri effettuati
CREATE VIEW VISTA_STORICO_RESTAURI AS
SELECT 
    F.Titolo AS Film,
    R.TipoIntervento,
    R.DataFine,
    RES.Nome AS NomeRestauratore,
    RES.Cognome AS CognomeRestauratore,
    R.Esito AS NuovoStatoConservazione
FROM RESTAURO R
JOIN MATERIALE_FISICO MF ON R.Materiale = MF.IdBene
JOIN BENE_CULTURALE BC ON MF.IdBene = BC.IdBeneCulturale
JOIN FILM F ON BC.Film = F.IdFilm
JOIN RESTAURATORE RES ON R.Restauratore = RES.Matricola;

--9) beni culturali che sono stati prestati
CREATE VIEW VISTA_PRESTITI_ATTIVI AS
SELECT 
    F.Titolo AS Film,
    U.Nome AS NomeRichiedente,
    U.Cognome AS CognomeRichiedente,
    E.Denominazione AS Ente,
    PC.DataInizio,
    PC.DataFine,
    CASE 
        WHEN PC.DataFine < CURRENT_DATE THEN 'SCADUTO'
        WHEN PC.DataFine - CURRENT_DATE <= 7 THEN 'IN SCADENZA'
        ELSE 'ATTIVO'
    END AS Stato
FROM PRESTITO_CULTURALE PC
JOIN RICHIESTA_PRESTITO RP ON PC.Richiesta = RP.IdRichiesta
JOIN BENE_CULTURALE BC ON RP.BeneCulturale = BC.IdBeneCulturale
JOIN FILM F ON BC.Film = F.IdFilm
JOIN UTENTE_PUBBLICO U ON RP.Richiedente = U.IdUtente
LEFT JOIN ENTE E ON E.CredenzialiUtente = U.IdUtente
WHERE PC.StatoPrestito IN ('attivo', 'scaduto');

--10) facilita il processo di valutazione dei prestiti per l'archivista. da questa vista può ricavare facilmente l'identificatore delle richieste 
-- ancora in elaborazione
CREATE VIEW VISTA_RICHIESTE_IN_ATTESA AS
SELECT 
    RP.IdRichiesta,
    F.Titolo AS Film,
    U.Nome  AS NomeRichiedente,
	U.Cognome AS CognomeRichiedente,
    RP.DataInvio,
    RP.FormatoRichiesto,
    RP.DataPrevistaProiezione
FROM RICHIESTA_PRESTITO RP
JOIN BENE_CULTURALE BC ON RP.BeneCulturale = BC.IdBeneCulturale
JOIN FILM F ON BC.Film = F.IdFilm
JOIN UTENTE_PUBBLICO U ON RP.Richiedente = U.IdUtente
WHERE RP.StatoRichiesta = 'inElaborazione'
ORDER BY RP.DataInvio;