%%  Base conocimiento

%%  integrante(Grupo,Persona,Instrumento)
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, solo, bateria).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

%%  nivelQueTiene(Persona,Intrumento,NivelImprovisacion)
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).
nivelQueTiene(solo, bateria, 2).

%%  Instrumento(Nombre,Rol)
instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

%%  PUNTO 1
tieneBuenaBase(Grupo):-
    integrante(Grupo,_,Instrumento),
    integrante(Grupo,_,Instrumento2),
    Instrumento \= Instrumento2,
    esInstrumentoDeTipo(Instrumento, armonico),
    esInstrumentoDeTipo(Instrumento2, ritmico).

esInstrumentoDeTipo(Instrumento, Tipo):-
    instrumento(Instrumento, Tipo).

%%  PUNTO 2
seDestaca(Persona,Grupo):-
    nivelConElQueToca(Persona,Grupo,Nivel),
    forall((nivelConElQueToca(OtraPersona,Grupo,OtroNivel), Persona \= OtraPersona), (Nivel >= OtroNivel + 2)).

nivelConElQueToca(Persona,Grupo,Nivel):-
    integrante(Grupo,Persona,Instrumento),
    nivelQueTiene(Persona,Instrumento,Nivel).

%%  PUNTO 3
%% grupo(Grupo,TipoGrupo)
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo,guitarra,violin])).
grupo(jazzmin, formacion([bateria,bajo,trompeta,piano,guitarra])).
grupo(estudio1,ensamble(3)).

%%  PUNTO 4
hayCupo(Grupo,Instrumento):-
    grupo(Grupo,bigBand),
    sirveInstrumento(Instrumento,bigBand).

hayCupo(Grupo,Instrumento):-
    grupo(Grupo,TipoGrupo),
    instrumento(Instrumento,_),
    sirveInstrumento(Instrumento,TipoGrupo),
    not(integrante(Grupo,_,Instrumento)).

sirveInstrumento(Instrumento,formacion(Instrumentos)):-
    member(Instrumento,Instrumentos).

sirveInstrumento(Instrumento,bigBand):-
    instrumento(Instrumento, melodico(viento)).

sirveInstrumento(bateria,bigBand).
sirveInstrumento(bajo,bigBand).
sirveInstrumento(piano,bigBand).

%%  PUNTO 5
puedeIncorporarse(Persona,Grupo,Instrumento):-
    hayCupo(Grupo,Instrumento),
    grupo(Grupo,TipoGrupo),
    not(integrante(Grupo,Persona,_)),
    nivelQueTiene(Persona,Instrumento,Nivel),
    nivelGrupo(TipoGrupo,NivelGrupo),
    Nivel >= NivelGrupo.

nivelGrupo(bigBand,1).
nivelGrupo(formacion(InstrumentosBuscados),Nivel):-
    length(InstrumentosBuscados, Cantidad),
    Nivel is 7 - Cantidad.
    

%% PUNTO 6
seQuedoEnBanda(Persona):-
    nivelQueTiene(Persona,_,_),
    not(integrante(_,Persona,_)),
    not(puedeIncorporarse(Persona,_,_)).

%% PUNTO 7
puedeTocar(Grupo):-
    grupo(Grupo,TipoGrupo),
    cumpleNecesidades(Grupo,TipoGrupo).

cumpleNecesidades(Grupo,formacion(_)):-
    grupo(Grupo, formacion(Instrumentos)),
    forall(member(Instrumento,Instrumentos), integrante(Grupo,_,Instrumento)).

cumpleNecesidades(Grupo,bigBand):-
    tieneBuenaBase(Grupo),
    findall(Integrante, (integrante(Grupo,Integrante,Instrumento), esDeViento(Instrumento)), IntegrantesViento),
    length(IntegrantesViento,Cantidad),
    Cantidad >= 5.

esDeViento(Instrumento):-
    instrumento(Instrumento, melodico(viento)).

%% PUNTO 8
nivelDeGrupo(ensamble(Cantidad),Nivel):-
    Nivel is Cantidad.

sirveInstrumento(_,ensamble(_)).

cumpleNecesidades(Grupo,ensamble(_)):-
    grupo(Grupo,ensamble(Cantidad)),
    tieneBuenaBase(Grupo),
    integrante(Grupo,_,Instrumento),
    instrumento(Instrumento,melodico(_)).