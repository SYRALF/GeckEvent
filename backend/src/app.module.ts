import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsuariosModule } from './usuarios/usuarios.module';
import { EventosModule } from './eventos/eventos.module';
import { InscripcionesModule } from './inscripciones/inscripciones.module';
import { AsistenciaModule } from './asistencia/asistencia.module';
import { CertificacionesModule } from './certificaciones/certificaciones.module';

@Module({
  imports: [AuthModule, UsuariosModule, EventosModule, InscripcionesModule, AsistenciaModule, CertificacionesModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
