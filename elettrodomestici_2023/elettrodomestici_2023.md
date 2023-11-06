$$\textbf{\color{lightgreen} \huge 🌀 Elettrodomesticoi Smart 2023💦}$$

<p align="center"> 🔥 <b>con AUTO-DOWNLOAD e AUTO-CONFIG</b> 🔥 </p>

| Sommario |
| :---: |
| [Introduzione](#introduzione) |
| [Prerequisiti](#prerequisiti) | 
| [Dispositivi](#dispositivi) | 
| [Funzionamento](#funzionamento) | 
| [User interface](#user-interface) |
| [Installazione](#installazione) | 
| [Configurazione](#configurazione) |
| [Conclusioni](#conclusioni) |

**Paragrafi obbligatori:**
- [x] [Prerequisiti](#prerequisiti)
- [x] [Installazione](#installazione)
- [x] [Configurazione](#configurazione)

<br>

|  |  |
| :---: | --- |
| Livello | Novizio (Novizio, Esperto, Pro) |
| Difficoltà | Bassa (Bassa, Media, Alta) |

<br>

**Ti piace questo package? Lascia una stella su Github e supportami per realizzarne altri!** <a href="https://www.buymeacoffee.com/jumping"><img src="https://cdn.buymeacoffee.com/buttons/default-yellow.png" height="20"></a>

[![Websitebadge]][website] [![Forum][forumbadge]][forum] [![telegrambadge]][telegram] [![facebookbadge]][facebook] 

## Introduzione

L'articolo riprende quanto avevamo già scritto nel 2020 con l'articolo **[Elettrodomestici Smart](https://hassiohelp.eu/2020/04/05/elettrodomestici-smart-con-home-assistant/)** che ha introdotto:
1. un package per poter monitorare lo stato degli elettrodomestici non smart utilizzando una presa o dispositivo in grado di effettuare delle misurazione dei livelli di potenza, 
2. una card Lovelace con effetti grafici CSS ed informazioni di funzionamento. 

In particolare in questo articolo descriveremo le procedure di installazione e configurazione per questi quattro elettrodomestici:
* Asciugatrice
* Lavatrice
* Lavastoviglie
* Forno

Nell'**edizione 2023** sono usati alcuni custom ricchi di funzionalità come [Button Card](https://github.com/custom-cards/button-card) ed [ApexChart Card](https://github.com/RomRider/apexcharts-card) che oramai sono diventati dei veri e propri classici delle interfacce sviluppate per Home Assistant e introdurremo ulteriori elementi sia a livello di dati disponibili che a livello di grafica, ma le perle che rendono l'uso del package veramente superiore sotto tutti punti di vista rispetto a pacchetti analoghi sono:
* l'utilizzo di una "macchina a stati finiti" [FSM](https://it.wikipedia.org/wiki/Automa_a_stati_finiti) che restituisce lo stato del dispositivo in maniera molto precisa. 
* Un [Blueprint](https://www.home-assistant.io/docs/automation/using_blueprints/) semplificherà la configurazione e contemporaneamente darà ottima precisione nella rilevazione delle fasi di asciugatura.
* **🔥E novità assoluta, il tutto sarà auto-configurante senza necessità di scrivere complesse istruzioni YAML** 🔥

Riepiloghiamo i punti di forza di questo pacchetto sono:
1. Adattabile per l'uso su tablet, smartphone, PC;
2. Macchina a stati finiti per ricavare lo stato della elettrodomestico;
3. Utilizzo di codice YAML non obsoleto e riduzioni del "codice inutile";
4. Versioni grafica unificata per dashboard "_yaml_" e "_storage_", vedi [Dashboard](https://www.home-assistant.io/dashboards/dashboards/);
5. Riduzione del numero di componenti custom necessari;
6. Utilizzo dei dati statistici conservati nel DB di HA senza quindi richiedere uan retention "_infinita_" o cmq molto estesa del DB stesso;

<br>

$$\textbf{\color{red} \normalsize 🚨 Come usuale prestate massima attenzione ai collegamenti elettrici. 🚨}$$


## Prerequisiti 

Per poter utilizzare il packages occorrono alcune card e alcune configurazioni abbastanza comuni, le card e i custom sono disponibili sul community store [HACS](https://hacs.xyz/) , sul sito [HassioHelp.eu](https://hassiohelp.eu) sono presenti numerose guide, prestate particolare attenzione alla data di rilascio della guida, alcune sono datate e potrebbero essere da ricontrollare, in questo caso il gruppo Telegram [HassioHelp](https://t.me/HassioHelp) è un validissimo aiuto.

| Card/Custom | Uso |
| :---: | --- |
| **[Button Card](https://github.com/custom-cards/button-card)** | Obbligatorio |
| **[ApexChart Card](https://github.com/RomRider/apexcharts-card)** | Obbligatorio |
| **[Browser Mod](https://github.com/thomasloven/hass-browser_mod)** | Obbligatorio |
| **[Card Mod](https://github.com/thomasloven/lovelace-card-mod)** | Obbligatorio |
| **[Layout Card](https://github.com/thomasloven/lovelace-layout-card)** | Usato ma non indispensabile |
| **[Bar Card](https://github.com/custom-cards/bar-card)** | Usato ma non indispensabile |
| **[Multiple Entity Row](https://github.com/benct/lovelace-multiple-entity-row)** | Usato ma non indispensabile |

L'utilizzo delle card _non indispensabili_ permette una migliore visualizzazione delle informazioni soprattutto con i dispositivi smartphone ma nulla vieta di poterle rimuovere utilizzando dei layout più scomodi ma comunque fruibili (questo vale per la Layout Card e la Multiple Entity Row). La rimozione dei card custom e dl relativo adattamento del codice YAML è lasciato al lettore "evoluto" in grado di procedere in autonomia.

| Configurazioni obbligatorie |
| :---: |

Per poter procedere con l'installazione del package ci sono alcuni passi da effettuare (potete saltare questa parte se avete già tutto configurato):
* abilitare i packages come descritto qui: [Packages](https://www.home-assistant.io/docs/configuration/packages/) oppure su [HassioHelp](https://hassiohelp.eu);
* configurare Home Assistant per avere i sensori di tempo e di data come spiegato qui: [Time & Date](https://www.home-assistant.io/integrations/time_date/) o nelle guide [HassioHelp](https://hassiohelp.eu);
* impostazione dei servizi di notifica: ad esempio [Telegram](https://www.home-assistant.io/integrations/telegram/), [Google](https://www.home-assistant.io/integrations/google_assistant/), [Mobile App](https://companion.home-assistant.io/) la scelta migliore rimane sempre l'uso del [Centro Notifiche](https://github.com/caiosweet/Package-Notification-HUB-AppDaemon) che centralizza la configurazione di tutti i servizi di notifica.
* configurare il ***blueprint*** ad hoc.

| Guide Hassiohelp |
| :---: |

Ecco alcune guide pubblicate da [HassioHelp.eu](https://hassiohelp.eu) che sicuramente sono meno aggiornate della documentazione ufficiale ma restano valide: 
* [Packages](https://hassiohelp.eu/2018/11/30/package-configurazione/)
* [ESPHome](https://hassiohelp.eu/2019/06/09/esphome/)
* [HACS](https://hassiohelp.eu/2019/10/06/hacs-guida-allinstallazione/)
* [Google](https://hassiohelp.eu/2018/11/29/google-home/)
* [Alexa](https://hassiohelp.eu/2019/12/11/alexa-su-home-assistant-gratis/)
* [Centro Notifiche](https://hassiohelp.eu/2020/11/09/centro-notifiche-3-0-appdaemon/)
* [Animazioni CSS](https://hassiohelp.eu/2020/04/09/css-lovelace/)

## Dispositivi

E' fondamentale avere una presa, o un relay “smart” (come la famiglia Shelly PM) o altro sistema smart basato su pinza amperometrica come Shelly EM o PZEM che restituisca la ***potenza assorbita in watt/Kw***  dall'elettrodomestico. 

## Funzionamento

L’idea alla base dell'articolo è che grazie alle informazioni di potenza restituite dalla presa smart siamo in grado di capire in che stato si trova il nostro elettrodomestico e quindi possiamo costruire una serie di sensori che diano delle informazioni da visualizzare nella UI di Home Assistant o piuttosto per avvertirci quando stendere i panni tramite un servizio di notifica.

Vediamo in dettaglio quali sono gli stati per ognuno dei quattro elettrodomestico: le transizioni da uno stato ad un altro sono guidate dalla potenza assorbita dall'elettrodomestico stesso e dal tempo di permanenza nello stato:

| Stato | Caratteristiche | Elettrodomestico |
| :---: | --- | --- |
| **Idle** | Stato iniziale a riposo della asciugatrice | Asciugatrice |
| **Asciugatura** | Avvio del programma di asciugatura dei panni | Asciugatrice |
| **Mantenimento** | Fase di mantenimento a bassa potenza | Asciugatrice |
| **Svuotare** | Stato finale del programma di asciugatura | Asciugatrice |
||||
| **Idle** | Stato iniziale a riposo della lavatrice | Lavatrice |
| **Lavaggio** | Avvio del programma con il riscaldamento dell'acqua e lavaggio dei panni vero e proprio | Lavatrice |
| **Risciacquo** | Fase di risciacquo in cui sono eliminati i residui di detersivo |Lavatrice |
| **Svuotare** | Stato finale del programma di lavaggio | Lavatrice |
||||
| **Idle** | Stato iniziale a riposo del forno | Forno |
| **Riscaldamento** | Avvio del programma di cottura con il riscaldamento del forno | Forno |
| **Mantenimento** | Fase di mantenimento della temperatura | Forno |
| **Raffreddamento** | Stato finale di raffreddamento | Forno |
||||
| **Idle** | Stato iniziale a riposo della lavastoviglie | Lavastoviglie |
| **Lavaggio** | Avvio del programma di lavaggio con il riscaldamento dell'acqua | Lavastoviglie |
| **Risciacquo** | Fase di risciacquo | Lavastoviglie |
| **Asciugatura** | Stato finale di asciugatura delle stoviglie | Lavastoviglie |

<br>

Anche chi possiede un elettrodomestico smart che espone in HA lo stato dell'elettrodomestico potrà utilizzare il package adattando il codice ai dati esposti dall'integrazione smart.

---

Il package e la relativa card espongono una serie di dati, funzionalità, grafici, proviamo a riassumerle:

**Dati**

* Dati giornalieri, settimanali, mensili ed annuali di energia (kWh) consumata e relativo costo in €
* Numero dei cicli giornalieri, settimanali, mensili ed annuali di asciugatura effettuati 
* Durata dei cicli giornalieri, settimanali, mensili ed annuali di asciugatura effettuati
* Numero e durata totale dei cicli effettuati
* Durata, energia e costo dell'ultimo asciugatura

**Grafici**

* Grafico X-Y della potenza consumata
* Grafico a barre dei cicli di funzionamento per programmare la manutenzione
* Grafico a istogramma dell'energia consumata negli ultimi 30 giorni
* Grafico a barre per corrente, tensione, potenza attiva, apparente e reattiva se restituiti dalla presa smart o altro sistema di misura.

**Funzionalità presenti**

* Timer con vari programmi dell'elettrodomestico per tenere sotto controllo il tempo trascorso
* Notifiche per i cambi di stato


***Altra funzionalità innovativa del package è l'uso delle funzionalità di esposizione dei dati statistici delle card standard Lovelace e Apex senza quindi incidere nelle dimensioni del DB***, il `recorder` può quindi rimanere configurato con i classici 5-10 giorni di memorizzazione dei dati ma è possibile visualizzare i dati di energia consumata degli ultimi 30 giorni o più se uno desidera.

<br>

## User Interface

<table align="center">
	<tr>
	  <th><center> 🖥 Desktop 🖥<center></th>
      <th><center>📱 Mobile 🔋<center></th>
	</tr>
    <tr>
      <td><div align=center><img width = "450" src="img/asciugatrice_1.png"/></div></td>
      <td><div align=center><img width = 420 src="img/asciugatrice_2.png"/></div></td>
    </tr>
    <tr>
        <td><div align=center><img width = "450" src="img/forno_pollo1.png"/></div></td>
        <td><div align=center><img width = 420 src="img/forno_2.png"/></div></td>
    </tr>
</table>

La card è, in sostanza, una _custom button-card_ con funzionalità di _container_ che al suo interno contiene due importanti sezioni:
* la _parte superiore_ è costituita da una _picture-elements card_
* la _parte inferiore_ è costituita da una fila orizzontale di 5 bottoni a loro volta realizzati con _custom button-card_

La ***picture-elements*** card ha la funzione di _contenitore_ sia per elementi grafici che informazioni testuali:
* **sulla parte sinistra** è presente l'immagine grafica dell'elettrodomestico, i CSS presenti nella configurazione fanno in modo che ad ogni stato corrisponda una animazione.
* **nella parte centrale** è collocato il grafico della potenza assorbita dalla elettrodomestico.
* **nella parte destra** è presente il grafico a barre dei cicli di asciugatura che indica quanti cicli sono stati effettuati e dove il 100% rappresenta il numero di cicli dopo il quale è  necessario effettuare una manutenzione.
* **in alto a destra** troviamo le informazioni testuali relative ad energia, potenza, stato, n° cicli.
* **in basso** sotto l'immagine dell'elettrodomestico è presente la scelta del programma dell'elettrodomestico con il tempo rimasto.

La sezione orizzontale di bottoni in basso ("***button container***") presenta le seguenti informazioni:

| Bottone | Cosa fa |
| :---: | --- |
| **Info** | cliccando si apre una finestra con le informazioni di dettaglio relative alla consumi/cicli/costi per giorno, settimana, mese, anno ed aspetti di configurazione |
| **Settimana** / **Mese** / **Anno** |informazioni relative all'energia consumata e i costi associati |
| **Elettrodomestico** | bottone che con il tocco singolo spegne/accende la presa collegata all'elettrodomestico, con il tocco prolungato apre la finestra con i dati e i grafici di energia recuperati dalle informazioni statistiche contenute nel DB di HA |

Come detto la card è adattabile al dispositivo usato e al suo orientamento, non si tratta una card _responsive_ ma si è cercato di rendere la fruizione buona sia su smartphone che su PC o tablet.

<table align="center">
	<tr>
	    <th><center>🎫 Info Card 🎫</center></th>
      <th><center>☢ Energy Card ☢</th>
	</tr>
    <tr>
        <td><div align=center><img width = 400 src="img/lavatrice_3.png"/></div></td>
        <td><div align=center><img width = 400 src="img/lavatrice_4.png"/></div></td>
    </tr>
	<tr>
	    <th><center>🌀 Centrifuga in corso 🌀</center></th>
      <th><center>🎽 E' l'ora di tendere i panni 🎽</center></th>
	</tr>
    <tr>
        <td><div align=center><img width = 400 src="img/centrifuga.png"/></div></td>
        <td><div align=center><img width = 400 src="img/svuotare.png"/></div></td>
    </tr>
</table>


## Installazione
Dopo aver configurato tutti i vari custom componments e aver otemperato ai prerequisiti è venuto il momento di iniziare con l'installazione vera e propria dei packages, che si compone di quattro passaggi:
1. download da Github dello script di installazione
2. avvio dello script in modalità "download"
3. completamento del blueprint relativo all'elettrodomestico scelto
4. avvio dello script in modalità "config"

Vediamo nel dettaglio i passaggi.

| Download dello script|
| :---: |

Il download automatico dei packages è possibile con l'utilizzo dello script `smart_config.sh`, per cui è necessario effettuare il download del file e il posizionamento nella dir `/config` o altra nella propria istanza di Home Assistant e quindi dare i giusti permessi di esecuzione, tutto questo è possibile con i seguenti passaggi attraverso la **CLI** (Command Line Interface) messa a disposizione dall'[addon SSH](https://github.com/hassio-addons/addon-ssh) oppure da CLI del container di Home Assistant o su host nel caso di installazione HA Core su VENV:
* avviare l'addon SSH o collegarsi alla CLI del container;
* posizionarsi nella cartella  `/config`;
* scaricare lo script da github `smart_config.sh`;
* dare i giusti permessi allo script con il comando `chmod`;

Di seguito la sequenza dei comandi:

```bash
/# cd /config
/config# wget https://raw.githubusercontent.com/jumping2000/ha-packages/main/smart_config.sh
/config# chmod +x smart_config.sh

```

**NOTA:** Se non riesci a lanciare i comandi precedenti dall'addon SSH, utilizza nella conf dell'addon l'username ***root***, potrai ripristinare il precedente username alla fine della configurazione.

| Struttura dei file |
| :---: |

La struttura dei file è rappresentata di seguito, lo script di download utilizzerà questa alberatura, in alternativa l'utente esperto può riposizionare i files nella maniera che più preferisce. 

La card Lovelace è unica ed è disponibile sia per chi usa la modalità [YAML o storage](https://www.home-assistant.io/dashboards/dashboards/).

**NOTA**:
Saranno presenti due cartelle _autoconfig_, una per PC (_autoconfig_x86_64_) e una per Raspberry (_autoconfig_rpi_).


```bash
.
├── addons/
├── backup/
│
├── config/
│   │
│   ├── lovelace/
│   │   └── card_elettrodomestici/
│   │       ├── card_lavastoviglie.yaml
│   │       ├── card_forno.yaml
│   │       ├── card_lavatrice.yaml
│   │       └── card_asciugatrice.yaml
|   |
│   ├── packages/
│   │   ├── autoconfig/
│   │   │   ├── pyarmor_runtime_000000/
│   │   │   └─── auto_config.py
│   │   ├── keys.txt
│   │   └── elettrodomestici/
│   │       ├── washing_machine.yaml
│   │       ├── dishwasher.yaml
│   │       ├── oven.yaml
│   │       └── dryer.yaml
│   │
│   ├── www/
│   │   └── hassiohelp/
│   │       └── pkg_elettrodomestici/
│   │           ├── XXXXX.png
.   .           ... XXXXX.png
│   │           ├── XXXXX.png
│   │           ├── sfondo_black.png
│   │           ├── sfondo_white.png
│   │           ├── sfondo_gray.png
│   │           └── sfondo_gray2.png
│   │ 
│   ├── home-assistant.log
│   └── secret.yaml
├── share/
└── ssl/
```

## Configurazione

Tutti i packages ***"Elettrodomestici"*** dipendono da un unico blueprint e da uno script che permette download e configurazione automatici.

| Download package & card |
| :---: |

Effettuare i seguenti passaggi attraverso l'addon SSH oppure da CLI del container:
* effettuare il backup di HA;
* avviare lo script `smart_config.sh`con l'opzione `download` (--> `config# ./smart_config.sh download` <--), questo script si preoccuperà di effettuare il download di tutti i files necessari;
* seguire le istruzioni dello script rispondendo "**Si**" alle prime tre domande relative alla scrittura dei file (ovviamente se si tratta della prima installazione di un package, già per i successivi occorre prestare attenzione altrimenti sovrascriverete i package già configurati), inserendo l'elettromestico da configurare e l'entità di energia;

Fatto questo **riavviate  Home Assistant** e verificate che non ci siano nel log errori relativi al nuovo package (ad esempio **dryer.yaml** oppure **oven.yaml**, etc). 
**In particolare** occorre prestare attenzione a non avere entità con lo stesso nome di altri package, un esempio è `input_number.costo_energia` che è presente in tutti e quattro i packages di ***Elettrodomestici 2023***, per cui se si installano due o più package occorre fare in modo che questa entità sia unica.

| Blueprint |
| :---: |

$$\textbf{\color{blue} \normalsize 🌀 Ricorda per ogni elettrodomestico che vorrai configurare dovrai eseguire il blueprint. 🌀}$$

Lanciare il blueprint [CN FSM ](https://github.com/jumping2000/ha-templates/tree/main/blueprints/cn_fsm):
* impostare le entità richieste come sensori di potenza e energia e le soglie di potenza relative all'attivazioni dell'elettrodomestico
* impostare le modalità di notifica, il blueprint funziona sia con il ***Centro Notifiche*** che senza;
* nel link precedente trovi la descrizione delle funzionalità offerte.

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fjumping2000%2Fha-templates%2Fblob%2Fmain%2Fblueprints%2Fcn_fsm%2Fcn_fsm_appliances.yaml)


Nel blueprint occorre indicare i sensori relativi a potenza ed energia, i servizi di notifica, alcuni helper e le entità relative allo stato dell'eletrodomestico  scelto, anche se poi ogni utilizzatore è libero di cambiarli; il tutto è abbastanza semplice poichè è organizzato in maniera ordinata secono questo ordine:

1. prima si inseriscono i dati relativi alla presa/dispositivo di misurazione, quindi potenza, energia, tensione, corrente etc 
2. dopo si inseriscono le entità relative all'elettrodomestico scelto e specificati di seguito, per facilitare la compilazione si può inserire il nome ad esempio "asciugatrice" nel campo di inserimento.
3. quindi si inseriscono le varie soglie di innesco delle varie fasi di lavaggio/cottura etc
4. come ultimo punto si inseriscono le informazioni necessarie per le notifiche


Vediamo ora le entità relative al punto **2.** da inserire per singolo eletrodomestico:


ASCIUGATRICE
* `input_select.dryer_status`
* `sensor.dryer_status`
* `input_boolean.asciugatrice_runtime`
* `input_number.asciugatrice_energia_iniziale`
* `counter.cicli_asciugatrice`

FORNO
* `input_select.oven_status`
* `sensor.oven_status`
* `input_boolean.forno_runtime`
* `input_number.forno_energia_iniziale`
* `counter.cicli_cottura_forno`

LAVATRICE
* `input_select.washing_machine_status`
* `sensor.washing_machine_status`
* `input_boolean.lavatrice_runtime`
* `input_number.lavatrice_energia_iniziale`
* `counter.cicli_lavaggio_lavatrice`

LAVASTOVIGLIE
* `input_select.dishwasher_status`
* `sensor.dishwasher_status`
* `input_boolean.lavastoviglie_runtime`
* `input_number.lavastoviglie_energia_iniziale`
* `counter.cicli_lavaggio_lavastoviglie`
<br>

| Configurazione package & card |
| :---: |

Dopo le operazioni preliminare sul package e il completamento del blueprint si passa alla fase finale di configurazione "automatica":

* avviare lo script `smart_config.sh`con l'opzione `config` (--> `config# ./smart_config.sh config` <--), questo script si preoccuperà di configurare il pacchetto con i dati inseriti nel blueprint;

* controllare package e card con un editor di testo e verificare che non ci siano tag "**ENTITA' NON NEL BLUEPRINT**", che può indicare 2 cose:
  * hai dimenticato di inserire nel blueprint delle entità necessarie;
  * ci sono delle entità da cancellare poichè non significative nella tua configurazione;
* finiti questi passaggi inserire la card dell'elettrodomestico (es. card_lavatrice.yaml) nella propria configurazione Lovelace in YAML oppure nella propria interfaccia costruita tramite UI come di seguito riportato;
* controllare che non ci siano _errori nel log di HA_.

***Avvertenze***: 
1. ricordarsi di seguire i passaggi nell'ordine presentato in questo articolo;
2. se sbagli qualcosa conviene cancellare i files scaricati e ripartire dall'inizio; oppure se si è più esperti effettuare le correzioni sui file YAML;

| Lovelace - Storage |
| :---: |

Chi usa questa modalità potrà fare copia e incolla del file Lovelace (es. card_asciugatrice.yaml) nella UI, ***dopo aver completato i passi precedenti***, e variare sempre da UI gli aspetti che più interessano.

<br>

<table align="center">
	<tr>
	    <th><center>🚀 Modalità UI storage 🚀</center></th>
	</tr>
  <tr>
      <td><div align=center><img width = "500" src="img/storage_mode.png"/></div></td>
  </tr>
</table>

Per quanto riguarda le impostazioni grafiche è possibile agire sul proprio "tema" del [Frontend](https://www.home-assistant.io/integrations/frontend/) oppure scegliere tra i vari **sfondi presenti** e su alcuni parametri relativi alla parte inferiore realizzata con button-card, in particolare:
1. raggio del bordo
2. colore del bordo
3. colore di background
4. altezza dei button inferiori

<br>

| Alcune considerazioni |
| :---: |

Il diagramma FSM realizzato dal ***blueprint*** é il seguente (in questo caso è visualizzato il diagramma relativo all'asciugatrice).

<br>

```mermaid
stateDiagram-v2
  direction LR
  [*] --> Idle
  Idle --> Asciugatura: POWER/TIME_1
  Asciugatura --> Mantenimento: POWER/TIME_2
  Mantenimento --> Asciugatura: POWER/TIME_3
  Mantenimento --> Svuotare: POWER/TIME_4
  Svuotare --> Idle: TIME_1
```

<br>
Per quanto riguarda lo script python, esso effettua una serie di operazioni di _"ricerca e sostituzione"_ all'interno del container, quindi il suo utilizzo è assolutamente sicuro: nel caso di problemi basterà cancellare lo script e riavviare HA. 

## Conclusioni
Con questo package abbiamo visto come combinare insieme diversi elementi:
* un blueprint per semplificare la configurazione
* una grafica accattivante con alcuni effetti visuali.
* un uso moderno dei dati statistici di HA
* **la grande novità della funzionalità di auto-download e auto-configurazione!!**

Il risultato sembra piacevole, lasciate pure le vostre impressioni sui nostri canali social.

| Ispirazione e ringraziamenti |
| :---: |

L'idea alla base di questo package è sempre l'ottimo lavoro di [Phil Hawthorne](https://philhawthorne.com/making-dumb-dishwashers-and-washing-machines-smart-alerts-when-the-dishes-and-clothes-are-cleaned/) del 2017 ma sempre fonte di ispirazioni per tutti i lavori di questo tipo. Per la parte FSM realizzata con blueprint esiste una buona discussione nel forum di [HA](https://community.home-assistant.io/t/detect-and-monitor-the-state-of-an-appliance-based-on-its-power-consumption-v2-1-1-updated/421670).
Per la parte FSM in ESPHOME Mikhail Diatchenko ha realizzato un ottimo componente: [ESPHome State Machine](https://github.com/muxa/esphome-state-machine).

Tutti i  nostri "follower" 😄

| Supporto |
| :---: |

**Ti piace questo package? Lascia una ⭐ su Github e supportami per realizzarne altri!** <a href="https://www.buymeacoffee.com/jumping"><img src="https://cdn.buymeacoffee.com/buttons/default-yellow.png" height="20"></a>

[![Websitebadge]][website] [![Forum][forumbadge]][forum] [![telegrambadge]][telegram] [![facebookbadge]][facebook] 

<!-- ✨ _special_ ✨ -->
[website]: https://hassiohelp.eu/
[Websitebadge]: https://img.shields.io/website?down_message=Offline&label=HassioHelp&logoColor=blue&up_message=Online&url=https%3A%2F%2Fhassiohelp.eu

[telegram]: https://t.me/HassioHelp
[telegrambadge]: https://img.shields.io/badge/Chat-Telegram-blue?logo=Telegram

[facebook]: https://www.facebook.com/groups/2062381507393179/
[facebookbadge]: https://img.shields.io/badge/Group-Facebook-blue?logo=Facebook

[forum]: https://forum.hassiohelp.eu/
[forumbadge]: https://img.shields.io/badge/HassioHelp-Forum-blue?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA0ppVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8%2BIDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5LjE1NTc3MiwgMjAxNC8wMS8xMy0xOTo0NDowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6ODcxMjY2QzY5RUIzMTFFQUEwREVGQzE4OTI4Njk5NDkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6ODcxMjY2QzU5RUIzMTFFQUEwREVGQzE4OTI4Njk5NDkiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTQgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDo0MWVhZDAwNC05ZWFmLTExZWEtOGY3ZS1mNzQ3Zjc1MjgyNGIiIHN0UmVmOmRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDo0MWVhZDAwNC05ZWFmLTExZWEtOGY3ZS1mNzQ3Zjc1MjgyNGIiLz4gPC9yZGY6RGVzY3JpcHRpb24%2BIDwvcmRmOlJERj4gPC94OnhtcG1ldGE%2BIDw/eHBhY2tldCBlbmQ9InIiPz4xQPr3AAADq0lEQVR42rRVW2wMURj%2Bz5lL7V27KG26KIuUEJemdalu3VN3Ei/ipSWUuIV4FB4kHrwo8VLRROJBgkYElZCi4olG4rVoROOSbTa0u7pzO/6Z2Zmd3Z2uevBn/8zsf/7zff/tnKGMMRi/pjM6/j08oKiqCm1tbTA4OAhuoqkS8KKPVjceOcgJngkfnl%2B5JiWH0pQvcfUPhULQ0dEBPp8PDBZZlqGyshLGFKG0fHHr/QfNlxnbjFp7uOcl8VVVj%2BXu9XohkUgY2NRpdJMpc5qWN5971zu7ftsWkSAX2iKLYg3NZ/t6Kxbu2Oi2x4g8IxSKSDR2tLXh2JOn3nAkKv9GAzPtyigS%2BSdV1B3sejhv09lTxTBcCXjRK9buu96%2BZG/7dUYEryK59EXWewNcza7zl%2Br237kpessC4yIITIlGGk88666OtR6VMFKmZhZY9sGsdw1ATgFU1O7et%2Brki56JVUtqsl4kl0CVUjB57vo1Tad7X4Wj9U1S0vRj8HfRSQKVC5auPN7zctqiPTs1Rz2pBV6xcOuq%2BkOPusVAeZWxDg5wl%2Bhz1vW%2BpBFMDIYXt9y%2BF6lr2a6kR7IEmipDeFYsRkVewFcTyAXcBtNMhTxCTTErUxZdu96qLW8varhFsyrnQCQOYNXU8qBp//4TH/jkHZ3UCTXFoncQGKciP1SiN1JDVY2IJwgEjq3jYMVsZgC/HSBw9RnA8CgBjmS3MkdefE638sCV0WGQk9/QXYNRicH%2B7eWwYUGpOT4oq%2Bfq0Upw4SEPVOCLnwOWp5o%2BgskfWEoZe8Qg6CGwcp7XWFVxTc0UYdlMrLmQsP8zVuQcWFNiORFCTSvRQTWQs6W101SRXE7/xiDSBeC5BKywRLx/KqbuA44TYUQS4HHfsLHEcZyhulP32zjEUwL2ACuPt24%2BR0HhnONJBA8IoRlG/4P4/%2B57FTTyC9bUMAQk8OJ9Am69VsHjC2cOJbPaU0iQn4DxrjnSwVwp4eF2XwC63uBVLCchpXgQPAiUUrM8xBwlfeqs%2Bc7JwFn//KHKtAI8IkVejFgIgY8p2etEB7cPDbF32wSE8pwx926XTx6pAcPxxmFlzIo2o/qPy84sb4JTSMb7v3qiGFhJIaAzw1wbkmh8tu4IrqKm4v347V1qmvQGKvjJjEyf7v/pX3GmrGp%2BtT73UDyRHCPLMBDKwUj801dl4P7Fwc8fh0rLwiaBrp2dN2Do%2Bxfb%2Bd%2BE2GwEe%2BEPTYaW1gNQUiKaBP9T/ggwAJik5dEKYSC3AAAAAElFTkSuQmCC
