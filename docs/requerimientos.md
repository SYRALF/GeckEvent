# REQUERIMIENTOS FUNCIONALES

## Módulo 1: Autenticación y Usuarios (AUTH)
| ID | REQUERIMIENTO | PRIORIDAD |
|--------|----------|----------|
| RF-01 | El sistema debe permitir el registro de nuevos usuarios con nombre, apellido, correo electrónico y contraseña. | Alta |
| RF-02 | El sistema debe permitir el inicio de sesión mediante correo y contraseña, retornando un token JWT válido. | Alta |
| RF-03 | El sistema debe soportar tres roles de usuario: Administrador, Organizador y Participante, con permisos diferenciados. | Alta |
| RF-04 | El sistema debe permitir al Administrador activar, desactivar y eliminar usuarios del sistema. | Alta |
| RF-05 | El sistema debe permitir al usuario actualizar su información de perfil (nombre, apellido, contraseña). | Media |
| RF-06 | El sistema debe cerrar la sesión del usuario invalidando el token JWT activo. | Media |

## Módulo 2: Gestión de Eventos (EVENTOS)
| ID | REQUERIMIENTO | PRIORIDAD |
|--------|----------|----------|
| RF-07 | El sistema debe permitir al Administrador y Organizador crear nuevos eventos con título, descripción, fecha de inicio, fecha de fin, ubicación, cupo máximo y categoría. | Alta |
| RF-08 | El sistema debe permitir al Administrador y Organizador editar los datos de un evento existente. | Alta |
| RF-09 | El sistema debe permitir al Administrador cancelar o eliminar un evento. | Alta |
| RF-10 | El sistema debe manejar los siguientes estados de un evento: BORRADOR, PUBLICADO, CANCELADO y FINALIZADO. | Alta |
| RF-11 | El sistema debe listar todos los eventos publicados con opción de filtrado por categoría, fecha y estado. | Alta |
| RF-12 | El sistema debe mostrar el detalle completo de un evento incluyendo cupo disponible y lista de categorías. | Media |
| RF-13 | El sistema debe permitir la carga de una imagen representativa por evento. | Baja |

## Módulo 3: Inscripciones (INSCRIPCIONES)
| ID | REQUERIMIENTO | PRIORIDAD |
|--------|----------|----------|
| RF-14 | El sistema debe permitir a un Participante inscribirse a un evento publicado con cupo disponible. | Alta |
| RF-15 | El sistema debe permitir que un participante se inscriba dos veces al mismo evento | Alta |
| RF-16 | El sistema debe permitir a un Participante cancelar su inscripción a un evento antes de su fecha de inicio. | Alta |
| RF-17 | El sistema debe mostrar al Organizador la lista completa de participantes inscritos a su evento. | Alta |
| RF-18 | El sistema debe reducir automáticamente el cupo disponible al registrar una nueva inscripción. | Alta |
| RF-19 | El sistema debe notificar al Participante mediante correo electrónico al confirmar su inscripción. | Media |

## Módulo 4: Control de Asistencia (ASISTENCIA)
| ID | REQUERIMIENTO | PRIORIDAD |
|--------|----------|----------|
| RF-20 | El sistema debe permitir al Organizador marcar la asistencia de cada participante inscrito a un evento. | Alta |
| RF-21 | El sistema debe registrar la fecha y hora en que se marcó la asistencia de cada participante. | Alta |
| RF-22 | El sistema debe registrar qué usuario (Organizador o Administrador) marcó la asistencia. | Media |
| RF-23 | El sistema debe mostrar un resumen de asistencia por evento (total inscritos vs. total asistentes). | Media |

## Módulo 5: Certificaciones Digitales (CERTIFICACIONES)
| ID | REQUERIMIENTO | PRIORIDAD |
|--------|----------|----------|
| RF-24 | El sistema debe generar automáticamente un certificado en formato PDF cuando se confirma la asistencia de un participante a un evento finalizado. | Alta |
| RF-25 | El certificado debe incluir: nombre completo del participante, nombre del evento, fecha de realización, horas de duración y un código único de verificación. | Alta |
| RF-26 | El sistema debe almacenar el certificado generado en Amazon S3 con un nombre de archivo único (UUID). | Alta |
| RF-27 | El sistema debe proveer al participante un enlace único e irrepetible para descargar su certificado en cualquier momento. | Alta |
| RF-28 | El sistema debe permitir al Administrador regenerar el certificado de un participante en caso de error. | Media |
| RF-29 | El sistema debe permitir verificar la autenticidad de un certificado mediante su código único de verificación. | Media |

## Módulo 6: Reportes y Dashboard (REPORTES)
| ID | REQUERIMIENTO | PRIORIDAD |
|--------|----------|----------|
| RF-30 | El sistema debe mostrar al Administrador un dashboard con estadísticas generales: total de eventos, total de inscripciones, total de certificados emitidos. | Media |
| RF-31 | El sistema debe permitir exportar la lista de asistentes de un evento en formato CSV. | Media |
| RF-32 | El sistema debe mostrar un historial de eventos al Participante con sus inscripciones y certificados asociados. | Baja |

# REQUERIMIENTOS NO FUNCIONALES

## Rendimiento
| ID | REQUERIMIENTO | METRICA |
|--------|----------|----------|
| RNF-01 | El sistema debe responder a las solicitudes de la API en un tiempo máximo de 500ms bajo condiciones normales de carga. | Tiempo de respuesta ≤ 500ms |
| RNF-02 | El sistema debe soportar al menos 100 usuarios concurrentes sin degradación del servicio. | 100 usuarios simultáneos |
| RNF-03 | La generación y almacenamiento de un certificado PDF en S3 debe completarse en menos de 10 segundos. | Tiempo ≤ 10s |
| RNF-04 | El sistema debe estar disponible al menos el 99% del tiempo mensual (Alta disponibilidad). | Uptime ≥ 99% |

## Seguridad
| ID | REQUERIMIENTO | DETALLE |
|--------|----------|----------|
| RNF-05 | Todas las contraseñas deben almacenarse cifradas usando el algoritmo bcrypt con un factor de coste mínimo de 10. | bcrypt salt rounds ≥ 10 |
| RNF-06 | Toda comunicación entre el cliente y el servidor debe realizarse mediante HTTPS (TLS 1.2 o superior). | HTTPS obligatorio |
| RNF-07 | Los tokens JWT deben tener un tiempo de expiración máximo de 7 días y deben ser invalidados al cerrar sesión. | JWT expiry ≤ 7 días |
| RNF-08 | El bucket S3 que almacena los certificados debe ser privado; el acceso debe realizarse únicamente mediante URLs prefirmadas (presigned URLs) con expiración. | URLs firmadas con expiración |
| RNF-09 | El sistema debe aplicar el principio de menor privilegio en los roles IAM de AWS, otorgando solo los permisos estrictamente necesarios a cada servicio. | Principio mínimo privilegio |
| RNF-10 | La base de datos RDS no debe ser accesible directamente desde internet; solo el backend puede conectarse a ella dentro de la VPC. | Subred privada, sin IP pública |

## Escalabilidad
| ID | REQUERIMIENTO | DETALLE |
|--------|----------|----------|
| RNF-11 | La arquitectura debe permitir el escalamiento horizontal automático del backend mediante AWS ECS Fargate Auto Scaling. | Auto Scaling activado |
| RNF-12 | El sistema de almacenamiento de certificados (Amazon S3) debe ser capaz de almacenar un número ilimitado de archivos sin configuración adicional. | S3 escalabilidad nativa |
| RNF-13 | La base de datos debe soportar configuración Multi-AZ para garantizar continuidad ante fallos en una zona de disponibilidad. | RDS Multi-AZ |

## Mantenibilidad
| ID | REQUERIMIENTO | DETALLE |
|--------|----------|----------|
| RNF-14 | El código del backend debe seguir los principios de arquitectura modular de NestJS (Módulo → Controlador → Servicio → Repositorio). | Arquitectura NestJS estándar |
| RNF-15 | El sistema debe contar con documentación automática de la API generada con Swagger/OpenAPI, accesible en la ruta /api/docs. | Swagger en /api/docs |
| RNF-16 | LEl proyecto debe contar con un pipeline CI/CD en GitHub Actions que ejecute pruebas automáticas antes de cada despliegue. | Pipeline CI/CD activo |
| RNF-17 | La cobertura de pruebas unitarias del backend debe ser mínimo del 70%. | Cobertura ≥ 70% |

## Usabilidad
| ID | REQUERIMIENTO | DETALLE |
|--------|----------|----------|
| RNF-18 | La interfaz de usuario debe ser responsiva y funcionar correctamente en dispositivos móviles, tablets y computadores de escritorio. | Diseño responsivo |
| RNF-19 | El sistema debe mostrar mensajes de error claros y descriptivos al usuario cuando una operación falle. | Mensajes de error descriptivos |
| RNF-20 | LEl tiempo de carga inicial de la aplicación frontend no debe superar los 3 segundos en una conexión estándar de 10 Mbps. | Carga inicial ≤ 3s |