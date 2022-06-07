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

MACÁK, PHD., Doc. MVDr. Vladimír, MVDr. Nela KYZEKOVÁ, Prof. MVDr. Peter REICHEL, CSC., MVDr. Miroslav HÚSKA, PHD., MVDr. Herbert SEIDEL, PHD., MVDr. Róbert LINK, PHD., MVDr. Jaroslav NOVOTNÝ, PHD. a MVDr. Katarína KOVAČOCYOVÁ, PHD. Indukcia ruje a ovulácie u prasničiek a prasníc. INFOVET: veterinársky odborný časopis [online]. Prešov: M&M vydavateľstvo [cit. 2022-05-04]. Dostupné z: https://infovet.sk/indukcia-ruje-a-ovulacie-u-prasniciek-a-prasnic/

RESTENSKÝ A KOL., V. NÁRODNÉ POĽNOHOSPODÁRSKE A POTRAVINÁRSKE CENTRUM - VÝSKUMNÝ ÚSTAV ŽIVOČÍŠNEJ VÝROBY NITRA. Chov hospodárskych zvierat [online]. Nitra, 2015, s. 181 [cit. 2022-06-07]. ISBN 978-80-89417-41-1. Dostupné z: http://www.vuzv.sk/pdf/chov_hz.pdf

### Poznatky zo zdroja vhodné pre simuláciu

##### Stimulácii „nástupu“ puberty u prepubertálnych prasničiek
- denný kontakt prasničiek vo veku 160 – 180 dní s kancom, minimálne po dobu 15. minút, vyvoláva ruju u 70 – 80 % zvierat do 28 dní
- prasničky sa nepripúšťajú hneď počas prvej ruje, ale až na druhú alebo tretiu 
- odmienkou úspešnej indukcie puberty u prasničiek je, že na stimuláciu sa používa kanec starší ako 11 mesiacov

##### Množstvo prasničiek
- Optimalizácia veľkosti skupín prasničiek je dôležitá, lebo je preukázané, že prasničky chované v malých skupinách (3 ks) vykazujú neskorší nástup puberty a ich prejavy ruje sú menej výrazné ako u chovaných po 10 ks
- Viacpočetné skupiny prasníc, najmä keď sú ustajnené na malej ploche kotercov, zas zvyšujú riziko pôsobenia stresov zo vzájomného napádania sa, čo negatívne ovplyvní nástup a priebeh ruje u prasníc.

##### Stimulácii „nástupu“ puberty u prepubertálnych prasničiek
- presun zvierat z farmy na farmu indukuje ruju u prasničiek do jedného týždňa

##### Zloženie kŕmnej dávky (výživa)
- Prasničky sú väčšinou kŕmené krmivom s limitovanou energetickou hodnotou. Vytvárajú sa tak podmienky pre ich optimálny rast, ale obmedzuje sa u nich tvorba nadmerného tuku.
- zvýšenie energetickej hodnoty krmiva o 50 – 100 %, 10 – 14 dní pred prvým pripustením, zvyšuje počet ovulácií na vaječníkoch prasničiek, skracuje čas dĺžky ovulácií a tým pozitívne ovplyvňuje veľkosť vrhu prasníc

##### Dĺžke laktácie prasníc
- Čím je dlhšia laktácia, tým kratší je potom interval odstav a tým aj väčšie percento prasničiek, ktoré bezprostredne po odstave vykazujú ruju. 
- Ruju 4 dni po odstave zaznamenáme u prasníc, ktoré dojčili minimálne 3 týždne. Kratšie dojčenie znižuje plodnosť prasníc. 
- 90 – 95 % prasníc chovaných v optimálnych podmienkach sa ruja manifestuje do 10 dní po odstave. U väčšiny sa estrus prejaví 4. – 7. deň po odstave
- Predĺžovaním dojčenia na 4, 5, respektíve 6 týždňov síce dosiahneme vyššiu mieru prasníc, ktoré na 4. – 6. deň po odstave vykazujú fertilnú ruju, ale predlžujeme reprodukčný cyklus prasníc a tým strácame možnosť zvyšovať obrátkovosť u zvierat (365 dní/115 dní + 21 dní + 4 dní = obrátkovosť 2,6; 365 dní/115 dní + 28 dní + 4 dní = obrátkovosť 2,5).

##### Diagnostika ruje 
- Dĺžka ruje u prasničiek je 24 – 28 hodín, u prasníc môže trvať 78 hodín
- K ovulácii dochádza v poslednej tretine ruje (38 až 48 hodín od začiatku ruje)
