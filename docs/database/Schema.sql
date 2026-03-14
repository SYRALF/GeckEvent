CREATE TABLE "usuarios" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "nombre" varchar(100) NOT NULL,
  "apellido" varchar(100) NOT NULL,
  "email" varchar(150) UNIQUE NOT NULL,
  "password" varchar(255) NOT NULL,
  "rol" varchar(20) NOT NULL,
  "activo" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "categorias" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "nombre" varchar(80) UNIQUE NOT NULL,
  "descripcion" text,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "eventos" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "titulo" varchar(200) NOT NULL,
  "descripcion" text,
  "fecha_inicio" timestamp NOT NULL,
  "fecha_fin" timestamp NOT NULL,
  "ubicacion" varchar(200),
  "cupo_maximo" integer,
  "estado" varchar(20) DEFAULT 'BORRADOR',
  "imagen_url" varchar(500),
  "horas_duracion" integer,
  "categoria_id" uuid,
  "organizador_id" uuid,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "inscripciones" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "evento_id" uuid,
  "participante_id" uuid,
  "fecha_inscripcion" timestamp DEFAULT (now()),
  "estado" varchar(20) DEFAULT 'ACTIVA'
);

CREATE TABLE "asistencias" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "inscripcion_id" uuid,
  "asistio" boolean DEFAULT false,
  "fecha_marcado" timestamp,
  "marcado_por" uuid
);

CREATE TABLE "certificados" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "inscripcion_id" uuid,
  "url_s3" varchar(500) NOT NULL,
  "nombre_archivo" varchar(200),
  "fecha_generacion" timestamp DEFAULT (now()),
  "codigo_verificacion" varchar(100) UNIQUE
);

CREATE UNIQUE INDEX "uq_inscripcion" ON "inscripciones" ("evento_id", "participante_id");

COMMENT ON COLUMN "usuarios"."rol" IS 'ADMIN | ORGANIZADOR | PARTICIPANTE';

COMMENT ON COLUMN "eventos"."estado" IS 'BORRADOR | PUBLICADO | CANCELADO | FINALIZADO';

COMMENT ON COLUMN "inscripciones"."estado" IS 'ACTIVA | CANCELADA';

ALTER TABLE "eventos" ADD FOREIGN KEY ("categoria_id") REFERENCES "categorias" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "eventos" ADD FOREIGN KEY ("organizador_id") REFERENCES "usuarios" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "inscripciones" ADD FOREIGN KEY ("evento_id") REFERENCES "eventos" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "inscripciones" ADD FOREIGN KEY ("participante_id") REFERENCES "usuarios" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "asistencias" ADD FOREIGN KEY ("inscripcion_id") REFERENCES "inscripciones" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "asistencias" ADD FOREIGN KEY ("marcado_por") REFERENCES "usuarios" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "certificados" ADD FOREIGN KEY ("inscripcion_id") REFERENCES "inscripciones" ("id") DEFERRABLE INITIALLY IMMEDIATE;
