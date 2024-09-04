% Prolog de la costa

%%%% Base de conocimiento %%%%

%   puestoDeComida(nombre,precio).
puestoDeComida(hamburguesa,2000).
puestoDeComida(panchoYpapas,1500).
puestoDeComida(lomitos,2500).
puestoDeComida(caramelos,0).

%   atraccion(nombre,tranquila(publico)).
atraccion(autitosChocadores,tranquila(familiar)).
atraccion(casaEmbrujada,tranquila(familiar)).
atraccion(laberito,tranquila(familiar)).
atraccion(tobogan,tranquila(chicos)).
atraccion(calesita,tranquila(chicos)).

%   atraccion(nombre,intensa(coef. lanzamiento)).
atraccion(barcoPirata,intensa(14)).
atraccion(tazasChinas,intensa(6)).
atraccion(simulador3D,intensa(2)).

%   atraccion(nombre,montaniaRusa(giros,duracion))
atraccion(abismoMortal, montaniaRusa(3,134)).
atraccion(paseoPorElBosque, montaniaRusa(0,45)).
atraccion(laRevoltosa, montaniaRusa(10,75)).
atraccion(enroscado, montaniaRusa(5,65)).

%   atraccion(nombre,tipo).
atraccion(torpedoSalpicon,acuatica).
atraccion(esperoHayasTraidoRopa,acuatica).

%   grupo(nombre, grupo).
grupo(eusebio,viejitos).
grupo(carmela,viejitos).

%   visitante(nombre, edad, dinero, sentimiento(hambre,aburrimiento)).
visitante(eusebio, 80, 3000, sentimiento(50,0)).
visitante(carmela, 80, 0, sentimiento(0,25)).
visitante(juan, 20, 5000, sentimiento(0,0)).
visitante(maria, 11, 1500, sentimiento(50,10)).


%%%% Punto 2 %%%%
visitante(Visitante):-
    visitante(Visitante,_,_,_).

vieneSolo(Visitante):-
    visitante(Visitante),
    not(vieneEnGrupo(Visitante)).

vieneEnGrupo(Visitante):-
    visitante(Visitante),
    grupo(Visitante,_).

bienestar(Visitante,felicidadPlena):-
    sumaSentimientos(Visitante,Valor),
    Valor = 0,
    vieneEnGrupo(Visitante).

bienestar(Visitante,podriaEstarMejor):- %Si esta solo no puede tener felicidadPlena
    sumaSentimientos(Visitante,Valor),
    Valor = 0,
    vieneSolo(Visitante).

bienestar(Visitante, podriaEstarMejor):-
    sumaSentimientosEntre(Visitante,1,50).

bienestar(Visitante, necesitaEntretenerse):-
    sumaSentimientosEntre(Visitante,51,99).

bienestar(Visitante, seQuiereIr):-
    sumaSentimientos(Visitante,Valor),
    Valor >= 100.

sumaSentimientos(Visitante,Valor):-
    visitante(Visitante,_,_,sentimiento(Hambre,Aburrimiento)),
    Valor is (Hambre + Aburrimiento).

sumaSentimientosEntre(Visitante,Limite1,Limite2):-
    visitante(Visitante,_,_,sentimiento(Hambre,Aburrimiento)),
    between(Limite1, Limite2, Valor),
    Valor is Hambre + Aburrimiento.


%%%% Punto 3 %%%%
esChico(Visitante):-
    visitante(Visitante,Edad,_,_),
    Edad =< 12.

puedeSatisfacerHambre(Grupo,Comida):-
    puestoDeComida(Comida,_),
    todosPuedenComprar(Grupo,Comida),
    leQuitaHambreATodos(Grupo,Comida).

todosPuedenComprar(Grupo,Comida):-
    forall(grupo(Integrante,Grupo),puedeComprar(Integrante,Comida)).

puedeComprar(Visitante,Comida):-
    visitante(Visitante,_,Dinero,_),
    puestoDeComida(Comida,Precio),
    Dinero >= Precio.

leQuitaHambreATodos(Grupo,Comida):-
    forall(grupo(Integrante,Grupo),leQuitaHambre(Integrante,Comida)).

leQuitaHambre(Visitante,hamburguesa):-
    visitante(Visitante,_,_,sentimiento(Hambre,_)),
    Hambre < 50.

leQuitaHambre(Visitante,panchoYpapas):-
    esChico(Visitante).

leQuitaHambre(_,lomitos).

leQuitaHambre(Visitante,caramelos):-
    forall(puestoDeComida(Comida,_), esPobre(Visitante,Comida)).

esPobre(Visitante,Comida):-
    not(puedeComprar(Visitante,Comida)), 
    Comida \= caramelos .


%%%% Punto 4 %%%%
posibleLluviaDeHamburguesas(Visitante,Atraccion):-
    puedeComprar(Visitante,hamburguesa),
    atraccionDeVomitos(Visitante, Atraccion).

atraccionDeVomitos(_,Atraccion):-
    atraccion(Atraccion,intensa(Coeficiente)),
    Coeficiente > 10.

atraccionDeVomitos(_,tobogan).

atraccionDeVomitos(Visitante,AtraccionRusa):-
    esMontaniaRusaPeligrosa(Visitante,AtraccionRusa).

esMontaniaRusaPeligrosa(Visitante, Atraccion):- 
    atraccion(Atraccion,montaniaRusa(Giros,_)),
    not(bienestar(Visitante, necesitaEntretenerse)),
    not(esChico(Visitante)),
    forall(atraccion(_,montaniaRusa(OtrosGiros,_)), Giros >= OtrosGiros).

esMontaniaRusaPeligrosa(Visitante,Atraccion):-
    atraccion(Atraccion,montaniaRusa(_,Duracion)),
    esChico(Visitante),
    Duracion > 60.

%% Punto 5 %%
atraccionDisponible(Visitante,Mes,Opcion):-
    opcionParticular(Visitante,Mes,Opcion).

opcionParticular(_,Mes,Opcion):-
    atraccion(Opcion,acuatica),
    member(Mes, [septiembre, octubre, noviembre, diciembre, enero, febrero, marzo]).

opcionParticular(Visitante,_,Opcion):-
    puestoDeComida(Opcion,_),
    puedeComprar(Visitante,Opcion).

opcionParticular(Visitante,_,Opcion):-
    atraccion(Opcion,tranquila(chicos)),
    esChico(Visitante).


/*%%%%%%%%%%%%%
%% Punto 5 %%
%%%%%%%%%%%%%
% opcionDeEntretenimiento(Mes, Visitante, Opcion)
opcionDeEntretenimiento(Mes, Visitante, Opcion) :-
    % TODO: hacer en casa (y que sea inversible)

opcionParticularDeEntretenimiento(_, Visitante, PuestoDeComida) :-
    puedeComprar(Visitante, PuestoDeComida).

opcionParticularDeEntretenimiento(_, Visitante, Atraccion) :-
    atraccion(Atraccion, tranquila(FranjaEtaria)),
    puedeAcceder(Visitante, FranjaEtaria).

opcionParticularDeEntretenimiento(_, _, Atraccion) :-
    atraccion(Atraccion, intensa(_)).
    
opcionParticularDeEntretenimiento(_, Visitante, Atraccion) :-
    atraccion(Atraccion, montaniaRusa(Giros, Duracion)),
    not(esPeligrosa(Visitante, montaniaRusa(Giros, Duracion))).

opcionParticularDeEntretenimiento(Mes, _, Atraccion) :-
    atraccion(Atraccion, acuatica),
    member(Mes, [septiembre, octubre, noviembre, diciembre, enero, febrero, marzo]).


puedeAcceder(Visitante, chicos) :-
    esChico(Visitante).
puedeAcceder(Visitante, chicos) :-
    grupo(Visitante, Grupo),
    not(esChico(Visitante)),
    hayAlgunChicoEnElGrupo(Grupo).

puedeAcceder(_, chicosYAdultos).

hayAlgunChicoEnElGrupo(Grupo) :-
    grupo(Integrante, Grupo),
    esChico(Integrante).*/