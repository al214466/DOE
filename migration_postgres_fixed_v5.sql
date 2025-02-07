CREATE TABLE IF NOT EXISTS app_usuario (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(255) NOT NULL,
        correo VARCHAR(255) UNIQUE NOT NULL,
        contrasena VARCHAR(255) NOT NULL,
        fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
CREATE TABLE IF NOT EXISTS "django_migrations" ("id" SERIAL PRIMARY KEY, "app" VARCHAR(255) NOT NULL, "name" VARCHAR(255) NOT NULL, "applied" TIMESTAMP NOT NULL);
CREATE TABLE IF NOT EXISTS "app_usuario_user_permissions" ("id" SERIAL PRIMARY KEY, "usuario_id" bigint NOT NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES app_usuario ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "django_session" ("session_key" VARCHAR(40) NOT NULL PRIMARY KEY, "session_data" text NOT NULL, "expire_date" TIMESTAMP NOT NULL);
CREATE TABLE IF NOT EXISTS "app_archivofase" ("id" SERIAL PRIMARY KEY, "archivo" VARCHAR(100) NOT NULL, "fecha_subida" TIMESTAMP NOT NULL, "doe_id" bigint NOT NULL REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED, "subido_por_id" bigint NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED, "fase" VARCHAR(100) NOT NULL);
CREATE TABLE IF NOT EXISTS "app_historialfase" ("id" SERIAL PRIMARY KEY, "fecha_cambio" TIMESTAMP NOT NULL, "comentario" text NOT NULL, "tiempo_transcurrido" bigint NULL, "cambiado_por_id" bigint NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED, "doe_id" bigint NOT NULL REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED, "fase" VARCHAR(100) NOT NULL);
CREATE TABLE IF NOT EXISTS "app_doe_fase" ("id" SERIAL PRIMARY KEY, "nombre_fase" VARCHAR(50) NOT NULL, "estado" VARCHAR(20) NOT NULL, "fecha_inicio" TIMESTAMP NOT NULL, "fecha_finalizacion" TIMESTAMP NULL, "doe_id" bigint NOT NULL REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_doe_fases" ("id" SERIAL PRIMARY KEY, "doe_id" bigint NOT NULL REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED, "doe_fase_id" bigint NOT NULL REFERENCES "app_doe_fase" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_turnocomentario" ("id" SERIAL PRIMARY KEY, "comentario" text NOT NULL, "fecha_creacion" TIMESTAMP NOT NULL, "doe_id" bigint NOT NULL REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED, "usuario_id" bigint NOT NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_comentario" ("id" SERIAL PRIMARY KEY, "contenido" text NOT NULL, "fecha_creacion" TIMESTAMP NOT NULL, "autor_id" bigint NOT NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED, "doe_id" bigint NOT NULL REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_chatmessage" ("id" SERIAL PRIMARY KEY, "mensaje" text NULL, "imagen" VARCHAR(100) NULL, "fecha_envio" TIMESTAMP NOT NULL, "doe_id" bigint NOT NULL REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED, "usuario_id" bigint NOT NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_usuario" ("id" SERIAL PRIMARY KEY, "password" VARCHAR(128) NOT NULL, "last_login" TIMESTAMP NULL, "is_superuser" bool NOT NULL, "username" VARCHAR(150) NOT NULL UNIQUE, "first_name" VARCHAR(150) NOT NULL, "last_name" VARCHAR(150) NOT NULL, "email" VARCHAR(254) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" TIMESTAMP NOT NULL, "nombre" VARCHAR(100) NOT NULL, "rol" VARCHAR(2) NOT NULL, "numero_reloj" VARCHAR(10) NOT NULL, "turno" integer NULL);
CREATE TABLE IF NOT EXISTS "app_equipo" ("id" SERIAL PRIMARY KEY, "nombre" VARCHAR(100) NOT NULL, "creado_por_id" bigint NOT NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_equipo_miembros" ("id" SERIAL PRIMARY KEY, "equipo_id" bigint NOT NULL REFERENCES "app_equipo" ("id") DEFERRABLE INITIALLY DEFERRED, "usuario_id" bigint NOT NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_datamining" ("id" SERIAL PRIMARY KEY, "issue" text NOT NULL, "excel_data" VARCHAR(100) NOT NULL, "dr" text NOT NULL, "doe_id" bigint NOT NULL UNIQUE REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_execution" ("id" SERIAL PRIMARY KEY, "link" VARCHAR(200) NOT NULL, "pic" integer NOT NULL, "status_per_pic" text NOT NULL, "executive_summary" text NOT NULL, "doe_id" bigint NOT NULL UNIQUE REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_resultfinal" ("id" SERIAL PRIMARY KEY, "ppt_final" VARCHAR(100) NOT NULL, "brief_conclusion" text NOT NULL, "doe_id" bigint NOT NULL UNIQUE REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "app_doe" ("id" SERIAL PRIMARY KEY, "titulo" VARCHAR(255) NOT NULL, "descripcion" text NOT NULL, "fecha_creacion" TIMESTAMP NOT NULL, "creado_por_id" bigint NOT NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED, "fase_actual" VARCHAR(50) NOT NULL, "fecha_ultima_modificacion" TIMESTAMP NOT NULL, "prioridad" VARCHAR(10) NOT NULL, "archivo_te" VARCHAR(100) NULL, "equipo_id" bigint NULL REFERENCES "app_equipo" ("id") DEFERRABLE INITIALLY DEFERRED, "data_mining_completed" bool NOT NULL, "execution_completed" bool NOT NULL, "infrastructure_completed" bool NOT NULL, "result_final_completed" bool NOT NULL);
CREATE TABLE IF NOT EXISTS "app_infrastructurematerial" ("id" SERIAL PRIMARY KEY, "collect_material" VARCHAR(10) NOT NULL, "rack" VARCHAR(255) NULL, "doe_id" bigint NOT NULL UNIQUE REFERENCES "app_doe" ("id") DEFERRABLE INITIALLY DEFERRED, "bay" VARCHAR(255) NULL, "material_name" VARCHAR(255) NULL, "material_pn" VARCHAR(255) NULL, "material_sn" VARCHAR(255) NULL, "test_list" text NULL);
CREATE TABLE IF NOT EXISTS "app_material" ("id" SERIAL PRIMARY KEY, "infrastructure_id" bigint NOT NULL REFERENCES "app_infrastructurematerial" ("id") DEFERRABLE INITIALLY DEFERRED, "material_name" VARCHAR(255) NULL, "material_pn" VARCHAR(255) NULL, "material_sn" VARCHAR(255) NULL);
CREATE TABLE IF NOT EXISTS "app_unidad" ("id" SERIAL PRIMARY KEY, "rack_sn" VARCHAR(255) NOT NULL, "rn_number" VARCHAR(255) NOT NULL, "unit_sn" VARCHAR(255) NOT NULL, "bay" VARCHAR(255) NOT NULL, "infrastructure_id" bigint NOT NULL REFERENCES "app_infrastructurematerial" ("id") DEFERRABLE INITIALLY DEFERRED, "link" VARCHAR(200) NULL);
CREATE TABLE IF NOT EXISTS "django_content_type" ("id" SERIAL PRIMARY KEY, "app_label" VARCHAR(100) NOT NULL, "model" VARCHAR(100) NOT NULL);
CREATE TABLE IF NOT EXISTS "" ("id" SERIAL PRIMARY KEY, "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "codename" VARCHAR(100) NOT NULL, "name" VARCHAR(255) NOT NULL);
CREATE TABLE IF NOT EXISTS "django_admin_log" ("id" SERIAL PRIMARY KEY, "object_id" text NULL, "object_repr" VARCHAR(200) NOT NULL, "action_flag" smallint NOT NULL CHECK ("action_flag" >= 0), "change_message" text NOT NULL, "content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" bigint NOT NULL REFERENCES "app_usuario" ("id") DEFERRABLE INITIALLY DEFERRED, "action_time" TIMESTAMP NOT NULL);
























BEGIN;

    
    BEGIN TRANSACTION;


INSERT INTO django_migrations VALUES(38,'contenttypes','0001_initial','2025-02-06 22:21:12.262936');
INSERT INTO django_migrations VALUES(39,'contenttypes','0002_remove_content_type_name','2025-02-06 22:21:12.286705');
INSERT INTO django_migrations VALUES(40,'auth','0001_initial','2025-02-06 22:21:12.304661');
INSERT INTO django_migrations VALUES(41,'auth','0002_alter_permission_name_max_length','2025-02-06 22:21:12.320447');
INSERT INTO django_migrations VALUES(42,'auth','0003_alter_user_email_max_length','2025-02-06 22:21:12.333499');
INSERT INTO django_migrations VALUES(43,'auth','0004_alter_user_username_opts','2025-02-06 22:21:12.345555');
INSERT INTO django_migrations VALUES(44,'auth','0005_alter_user_last_login_null','2025-02-06 22:21:12.359900');
INSERT INTO django_migrations VALUES(45,'auth','0006_require_contenttypes_0002','2025-02-06 22:21:12.366911');
INSERT INTO django_migrations VALUES(46,'auth','0007_alter_validators_add_error_messages','2025-02-06 22:21:12.374827');
INSERT INTO django_migrations VALUES(47,'auth','0008_alter_user_username_max_length','2025-02-06 22:21:12.383730');
INSERT INTO django_migrations VALUES(48,'auth','0009_alter_user_last_name_max_length','2025-02-06 22:21:12.400088');
INSERT INTO django_migrations VALUES(49,'auth','0010_alter_group_name_max_length','2025-02-06 22:21:12.409448');
INSERT INTO django_migrations VALUES(50,'auth','0011_update_proxy_permissions','2025-02-06 22:21:12.420302');
INSERT INTO django_migrations VALUES(51,'auth','0012_alter_user_first_name_max_length','2025-02-06 22:21:12.424597');
INSERT INTO django_migrations VALUES(52,'app','0001_initial','2025-02-06 22:21:12.611670');
INSERT INTO django_migrations VALUES(53,'admin','0001_initial','2025-02-06 22:21:12.632615');
INSERT INTO django_migrations VALUES(54,'admin','0002_logentry_remove_auto_add','2025-02-06 22:21:12.668189');
INSERT INTO django_migrations VALUES(55,'admin','0003_logentry_add_action_flag_choices','2025-02-06 22:21:12.693138');
INSERT INTO django_migrations VALUES(56,'sessions','0001_initial','2025-02-06 22:21:12.704693');


INSERT INTO django_session VALUES('n89m6gcrwlu000pqqvty6nhvt4sqtufd','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tf8IU:9CvzzQQSUcM94fq7wdFeZ3iqR59aKnAOqYDBSjGHe4s','2025-02-04 03:04:18.001452');
INSERT INTO django_session VALUES('vclevcu3vmf8b1e77aun01u8nj2k0bt9','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfRoV:fbaqU9oRtuJckOsumyYrgixuS19yZKuy0IpU5qovZpY','2025-02-04 23:54:39.753972');
INSERT INTO django_session VALUES('19e88npqh09xhd9306plcd4xxmddtou2','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfSpT:LEaaLiBKXqjdCwXLibkfUWof219r2iLTgr9sR3AyzBI','2025-02-05 00:59:43.257267');
INSERT INTO django_session VALUES('7n0crvvf08r420acwks9xtbl1ckgeqkp','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tfUnu:rETqNF7UQjZZAzlB2hxhFycwBVrxFoTWfEJR7KC3bWc','2025-02-05 03:06:14.047823');
INSERT INTO django_session VALUES('t1lx5sd93dtwb8b93jji3e5q60hf2jvd','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tfgyp:e8aKDcCstuhA080BiBiw5mqd7UVQPctRb8MoftfdW7Q','2025-02-05 16:06:19.124060');
INSERT INTO django_session VALUES('gp2kh2g9x20jie8ffqz2macfvapzkmi2','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfioS:jVXKbOz3ay6_B4Iw0t5AI7vCeO0bdP5wZbiR6d7tXLE','2025-02-05 18:03:44.527250');
INSERT INTO django_session VALUES('6cimrfdhbxiw4tjni863vilshqowkmfr','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfip9:yd381Z85z67YZoZp5hSZtlGxtXUxIZsfR56MLp4D_Mg','2025-02-05 18:04:27.122269');
INSERT INTO django_session VALUES('ugeao3q3hr9km76z4onb6lk3s796rsyg','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tfirJ:g1EMI0GXdmz_vaxn9lrKfO6nDQyE7boZsZJKmriQBJY','2025-02-05 18:06:41.770801');
INSERT INTO django_session VALUES('pmnktexzrx18m326u2ji3tgpz3fbj8da','.eJxVjMsOwiAQRf-FtSHIG5fu-w1kYAapGkhKuzL-uzbpQrf3nHNfLMK21rgNWuKM7MIsO_1uCfKD2g7wDu3Wee5tXebEd4UfdPCpIz2vh_t3UGHUb-0UJiuzUBac0K5AMdoAKAPekAwWQ9GE5L0OOgtPxfizJZIedM6QFHt_AOYUOEc:1tfiww:HSqz0QcOmvvXn1-k0ne1RAD9fA65Tp8QP-1HwaYkmi4','2025-02-05 18:12:30.679002');
INSERT INTO django_session VALUES('lcq8u315y616g8fimbsvemi9txq4j215','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tfk5V:4pf3keg3Xqrp8jGULf2i8e8wTboVojjdA5DHdNC3xMg','2025-02-05 19:25:25.624573');
INSERT INTO django_session VALUES('ujyu0cpseg6q2cqk2srmfcpiikfe0f52','.eJxVjMsOwiAQRf-FtSHIG5fu-w1kYAapGkhKuzL-uzbpQrf3nHNfLMK21rgNWuKM7MIsO_1uCfKD2g7wDu3Wee5tXebEd4UfdPCpIz2vh_t3UGHUb-0UJiuzUBac0K5AMdoAKAPekAwWQ9GE5L0OOgtPxfizJZIedM6QFHt_AOYUOEc:1tfk5m:6sm8VPUmzDyuYStP455N8UMUNPYXBO19Pr1i_9zF57w','2025-02-05 19:25:42.693757');
INSERT INTO django_session VALUES('v2dagfgl089l2ap34wpddbp8y5a41i4g','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfkXK:_uubXPp8cep-mKWhy8p_5AlOD4iAJeYNHIIKhUd1Myw','2025-02-05 19:54:10.751197');
INSERT INTO django_session VALUES('7nwzlzoqim5t1vru0wvjrxl2pxg45m0t','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tflVX:zSSCk8z1JGW3Nif3zLMKdrxk2v9UJ3BkRgsynzziiVw','2025-02-05 20:56:23.137265');
INSERT INTO django_session VALUES('968qrhd7aoq799byifccdzvs9d6hh3vq','.eJxVjMsOwiAQRf-FtSHIG5fu-w1kYAapGkhKuzL-uzbpQrf3nHNfLMK21rgNWuKM7MIsO_1uCfKD2g7wDu3Wee5tXebEd4UfdPCpIz2vh_t3UGHUb-0UJiuzUBac0K5AMdoAKAPekAwWQ9GE5L0OOgtPxfizJZIedM6QFHt_AOYUOEc:1tflhd:cdbsd3xJyzZvutA5zEDtDhgJqRQ9hjd9EvBEZch7O74','2025-02-05 21:08:53.968449');
INSERT INTO django_session VALUES('y2wt88swzgk05zaq2g3ssxyrx91u1guv','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfnAs:LmsQorgSyUtipooIsWhAcvHr7nXwPw5s65LwrbP4JF4','2025-02-05 22:43:10.532640');
INSERT INTO django_session VALUES('wlgikk3zldv9wu4a1fqbnb6v7l60ofja','.eJxVjEEOwiAQRe_C2hAoyIBL9z0DmWFAqoYmpV0Z765NutDtf-_9l4i4rTVuPS9xYnERgxWn35EwPXLbCd-x3WaZ5rYuE8ldkQftcpw5P6-H-3dQsddvbTnkYgmQvDJQ2LBPDAXBeWBG51AVNAietSKTUZ9DYGJvtfIQBi3eHzUWOKQ:1tfnnT:Z6voI6y6YOCHD6-EMGZAbQuMZDnSWNc82AvMb2EQXn0','2025-02-05 23:23:03.320220');
INSERT INTO django_session VALUES('f3ohnbn3rnasj3culj2j7cadwcd1y9hn','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tfokE:TYvIi7VZFIpccaT1TZcmcxAZlE1thfegBVZfyqTjOwY','2025-02-06 00:23:46.784363');
INSERT INTO django_session VALUES('tm9ipntfewkeor50tub51gm6hqu7zy0u','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfomC:0I3j1pAXwK57HdglHSN1Fk3xFX22N3fYPrCuueVnk8w','2025-02-06 00:25:48.515551');
INSERT INTO django_session VALUES('ffnx2zc79sj7x1e9py1onevnnqey2v19','.eJxVjEEOwiAQRe_C2hAoyIBL9z0DmWFAqoYmpV0Z765NutDtf-_9l4i4rTVuPS9xYnERgxWn35EwPXLbCd-x3WaZ5rYuE8ldkQftcpw5P6-H-3dQsddvbTnkYgmQvDJQ2LBPDAXBeWBG51AVNAietSKTUZ9DYGJvtfIQBi3eHzUWOKQ:1tfpv0:M9DhM6AgqgrwxZsMX0XYATXTNpr_3zXSx-9Aw2g827U','2025-02-06 01:38:58.283325');
INSERT INTO django_session VALUES('dzwr9lj0umdr19pk356nupfv1xlzh5kj','.eJxVjEEOwiAQRe_C2hCGAUpduvcMBIZBqoYmpV0Z765NutDtf-_9lwhxW2vYOi9hyuIsAMXpd0yRHtx2ku-x3WZJc1uXKcldkQft8jpnfl4O9--gxl6_dYHosiPybDxiVkw80GiscnbQYwaPoAuiJ-uAR2WQCjNbDeCAuCTx_gAGyDgK:1tfqI0:-8cEERyVJQGcqB5iZBcu6mjV_gNnqxnHVLHJgXND1dI','2025-02-06 02:02:44.029499');
INSERT INTO django_session VALUES('2w4yljwkwk08vda1ytdm28ki0pmjlw96','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tfrV8:cXmF9bDwdeZb4gwgh7FvA00mbfWCQoI8KnaVoLmWhiU','2025-02-06 03:20:22.800127');
INSERT INTO django_session VALUES('m4xmasn2tvm66ezjf894ttpor18s5s8u','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfrny:zhd5BUl3n8cNZmy0YgCzgjDH5DjHxh-wk_Me51OfwfI','2025-02-06 03:39:50.741841');
INSERT INTO django_session VALUES('jg2pgkcfgduqquvp11ejm5lod9eq08a2','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tfsRb:Tv3--xxsDg9NmcK1FLSBcgHFE-8Pt8A9_2lYtqb3a60','2025-02-06 04:20:47.860544');
INSERT INTO django_session VALUES('ksbinrfzydttgiuachuc93h9unien02s','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tg3jY:Gvid1s8rfF3Mo7ZUuHt22-7RfjavbkLVw7lHyBP-2xg','2025-02-06 16:24:04.738627');
INSERT INTO django_session VALUES('wgf7c4bpua6gvvfeu54236rv2qofybdf','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tg5pf:A4xqVYAwlBtUkbL5bSe37MWulv6BXucCFf8oM0lq-L4','2025-02-06 18:38:31.716679');
INSERT INTO django_session VALUES('l0pz2n2und0thmdh3vvk1z9gih0gb1v9','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tg8Vn:ct1G9ZuuiJ1UqSuCPPdiyuignZiPZ0jcDKxDJDv4pL8','2025-02-06 21:30:11.039288');
INSERT INTO django_session VALUES('7droiub6h8vfs4piouhzc2xa6cnna0r8','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tg8XJ:YojvHmSVHrF1vKeAnrNtdEUeEXnSPElZivyT-yIL2uw','2025-02-06 21:31:45.160040');
INSERT INTO django_session VALUES('7myn1tdafjc5hylxa3x3l90xxsr188za','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tg9db:l85IbzCTWrOcuAkRyYwXKLVEeeSF09skVKZMn8vKeEY','2025-02-06 22:42:19.949650');
INSERT INTO django_session VALUES('p2dks5tm54k3jpypvze4wwufzk6629an','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tgAgu:NiUoBtOHENjbKJhYTr6aYsUeDYWiKx_Af-Kg8nSkdhA','2025-02-06 23:49:48.368636');



-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);





-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);

INSERT INTO app_equipo VALUES(22,'Top 1',11);

INSERT INTO app_equipo_miembros VALUES(52,22,1);
INSERT INTO app_equipo_miembros VALUES(53,22,9);
INSERT INTO app_equipo_miembros VALUES(54,22,10);
INSERT INTO app_equipo_miembros VALUES(55,22,14);
INSERT INTO app_equipo_miembros VALUES(56,22,16);
INSERT INTO app_equipo_miembros VALUES(57,22,26);
INSERT INTO app_equipo_miembros VALUES(58,22,22);

INSERT INTO app_datamining VALUES(1,'jijija','data_mining/EMPLEADOS_1_5jpo4aa.xlsx','xdddd',19);
INSERT INTO app_datamining VALUES(2,'xddddddddd','data_mining/Tarea_Metricas.pdf','jijija',20);
INSERT INTO app_datamining VALUES(3,'xddd','data_mining/Diagnostico.docx','xddd',21);

-- ERROR: Revisión manual necesaria para la tabla app_execution
-- INSERT INTO app_execution VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_execution
-- INSERT INTO app_execution VALUES(...);

INSERT INTO app_resultfinal VALUES(1,'','',19);
INSERT INTO app_resultfinal VALUES(2,'','',20);

-- ERROR: Revisión manual necesaria para la tabla app_doe
-- INSERT INTO app_doe VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe
-- INSERT INTO app_doe VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe
-- INSERT INTO app_doe VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe
-- INSERT INTO app_doe VALUES(...);

-- ERROR: Revisión manual necesaria para la tabla app_infrastructurematerial
-- INSERT INTO app_infrastructurematerial VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_infrastructurematerial
-- INSERT INTO app_infrastructurematerial VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_infrastructurematerial
-- INSERT INTO app_infrastructurematerial VALUES(...);

INSERT INTO app_material VALUES(1,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(2,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(3,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(4,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(5,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(6,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(7,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(8,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(9,1,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(10,3,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(11,3,'K2V4','2552552','25555555');
INSERT INTO app_material VALUES(12,2,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(13,1,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(14,1,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(15,1,'K2V5','1000','25555555');
INSERT INTO app_material VALUES(16,1,'K2V4','1000','25555555');
INSERT INTO app_material VALUES(17,1,'K2V3','1000','25555555');
INSERT INTO app_material VALUES(18,1,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(19,3,'K2V3','1000','25555555');
INSERT INTO app_material VALUES(20,3,'K2V2','1000','25555555');

-- ERROR: Revisión manual necesaria para la tabla app_unidad
-- INSERT INTO app_unidad VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_unidad
-- INSERT INTO app_unidad VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_unidad
-- INSERT INTO app_unidad VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_unidad
-- INSERT INTO app_unidad VALUES(...);

INSERT INTO django_content_type VALUES(1,'app','usuario');
INSERT INTO django_content_type VALUES(2,'app','doe');
INSERT INTO django_content_type VALUES(3,'app','archivofase');
INSERT INTO django_content_type VALUES(4,'app','historialfase');
INSERT INTO django_content_type VALUES(5,'app','material');
INSERT INTO django_content_type VALUES(6,'app','doe_fase');
INSERT INTO django_content_type VALUES(7,'app','turnocomentario');
INSERT INTO django_content_type VALUES(8,'app','comentario');
INSERT INTO django_content_type VALUES(9,'app','chatmessage');
INSERT INTO django_content_type VALUES(10,'admin','logentry');
INSERT INTO django_content_type VALUES(11,'auth','permission');
INSERT INTO django_content_type VALUES(12,'auth','group');
INSERT INTO django_content_type VALUES(13,'contenttypes','contenttype');
INSERT INTO django_content_type VALUES(14,'sessions','session');
INSERT INTO django_content_type VALUES(15,'app','equipo');
INSERT INTO django_content_type VALUES(16,'app','infrastructurematerial');
INSERT INTO django_content_type VALUES(17,'app','execution');
INSERT INTO django_content_type VALUES(18,'app','datamining');
INSERT INTO django_content_type VALUES(19,'app','resultfinal');
INSERT INTO django_content_type VALUES(20,'app','unidad');

INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(1,1,'add_usuario','Can add user');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(2,1,'change_usuario','Can change user');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(3,1,'delete_usuario','Can delete user');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(4,1,'view_usuario','Can view user');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(5,2,'add_doe','Can add doe');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(6,2,'change_doe','Can change doe');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(7,2,'delete_doe','Can delete doe');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(8,2,'view_doe','Can view doe');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(9,3,'add_archivofase','Can add archivo fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(10,3,'change_archivofase','Can change archivo fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(11,3,'delete_archivofase','Can delete archivo fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(12,3,'view_archivofase','Can view archivo fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(13,4,'add_historialfase','Can add historial fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(14,4,'change_historialfase','Can change historial fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(15,4,'delete_historialfase','Can delete historial fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(16,4,'view_historialfase','Can view historial fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(17,5,'add_material','Can add material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(18,5,'change_material','Can change material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(19,5,'delete_material','Can delete material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(20,5,'view_material','Can view material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(21,6,'add_doe_fase','Can add do e_ fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(22,6,'change_doe_fase','Can change do e_ fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(23,6,'delete_doe_fase','Can delete do e_ fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(24,6,'view_doe_fase','Can view do e_ fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(25,7,'add_turnocomentario','Can add turno comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(26,7,'change_turnocomentario','Can change turno comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(27,7,'delete_turnocomentario','Can delete turno comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(28,7,'view_turnocomentario','Can view turno comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(29,8,'add_comentario','Can add comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(30,8,'change_comentario','Can change comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(31,8,'delete_comentario','Can delete comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(32,8,'view_comentario','Can view comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(33,9,'add_chatmessage','Can add chat message');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(34,9,'change_chatmessage','Can change chat message');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(35,9,'delete_chatmessage','Can delete chat message');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(36,9,'view_chatmessage','Can view chat message');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(37,10,'add_logentry','Can add log entry');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(38,10,'change_logentry','Can change log entry');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(39,10,'delete_logentry','Can delete log entry');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(40,10,'view_logentry','Can view log entry');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(41,11,'add_permission','Can add permission');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(42,11,'change_permission','Can change permission');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(43,11,'delete_permission','Can delete permission');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(44,11,'view_permission','Can view permission');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(45,12,'add_group','Can add group');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(46,12,'change_group','Can change group');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(47,12,'delete_group','Can delete group');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(48,12,'view_group','Can view group');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(49,13,'add_contenttype','Can add content type');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(50,13,'change_contenttype','Can change content type');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(51,13,'delete_contenttype','Can delete content type');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(52,13,'view_contenttype','Can view content type');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(53,14,'add_session','Can add session');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(54,14,'change_session','Can change session');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(55,14,'delete_session','Can delete session');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(56,14,'view_session','Can view session');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(57,15,'add_equipo','Can add equipo');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(58,15,'change_equipo','Can change equipo');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(59,15,'delete_equipo','Can delete equipo');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(60,15,'view_equipo','Can view equipo');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(61,16,'add_infrastructurematerial','Can add infrastructure material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(62,16,'change_infrastructurematerial','Can change infrastructure material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(63,16,'delete_infrastructurematerial','Can delete infrastructure material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(64,16,'view_infrastructurematerial','Can view infrastructure material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(65,17,'add_execution','Can add execution');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(66,17,'change_execution','Can change execution');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(67,17,'delete_execution','Can delete execution');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(68,17,'view_execution','Can view execution');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(69,18,'add_datamining','Can add data mining');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(70,18,'change_datamining','Can change data mining');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(71,18,'delete_datamining','Can delete data mining');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(72,18,'view_datamining','Can view data mining');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(73,19,'add_resultfinal','Can add result final');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(74,19,'change_resultfinal','Can change result final');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(75,19,'delete_resultfinal','Can delete result final');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(76,19,'view_resultfinal','Can view result final');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(77,20,'add_unidad','Can add unidad');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(78,20,'change_unidad','Can change unidad');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(79,20,'delete_unidad','Can delete unidad');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(80,20,'view_unidad','Can view unidad');

-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
DELETE FROM sqlite_sequence;
CREATE UNIQUE INDEX "app_usuario_groups_usuario_id_group_id_0f4abc88_uniq" ON "app_usuario_groups" ("usuario_id", "group_id");
CREATE INDEX "app_usuario_groups_usuario_id_691971dd" ON "app_usuario_groups" ("usuario_id");
CREATE INDEX "app_usuario_groups_group_id_b38b0d6e" ON "app_usuario_groups" ("group_id");
CREATE UNIQUE INDEX "app_usuario_user_permissions_usuario_id_permission_id_6fd11793_uniq" ON "app_usuario_user_permissions" ("usuario_id", "permission_id");
CREATE INDEX "app_usuario_user_permissions_usuario_id_d2c76ed5" ON "app_usuario_user_permissions" ("usuario_id");
CREATE INDEX "app_usuario_user_permissions_permission_id_fbaf8fa8" ON "app_usuario_user_permissions" ("permission_id");
CREATE INDEX "django_session_expire_date_a5c62663" ON "django_session" ("expire_date");
CREATE INDEX "app_archivofase_doe_id_15e70f9e" ON "app_archivofase" ("doe_id");
CREATE INDEX "app_archivofase_subido_por_id_eaa050c7" ON "app_archivofase" ("subido_por_id");
CREATE INDEX "app_historialfase_cambiado_por_id_b917c17d" ON "app_historialfase" ("cambiado_por_id");
CREATE INDEX "app_historialfase_doe_id_b8764d39" ON "app_historialfase" ("doe_id");
CREATE INDEX "app_doe_fase_doe_id_29c89fea" ON "app_doe_fase" ("doe_id");
CREATE UNIQUE INDEX "app_doe_fases_doe_id_doe_fase_id_a0038dde_uniq" ON "app_doe_fases" ("doe_id", "doe_fase_id");
CREATE INDEX "app_doe_fases_doe_id_b2a6e550" ON "app_doe_fases" ("doe_id");
CREATE INDEX "app_doe_fases_doe_fase_id_289648b4" ON "app_doe_fases" ("doe_fase_id");
CREATE UNIQUE INDEX "app_turnocomentario_doe_id_usuario_id_a69d02b4_uniq" ON "app_turnocomentario" ("doe_id", "usuario_id");
CREATE INDEX "app_turnocomentario_doe_id_a6b5088d" ON "app_turnocomentario" ("doe_id");
CREATE INDEX "app_turnocomentario_usuario_id_33ba2cdf" ON "app_turnocomentario" ("usuario_id");
CREATE INDEX "app_comentario_autor_id_0cc472a6" ON "app_comentario" ("autor_id");
CREATE INDEX "app_comentario_doe_id_4580b502" ON "app_comentario" ("doe_id");
CREATE INDEX "app_chatmessage_doe_id_e738519a" ON "app_chatmessage" ("doe_id");
CREATE INDEX "app_chatmessage_usuario_id_6a2b0872" ON "app_chatmessage" ("usuario_id");
CREATE INDEX "app_equipo_creado_por_id_953ef182" ON "app_equipo" ("creado_por_id");
CREATE UNIQUE INDEX "app_equipo_miembros_equipo_id_usuario_id_a95e4911_uniq" ON "app_equipo_miembros" ("equipo_id", "usuario_id");
CREATE INDEX "app_equipo_miembros_equipo_id_a7173309" ON "app_equipo_miembros" ("equipo_id");
CREATE INDEX "app_equipo_miembros_usuario_id_0e840c63" ON "app_equipo_miembros" ("usuario_id");
CREATE INDEX "app_doe_creado_por_id_23d6a73f" ON "app_doe" ("creado_por_id");
CREATE INDEX "app_doe_equipo_id_55794f0e" ON "app_doe" ("equipo_id");
CREATE INDEX "app_material_infrastructure_id_cc57f31c" ON "app_material" ("infrastructure_id");
CREATE INDEX "app_unidad_infrastructure_id_12d5a3b4" ON "app_unidad" ("infrastructure_id");
CREATE UNIQUE INDEX "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" ("app_label", "model");
CREATE UNIQUE INDEX "auth_permission_content_type_id_codename_01ab375a_uniq" ON "" ("content_type_id", "codename");
CREATE INDEX "auth_permission_content_type_id_2f476e4b" ON "" ("content_type_id");
CREATE INDEX "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" ("content_type_id");
CREATE INDEX "django_admin_log_user_id_c564eba6" ON "django_admin_log" ("user_id");


COMMIT;
INSERT INTO django_migrations VALUES(38,'contenttypes','0001_initial','2025-02-06 22:21:12.262936');
INSERT INTO django_migrations VALUES(39,'contenttypes','0002_remove_content_type_name','2025-02-06 22:21:12.286705');
INSERT INTO django_migrations VALUES(40,'auth','0001_initial','2025-02-06 22:21:12.304661');
INSERT INTO django_migrations VALUES(41,'auth','0002_alter_permission_name_max_length','2025-02-06 22:21:12.320447');
INSERT INTO django_migrations VALUES(42,'auth','0003_alter_user_email_max_length','2025-02-06 22:21:12.333499');
INSERT INTO django_migrations VALUES(43,'auth','0004_alter_user_username_opts','2025-02-06 22:21:12.345555');
INSERT INTO django_migrations VALUES(44,'auth','0005_alter_user_last_login_null','2025-02-06 22:21:12.359900');
INSERT INTO django_migrations VALUES(45,'auth','0006_require_contenttypes_0002','2025-02-06 22:21:12.366911');
INSERT INTO django_migrations VALUES(46,'auth','0007_alter_validators_add_error_messages','2025-02-06 22:21:12.374827');
INSERT INTO django_migrations VALUES(47,'auth','0008_alter_user_username_max_length','2025-02-06 22:21:12.383730');
INSERT INTO django_migrations VALUES(48,'auth','0009_alter_user_last_name_max_length','2025-02-06 22:21:12.400088');
INSERT INTO django_migrations VALUES(49,'auth','0010_alter_group_name_max_length','2025-02-06 22:21:12.409448');
INSERT INTO django_migrations VALUES(50,'auth','0011_update_proxy_permissions','2025-02-06 22:21:12.420302');
INSERT INTO django_migrations VALUES(51,'auth','0012_alter_user_first_name_max_length','2025-02-06 22:21:12.424597');
INSERT INTO django_migrations VALUES(52,'app','0001_initial','2025-02-06 22:21:12.611670');
INSERT INTO django_migrations VALUES(53,'admin','0001_initial','2025-02-06 22:21:12.632615');
INSERT INTO django_migrations VALUES(54,'admin','0002_logentry_remove_auto_add','2025-02-06 22:21:12.668189');
INSERT INTO django_migrations VALUES(55,'admin','0003_logentry_add_action_flag_choices','2025-02-06 22:21:12.693138');
INSERT INTO django_migrations VALUES(56,'sessions','0001_initial','2025-02-06 22:21:12.704693');
INSERT INTO django_session VALUES('n89m6gcrwlu000pqqvty6nhvt4sqtufd','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tf8IU:9CvzzQQSUcM94fq7wdFeZ3iqR59aKnAOqYDBSjGHe4s','2025-02-04 03:04:18.001452');
INSERT INTO django_session VALUES('vclevcu3vmf8b1e77aun01u8nj2k0bt9','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfRoV:fbaqU9oRtuJckOsumyYrgixuS19yZKuy0IpU5qovZpY','2025-02-04 23:54:39.753972');
INSERT INTO django_session VALUES('19e88npqh09xhd9306plcd4xxmddtou2','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfSpT:LEaaLiBKXqjdCwXLibkfUWof219r2iLTgr9sR3AyzBI','2025-02-05 00:59:43.257267');
INSERT INTO django_session VALUES('7n0crvvf08r420acwks9xtbl1ckgeqkp','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tfUnu:rETqNF7UQjZZAzlB2hxhFycwBVrxFoTWfEJR7KC3bWc','2025-02-05 03:06:14.047823');
INSERT INTO django_session VALUES('t1lx5sd93dtwb8b93jji3e5q60hf2jvd','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tfgyp:e8aKDcCstuhA080BiBiw5mqd7UVQPctRb8MoftfdW7Q','2025-02-05 16:06:19.124060');
INSERT INTO django_session VALUES('gp2kh2g9x20jie8ffqz2macfvapzkmi2','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfioS:jVXKbOz3ay6_B4Iw0t5AI7vCeO0bdP5wZbiR6d7tXLE','2025-02-05 18:03:44.527250');
INSERT INTO django_session VALUES('6cimrfdhbxiw4tjni863vilshqowkmfr','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfip9:yd381Z85z67YZoZp5hSZtlGxtXUxIZsfR56MLp4D_Mg','2025-02-05 18:04:27.122269');
INSERT INTO django_session VALUES('ugeao3q3hr9km76z4onb6lk3s796rsyg','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tfirJ:g1EMI0GXdmz_vaxn9lrKfO6nDQyE7boZsZJKmriQBJY','2025-02-05 18:06:41.770801');
INSERT INTO django_session VALUES('pmnktexzrx18m326u2ji3tgpz3fbj8da','.eJxVjMsOwiAQRf-FtSHIG5fu-w1kYAapGkhKuzL-uzbpQrf3nHNfLMK21rgNWuKM7MIsO_1uCfKD2g7wDu3Wee5tXebEd4UfdPCpIz2vh_t3UGHUb-0UJiuzUBac0K5AMdoAKAPekAwWQ9GE5L0OOgtPxfizJZIedM6QFHt_AOYUOEc:1tfiww:HSqz0QcOmvvXn1-k0ne1RAD9fA65Tp8QP-1HwaYkmi4','2025-02-05 18:12:30.679002');
INSERT INTO django_session VALUES('lcq8u315y616g8fimbsvemi9txq4j215','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tfk5V:4pf3keg3Xqrp8jGULf2i8e8wTboVojjdA5DHdNC3xMg','2025-02-05 19:25:25.624573');
INSERT INTO django_session VALUES('ujyu0cpseg6q2cqk2srmfcpiikfe0f52','.eJxVjMsOwiAQRf-FtSHIG5fu-w1kYAapGkhKuzL-uzbpQrf3nHNfLMK21rgNWuKM7MIsO_1uCfKD2g7wDu3Wee5tXebEd4UfdPCpIz2vh_t3UGHUb-0UJiuzUBac0K5AMdoAKAPekAwWQ9GE5L0OOgtPxfizJZIedM6QFHt_AOYUOEc:1tfk5m:6sm8VPUmzDyuYStP455N8UMUNPYXBO19Pr1i_9zF57w','2025-02-05 19:25:42.693757');
INSERT INTO django_session VALUES('v2dagfgl089l2ap34wpddbp8y5a41i4g','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfkXK:_uubXPp8cep-mKWhy8p_5AlOD4iAJeYNHIIKhUd1Myw','2025-02-05 19:54:10.751197');
INSERT INTO django_session VALUES('7nwzlzoqim5t1vru0wvjrxl2pxg45m0t','.eJxVjEsOwiAUAO_C2pDyK-DSfc9A4D2eVA0kpV0Z725IutDtzGTeLMRjL-HoeQsrsisz7PLLUoRnrkPgI9Z749Dqvq2Jj4SftvOlYX7dzvZvUGIvYwsopJdKaufIkTTJKZoJtDdEMc0GpfU6StIZgVCobNwksgU_eSsEsM8X49E37g:1tflVX:zSSCk8z1JGW3Nif3zLMKdrxk2v9UJ3BkRgsynzziiVw','2025-02-05 20:56:23.137265');
INSERT INTO django_session VALUES('968qrhd7aoq799byifccdzvs9d6hh3vq','.eJxVjMsOwiAQRf-FtSHIG5fu-w1kYAapGkhKuzL-uzbpQrf3nHNfLMK21rgNWuKM7MIsO_1uCfKD2g7wDu3Wee5tXebEd4UfdPCpIz2vh_t3UGHUb-0UJiuzUBac0K5AMdoAKAPekAwWQ9GE5L0OOgtPxfizJZIedM6QFHt_AOYUOEc:1tflhd:cdbsd3xJyzZvutA5zEDtDhgJqRQ9hjd9EvBEZch7O74','2025-02-05 21:08:53.968449');
INSERT INTO django_session VALUES('y2wt88swzgk05zaq2g3ssxyrx91u1guv','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfnAs:LmsQorgSyUtipooIsWhAcvHr7nXwPw5s65LwrbP4JF4','2025-02-05 22:43:10.532640');
INSERT INTO django_session VALUES('wlgikk3zldv9wu4a1fqbnb6v7l60ofja','.eJxVjEEOwiAQRe_C2hAoyIBL9z0DmWFAqoYmpV0Z765NutDtf-_9l4i4rTVuPS9xYnERgxWn35EwPXLbCd-x3WaZ5rYuE8ldkQftcpw5P6-H-3dQsddvbTnkYgmQvDJQ2LBPDAXBeWBG51AVNAietSKTUZ9DYGJvtfIQBi3eHzUWOKQ:1tfnnT:Z6voI6y6YOCHD6-EMGZAbQuMZDnSWNc82AvMb2EQXn0','2025-02-05 23:23:03.320220');
INSERT INTO django_session VALUES('f3ohnbn3rnasj3culj2j7cadwcd1y9hn','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tfokE:TYvIi7VZFIpccaT1TZcmcxAZlE1thfegBVZfyqTjOwY','2025-02-06 00:23:46.784363');
INSERT INTO django_session VALUES('tm9ipntfewkeor50tub51gm6hqu7zy0u','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfomC:0I3j1pAXwK57HdglHSN1Fk3xFX22N3fYPrCuueVnk8w','2025-02-06 00:25:48.515551');
INSERT INTO django_session VALUES('ffnx2zc79sj7x1e9py1onevnnqey2v19','.eJxVjEEOwiAQRe_C2hAoyIBL9z0DmWFAqoYmpV0Z765NutDtf-_9l4i4rTVuPS9xYnERgxWn35EwPXLbCd-x3WaZ5rYuE8ldkQftcpw5P6-H-3dQsddvbTnkYgmQvDJQ2LBPDAXBeWBG51AVNAietSKTUZ9DYGJvtfIQBi3eHzUWOKQ:1tfpv0:M9DhM6AgqgrwxZsMX0XYATXTNpr_3zXSx-9Aw2g827U','2025-02-06 01:38:58.283325');
INSERT INTO django_session VALUES('dzwr9lj0umdr19pk356nupfv1xlzh5kj','.eJxVjEEOwiAQRe_C2hCGAUpduvcMBIZBqoYmpV0Z765NutDtf-_9lwhxW2vYOi9hyuIsAMXpd0yRHtx2ku-x3WZJc1uXKcldkQft8jpnfl4O9--gxl6_dYHosiPybDxiVkw80GiscnbQYwaPoAuiJ-uAR2WQCjNbDeCAuCTx_gAGyDgK:1tfqI0:-8cEERyVJQGcqB5iZBcu6mjV_gNnqxnHVLHJgXND1dI','2025-02-06 02:02:44.029499');
INSERT INTO django_session VALUES('2w4yljwkwk08vda1ytdm28ki0pmjlw96','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tfrV8:cXmF9bDwdeZb4gwgh7FvA00mbfWCQoI8KnaVoLmWhiU','2025-02-06 03:20:22.800127');
INSERT INTO django_session VALUES('m4xmasn2tvm66ezjf894ttpor18s5s8u','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tfrny:zhd5BUl3n8cNZmy0YgCzgjDH5DjHxh-wk_Me51OfwfI','2025-02-06 03:39:50.741841');
INSERT INTO django_session VALUES('jg2pgkcfgduqquvp11ejm5lod9eq08a2','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tfsRb:Tv3--xxsDg9NmcK1FLSBcgHFE-8Pt8A9_2lYtqb3a60','2025-02-06 04:20:47.860544');
INSERT INTO django_session VALUES('ksbinrfzydttgiuachuc93h9unien02s','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tg3jY:Gvid1s8rfF3Mo7ZUuHt22-7RfjavbkLVw7lHyBP-2xg','2025-02-06 16:24:04.738627');
INSERT INTO django_session VALUES('wgf7c4bpua6gvvfeu54236rv2qofybdf','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tg5pf:A4xqVYAwlBtUkbL5bSe37MWulv6BXucCFf8oM0lq-L4','2025-02-06 18:38:31.716679');
INSERT INTO django_session VALUES('l0pz2n2und0thmdh3vvk1z9gih0gb1v9','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tg8Vn:ct1G9ZuuiJ1UqSuCPPdiyuignZiPZ0jcDKxDJDv4pL8','2025-02-06 21:30:11.039288');
INSERT INTO django_session VALUES('7droiub6h8vfs4piouhzc2xa6cnna0r8','.eJxVjDsOwjAQBe_iGlnrLzYlfc5grb1rHECxlE-FuDtESgHtm5n3Egm3taVt4TmNJC5CidPvlrE8eNoB3XG6dVn6tM5jlrsiD7rIoRM_r4f7d9Bwad-aA5GrSKBNjSqEHEsEG0phhlzROeu9VhCVQa1BOaoVLCMEjS6ejRfvD_FlN5s:1tg8XJ:YojvHmSVHrF1vKeAnrNtdEUeEXnSPElZivyT-yIL2uw','2025-02-06 21:31:45.160040');
INSERT INTO django_session VALUES('7myn1tdafjc5hylxa3x3l90xxsr188za','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tg9db:l85IbzCTWrOcuAkRyYwXKLVEeeSF09skVKZMn8vKeEY','2025-02-06 22:42:19.949650');
INSERT INTO django_session VALUES('p2dks5tm54k3jpypvze4wwufzk6629an','.eJxVjEEOwiAQRe_C2pAO0w7g0r1nIAMDUjVtUtqV8e7apAvd_vfef6nA21rD1vISRlFnBaBOv2Pk9MjTTuTO023WaZ7WZYx6V_RBm77Okp-Xw_07qNzqt_aMPTvy6NFGD5BLx4DkjBmKNWwldWQJqbdABD4JiynFDA57EMCo3h_YGzbo:1tgAgu:NiUoBtOHENjbKJhYTr6aYsUeDYWiKx_Af-Kg8nSkdhA','2025-02-06 23:49:48.368636');
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe_fase
-- INSERT INTO app_doe_fase VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_usuario
-- INSERT INTO app_usuario VALUES(...);
INSERT INTO app_equipo VALUES(22,'Top 1',11);
INSERT INTO app_equipo_miembros VALUES(52,22,1);
INSERT INTO app_equipo_miembros VALUES(53,22,9);
INSERT INTO app_equipo_miembros VALUES(54,22,10);
INSERT INTO app_equipo_miembros VALUES(55,22,14);
INSERT INTO app_equipo_miembros VALUES(56,22,16);
INSERT INTO app_equipo_miembros VALUES(57,22,26);
INSERT INTO app_equipo_miembros VALUES(58,22,22);
INSERT INTO app_datamining VALUES(1,'jijija','data_mining/EMPLEADOS_1_5jpo4aa.xlsx','xdddd',19);
INSERT INTO app_datamining VALUES(2,'xddddddddd','data_mining/Tarea_Metricas.pdf','jijija',20);
INSERT INTO app_datamining VALUES(3,'xddd','data_mining/Diagnostico.docx','xddd',21);
-- ERROR: Revisión manual necesaria para la tabla app_execution
-- INSERT INTO app_execution VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_execution
-- INSERT INTO app_execution VALUES(...);
INSERT INTO app_resultfinal VALUES(1,'','',19);
INSERT INTO app_resultfinal VALUES(2,'','',20);
-- ERROR: Revisión manual necesaria para la tabla app_doe
-- INSERT INTO app_doe VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe
-- INSERT INTO app_doe VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe
-- INSERT INTO app_doe VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_doe
-- INSERT INTO app_doe VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_infrastructurematerial
-- INSERT INTO app_infrastructurematerial VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_infrastructurematerial
-- INSERT INTO app_infrastructurematerial VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_infrastructurematerial
-- INSERT INTO app_infrastructurematerial VALUES(...);
INSERT INTO app_material VALUES(1,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(2,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(3,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(4,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(5,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(6,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(7,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(8,1,'Desconocido',NULL,NULL);
INSERT INTO app_material VALUES(9,1,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(10,3,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(11,3,'K2V4','2552552','25555555');
INSERT INTO app_material VALUES(12,2,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(13,1,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(14,1,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(15,1,'K2V5','1000','25555555');
INSERT INTO app_material VALUES(16,1,'K2V4','1000','25555555');
INSERT INTO app_material VALUES(17,1,'K2V3','1000','25555555');
INSERT INTO app_material VALUES(18,1,'BaseBoard','1000','25555555');
INSERT INTO app_material VALUES(19,3,'K2V3','1000','25555555');
INSERT INTO app_material VALUES(20,3,'K2V2','1000','25555555');
-- ERROR: Revisión manual necesaria para la tabla app_unidad
-- INSERT INTO app_unidad VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_unidad
-- INSERT INTO app_unidad VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_unidad
-- INSERT INTO app_unidad VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla app_unidad
-- INSERT INTO app_unidad VALUES(...);
INSERT INTO django_content_type VALUES(1,'app','usuario');
INSERT INTO django_content_type VALUES(2,'app','doe');
INSERT INTO django_content_type VALUES(3,'app','archivofase');
INSERT INTO django_content_type VALUES(4,'app','historialfase');
INSERT INTO django_content_type VALUES(5,'app','material');
INSERT INTO django_content_type VALUES(6,'app','doe_fase');
INSERT INTO django_content_type VALUES(7,'app','turnocomentario');
INSERT INTO django_content_type VALUES(8,'app','comentario');
INSERT INTO django_content_type VALUES(9,'app','chatmessage');
INSERT INTO django_content_type VALUES(10,'admin','logentry');
INSERT INTO django_content_type VALUES(11,'auth','permission');
INSERT INTO django_content_type VALUES(12,'auth','group');
INSERT INTO django_content_type VALUES(13,'contenttypes','contenttype');
INSERT INTO django_content_type VALUES(14,'sessions','session');
INSERT INTO django_content_type VALUES(15,'app','equipo');
INSERT INTO django_content_type VALUES(16,'app','infrastructurematerial');
INSERT INTO django_content_type VALUES(17,'app','execution');
INSERT INTO django_content_type VALUES(18,'app','datamining');
INSERT INTO django_content_type VALUES(19,'app','resultfinal');
INSERT INTO django_content_type VALUES(20,'app','unidad');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(1,1,'add_usuario','Can add user');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(2,1,'change_usuario','Can change user');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(3,1,'delete_usuario','Can delete user');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(4,1,'view_usuario','Can view user');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(5,2,'add_doe','Can add doe');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(6,2,'change_doe','Can change doe');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(7,2,'delete_doe','Can delete doe');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(8,2,'view_doe','Can view doe');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(9,3,'add_archivofase','Can add archivo fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(10,3,'change_archivofase','Can change archivo fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(11,3,'delete_archivofase','Can delete archivo fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(12,3,'view_archivofase','Can view archivo fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(13,4,'add_historialfase','Can add historial fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(14,4,'change_historialfase','Can change historial fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(15,4,'delete_historialfase','Can delete historial fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(16,4,'view_historialfase','Can view historial fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(17,5,'add_material','Can add material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(18,5,'change_material','Can change material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(19,5,'delete_material','Can delete material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(20,5,'view_material','Can view material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(21,6,'add_doe_fase','Can add do e_ fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(22,6,'change_doe_fase','Can change do e_ fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(23,6,'delete_doe_fase','Can delete do e_ fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(24,6,'view_doe_fase','Can view do e_ fase');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(25,7,'add_turnocomentario','Can add turno comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(26,7,'change_turnocomentario','Can change turno comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(27,7,'delete_turnocomentario','Can delete turno comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(28,7,'view_turnocomentario','Can view turno comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(29,8,'add_comentario','Can add comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(30,8,'change_comentario','Can change comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(31,8,'delete_comentario','Can delete comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(32,8,'view_comentario','Can view comentario');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(33,9,'add_chatmessage','Can add chat message');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(34,9,'change_chatmessage','Can change chat message');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(35,9,'delete_chatmessage','Can delete chat message');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(36,9,'view_chatmessage','Can view chat message');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(37,10,'add_logentry','Can add log entry');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(38,10,'change_logentry','Can change log entry');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(39,10,'delete_logentry','Can delete log entry');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(40,10,'view_logentry','Can view log entry');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(41,11,'add_permission','Can add permission');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(42,11,'change_permission','Can change permission');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(43,11,'delete_permission','Can delete permission');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(44,11,'view_permission','Can view permission');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(45,12,'add_group','Can add group');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(46,12,'change_group','Can change group');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(47,12,'delete_group','Can delete group');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(48,12,'view_group','Can view group');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(49,13,'add_contenttype','Can add content type');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(50,13,'change_contenttype','Can change content type');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(51,13,'delete_contenttype','Can delete content type');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(52,13,'view_contenttype','Can view content type');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(53,14,'add_session','Can add session');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(54,14,'change_session','Can change session');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(55,14,'delete_session','Can delete session');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(56,14,'view_session','Can view session');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(57,15,'add_equipo','Can add equipo');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(58,15,'change_equipo','Can change equipo');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(59,15,'delete_equipo','Can delete equipo');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(60,15,'view_equipo','Can view equipo');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(61,16,'add_infrastructurematerial','Can add infrastructure material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(62,16,'change_infrastructurematerial','Can change infrastructure material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(63,16,'delete_infrastructurematerial','Can delete infrastructure material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(64,16,'view_infrastructurematerial','Can view infrastructure material');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(65,17,'add_execution','Can add execution');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(66,17,'change_execution','Can change execution');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(67,17,'delete_execution','Can delete execution');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(68,17,'view_execution','Can view execution');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(69,18,'add_datamining','Can add data mining');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(70,18,'change_datamining','Can change data mining');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(71,18,'delete_datamining','Can delete data mining');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(72,18,'view_datamining','Can view data mining');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(73,19,'add_resultfinal','Can add result final');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(74,19,'change_resultfinal','Can change result final');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(75,19,'delete_resultfinal','Can delete result final');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(76,19,'view_resultfinal','Can view result final');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(77,20,'add_unidad','Can add unidad');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(78,20,'change_unidad','Can change unidad');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(79,20,'delete_unidad','Can delete unidad');
INSERT INTO permisos (id, permission_group, permission_name, description) VALUES(80,20,'view_unidad','Can view unidad');
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
-- ERROR: Revisión manual necesaria para la tabla django_admin_log
-- INSERT INTO django_admin_log VALUES(...);
INSERT INTO sqlite_sequence VALUES('app_execution',2);