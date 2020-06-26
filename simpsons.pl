% Requerimientos:
% 1. Quién es padre de quién.
% 2. Los hermanos de una persona.
% 3. Las personas que son hijo único, que se cumple si no tiene hermanos.
% 4. Si existe algún abuelo hasta las manos: aquel para quien todos sus hijos tuvieron hijos.

% 1. Quién es padre de quién.

padreDe(homero,bart).
padreDe(homero,lisa).
padreDe(homero,maggie).
padreDe(marge,bart).
padreDe(marge,lisa).
padreDe(marge,maggie).

padreDe(abraham,herbert).
padreDe(abraham,homero).
padreDe(mona,homero).

padreDe(kirk,milhouse).

% 2. Los hermanos de una persona.

sonHermanos(UnaPersona,OtraPersona):-
  padreDe(Padre,UnaPersona),
  padreDe(Padre,OtraPersona),
  UnaPersona \= OtraPersona.

% 3. Las personas que son hijo único, que se cumple si no tiene hermanos.

esHijoUnico(Persona):-
  esPersona(Persona),
  not(sonHermanos(Persona,_)).

esPersona(Persona):-
  padreDe(Persona,_).

esPersona(Persona):-
  padreDe(_,Persona).

% 4. Si existe algún abuelo hasta las manos: aquel para quien todos sus hijos tuvieron hijos.

abueloHastaLasManos(Abuelo):-
  padreDe(Abuelo,_),
  forall(padreDe(Abuelo,Hijo), padreDe(Hijo,_)).
  % "Para todos los hijos del abuelo, todos deben cumplir que tengan algun hijo"
  % Vx (P(x) => Q(x))

% 5. Las personas con infancia problematica, aquellas para quien todos sus hermanos son cara rotas. 

esCaraRrota(bart).
esCaraRrota(maggie).
esCaraRrota(homero).

infanciaProblematica(Persona):-
  esPersona(Persona), % Generador
  forall(sonHermanos(Persona,Hermano), esCaraRrota(Hermano)).
  % "Para todo hermano de la persona, ese hermano es caraRrota"

% Tests
:- begin_tests(hermanos).

  test(dos_personas_son_hermanos, nondet):-
    sonHermanos(bart,lisa).

  test(dos_personas_no_son_hermanos, fail):-
    sonHermanos(bart, milhouse).

  test(una_persona_no_es_hermano_de_si_misma,fail):-
    sonHermanos(Persona, Persona).

  test(saber_los_hermanos_de_una_persona, set(Persona == [maggie, lisa])) :-	
    sonHermanos(bart, Persona).


:- end_tests(hermanos).

:-begin_tests(hijosUnicos).

test(una_persona_sin_hermanos_es_hijo_unico, nondet):-
  esHijoUnico(milhouse).

test(una_persona_con_hermanos_es_hijo_unico, fail):-
  esHijoUnico(bart).

:-end_tests(hijosUnicos).


:-begin_tests(abuelosHastaLasManos).

test(un_abuelo_cuyos_hijos_todos_tienen_hijos_esta_hasta_las_manos, nondet):-
  abueloHastaLasManos(mona).

test(un_abuelo_con_un_hijo_sin_hijos_no_esta_hasta_las_manos, fail):-
  abueloHastaLasManos(abraham).

:-end_tests(abuelosHastaLasManos).


:-begin_tests(ejemplo_inversibilidad_multiple).

test(padreDe_es_totalmente_inversible, nondet):-
  padreDe(Padre, Hijo),
  assertion(Padre == homero),
  assertion(Hijo == bart).

:-end_tests(ejemplo_inversibilidad_multiple).

