%%   PARCIAL 31 MINUTOS: PROLOG CHILENO   %%

% Cancion, Compositores,  Reproducciones
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927). 
cancion(lala, [pabloIlabaca, pedroPeirano], 5100530).
cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).

% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).

% PUNTO UNO. Saber si una cancion es hit
esHit(Cancion):-
    cancion(Cancion,_,_),
    forall(rankingTop3(Mes,_,_), rankingTop3(Mes,_,Cancion)). %para todo mes, la cancion esta en alguna posicion sin importar cual

% PUNTO DOS. Saber si una cancion no es reconocida
noEsReconocida(Cancion):-
    cancion(Cancion,_,Reproducciones),
    not((rankingTop3(_,_,Cancion))),
    Reproducciones >= 700000.

% PUNTO TRES. Saber si dos compositores son colaboradores
sonColaboradores(Compositor,OtroCompositor):-
    cantaEn(Cancion,Compositor),
    cantaEn(Cancion,OtroCompositor),
    Compositor \= OtroCompositor.

cantaEn(Cancion,Compositor):-
    cancion(Cancion,Compositores,_),
    member(Compositor,Compositores).

% PUNTO CUATRO. Trabajos
%conductor(aniosExperiencia).
%periodista(aniosExperiencia,titulo). titulo es licenciatura o posgrado
%reportero(aniosExperiencia,cantidadNotas).
trabajo(tulio, conductor(5)).
trabajo(juanin, conductor(0)).
trabajo(bodoque, periodista(2,licenciatura)).
trabajo(marioHugo, periodista(10,posgrado)).
trabajo(bodoque, reportero(5,300)).

% PUNTO CUATRO. Saber sueldo total de una persona
sueldoTotal(Persona,Sueldo):-
    trabajo(Persona,_),
    findall(SueldoParcial, sueldoParcial(Persona,SueldoParcial), Sueldos),
    sum_list(Sueldos,Sueldo).

sueldoParcial(Persona,Sueldo):-
    trabajo(Persona,Trabajo),
    sueldoTrabajo(Trabajo,Sueldo).

sueldoTrabajo(conductor(Anios),Sueldo):-
    productoSueldo(10000,Anios,Sueldo).

sueldoTrabajo(reportero(Anios,Reportes),Sueldo):-
    productoSueldo(10000,Anios,SueldoAnios),
    productoSueldo(100,Reportes,SueldoReportes),
    Sueldo is SueldoAnios + SueldoReportes.

sueldoTrabajo(periodista(Anios,licenciatura),Sueldo):-
    productoSueldo(5000,Anios,SueldoAnios),
    Sueldo is SueldoAnios * (1.2).

sueldoTrabajo(periodista(Anios,posgrado),Sueldo):-
    productoSueldo(5000,Anios,SueldoAnios),
    Sueldo is SueldoAnios * (1.35).

productoSueldo(Valor,Referencia,Sueldo):-
    Sueldo is Referencia * Valor.

