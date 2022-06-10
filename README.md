# 
Semestrálka práce na predmet 4IT495 Simulace systému.

Zadanie:

# Stimulovanie a regulavanie chovu ošípaných
### Definícia problému

Rentabilita chovu prasníc vo výraznej miere závisí od produktivity chovu, ktorú zas ovplyvňuje obrátkovosť (počet pôrodov u prasnice počas roka) a počet odchovaných prasiatok od prasnice v priebehu roka. Je zrejmé, že chovatelia v snahe dosiahnúť čo najväčšiu obrátkovosť, musia zabezpečiť, aby u prasníc prebiehal kontinuálny reprodukčný cyklus s optimálnou dĺžkou trvania, opakujúci sa až do vyradenia zvieraťa z chovu.

U prasníc je preto potrebné aktívne monitorovať priebeh reprodukčného cyklu a v prípade jeho porúch ho aj operatívne stimulovať a regulovať. Stimuláciu a reguláciu reprodukčného cyklu u prasníc môžeme vykonávať zootechnickými metódami (transport, úprava kŕmnej dávky, stimulácia kancom, úprava zoohygienických podmienok ustajnenia, vytváranie optimálnych skupín zvierat).


### Cieľ simulácie

Vytvoriť simuláciu chovu ošípanych a zistiť, aké kombinácie rôznych typov stimulácií a regulovania reprodukčného cyklu chovaných ošípaných prináša najlepšie výsledky.

### Popis simulácie

Budeme mať niekoľko typov chovateľov, ktorý budú mať rôznu úroveň vzdelania v oblasti stimulácie a regulovania reprodukčného cyklu ošípaných. Každý chovateľ bude začínať s rovnakým množstvom samcov, samíc, mládať a rovnakým množstvom peňazí.

Peniaze míňajú chovatelia dvoma spôsobmi. Na krmivo míňajú chovatelia peniaze rovnakým spôsobom. Každý jeden kus jedného typu ošípanej (samec, samica, mláďa) má rovnaké náklady na krmivo pre všetkých chovateľov. Zvyšné peniaze chovatelia míňaju podľa vlastného uváženia (vzdelanostnej úrovni) na stimuláciu a regulovanie reprodukčného cyklu.

Každý chovateľ má príjem z predaja ošípaných. Na začiatku bude nastavený rovnaký počet predaja prasníc za určitý čas. Každý chovateľ môže množstvo predaných ošípaných zmeniť po zavedení stimulácie alebo regulácie reprodukčného cyklu. Každý chovateľ sa teda môže svoje príjmy znižovat alebo zvyšovať, ale vždy si ponechá aspoň také príjmy aby bol schopný nakŕmniť všetky chované zvieratá.

### Nástroj

NetLogo

### Autor

Marcel Žec, zecm01

### Zdroje
[1] RESTENSKÝ A KOL., V. NÁRODNÉ POĽNOHOSPODÁRSKE A POTRAVINÁRSKE CENTRUM - VÝSKUMNÝ ÚSTAV ŽIVOČÍŠNEJ VÝROBY NITRA. Chov hospodárskych zvierat [online]. Nitra, 2015, s. 155-228 [cit. 2022-06-07]. ISBN 978-80-89417-41-1. Dostupné z: http://www.vuzv.sk/pdf/chov_hz.pdf

[2] MACÁK, PHD., Doc. MVDr. Vladimír, MVDr. Nela KYZEKOVÁ, Prof. MVDr. Peter REICHEL, CSC., MVDr. Miroslav HÚSKA, PHD., MVDr. Herbert SEIDEL, PHD., MVDr. Róbert LINK, PHD., MVDr. Jaroslav NOVOTNÝ, PHD. a MVDr. Katarína KOVAČOCYOVÁ, PHD. Indukcia ruje a ovulácie u prasničiek a prasníc. INFOVET: veterinársky odborný časopis [online]. Prešov: M&M vydavateľstvo [cit. 2022-05-04]. Dostupné z: https://infovet.sk/indukcia-ruje-a-ovulacie-u-prasniciek-a-prasnic/


### Poznatky zo zdroja vhodné pre simuláciu
##### Pohlavné dospievanie [1]
- Prvé prejavy pohlavného dospievania sa objavujú vo veku 4-5 mesiacov pri hmotnosti cca 50-70 kg a jeho ukončenie
- pohlavná dospelosť je asi vo veku 7 mesiacov, pri hmotnosti približne 90 kg. 
- Prvé pripustenie prasničky odporúčame vo veku 220-240 dní, pri hmotnosti 110-130 kg v závislosti od plemennej príslušnosti, t.j. v čase, kedy už predtým prebehli 3-4 plnohodnotné ruje. 

##### Pohlavný cyklus [1]
Prasnica je polyestrické zviera, u ktorého sa na pohlavných orgánoch a v celom
organizme objavujú pravidelne sa opakujúce zmeny počas celého roka, ktoré
charakterizujeme ako pohlavný cyklus. Tento je v priemere 21 dňový (18-24 dní), pri
mladých prasničkách je kratší a pri starších prasniciach dlhší. Rytmus pohlavných cyklov
len málo ovplyvňuje ročné obdobie a fyziologicky ho prerušuje gravidita. Pohlavný
cyklus rozdeľujeme na 4 štádiá:
1. Proestrus (obdobie pred rujou) trvá asi 2-3 dni a charakterizuje ho rast folikulov
a regresia starých žltých teliesok z predošlého cyklu, edematózne zdurenie vulvy,
dráždivosť, nepokoj.
2. Estrus (obdobie samotnej ruje) trvá 1,5-2,5 dňa, je charakterizované dozrievaním
Graafových folikulov, ich ovuláciou, otvorením kŕčka maternice, tvorbou
cervikálneho hlienu, zmenou správania - reflex nehybnosti (ochota páriť sa).
Vrcholom ruje je ovulácia, ktorá prebieha 3-8 hodín pred jej skončením a trvá asi 4-7
hodín.
3. Metestrus (obdobie po ruji) trvá asi 7-8 dní. Je charakterizované rýchlym vývojom
žltých teliesok v mieste ovulovaných folikulov, uzatvorením kŕčka maternice,
zánikom edému vulvy a celkovým upokojením správania sa prasnice.
4. Diestrus (obdobie medzi rujami) je obdobie pohlavného kľudu s trvaním 7-9 dní.
Počas tohto obdobia nevznikajú žiadne zmeny na pohlavných orgánoch prasníc, ani
v ich správaní. Na konci diestru sa začína regresia žltých teliesok a nastupuje zasa
proestrus (pokiaľ nie je prasnica prasná).

##### Predpôrodné obdobie a pôrod [1]
Dĺžka prasnosti je pri prasniciach ***115 ± 5 dní***.

##### Prirodzené pripúšťanie [1]
- V bežných chovoch sa kance obmieňajú po 16-24 mesiacoch
- Pri využívaní prirodzenej plemenitby je potrebné počítať na jedného kanca v priemere 20-25 prasníc
- Dospelý kanec sa môže využívať na ***tri skoky týždenne***
- pri mladých kančekoch sú to ***1-2 skoky týždenne***.
- Prestávky medzi skokmi by ***mali trvať tri dni***, maximálne 6 dní.
- oplodnenie po I. inseminácii ***70 %*** a viac
- priemerná veľkosť vrhu ***12***  a viac

##### Biotechnické metódy využívané v reprodukcii ošípaných [1]
Po odstave ciciakov od prasníc sa ruja objaví do 6 dní v priemere na 3.-9. deň. Pokiaľ
sa odstav uskutoční v termíne nad 35-42 dní veku ciciakov, nie je vo všeobecnosti
potrebná žiadna hormonálna stimulácia a ruja sa objaví u viac ako 90 % prasníc.
Skracovaním doby odstavu na 28-42 dní je pre dosiahnutie 90 % ruje u prasníc potrebná
stimulácia.

- oplodnenie po I. inseminácii 70 % a viac
- priemerná veľkosť vrhu 12 a viac 

##### Výživa a kŕmenie [1]
- Presun prasníc do pôrodných kotercov sa uskutočňuje obvykle okolo 110. dňa gravidity (štandardná dĺžka gravidity je 112-116 dní). V tomto období sa prasnice kŕmia už kŕmnou zmesou pre kojace prasnice OŠ 09 (PKK) v množstve do ***3,0 kg/deň***
- Základom prepočtu denného príjmu krmiva počas dojčenia je ***2,2 kg*** krmiva na záchov
prasnice plus ***0,3 až 0,4 kg*** na každé prasiatko. 
- Od hmotnosti 15 kg sa ošípané s postupným prechodom zo štartéru kŕmia zmesou pre ošípané vo výkrme OŠ 03 s optimálnym pomerom živín, aby sa maximálne využil rastový potenciál zvierat pre tvorbu svaloviny. Táto zmes sa používa do dosiahnutia 35 kg, kedy končí predvýkrm. Smerodajným ukazovateľom pri dobrom kŕmení je dosiahnutie živej hmotnosti 36 - 40 kg vo veku 90 dní. V tejto hmotnosti sa počíta s denným príjmom zmesi
***1,5 kg***.
- Plemenné kance sa kŕmia kŕmnou zmesou OŠ 10, ktorá sa skrmuje v závislosti od veku, kondície a pohlavného zaťaženia v dennom množstve ***2,0 – 3,5*** kg. 

##### Stimulácii „nástupu“ puberty u prepubertálnych prasničiek [2]
- denný kontakt prasničiek vo veku 160 – 180 dní s kancom, minimálne po dobu 15. minút, vyvoláva ruju u 70 – 80 % zvierat do 28 dní
- prasničky sa nepripúšťajú hneď počas prvej ruje, ale až na druhú alebo tretiu 
- odmienkou úspešnej indukcie puberty u prasničiek je, že na stimuláciu sa používa kanec starší ako 11 mesiacov

##### Množstvo prasničiek [2]
- Optimalizácia veľkosti skupín prasničiek je dôležitá, lebo je preukázané, že prasničky chované v malých skupinách (3 ks) vykazujú neskorší nástup puberty a ich prejavy ruje sú menej výrazné ako u chovaných po 10 ks
- Viacpočetné skupiny prasníc, najmä keď sú ustajnené na malej ploche kotercov, zas zvyšujú riziko pôsobenia stresov zo vzájomného napádania sa, čo negatívne ovplyvní nástup a priebeh ruje u prasníc.

##### Stimulácii „nástupu“ puberty u prepubertálnych prasničiek [2]
- presun zvierat z farmy na farmu indukuje ruju u prasničiek do jedného týždňa

##### Zloženie kŕmnej dávky (výživa) [2]
- Prasničky sú väčšinou kŕmené krmivom s limitovanou energetickou hodnotou. Vytvárajú sa tak podmienky pre ich optimálny rast, ale obmedzuje sa u nich tvorba nadmerného tuku.
- zvýšenie energetickej hodnoty krmiva o 50 – 100 %, 10 – 14 dní pred prvým pripustením, zvyšuje počet ovulácií na vaječníkoch prasničiek, skracuje čas dĺžky ovulácií a tým pozitívne ovplyvňuje veľkosť vrhu prasníc

##### Dĺžke laktácie prasníc [2]
- Čím je dlhšia laktácia, tým kratší je potom interval odstav a tým aj väčšie percento prasničiek, ktoré bezprostredne po odstave vykazujú ruju. 
- Ruju 4 dni po odstave zaznamenáme u prasníc, ktoré dojčili minimálne 3 týždne. Kratšie dojčenie znižuje plodnosť prasníc. 
- 90 – 95 % prasníc chovaných v optimálnych podmienkach sa ruja manifestuje do 10 dní po odstave. U väčšiny sa estrus prejaví 4. – 7. deň po odstave
- Predĺžovaním dojčenia na 4, 5, respektíve 6 týždňov síce dosiahneme vyššiu mieru prasníc, ktoré na 4. – 6. deň po odstave vykazujú fertilnú ruju, ale predlžujeme reprodukčný cyklus prasníc a tým strácame možnosť zvyšovať obrátkovosť u zvierat (365 dní/115 dní + 21 dní + 4 dní = obrátkovosť 2,6; 365 dní/115 dní + 28 dní + 4 dní = obrátkovosť 2,5).

##### Diagnostika ruje  [2]
- Dĺžka ruje u prasničiek je 24 – 28 hodín, u prasníc môže trvať 78 hodín
- K ovulácii dochádza v poslednej tretine ruje (38 až 48 hodín od začiatku ruje)
