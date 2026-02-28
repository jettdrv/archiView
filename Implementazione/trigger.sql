
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- TRIGGER
--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
DROP TRIGGER IF EXISTS iniz_biglietto ON PROIEZIONE;
DROP TRIGGER IF EXISTS acquisto_biglietto ON BIGLIETTO;
DROP TRIGGER IF EXISTS check_acquisto_biglietto ON BIGLIETTO;
DROP TRIGGER IF EXISTS trigger_check_posto ON BIGLIETTO;
DROP TRIGGER IF EXISTS trigger_sede_mostra ON MOSTRA;
DROP TRIGGER IF EXISTS trigger_sede_rassegna ON RASSEGNA;
DROP TRIGGER IF EXISTS trigger_sede_incontro ON INCONTRO_CAST;
DROP TRIGGER IF EXISTS trigger_sede_proiezione ON PROIEZIONE;
DROP TRIGGER IF EXISTS trigger_controlla_orario_sala ON PROIEZIONE;
DROP TRIGGER IF EXISTS trigger_data_proiezione ON PROIEZIONE;
DROP TRIGGER IF EXISTS trigger_sovrapposizione_eventi ON EVENTO;
DROP TRIGGER IF EXISTS trigger_insert_proiezione ON PROIEZIONE;

DROP TRIGGER IF EXISTS trigger_accetta_richiesta ON RICHIESTA_PRESTITO;
DROP TRIGGER IF EXISTS trigger_rifiuto_richiesta ON RICHIESTA_PRESTITO;
DROP TRIGGER IF EXISTS trigger_restituzione_bene ON PRESTITO_CULTURALE;
DROP TRIGGER IF EXISTS trigger_cambia_stato_prestito ON PRESTITO_CULTURALE;
DROP TRIGGER IF EXISTS trigger_aggiorna_disp_critico ON MATERIALE_FISICO;


DROP TRIGGER IF EXISTS trigger_controllo_sezione ON SEZIONE;

DROP TRIGGER IF EXISTS trigger_avvia_restauro ON RESTAURO;
DROP TRIGGER IF EXISTS trigger_cambio_stato_restauro ON RESTAURO;
DROP TRIGGER IF EXISTS trigger_cambio_stato_verifica ON VERIFICA;


DROP TRIGGER IF EXISTS trigger_team ON TECNICO;

--==========================================================
--GESTIONE BIGLIETTI
--==========================================================

--1) Inizializzazione della disponibilità dei biglietti di una proiezione al valore della capacità massima della sala

CREATE OR REPLACE FUNCTION inizializza_disp_biglietti()
RETURNS TRIGGER AS $$
DECLARE
	n_file INT;
	n_posti_fila INT;
BEGIN
	SELECT NrFile, NrPostiFila INTO n_file, n_posti_fila
	FROM SALA
	WHERE NumeroSala=NEW.NumeroSala AND IdSede=NEW.IdSede;
	
	NEW.DisponibilitaBiglietti :=n_file * n_posti_fila;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER iniz_biglietto
BEFORE INSERT ON PROIEZIONE
FOR EACH ROW
EXECUTE FUNCTION  inizializza_disp_biglietti();


--2) Si può comprare un biglietto se e solo se l'acquisto precede la data di proiezione e la proiezione non è ancora iniziata
CREATE OR REPLACE FUNCTION check_data_acquisto()
RETURNS TRIGGER AS $$
DECLARE
	data_proiezione DATE;
	orario_inizio TIME;
BEGIN
	SELECT DataInizio, OrarioInizio 
	INTO data_proiezione, orario_inizio 
	FROM EVENTO E
	JOIN PROIEZIONE P ON P.IdEvento = E.IdEvento
	WHERE P.IdEvento = NEW.Proiezione;

	IF CURRENT_DATE > data_proiezione OR (CURRENT_DATE=data_proiezione AND CURRENT_TIME>= orario_inizio) THEN
		RAISE EXCEPTION  'Non si possono comprare i biglietti per una proiezione che è già finita';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER 	check_acquisto_biglietto
BEFORE INSERT ON BIGLIETTO
FOR EACH ROW
EXECUTE FUNCTION check_data_acquisto();

--3) Decremento della disponibilità dei biglietti dopo l'acquisto di un biglietto 

CREATE OR REPLACE FUNCTION decrementa_disp()
RETURNS TRIGGER AS $$
DECLARE 
	posti_attuali INT;
BEGIN
	SELECT DisponibilitaBiglietti INTO posti_attuali
	FROM PROIEZIONE
	WHERE IdEvento = NEW.Proiezione;

	IF posti_attuali<=0 THEN
		RAISE EXCEPTION 'Errore: non ci sono più posti disponibili %', NEW.Proiezione;
	END IF;
	
	UPDATE PROIEZIONE
    SET DisponibilitaBiglietti = DisponibilitaBiglietti - 1
 	WHERE IdEvento = NEW.Proiezione;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER acquisto_biglietto
BEFORE INSERT ON BIGLIETTO
FOR EACH ROW
EXECUTE FUNCTION decrementa_disp();


--4) -- verifica se il numero di posto e di fila inserito è valido per la sala in cui si svolge la proiezione

CREATE OR REPLACE FUNCTION check_posto()
RETURNS TRIGGER AS $$
DECLARE 
max_nr_fila INT;
max_nr_posto INT;
BEGIN
	SELECT S.NrFile, S.NrPostiFila INTO max_nr_fila, max_nr_posto
	FROM PROIEZIONE P
	JOIN SALA S ON P.NumeroSala=S.NumeroSala AND P.IdSede=S.IdSede
	WHERE P.IdEvento= NEW.Proiezione;

	IF NEW.Fila > max_nr_fila OR NEW.Fila <= 0 THEN
		RAISE EXCEPTION 'Fila % non valida.', NEW.Fila;
	END IF;
	IF NEW.NumeroPosto > max_nr_posto OR NEW.NumeroPosto <=0 THEN
		RAISE EXCEPTION 'Posto % non valido.', NEW.NumeroPosto;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_posto
BEFORE INSERT ON BIGLIETTO
FOR EACH ROW
EXECUTE FUNCTION check_posto();

--=============================================================================
--GESTIONE CREAZIONE EVENTI
--=============================================================================
-- 1) Un evento di tipo mostra, incontro con staff oppure rassegna si può svolgere solo 
--nella sede Palazzo delle Esposizioni. Le proiezioni si svolgono solo nella Casa del Cinema
CREATE OR REPLACE FUNCTION verifica_sede_evento()
RETURNS TRIGGER AS $$
DECLARE
    sede_evento NOME_SEDE;
BEGIN
    SELECT NomeSede INTO sede_evento
    FROM SEDE S
    JOIN EVENTO E ON E.Sede=S.IdSede
	WHERE E.IdEvento=NEW.IdEvento;
    
    IF TG_TABLE_NAME IN ('mostra', 'rassegna', 'incontro_cast') THEN
        IF sede_evento <> 'Palazzo delle Esposizioni' THEN
            RAISE EXCEPTION '% deve svolgersi al Palazzo delle Esposizioni', TG_TABLE_NAME;
        END IF;

    ELSIF TG_TABLE_NAME = 'proiezione' THEN
        IF sede_evento <> 'Casa del Cinema' THEN
            RAISE EXCEPTION 'Le proiezioni devono svolgersi alla Casa del Cinema';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--controllo della sede per ogni tipo di evento inserito
CREATE TRIGGER trigger_sede_mostra
BEFORE INSERT OR UPDATE ON MOSTRA
FOR EACH ROW
EXECUTE FUNCTION verifica_sede_evento();

CREATE TRIGGER trigger_sede_incontro
BEFORE INSERT OR UPDATE ON INCONTRO_CAST
FOR EACH ROW
EXECUTE FUNCTION verifica_sede_evento();

CREATE TRIGGER trigger_sede_rassegna
BEFORE INSERT OR UPDATE ON RASSEGNA
FOR EACH ROW
EXECUTE FUNCTION verifica_sede_evento();

CREATE TRIGGER trigger_sede_proiezione
BEFORE INSERT OR UPDATE ON PROIEZIONE
FOR EACH ROW
EXECUTE FUNCTION verifica_sede_evento();

--2) coerenza date

--Una proiezione si può svolgere nella stessa sala e stessa data di un’altra proiezione, se e solo se il suo orario di inizio
--è maggiore dell’orario di fine dell’altra proiezione.

CREATE OR REPLACE FUNCTION verifica_sovrapposizione_proiezioni()
RETURNS TRIGGER AS $$
DECLARE
	nuovo_inizio TIME;
	nuovo_fine TIME;
	nuova_data DATE;
BEGIN
    SELECT E.OrarioInizio, E.OrarioFine, E.DataInizio
	INTO nuovo_inizio, nuovo_fine, nuova_data
	FROM EVENTO E
	WHERE E.IdEvento = NEW.IdEvento;

	IF EXISTS(
		SELECT *
		FROM PROIEZIONE P
		JOIN EVENTO E ON P.IdEvento=E.IdEvento
		WHERE P.NumeroSala=NEW.NumeroSala
		AND P.IdSede = NEW.IdSede
          AND P.IdEvento <> NEW.IdEvento
          AND E.DataInizio = nuova_data
          AND E.OrarioInizio < nuovo_fine
          AND E.OrarioFine > nuovo_inizio
    ) THEN
        RAISE EXCEPTION 'esiste già una proiezione in questa sala in questo orario';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_controlla_orario_sala
BEFORE INSERT OR UPDATE ON PROIEZIONE
FOR EACH ROW EXECUTE FUNCTION verifica_sovrapposizione_proiezioni();

-- Per una proiezione, la data inizio coincide con la data fine.
CREATE OR REPLACE FUNCTION check_date_proiezione()
RETURNS TRIGGER AS $$
DECLARE 
	data_inizio DATE;
	data_fine DATE;
BEGIN
	SELECT E.DataInizio, E.DataFine 
	INTO data_inizio, data_fine
	FROM EVENTO E
	WHERE E.IdEvento= NEW.IdEvento;

	IF data_inizio <> data_fine THEN
		RAISE EXCEPTION 'Una proiezione non può durare più di un giorno';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_data_proiezione
BEFORE INSERT OR UPDATE ON PROIEZIONE
FOR EACH ROW EXECUTE FUNCTION check_date_proiezione();

-- per una proiezione, si deve prestare attenzione all'orario di inizio e fine. siccome per un evento generico che si svolge in diverse
--giornate l'orario di inizio non è necessariamente minore dell'orario di fine, il controllo per una proiezione si effettua tramite un trigger.
-- In particolare, si deve controllare che l'orario di inizio debba essere minore dell'orario di fine. E l'orario di fine è uguale all'orario 
--di inizio + la durata del film + 20 minuti per la pubblicità

CREATE OR REPLACE FUNCTION check_orario_proiezione()
RETURNS TRIGGER AS $$
DECLARE
		durata_film INT;
		orario_inizio TIME;
		orario_fine TIME;
BEGIN
	SELECT OrarioInizio, OrarioFine
	INTO orario_inizio, orario_fine
	FROM EVENTO E 
	WHERE E.IdEvento = NEW.IdEvento;
	
	IF  orario_inizio > orario_fine THEN 
		RAISE EXCEPTION 'L orario di fine proiezione non può procedere l orario di inizio.';
	END IF;
	
	SELECT Durata 
	INTO durata_film
	FROM FILM F
	JOIN BENE_CULTURALE B ON B.Film = F.IdFilm
	WHERE B.IdBeneCulturale = NEW.BeneCulturale;

	IF orario_fine < orario_inizio + (durata_film + 20) * INTERVAL '1 minute' THEN
		RAISE EXCEPTION 'Inserire un orario di fine maggiore della durata del film %', NEW.IdEvento;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_insert_proiezione
BEFORE INSERT OR UPDATE ON PROIEZIONE
FOR EACH ROW EXECUTE FUNCTION check_orario_proiezione();


-- Un evento si può svolgere nella stessa sede di un altro evento, se e solo se la sua data di inizio è maggiore della data
--di fine dell’altro evento.
CREATE OR REPLACE FUNCTION check_occupazione_sede()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Sede = (SELECT IdSede FROM SEDE WHERE NomeSede = 'Palazzo delle Esposizioni') THEN --questo controllo vale solo per il palazzo delle esposizioni. Normalmente la casa del cinema ha più sale che ospitano più proiezioni
		IF EXISTS (
	        SELECT * 
			FROM EVENTO E
	        WHERE E.Sede = NEW.Sede
	        AND IdEvento <> NEW.IdEvento
			AND E.DataInizio<=NEW.DataInizio
			AND E.DataFine>=NEW.DataInizio
	    ) THEN
	        RAISE EXCEPTION 'Esiste già un evento nella sede % per il periodo selezionato', NEW.Sede;
	    END IF;
	END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sovrapposizione_eventi
BEFORE INSERT OR UPDATE ON EVENTO
FOR EACH ROW
EXECUTE FUNCTION check_occupazione_sede();
--==================================================================================================================
--CHECK TEMPERATURA E UMIDITA' PER LE SEZIONI DI MAGAZZINO ASSOCIATI A PELLICOLE
--==============================================================================================================
CREATE OR REPLACE FUNCTION check_temp_umid()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.TipoMateriale ='pellicola' THEN
		IF NEW.TemperaturaMedia >=4 THEN
			RAISE EXCEPTION 'Temperatura troppo altra per conservare le pellicole nitrato';
		END IF;
		IF NEW.UmiditaMedia <= 30 OR NEW.UmiditaMedia >= 35 THEN
			RAISE EXCEPTION 'Umidità media non conforme per le pellicole nitrato';
		END IF;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_controllo_sezione
BEFORE INSERT OR UPDATE ON SEZIONE
FOR EACH ROW EXECUTE FUNCTION check_temp_umid();

--======================================================================================================================
--GESTIONE PRESTITI CULTURALI
--=====================================================================================================================

-- 1) se un bene culturale è associato a una proiezione che avviene durante il periodo richiesto da un utente, il prestito non è possibile
-- gli eventi organizzati dalla cineteca hanno priorità maggiore.

CREATE OR REPLACE FUNCTION check_richiesta_e_proiezione()
RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS (
		SELECT *
		FROM PROIEZIONE P
		JOIN EVENTO E ON E.IdEvento = P.IdEvento
		WHERE P.BeneCulturale=NEW.BeneCulturale
		AND E.DataInizio = NEW.DataPrevistaProiezione
	)
	THEN
		NEW.StatoRichiesta:='rifiutata';
		NEW.MotivazioneRifiuto:='Il bene è già prenotato per una proiezione organizzata dalla Cineteca.';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_rifiuto_richiesta
BEFORE INSERT OR UPDATE ON RICHIESTA_PRESTITO
FOR EACH ROW EXECUTE FUNCTION check_richiesta_e_proiezione();


--2) Se una richiesta di prestito viene accettata, quindi passa allo stato 'accettata', si crea un prestito culturale e 
-- si aggiorna la disponibilita a false

CREATE OR REPLACE FUNCTION crea_prestito()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.StatoRichiesta ='accettata' AND OLD.StatoRichiesta <> 'accettata' THEN	
		INSERT INTO PRESTITO_CULTURALE(Richiesta, StatoPrestito, DataInizio, DataFine)
		VALUES(NEW.IdRichiesta, 'attivo', NEW.DataPrevistaProiezione, NEW.DataPrevistaProiezione + INTERVAL '1 month');

		UPDATE BENE_CULTURALE
		SET DisponibilitaPrestito= FALSE
		WHERE IdBeneCulturale = NEW.BeneCulturale;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_accetta_richiesta
AFTER UPDATE ON RICHIESTA_PRESTITO
FOR EACH ROW EXECUTE FUNCTION crea_prestito();


--3) Quando il bene viene restituito, si aggiorna la disponibilità a TRUE
CREATE OR REPLACE FUNCTION aggiorna_disp_dopo_restituzione()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.StatoPrestito ='restituito' AND OLD.StatoPrestito <>'restituito' THEN
		NEW.RestituzioneEffettiva := CURRENT_DATE;
		
		UPDATE BENE_CULTURALE
		SET DisponibilitaPrestito =TRUE
		WHERE IdBeneCulturale = (
			SELECT R.BeneCulturale
			FROM RICHIESTA_PRESTITO R
			WHERE R.IdRichiesta = NEW.Richiesta
		);
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_restituzione_bene
BEFORE UPDATE ON PRESTITO_CULTURALE
FOR EACH ROW EXECUTE FUNCTION aggiorna_disp_dopo_restituzione();

--4) Se un materiale fisico raggiunge uno stato di conservazione ’critico’, allora la disponibilità al prestito del bene culturale associato diventa falso
CREATE OR REPLACE FUNCTION check_stato_materiale()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.StatoConservazione = 'critico' AND OLD.StatoConservazione <>'critico'THEN
		UPDATE BENE_CULTURALE
		SET DisponibilitaPrestito = FALSE
		WHERE IdBeneCulturale = NEW.IdBene;
	END IF;
	IF NEW.StatoConservazione <>'critico' AND OLD.StatoConservazione ='critico' THEN
		UPDATE BENE_CULTURALE
		SET DisponibilitaPrestito = TRUE
		WHERE IdBeneCulturale = NEW.IdBene;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
	
CREATE TRIGGER trigger_aggiorna_disp_critico
AFTER UPDATE ON MATERIALE_FISICO
FOR EACH ROW EXECUTE FUNCTION check_stato_materiale();


--5) cambio stato di un prestito che non è ancora stato restituito dopo la data fine prevista
CREATE OR REPLACE FUNCTION scadenza_prestito()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.DataFine< CURRENT_DATE AND NEW.StatoPrestito ='attivo' THEN
		NEW.StatoPrestito:='scaduto';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cambia_stato_prestito
BEFORE UPDATE ON PRESTITO_CULTURALE
FOR EACH ROW EXECUTE FUNCTION scadenza_prestito();

--================================================================================================================
--GESTIONE RESTAURI E VERIFICHE
--============================================================================================================
--1) i restauri avvengono solo per quei materiali fisici con stato critico
CREATE OR REPLACE FUNCTION check_stato()
RETURNS TRIGGER AS $$
DECLARE 
	stato_attuale STATO_CONSERVAZIONE;
BEGIN
	SELECT StatoConservazione
	INTO stato_attuale
	FROM MATERIALE_FISICO
	WHERE IdBene=NEW.Materiale;

	IF stato_attuale <> 'critico' THEN
		RAISE EXCEPTION 'Si possono restaurare solo i materiali in stato critico';
	END IF;
	RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_avvia_restauro
BEFORE INSERT ON RESTAURO
FOR EACH ROW EXECUTE FUNCTION check_stato();

--2) viene registrato un intervento di restauro con esito positivo che cambia il suo stato di conservazione.

CREATE OR REPLACE FUNCTION cambia_stato_dopo_restauro()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.Esito IS NOT NULL AND OLD.Esito IS NULL THEN
		UPDATE MATERIALE_FISICO
		SET StatoConservazione = NEW.Esito
		WHERE IdBene=NEW.Materiale;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cambio_stato_restauro
AFTER UPDATE ON RESTAURO
FOR EACH ROW EXECUTE FUNCTION cambia_stato_dopo_restauro();

--3) uguale come prima, solo che adesso lo stato viene cambiato dopo una verifica
CREATE OR REPLACE FUNCTION cambia_stato_dopo_verifica()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.LivelloRiscontrato IS NOT NULL THEN
		UPDATE MATERIALE_FISICO
		SET StatoConservazione = NEW.LivelloRiscontrato
		WHERE IdBene=NEW.IdMateriale;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cambio_stato_verifica
AFTER INSERT OR UPDATE ON VERIFICA
FOR EACH ROW EXECUTE FUNCTION cambia_stato_dopo_verifica();

--==============================================================================
--GESTIONE TEAM TECNICI
--==============================================================================
CREATE OR REPLACE FUNCTION check_numero_tecnici()
RETURNS TRIGGER AS $$
DECLARE 
	cont_tecnici INT;
BEGIN
	SELECT COUNT(*) 
	INTO cont_tecnici
	FROM TECNICO
	WHERE Team=NEW.Team;

	IF cont_tecnici > 5 THEN
		RAISE EXCEPTION 'Il team % deve avere al massimo 5 tecnici', NEW.Team;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_team
BEFORE INSERT OR UPDATE ON TECNICO
FOR EACH ROW EXECUTE FUNCTION check_numero_tecnici();
