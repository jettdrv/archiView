DROP ROLE IF EXISTS archivista;
DROP ROLE IF EXISTS restauratore;
DROP ROLE IF EXISTS responsabile_eventi;
DROP ROLE IF EXISTS tecnico;

--ARCHIVISTA
CREATE ROLE archivista WITH LOGIN PASSWORD 'cinetecaadmin' SUPERUSER;


-- UTENTE PUBBLICO
DROP ROLE IF EXISTS utente_pubblico;
CREATE ROLE utente_pubblico WITH LOGIN PASSWORD 'cineteca';

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM utente_pubblico;

GRANT SELECT ON VISTA_DETTAGLI_PROIEZIONE TO utente_pubblico;
GRANT SELECT ON VISTA_CATALOGO TO utente_pubblico;
GRANT SELECT ON VISTA_PELLICOLE TO utente_pubblico;
GRANT SELECT ON VISTA_MANIFESTI TO utente_pubblico;
GRANT SELECT ON VISTA_COLLEZIONI TO utente_pubblico;
GRANT INSERT ON BIGLIETTO TO utente_pubblico;
GRANT USAGE ON SEQUENCE biglietto_idbiglietto_seq TO utente_pubblico;

GRANT INSERT ON RICHIESTA_PRESTITO TO utente_pubblico;
GRANT SELECT ON RICHIESTA_PRESTITO TO utente_pubblico;
GRANT USAGE ON SEQUENCE richiesta_prestito_idrichiesta_seq TO utente_pubblico;

-- STAFF
-- un restauratore può vedere storico restauri e aggiornare restauri
CREATE ROLE restauratore WITH LOGIN PASSWORD 'cinetecarestauratore';
GRANT SELECT ON VISTA_STORICO_RESTAURI TO restauratore;
GRANT SELECT, UPDATE ON RESTAURO TO restauratore;
GRANT SELECT ON MATERIALE_FISICO TO restauratore;
GRANT SELECT ON BENE_CULTURALE TO restauratore;
GRANT SELECT ON FILM TO restauratore;

-- un responsabile eventi può creare e modificare eventi
CREATE ROLE responsabile_eventi WITH LOGIN PASSWORD 'cinetecaresponsabile';
GRANT SELECT, INSERT, UPDATE ON EVENTO TO responsabile_eventi;
GRANT SELECT, INSERT, UPDATE ON PROIEZIONE TO responsabile_eventi;
GRANT SELECT, INSERT, UPDATE ON MOSTRA TO responsabile_eventi;
GRANT SELECT, INSERT, UPDATE ON RASSEGNA TO responsabile_eventi;
GRANT SELECT, INSERT, UPDATE ON INCONTRO_CAST TO responsabile_eventi;
GRANT SELECT ON SALA TO responsabile_eventi;
GRANT SELECT ON SEDE TO responsabile_eventi;
GRANT SELECT ON FILM TO responsabile_eventi;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO responsabile_eventi;

-- un tecnico può vedere i restauri, le proiezioni e aggiornare note operative
CREATE ROLE tecnico WITH LOGIN PASSWORD 'cinetecatecnico';
GRANT SELECT ON VISTA_DETTAGLI_PROIEZIONE TO tecnico;
GRANT SELECT ON PROIEZIONE TO tecnico;
GRANT UPDATE (NoteOperative, ProblemiTecnici) ON PROIEZIONE TO tecnico;
GRANT SELECT ON BENE_CULTURALE TO tecnico;
GRANT SELECT ON FILM TO tecnico;
GRANT SELECT ON RESTAURO TO tecnico;
GRANT SELECT ON VISTA_STORICO_RESTAURI TO tecnico;