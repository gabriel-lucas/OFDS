BEGIN;

-- Network Table
CREATE TABLE IF NOT EXISTS public."Network"
(
    id SERIAL PRIMARY KEY,
    name text,
    website text,
    "publisher-id" text,
    "publicationDate" date,
    "collectionDate" date,
    "crs-name" text NOT NULL,
    "crs-uri" text NOT NULL,
    accuracy integer,
    "accuracy-details" text,
    language text
);

COMMENT ON TABLE public."Network" IS 'Network definition based on the Open Fiber Data Standar https://open-fibre-data-standard.readthedocs.io/en/latest/reference/schema.html#structure';

-- Node Table
CREATE TABLE IF NOT EXISTS public."Node"
(
    id SERIAL PRIMARY KEY,
    id_network integer NOT NULL,
    name text,
    "phase-id" text NOT NULL,
    "phase-name" text,
    status text,
    location geography(Point),
    "streetAddress" text,
    locality text,
    region text,
    "postalCode" text,
    country text,
    type text,
    "accessPoint" text,
    power boolean,
    technologies text,
    "physicalInfrastructureProvider" text,
    CONSTRAINT fk_node_network FOREIGN KEY (id_network) REFERENCES public."Network" (id) ON DELETE NO ACTION
);

COMMENT ON TABLE public."Node" IS 'Nodes https://open-fibre-data-standard.readthedocs.io/en/latest/reference/schema.html#node';


CREATE TABLE IF NOT EXISTS public."Organisation"
(
    id SERIAL PRIMARY KEY,    
    id_network integer NOT NULL,
    name text,
    "identifier-id" text,
    "identifier-scheme" text,
    "identifier-legalName" text,
    "identifier-uri" text,
    country text,
    roles text,
    "roleDetails" text,
    website text,
    logo text,
    CONSTRAINT fk_org_network FOREIGN KEY (id_network) REFERENCES public."Network" (id)
);


-- Span Table
CREATE TABLE IF NOT EXISTS public."Span"
(
    id SERIAL PRIMARY KEY,
    id_network integer NOT NULL,
    name text,
    "phase-id" text NOT NULL,
    "phase-name" text,
    status text,
    "readyForServiceDate" date,
    start text,
    "end" text,
    directed boolean,
    route geography(LineString),
    "transmissionMedium" text,
    deployment text,
    "deploymentDetails-description" text,
    "darkFibre" boolean,
    "fibreType" text,
    "fibreSubtype" text,
    "fibreSubtype-description" text,
    "fibreCount" integer,
    "fibreLength" integer,
    technologies text,
    capacity integer,
    "capacityDetails-description" text,
    countries text,
    CONSTRAINT fk_span_network FOREIGN KEY (id_network) REFERENCES public."Network" (id) ON DELETE NO ACTION
);

COMMENT ON TABLE public."Span" IS 'Span https://open-fibre-data-standard.readthedocs.io/en/latest/reference/publication_formats/csv.html#spans';

CREATE TABLE IF NOT EXISTS public."SpanNetworkProvider"
(
    id_span integer NOT NULL,
    id_organisation integer NOT NULL,
    name text,
    id_network integer NOT NULL,
    PRIMARY KEY (id_span, id_organisation),
    CONSTRAINT fk_span_networkprovider_span FOREIGN KEY (id_span) REFERENCES public."Span" (id),
    CONSTRAINT fk_span_networkprovider_org FOREIGN KEY (id_organisation) REFERENCES public."Organisation" (id)
);

COMMENT ON TABLE public."SpanNetworkProvider" IS 'https://open-fibre-data-standard.readthedocs.io/en/latest/reference/publication_formats/csv.html#spans_networkProviders';

CREATE TABLE IF NOT EXISTS public."Phase"
(
    id SERIAL PRIMARY KEY,
    id_network integer NOT NULL,
    name text,
    description text,
    CONSTRAINT fk_phase_network FOREIGN KEY (id_network) REFERENCES public."Network" (id)
);

CREATE TABLE IF NOT EXISTS public."PhaseFunder"
(
    id_network integer NOT NULL,
    id_phase integer NOT NULL,
    id_funder integer NOT NULL,
    description text,
    CONSTRAINT fk_phasefunder_phase FOREIGN KEY (id_phase) REFERENCES public."Phase" (id),
    CONSTRAINT fk_phasefunder_funder FOREIGN KEY (id_funder) REFERENCES public."Organisation" (id)
);

COMMENT ON TABLE public."PhaseFunder" IS 'https://open-fibre-data-standard.readthedocs.io/en/latest/reference/publication_formats/csv.html#phases_funders';

CREATE TABLE IF NOT EXISTS public."Contract"
(
    id SERIAL PRIMARY KEY,
    id_network integer NOT NULL,
    title text,
    description text,
    type text,
    "value-amount" integer,
    "value-currency" text,
    "dateSigned" text,
    CONSTRAINT fk_contract_network FOREIGN KEY (id_network) REFERENCES public."Network" (id)
);

COMMENT ON TABLE public."Contract" IS 'https://open-fibre-data-standard.readthedocs.io/en/latest/reference/publication_formats/csv.html#Contracts';

CREATE TABLE IF NOT EXISTS public."NodeInternationalConnection"
(
    id SERIAL PRIMARY KEY,
    id_network integer NOT NULL,
    id_node integer NOT NULL,
    "streetAddress" text,
    locality text,
    region text,
    "postalCode" text,
    country text,
    CONSTRAINT fk_nic_node FOREIGN KEY (id_node) REFERENCES public."Node" (id)
);

CREATE TABLE IF NOT EXISTS public."NodeNetworkProvider"
(
    id SERIAL PRIMARY KEY,
    id_network integer NOT NULL,
    id_node integer NOT NULL,
    name text,
    CONSTRAINT fk_nnp_node FOREIGN KEY (id_node) REFERENCES public."Node" (id)
);

COMMENT ON TABLE public."NodeNetworkProvider" IS 'https://open-fibre-data-standard.readthedocs.io/en/latest/reference/publication_formats/csv.html#nodes-networkproviders';

CREATE TABLE IF NOT EXISTS public."ContractDocument"
(
    id SERIAL PRIMARY KEY,
    id_network integer NOT NULL,
    title text,
    description text,
    url text,
    format text,
    id_contract integer NOT NULL,
    CONSTRAINT fk_contractdocument_contract FOREIGN KEY (id_contract) REFERENCES public."Contract" (id)
);

COMMENT ON TABLE public."ContractDocument" IS 'https://open-fibre-data-standard.readthedocs.io/en/latest/reference/publication_formats/csv.html#contracts-documents';

CREATE TABLE IF NOT EXISTS public."ContractPhases"
(
    id_contract integer NOT NULL,
    id_phase integer NOT NULL,
    id_network integer NOT NULL,
    name text,
    PRIMARY KEY (id_phase, id_contract),
    CONSTRAINT fk_cp_contract FOREIGN KEY (id_contract) REFERENCES public."Contract" (id),
    CONSTRAINT fk_cp_phase FOREIGN KEY (id_phase) REFERENCES public."Phase" (id)
);

COMMENT ON TABLE public."ContractPhases" IS 'https://open-fibre-data-standard.readthedocs.io/en/latest/reference/publication_formats/csv.html#contracts-relatedphases';

END;
