%%  PARCIAL POKEMON LEGENDS OF LOGIC

%%  PARTE UNO - POKEDEX

%% pokemon(nombre,tipo)
pokemon(pikachu, electrico).
pokemon(chalizard, fuego).
pokemon(venasaur, planta).
pokemon(blastoide, agua).
pokemon(totodile, agua).
pokemon(snorlax, normal).
pokemon(rayquaza,dragon).
pokemon(rayquaza,volador).
pokemon(arceus,desconocido).

%% entrenador(nombre,pokemon)
entrenador(ash,pikachu).
entrenador(ash,chalizard).
entrenador(brock,snorlax).
entrenador(misty,blastoide).
entrenador(misty,venasaur).
entrenador(misty,arceus).


%%  Saber si un pokemon es de tipo multiple
esDeTipoMultiple(Pokemon):-
    pokemon(Pokemon, Tipo1),
    pokemon(Pokemon, Tipo2),
    Tipo1 \= Tipo2.

%%  Saber si un pokemon es legendario
esLegendario(Pokemon):-
    esDeTipoMultiple(Pokemon),
    not(entrenador(_,Pokemon)).

%%  Saber si un pokemon es misterioso
esMisterioso(Pokemon):-
    pokemon(Pokemon, Tipo),
    not((pokemon(OtroPokemon, Tipo), Pokemon \= OtroPokemon)).

esMisterioso(Pokemon):-
    not(entrenador(_,Pokemon)).

%%  PARTE DOS - MOVIMIENTOS
%%  movimientoPokemon(pokemon,movimiento).
movimientoPokemon(pikachu, morderura).
movimientoPokemon(pikachu, impactrueno).

movimientoPokemon(chalizard, garraDragon).
movimientoPokemon(chalizard, morderura).

movimientoPokemon(blastoide, proteccion).
movimientoPokemon(blastoide, placaje).

movimientoPokemon(arceus, impactrueno).
movimientoPokemon(arceus, garraDragon).
movimientoPokemon(arceus, proteccion).
movimientoPokemon(arceus, placaje).
movimientoPokemon(arceus, alivio).

%% movimiento(movimiento,tipoMovimiento)
movimiento(morderura, fisico(95)).
movimiento(impactrueno, especial(electrico, 40)).
movimiento(garraDragon, especial(dragon, 100)).
movimiento(proteccion, defensivo(10)).
movimiento(placaje, fisico(50)).
movimiento(alivio, defensivo(100)).

%% Danio de ataque(Movimiento)
danioAtaqueMovimiento(Movimiento, Danio):-
    movimiento(Movimiento, TipoMovimiento),
    danioPorTipo(TipoMovimiento, Danio).  

danioPorTipo(fisico(Danio), Danio).
danioPorTipo(defensivo(_), 0).

danioPorTipo(especial(Tipo,Potencia), Danio):-
    multiplicadorPorTipo(Tipo, Multiplicador),
    Danio is Potencia * Multiplicador.

multiplicadorPorTipo(dragon, 3).

multiplicadorPorTipo(Tipo, 1.5):-
    member(Tipo, [fuego, agua, planta,normal]).

multiplicadorPorTipo(Tipo, 1) :-
    not(member(Tipo, [dragon, fuego, agua, planta, normal])).


%% Capacidad ofensiva de un pokemon
capacidadOfensiva(Pokemon, Capacidad):-
    pokemon(Pokemon, _),
    findall(Danio, danioAtaquePokemon(Pokemon, Danio), Danios),
    sumlist(Danios, Capacidad).

danioAtaquePokemon(Pokemon, Danio):-
    movimientoPokemon(Pokemon, Movimiento),
    danioAtaqueMovimiento(Movimiento, Danio).

%% Es picante un entrenador
esPicante(Entrenador):-
    entrenador(Entrenador,_),
    forall(capacidadOfensivaEntrenador(Entrenador,Capacidad), Capacidad > 100).

esPicante(Entrenador):-
    entrenador(Entrenador,_),
    forall(entrenador(Entrenador, Pokemon), (esMisterioso(Pokemon))).

capacidadOfensivaEntrenador(Entrenador,Capacidad):-
    entrenador(Entrenador, Pokemon),    
    capacidadOfensiva(Pokemon, Capacidad).

