

--drop degli indici

DROP INDEX IF EXISTS index_fk_mostra_evento CASCADE;
DROP INDEX IF EXISTS index_fk_rassegna_evento CASCADE;
DROP INDEX IF EXISTS index_fk_incontro_evento CASCADE;
DROP INDEX IF EXISTS index_fk_invito_regista CASCADE;
DROP INDEX IF EXISTS index_fk_invito_attore CASCADE;
DROP INDEX IF EXISTS index_fk_invito_incontro CASCADE;
DROP INDEX IF EXISTS index_fk_programmazione_evento CASCADE;
DROP INDEX IF EXISTS index_fk_programmazione_film CASCADE;
DROP INDEX IF EXISTS index_fk_regia_film CASCADE;
DROP INDEX IF EXISTS index_fk_regia_regista CASCADE;
DROP INDEX IF EXISTS index_fk_recitazione_film CASCADE;
DROP INDEX IF EXISTS index_fk_recitazione_attore CASCADE;
DROP INDEX IF EXISTS index_fk_bene_film CASCADE;

DROP INDEX IF EXISTS index_fk_proiezione_evento CASCADE;
DROP INDEX IF EXISTS index_fk_proiezione_bene CASCADE;
DROP INDEX IF EXISTS index_fk_proiezione_sala CASCADE;

DROP INDEX IF EXISTS index_fk_mdigitale_bene CASCADE;
DROP INDEX IF EXISTS index_fk_mfisico_bene CASCADE;
DROP INDEX IF EXISTS index_fk_pellicola_bene CASCADE;
DROP INDEX IF EXISTS index_fk_manifesto_bene CASCADE;
DROP INDEX IF EXISTS index_fk_collezione_bene CASCADE;
DROP INDEX IF EXISTS index_fk_foto_collezione CASCADE;

DROP INDEX IF EXISTS index_fk_verifica_mfisico CASCADE;
DROP INDEX IF EXISTS index_fk_restauro_materiale CASCADE;
DROP INDEX IF EXISTS index_fk_restauro_verifica CASCADE;
DROP INDEX IF EXISTS index_fk_biglietto_proiezione CASCADE;
DROP INDEX IF EXISTS index_fk_biglietto_cliente CASCADE;
DROP INDEX IF EXISTS index_fk_ente_cred CASCADE;
DROP INDEX IF EXISTS index_fk_richiesta_utente CASCADE;
DROP INDEX IF EXISTS index_fk_richiesta_bene CASCADE;
DROP INDEX IF EXISTS index_fk_richiesta_archivista CASCADE;

DROP INDEX IF EXISTS index_film CASCADE;
DROP INDEX IF EXISTS index_data_evento CASCADE;
DROP INDEX IF EXISTS index_stato_prestito CASCADE;
DROP INDEX IF EXISTS index_stato_richiesta CASCADE;
DROP INDEX IF EXISTS index_stato_conservazione CASCADE;
DROP INDEX IF EXISTS index_biglietto_fila_posto CASCADE;
DROP INDEX IF EXISTS index_proiezione_sala_sede CASCADE;




--INDICI
--Si creano inizialmente gli indici sulle foreign key per velocizzare le JOIN. Sono stati saltati quelle foreign key che puntano a tabelle con un volume molto basso secondo la stima del carico applicativo(come ad esempio per il magazzino che è solo uno, oppure per restauratore che sono solo 15)
CREATE INDEX index_fk_mostra_evento ON MOSTRA(IdEvento);
CREATE INDEX index_fk_rassegna_evento ON RASSEGNA(IdEvento);
CREATE INDEX index_fk_incontro_evento ON INCONTRO_CAST(IdEvento);
CREATE INDEX index_fk_invito_regista ON INVITO(Regista);
CREATE INDEX index_fk_invito_attore ON INVITO(Attore);
CREATE INDEX index_fk_invito_incontro ON INVITO(Incontro);
CREATE INDEX index_fk_programmazione_evento ON PROGRAMMAZIONE_FILM(Evento);
CREATE INDEX index_fk_programmazione_film ON PROGRAMMAZIONE_FILM(Film);
CREATE INDEX index_fk_regia_film ON REGIA(Film);
CREATE INDEX index_fk_regia_regista ON REGIA(Regista);
CREATE INDEX index_fk_recitazione_film ON RECITAZIONE(Film);
CREATE INDEX index_fk_recitazione_attore ON RECITAZIONE(Attore);
CREATE INDEX index_fk_bene_film ON BENE_CULTURALE(Film);

CREATE INDEX index_fk_proiezione_evento ON PROIEZIONE(IdEvento);
CREATE INDEX index_fk_proiezione_bene ON PROIEZIONE(BeneCulturale);
CREATE INDEX index_fk_proiezione_sala ON PROIEZIONE(NumeroSala, IdSede);

CREATE INDEX index_fk_mdigitale_bene ON MATERIALE_DIGITALE(IdBene);

CREATE INDEX index_fk_mfisico_bene ON MATERIALE_FISICO(IdBene);
CREATE INDEX index_fk_pellicola_bene ON PELLICOLA(IdBene);
CREATE INDEX index_fk_manifesto_bene ON MANIFESTO(IdBene);
CREATE INDEX index_fk_collezione_bene ON COLLEZIONE(IdBene);
CREATE INDEX index_fk_foto_collezione ON FOTOGRAFIA_ANALOGICA(Collezione);

CREATE INDEX index_fk_verifica_mfisico ON VERIFICA(IdMateriale);
CREATE INDEX index_fk_restauro_materiale ON RESTAURO(Materiale);
CREATE INDEX index_fk_restauro_verifica ON RESTAURO(Verifica);

CREATE INDEX index_fk_biglietto_proiezione ON BIGLIETTO(Proiezione);
CREATE INDEX index_fk_biglietto_cliente ON BIGLIETTO(Cliente);
CREATE INDEX index_fk_ente_cred ON ENTE(CredenzialiUtente);
CREATE INDEX index_fk_richiesta_utente ON UTENTE_PUBBLICO(IdUtente);
CREATE INDEX index_fk_richiesta_bene ON BENE_CULTURALE(IdBeneCulturale);
CREATE INDEX index_fk_richiesta_archivista ON ARCHIVISTA(Matricola);


-- la ricerca di un film per il titolo, è un'operazione frequente.
CREATE INDEX index_film ON FILM(Titolo);
-- Un operazione frequente è la visualizzazione dei dati delle proiezioni in programmazione. Creo un indice sulla data degli eventi
CREATE INDEX index_data_evento ON EVENTO(DataInizio);

-- usato in VISTA_PRESTITI_ATTIVI e trigger scadenza_prestito
CREATE INDEX index_stato_prestito ON PRESTITO_CULTURALE(StatoPrestito);

-- usato in VISTA_RICHIESTE_IN_ATTESA e trigger rifiuto_richiesta
CREATE INDEX index_stato_richiesta ON RICHIESTA_PRESTITO(StatoRichiesta);

-- usato in VISTA_STATO_CONSERVAZIONE_CRITICO e trigger check_stato_materiale
CREATE INDEX index_stato_conservazione ON MATERIALE_FISICO(StatoConservazione);

-- usato nei trigger dei biglietti
CREATE INDEX index_biglietto_fila_posto ON BIGLIETTO(Proiezione, Fila, NumeroPosto);

-- usato nel trigger di sovrapposizione proiezioni
CREATE INDEX index_proiezione_sala_sede ON PROIEZIONE(NumeroSala, IdSede);

