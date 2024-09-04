%%  STEAM SUMMER SALE 2024  %%

%juego(nombre, precio, accion)
%juego(nombre, precio, rol(usuarios))
%juego(nombre, precio, puzzle(niveles,dificultad))
juego(minecraft, 1000, accion).
juego(terraria, 500, rol(100000)).
juego(gta, 2000, accion).
juego(starWars, 1500, puzzle(50, dificil)).
juego(assassinsCreed, 3000, rol(50000)).
juego(counterStrike,50, accion).

%oferta(nombre, descuento)
oferta(minecraft, 10).
oferta(terraria, 20).
oferta(starWars, 50).

%cuantoSale(Juego,PrecioFinal)
cuantoSale(Juego,PrecioFinal):-
    juego(Juego,Precio,_),
    tieneDescuento(Juego, Descuento),
    PrecioFinal is Precio - (Precio * Descuento / 100).

cuantoSale(Juego,Precio):-
    juego(Juego,Precio,_),
    not(tieneDescuento(Juego,_)).

tieneDescuento(Juego,Descuento):-
    juego(Juego,_,_),
    oferta(Juego,Descuento).

%tieneBuenDescuento(Juego)
tieneBuenDescuento(Juego):-
    oferta(Juego,Descuento),
    Descuento >= 50.

%esPopular(juego).
esPopular(minecraft).
esPopular(counterStrike).

esPopular(Juego):-
    juego(Juego,_,Tipo),
    popularTipo(Tipo).

popularTipo(accion).

popularTipo(rol(UsuarioActivos)):-
    UsuarioActivos >= 1000000.

popularTipo(puzzle(25,_)).
popularTipo(puzzle(_,facil)).

%%  DEFINO USUARIOS Y ADQUISICIONES  %%
%usuario(nombreUsuario,juegosQuePosee).
usuario(gabo, minecraft).
usuario(gabo, starWars).
usuario(gabo, gta).
usuario(rama, starWars).
usuario(rama, assassinsCreed).
usuario(fer, counterStrike).

%adquisiciones(nombreUsuario, juego, tipoAdquisicion)
adquisiciones(gabo, minecraft, regalo(rama)).
adquisiciones(rama, terraria, personal).
adquisiciones(rama, minecraft, personal).
adquisiciones(rama, counterStrike, regalo(gabo)).
adquisiciones(fer, starWars, regalo(gabo)).

%esAdictoADescuentos(Usuario)
esAdictoADescuentos(Usuario):-
    adquisiciones(Usuario,_,_),
    forall(adquisiciones(Usuario,Juego,_), tieneBuenDescuento(Juego)).

%esFanaticoGenero(Usuario,Tipo).
esFanaticoGenero(Usuario,Tipo):-
    usuario(Usuario, Juego1),
    usuario(Usuario, Juego2),
    generoDeJuegos(Juego1,Juego2,Tipo).

generoDeJuegos(Juego1,Juego2,Tipo):-
    juego(Juego1, _, Tipo1),
    juego(Juego2,_, Tipo2),
    Juego1 \= Juego2,
    sonDelMismoTipo(Tipo1,Tipo2),
    Tipo1 = Tipo.

sonDelMismoTipo(accion,accion).
sonDelMismoTipo(puzzle(_,_),puzzle(_,_)).
sonDelMismoTipo(rol(_),rol(_)).

%esMonotematico(Usuario). lo es si todos los juegos que posee son del mismo tipo
esMonotematico(Usuario):-
    usuario(Usuario,_),
    forall(usuario(Usuario,Juego), juegosDelMismoTipo(Usuario,Juego)).

juegosDelMismoTipo(Usuario,Juego):-
    juego(Juego,_,Tipo),
    forall((usuario(Usuario,OtroJuego), juego(OtroJuego,_,OtroTipo)), sonDelMismoTipo(Tipo,OtroTipo)).

%sonBuenosAmigos(Usuario,OtroUsuario)
sonBuenosAmigos(Usuario,OtroUsuario):-
    adquisiciones(Usuario,Juego1,regalo(OtroUsuario)),
    adquisiciones(OtroUsuario,Juego2,regalo(Usuario)),
    esPopular(Juego1),
    esPopular(Juego2).

%cuantoGastara(Usuario,Gasto):-
cuantoGastaraTotal(Usuario,Gasto):-
    gastosDeRegalos(Usuario,GastoRegalos,regalo(_)),
    gastosDeRegalos(Usuario,GastoPersonal,personal),
    Gasto is GastoRegalos + GastoPersonal.

cuantoGastaraRegalando(Usuario,Gasto):-
    gastosDeRegalos(Usuario,Gasto,regalo(_)).

cuantoGastaraPersonalmente(Usuario,Gasto):-
    gastosDeRegalos(Usuario,Gasto,personal).

gastosDeRegalos(Usuario,Gasto,TipoGasto):-
    adquisiciones(Usuario,_,TipoGasto),
    findall(Precio, (adquisiciones(Usuario,Juego,TipoGasto), cuantoSale(Juego,Precio)), Precios),
    sum_list(Precios,Gasto).