%   PARCIAL LOGICO 2019 RALLY DAKAR

% auto(modelo)
% moto(anioDeFabricacion, suspensionesExtras)
% camion(items)
% cuatri(marca)

% ganador(anio, piloto, vehiculo)
ganador(1997,peterhansel,moto(1995, 1)).
ganador(1998,peterhansel,moto(1998, 1)).
ganador(2010,sainz,auto(touareg)).
ganador(2010,depress,moto(2009, 2)).
ganador(2010,karibov,camion([vodka, mate])).
ganador(2010,patronelli,cuatri(yamaha)).
ganador(2011,principeCatar,auto(touareg)).
ganador(2011,coma,moto(2011, 2)).
ganador(2011,chagin,camion([repuestos, mate])).
ganador(2011,patronelli,cuatri(yamaha)).
ganador(2012,peterhansel,auto(countryman)).
ganador(2012,depress,moto(2011, 2)).
ganador(2012,deRooy,camion([vodka, bebidas])).
ganador(2012,patronelli,cuatri(yamaha)).
ganador(2013,peterhansel,auto(countryman)).
ganador(2013,depress,moto(2011, 2)).
ganador(2013,nikolaev,camion([vodka, bebidas])).
ganador(2013,patronelli,cuatri(yamaha)).
ganador(2014,coma,auto(countryman)).
ganador(2014,coma,moto(2013, 3)).
ganador(2014,karibov,camion([tanqueExtra])).
ganador(2014,casale,cuatri(yamaha)).
ganador(2015,principeCatar,auto(countryman)).
ganador(2015,coma,moto(2013, 2)).
ganador(2015,mardeev,camion([])).
ganador(2015,sonic,cuatri(yamaha)).
ganador(2016,peterhansel,auto(2008)).
ganador(2016,prince,moto(2016, 2)).
ganador(2016,deRooy,camion([vodka, mascota])).
ganador(2016,patronelli,cuatri(yamaha)).
ganador(2017,peterhansel,auto(3008)).
ganador(2017,sunderland,moto(2016, 4)).
ganador(2017,nikolaev,camion([ruedaExtra])).
ganador(2017,karyakin,cuatri(yamaha)).
ganador(2018,sainz,auto(3008)).
ganador(2018,walkner,moto(2018, 3)).
ganador(2018,nicolaev,camion([vodka, cama])).
ganador(2018,casale,cuatri(yamaha)).
ganador(2019,principeCatar,auto(hilux)).
ganador(2019,prince,moto(2018, 2)).
ganador(2019,nikolaev,camion([cama, mascota])).
ganador(2019,cavigliasso,cuatri(yamaha)).

% pais (ganador, pais)
pais(peterhansel,francia).
pais(sainz,espania).
pais(depress,francia).
pais(karibov,rusia).
pais(patronelli,argentina).
pais(principeCatar,catar).
pais(coma,espania).
pais(chagin,rusia).
pais(deRooy,holanda).
pais(nikolaev,rusia).
pais(casale,chile).
pais(mardeev,rusia).
pais(sonic,polonia).
pais(prince,australia).
pais(sunderland,reinoUnido).
pais(karyakin,rusia).
pais(walkner,austria).
pais(cavigliasso,argentina).


% PUNTO UNO
marcaDelModelo(peugeot,2008).
marcaDelModelo(peugeot,3008).
marcaDelModelo(mini,countryman).
marcaDelModelo(volkswagen,touareg).
marcaDelModelo(toyota,hilux).

%   B) Si quisiera agregar que el modelo buggy es de la marca mini, puedo agregar un hecho a mi base de conocimientos:
%       marcaDelModelo(mini, buggy).
%       En el caso del modelo dkr, no es necesario agregar nada, ya que gracias al principio de universo cerrado aquello 
%       que no está definido en mi base de conocimientos, es falso

% PUNTO DOS
ganadorReincidente(Piloto):-
    ganador(Anio, Piloto, _),
    ganador(OtroAnio, Piloto, _),
    Anio \= OtroAnio.

% PUNTO TRES
inspiraA(Inspirador, Inspirado):-
    esInspiracion(Inspirador, Inspirado),
    mismoPais(Inspirador, Inspirado).

esInspiracion(Inspirador, Inspirado):-
    ganador(Anio, Inspirador, _),
    not(ganador(Anio, Inspirado, _)).

esInspiracion(Inspirador, Inspirado):-
    ganador(Anio, Inspirador, _),
    ganador(OtroAnio, Inspirado, _),
    Anio < OtroAnio.

mismoPais(Inspirador, Inspirado):-
    pais(Inspirador, Pais),
    pais(Inspirado, Pais),
    Inspirador \= Inspirado.

% PUNTO CUATRO
marcaDeLaFortuna(Piloto, Marca):-
    ganador(_,Piloto,_),
    usoLaMarca(Piloto,Marca),
    not(repiteMarca(Piloto,Marca)).

usoLaMarca(Piloto,Marca):-
    ganador(_,Piloto,Vehiculo),
    marca(Vehiculo,Marca).

repiteMarca(Piloto, Marca):-
    usoLaMarca(Piloto,Marca),
    usoLaMarca(Piloto,OtraMarca),
    Marca \= OtraMarca.

%Marca Vehiculos
marca(auto(Modelo),Marca):-
    marcaDelModelo(Marca,Modelo).

marca(cuatri(Marca),Marca).

%Marca de Camion
marca(Camion, kamaz):-
    lleva(vodka, Camion).

marca(Camion, iveco):-
    esCamion(Camion),
    not(lleva(vodka, Camion)).

lleva(Item, camion(Items)):-
    member(Item, Items).

esCamion(camion(_)).

% Marca de Moto
marca(Moto, ktm):-
    fabricadaAnio(2000,Moto).

marca(Moto, yamaha):-
    esMoto(Moto),
    not(fabricadaAnio(2000,Moto)).

fabricadaAnio(Anio, moto(AnioFabricacion, _)):-
    AnioFabricacion >= Anio.

esMoto(moto(_,_)).

% PUNTO CINCO
heroePopular(Piloto):-
    esInspiracion(Piloto,_),
    unicoHumilde(Piloto).

unicoHumilde(Piloto):-
    ganador(Anio,Piloto,_),
    not(usoVehiculoCaro(Piloto,Anio)),
    forall(otroGanador(Anio,Piloto,OtroPiloto), usoVehiculoCaro(OtroPiloto,Anio)).

otroGanador(Anio,Piloto,OtroPiloto):-
    ganador(Anio,Piloto,_),
    ganador(Anio,OtroPiloto,_),
    Piloto \= OtroPiloto.

usoVehiculoCaro(Piloto,Anio):-
    ganador(Anio,Piloto,Vehiculo),
    esCaro(Vehiculo).

esCaro(Vehiculo):-
    marca(Vehiculo,Marca),
    marcaCara(Marca).

esCaro(Vehiculo):-
    suspensionesExtra(Vehiculo, Suspensiones),
    Suspensiones >= 3.

suspensionesExtra(moto(_, Suspensiones), Suspensiones).
suspensionesExtra(cuatri(_),4).

marcaCara(mini).
marcaCara(toyota).
marcaCara(iveco).

% PUNTO SEIS
etapa(marDelPlata,santaRosa,60).
etapa(santaRosa,sanRafael,290).
etapa(sanRafael,sanJuan,208).
etapa(sanJuan,chilecito,326).
etapa(chilecito,fiambala,177).
etapa(fiambala,copiapo,274).
etapa(copiapo,antofagasta,477).
etapa(antofagasta,iquique,557).
etapa(iquique,arica,377).
etapa(arica,arequipa,478).
etapa(arequipa,nazca,246).
etapa(nazca,pisco,276).
etapa(pisco,lima,29).

% A)
distancia(Partida,Destino,Kilometros):-     %Si son de la misma etapa, esta es su distancia
    etapa(Partida,Destino,Kilometros).

distancia(Partida,Destino,Kilometros):-
    etapa(Partida,SiguienteLocacion,KilometrosParcial),
    etapa(SiguienteLocacion,Destino,KilometrosFaltantes),
    Kilometros is KilometrosParcial + KilometrosFaltantes.

% B)
puedeRecorrerSinParar(Vehiculo,Distancia):-
    limiteDistancia(Vehiculo, Limite),
    Limite >= Distancia.

limiteDistancia(Vehiculo,Limite):-
    esCaro(Vehiculo),
    Limite is 2000.

limiteDistancia(Vehiculo,Limite):-
    not(esCaro(Vehiculo)),
    Limite is 1800.

limiteDistancia(camion(Items),Limite):-
    length(Items, Cantidad),
    Limite is Cantidad * 1000.

vehiculo(Vehiculo):-
    marca(Vehiculo, _).
