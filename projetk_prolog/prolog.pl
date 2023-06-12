%krotsza wersja proejktu do zaliczenia 

%ustawienia
:- dynamic pozycja/1.
:- dynamic torba/1.

:- dynamic dostep_do_skladnikow/1.
:- dynamic pora_dnia/1.

%Poczatek
pozycja(wejscie).
dostep_do_skladnikow(0).
pora_dnia(dzien).

%rozgrywka
cel() :- write('Cel gry: stwórz miksturę nieśmiertelności znajdując wszystkie potrzebne składniki w domu wróżki.'), nl.
mapa() :- write('
###################################################*******************
#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#..................*
#,,^^oovv'',,,,,,,,ogrod,,,,,,,,**~~>><<% %,,,,,,,,#"""""......*......*
#,,^^oovv'',,,,,,,,,,,,,,,,,,,,,**~~>><<% %,,,,,,,,=     "........w...*
#,,^^oovv'',,,,,,,,,,,,,,,,,,,,,**~~>><<% %,,,,,,,,#""""  """.........*
#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#...."    "".......*
+-------------+-------=-------+-------------------+....."""   "......*
|  lazienka   =               |                   |........"" "....*.*
|             |               =      kuchnia      |........."  ".....*
+-------------+               |                   |...w......" ".....*
|             |               |                   |.........." ".....*
|  sypialnia  =     salon     +-------------------+.*......""  "..w..*
|             |               |                   |......""   "......*
+-------------+               |                   |....""   "".......*
|             |               =    labolatorium   |..""   "".........*
| biblioteka  =               |                   |.."  ""...mroczny.*
|             |               |                   |.."  "......las...*
+-------------+-------=-------+-------------------+..." "............*
|    grota    |               |                   |..."  ""..........*
| krysztalow  =    wejscie    =    spizarnia      |...."   ".........*
|             |               |                   |.*...""  "........*
+-------------+-------=-------+-------------------+......." "...*....*
*...................." ".................................." "........*
*...................."  "...............................""  "........*
*....w.......w........"  """""""""""""""""""""""""""""""   ".........*
*......................"                                 ""....w.....*
*.........*............."""""""""""""""""""""""""""""""""............*
*....w.........*.....................................................*
*....................................................................*
**********************************************************************'), nl.

komendy :-
    dostep_do_skladnikow(X),
    X == 0
    ->
    (
        write('Wyswietl dostepne komendy                        -komendy.'),nl,
        write('Wyswietl cel gry                                 -cel.'),nl,
        write('Wyswietl mape domu                               -mapa.'),nl,
        write('Wyswietla aktualny pokoj                         -gdzie_jestes.'),nl,
        write('Wyswietla mozliwe przejscia do innych pokoi      -dostepne_przejscia_teraz.'),nl,
        write('Przechodzi do wskazanego pokoju                  -idz(pokoj).'),nl,
        write('Znajduje sciezke z pokoju do pokoju              -znajdz_sciezke(pokojA,pokojB,Sciezka).'),nl,
        write('Wyswietla zawartosc torby                        -pokaz_torbe.'),nl,
        write('Wyswietla dodatkowe komendy dostepne w pokoju    -komendy_tu.'),nl,
        write('Wyswietla pore dnia                              -jaka_pora_dnia.'),nl
    )
    ;
    (
        write('Wyswietl dostepne komendy                        -komendy.'),nl,
        write('Wyswietl cel gry                                 -cel.'),nl,
        write('Wyswietl mape domu                               -mapa.'),nl,
        write('Wyswietla aktualny pokoj                         -gdzie_jestes.'),nl,
        write('Wyswietla mozliwe przejscia do innych pokoi      -dostepne_przejscia_teraz.'),nl,
        write('Przechodzi do wskazanego pokoju                  -idz(pokoj).'),nl,
        write('Znajduje sciezke z pokoju do pokoju              -znajdz_sciezke(pokojA,pokojB,Sciezka).'),nl,
        write('Wyswietla zawartosc torby                        -pokaz_torbe.'),nl,
        write('Wyswietla dodatkowe komendy dostepne w pokoju    -komendy_tu.'),nl,
        write('Wyswietla pore dnia                              -jaka_pora_dnia.'),nl,
        write('Wyswietla informacje czy posiadasz skladniki     -czy_skladniki_w_torbie.'),nl,
        write('Wyswietla skladniki potrzebne do eliksiru        -pokaz_skladniki.'),nl
    ).

% Polaczenia miedzy pokojami
polaczenia(wejscie, [mroczny_las,spizarnia,grota_krysztalow,salon]).
polaczenia(grota_krysztalow,[wejscie]).
polaczenia(spizarnia,[wejscie]).
polaczenia(salon,[wejscie,biblioteka,sypialnia,lazienka,ogrod,kuchnia,labolatorium]).
polaczenia(biblioteka,[salon]).
polaczenia(sypialnia,[salon]).
polaczenia(lazienka,[salon]).
polaczenia(ogrod,[salon,mroczny_las]).
polaczenia(kuchnia,[salon]).
polaczenia(labolatorium,[salon]).
polaczenia(mroczny_las,[ogrod,wejscie]).

%Wyswietlanie przejsc
dostepne_przejscia(Pokoj) :-
    polaczenia(Pokoj,Przejscia),
    write('Z "'),
    write(Pokoj),
    write('" dostepne przejscia to: '),
    write(Przejscia),
    writeln('.').

% Wyświetlanie aktualnej pozycji
gdzie_jestem() :-
    write('Jestem w: '),
    pozycja(X),
    write(X),
    writeln('.').

% Reguła wyświetlająca dostępne przejścia z aktualnej pozycji
dostepne_przejscia_teraz :-
    pozycja(X),
    dostepne_przejscia(X).

% Idź do 
idz(X) :-
    pozycja(AktualnaPozycja),
    polaczenia(AktualnaPozycja, Przejscia),
    member(X, Przejscia)
    ->
    retract(pozycja(AktualnaPozycja)),
    asserta(pozycja(X)),
    write('Jesteś teraz w: '),nl,
    write(X)
    ;
    write('Nie mozesz isc do: '),nl,
    write(X),
    fail.

%szukanie sciezki 
znajdz_sciezke(Pokoj1, Pokoj2, Sciezka) :-
    znajdz_sciezke(Pokoj1, Pokoj2, [Pokoj1], Sciezka).

znajdz_sciezke(Pokoj, Pokoj, Odwiedzone, Odwiedzone).

znajdz_sciezke(Pokoj1, Pokoj2, Odwiedzone, Sciezka) :-
    polaczenia(Pokoj1, Przejscia),
    member(NastepnyPokoj, Przejscia),
    \+ member(NastepnyPokoj, Odwiedzone),
    znajdz_sciezke(NastepnyPokoj, Pokoj2, [NastepnyPokoj|Odwiedzone], Sciezka).

% Sprawdza, czy dany przedmiot znajduje się w torbie
czy_w_torbie(Przedmiot) :-
    torba(Przedmiot),
    !.

% Przykładowe zastosowanie: Sprawdzenie, czy w torbie znajduje się składnik niezbędny do stworzenia mikstury nieśmiertelności


czy_skladniki_w_torbie :-
    dostep_do_skladnikow(X),
    X == 1
    -> (
        (czy_w_torbie(nasiona_slonca),
        czy_w_torbie(arcyklejnot),
        czy_w_torbie(grzyb_niesmiertelnosci),
        czy_w_torbie(roslina_szczescia),
        czy_w_torbie(gwiezdny_pyl),
        czy_w_torbie(wampirzy_czosnek))
        -> write('Posiadasz wszystkie składniki potrzebne do stworzenia mikstury nieśmiertelności!'),nl
        ; write('Nie posiadasz wszystkich składników!'),nl
    )
    ; write('Nie masz dostępu do tej czynności!'), nl.

pokaz_torbe :-
    write('Masz w torbie: '),
    findall(X, torba(X), Lista),
    wypisz_lista(Lista),
    nl.

wypisz_lista([]).
wypisz_lista([X|Xs]) :-
    write(X), write(', '),
    wypisz_lista(Xs).


skladniki_do_mikstury([wampirzy_czosnek, roslina_szczescia, grzyb_niesmiertelnosci, arcyklejnot, gwiezdny_pyl, nasiona_slonca]).

pokaz_skladniki :-
    dostep_do_skladnikow(X),
    X==1,
    write('Skladniki do mikstury: '), nl,
    skladniki_do_mikstury(Skladniki),
    write(Skladniki),nl.

pokaz_skladniki :-
    dostep_do_skladnikow(X),
    X==0
    ->
    write('Nie masz dostepu do tej czynnosci!!!'),nl.

jaka_pora_dnia :-
    pora_dnia(X),
    write('Teraz jest: '),
    write(X),nl.

%CZYNNOSCI
czynnosci(biblioteka,['ksiazki','czytaj(ksiazka)']).
czynnosci(spizarnia,['wez(nasiona)']).
czynnosci(grota_krysztalow,['szukaj_krysztalow']).
czynnosci(sypialnia,['dzien','noc']).
czynnosci(ogrod,['posadz(nasiona)', 'podlej', 'zbierz(roslina)', 'co_w_ogrodzie']).
czynnosci(mroczny_las, ['szukaj']).
czynnosci(labolatorium,['zrob_eliksir']).
czynnosci(kuchnia,['szukaj(gdzie)','pokaz_kuchnie']).

komendy_tu :-
    pozycja(X),
    czynnosci(X,Y),
    write('Dostepne komendy w: '),
    write(X),nl,
    write(Y),nl.

%BIBLIOTEKA===============================================================================================
ksiazki_spis([ogrod,mroczny_las,grota_krysztalow,labolatorium]).

ksiazki :-
    pozycja(X),
    X == biblioteka
    ->
    ksiazki_spis(K),
    write(K), nl.

czytaj(K) :-
    pozycja(X),
    X == biblioteka,
    K == ogrod
    ->
    write('Rośliny i ich nasiona:
-kwiat słońca 🌻 - nasiona słońca 💛
-roślina szczęścia 🍀 - nasiona szczęścia 💚
* aby rosliwy wyrosly musisz je podlac'),nl.

czytaj(K) :-
    pozycja(X),
    X == biblioteka,
    K == mroczny_las
    ->
    write('Co można znaleźć w mrocznym lesie:
-grzyb nieśmiertelności 🍄
-gwiezdny pyl ✨ 
* niektore skladniki mozna znalesc tylko w nocy'),nl.

czytaj(K) :-
    pozycja(X),
    X == biblioteka,
    K == grota_krysztalow
    ->
    write('Znane kryształy:
-krystaliczna kula 🫧
-arcyklejnot 💎
* niektorych krysztalow szuka sie dluzej niz innych'),nl.

czytaj(K) :-
    pozycja(X),
    X == biblioteka,
    K == labolatorium
    ->
    retract(dostep_do_skladnikow(0)),
    assert(dostep_do_skladnikow(1)),
    write('Mikstura:
💠Eliksir nieśmiertelności: wampirzy czosnek🧄 + roślina szczęścia🍀 + grzyb nieśmiertelności🍄 + arcyklejnot💎 + gwiezdny pył✨ + nasiona slonca💛
* uzyskalas dostep do nowych komend!'),nl.

%SPIZARNIA==============================================================================================

:- dynamic w_spizarni/1.
w_spizarni(nasiona_slonca).
w_spizarni(nasiona_szczescia).

wez(R) :-
    pozycja(X),
    X == spizarnia,
    (w_spizarni(R) ->
        (torba(R) ->
            write('Ten przedmiot już znajduje się w torbie!'),nl
            ;
            (
                assert(torba(R)),
                write('Zabrałaś do torby: '),
                write(R),nl
            )
        )
        ;
        write('Tej rzeczy nie ma w spiżarni.'),nl
    ).


%GROTA KRYSZTALOW======================================================================================
:- dynamic state/1.
state(0).

szukaj_krysztalow :-
    pozycja(X),
    X == grota_krysztalow
    ->
    (
        state(N),
        N == 0
        ->
        (
            \+ torba(krystaliczna_kula),
            assert(torba(krystaliczna_kula)),
            write('Znalazłeś krystaliczną kulę!'),nl,
            retract(state(0)),
            assert(state(1))
        )
        ;
        (
            \+ torba(arcyklejnot),
            assert(torba(arcyklejnot)),
            write('Znalazłeś arcyklejnot!'),nl,
            retract(state(1)),
            assert(state(0))
        )
    )
    ;
    write('Niedozwolona czynność!'),nl.


%SYPIALNIA===============================================================================================


dzien :-
    pozycja(sypialnia),
    pora_dnia(X),
    retract(pora_dnia(X)),
    asserta(pora_dnia(dzien)),
    jaka_pora_dnia.

noc :-
    pozycja(sypialnia),
    pora_dnia(X),
    retract(pora_dnia(X)),
    asserta(pora_dnia(noc)),
    jaka_pora_dnia.



%OGROD===================================================================================================

:- dynamic w_ogrodzie/1.
:- dynamic podlane/1.

podlane(false).

roslina(nasiona_slonca,kwiat_slonca).
roslina(nasiona_szczescia,roslina_szczescia).

co_w_ogrodzie :-
    pozycja(ogrod),
    findall(X, w_ogrodzie(X), Lista),
    wypisz_lista(Lista).


posadz(N) :-
    pozycja(X),
    X == ogrod,
    (torba(N) ->
        (
            retract(torba(N)),
            assert(w_ogrodzie(N)),
            podlane(Y),
            retract(podlane(Y)),
            assert(podlane(false)),
            write('Posadziłaś: '),
            write(N),nl
        )
        ;
        write('Nie masz tego w torbie!'),nl
    ).

podlej :-
    pozycja(Y),
    Y == ogrod,
    w_ogrodzie(Nasiona),
    roslina(Nasiona, NazwaRosliny),
    retract(w_ogrodzie(Nasiona)),
    assertz(w_ogrodzie(NazwaRosliny)),
    write('Podlalas rosliny.'),nl.

zbierz(X) :-
    pozycja(Y),
    Y == ogrod,
    w_ogrodzie(X),
    (torba(X) ->
        write('Ten przedmiot już znajduje się w torbie!'),nl
        ;
        (
            assert(torba(X)),
            retract(w_ogrodzie(X)),
            write('Zebrałaś: '),
            write(X),nl
        )
    ),
    podlane(Y),
    retract(podlane(Y)),
    assert(podlane(false)).


%MROCZNY LAS ==============================================================================================

szukaj :-
    pozycja(Y),
    Y == mroczny_las,
    (
        pora_dnia(X),
        X == dzien 
        -> 
        (
            (torba(grzyb_niesmiertelnosci) ->
                write('Ten przedmiot już znajduje się w torbie!'),nl
                ;
                (
                    assert(torba(grzyb_niesmiertelnosci)),
                    write('Znalazłaś: grzyb niesmiertelności.'),nl
                )
            )
        )
        ;
        (
            (torba(gwiezdny_pyl) ->
                write('Ten przedmiot już znajduje się w torbie!'),nl
                ;
                (
                    assert(torba(gwiezdny_pyl)),
                    write('Znalazłaś: gwiezdny pył.'),nl
                )
            )
        )
    ).


%KUCHNIA==================================================================================================================

pokaz_kuchnie :-
    write('szafka1...........................................
--------..........................................
|      |..........................................
|      |..........................................
|  &&  |.................lodowka..................
--------.................-------..................
|  &&  |.................|     |..................
|      |.................|     |..................
--------.................|     |..................
.........................|     |..................
.........................|     |...........------.
szafka2.piekarnik.szafka3|     |szafka4.../stol /.
-------------------------|    ~|-------../     /|.
|  ||  || oo  o ||   |   |     ||  |  |./-----/.|.
|  ||  ||+-----+||   |   |     ||  |  |.|.|...|.|.
| &||& |||     |||  &|&  |     || &|& |.|.|...|.|.
|  ||  |||     |||   |   |     ||  |  |.|.|...|.|.
|  ||  |||     |||   |   |     ||  |  |.|.|...|.|.
|  ||  |||     |||   |   |     ||  |  |.|.|...|.|.
==================================================
..................................................
..................................................
........................podloga...................
..................................................
..................................................'),nl.

%meble
mebel(lodowka).
mebel(szafka1).
mebel(stol).
mebel(piekarnik).
mebel(szafka2).
mebel(szafka3).
mebel(szafka4).

nad(szafka1, szafka2).
obok(szafka2, piekarnik).
obok(piekarnik, szafka3).
obok(szafka3, lodowka).
obok(lodowka, stol).

w(szafka1,nic).
w(szafka2,nic).
w(szafka3,wampirzy_czosnek).
w(szafka4,nic).

w(lodowka,nic).
w(piekarnik,nic).

na(stol,nic).

szukaj(X) :-
    pozycja(kuchnia),
    w(X, wampirzy_czosnek),
    write('Znalazłaś wampirzy czosnek w szafce '), write(X), write('. Zabieram go do torby.'), nl,
    zabierz_do_torby(wampirzy_czosnek).

szukaj(X) :-
    pozycja(kuchnia),
    w(X, nic),
    write('W '), write(X), write(' nie ma nic.'), nl.

szukaj(stol) :-
    pozycja(kuchnia),
    na(stol, wampirzy_czosnek),
    write('Znalazłaś wampirzy czosnek na stole. Zabieram go do torby.'), nl,
    zabierz_do_torby(wampirzy_czosnek).

szukaj(stol) :-
    pozycja(kuchnia),
    na(stol, nic),
    write('Na stole nie ma nic.'), nl.

zabierz_do_torby(X) :-
    torba(X),
    write('Wampirzy czosnek jest już w twojej torbie.'), nl.

zabierz_do_torby(X) :-
    \+ torba(X),
    assertz(torba(X)),
    write('Zabrałaś wampirzy czosnek do torby.'), nl.



%LABOLATORIUM==============================================================================================================

zrob_eliksir :-
    pozycja(labolatorium),
    (
        czy_w_torbie(nasiona_slonca),
        czy_w_torbie(arcyklejnot),
        czy_w_torbie(grzyb_niesmiertelnosci),
        czy_w_torbie(roslina_szczescia),
        czy_w_torbie(gwiezdny_pyl),
        czy_w_torbie(wampirzy_czosnek)
    )
    ->
    (
        retract(torba(wampirzy_czosnek)),
        retract(torba(roslina_szczescia)),
        retract(torba(grzyb_niesmiertelnosci)),
        retract(torba(arcyklejnot)),
        retract(torba(gwiezdny_pyl)),
        retract(torba(nasiona_slonca)),
        assert(torba(eliksir_niesmiertelnosci)),
        write('Stworzyłaś eliksir nieśmiertelności!'), nl,
        write('WYGRANA.'), nl
    )
    ;
    write('Brakuje składników!!!')
    .




