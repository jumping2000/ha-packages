# 🌊 Lavatrice smart 💧


| Sommario |
| :---: |
| [Introduzione](#introduzione) |
| [Prerequisiti](#prerequisiti) | 
| [Dispositivi](#dispositivi) | 
| [Funzionamento](#funzionamento) | 
| [User interface](#user-interface) |
| [Installazione](#installazione) | 
| [Configurazione](#configurazione) |
| [Conclusioni e Supporto](#conclusioni-e-supporto) |

**Paragrafi obbligatori:**
- [x] [Prerequisiti](#prerequisiti)
- [x] [Installazione](#installazione)
- [x] [Configurazione](#configurazione)

## Introduzione

L'articolo riprende quanto avevamo già scritto nel 2020 con l'articolo **[Elettrodomestici Smart](https://hassiohelp.eu/2020/04/05/elettrodomestici-smart-con-home-assistant/)** che ha introdotto:
1. un package per poter monitorare lo stato degli elettrodomestici non smart utilizzando una presa o dispositivo in grado di effettuare delle misurazione dei livelli di potenza, 
2. una card Lovelace con effetti grafici CSS ed informazioni di funzionamento. 

In particolare in questa **edizione 2023** useremo alcuni custom ricchi di funzionalità come [Button Card](https://github.com/custom-cards/button-card) ed [ApexChart Card](https://github.com/RomRider/apexcharts-card) che oramai sono diventati dei veri e propri classici delle interfacce sviluppate per Home Assistant e introdurremo ulteriori elementi sia a livello di dati disponibili che a livello di grafica, ma la perla che rende l'uso del package veramente superiore sotto tutti punti di vista rispetto a pacchetti analoghi, è l'utilizzo di una "macchina a stati finiti" [FSM](https://it.wikipedia.org/wiki/Automa_a_stati_finiti) sviluppata in ESPHome che restituisce lo stato del dispositivo in maniera molto precisa. Ovviamente è disponibile anhce la versione _lite_ per chi non vuole cimentarsi nella configurazione della presa smart. 

Riepiloghiamo i punti di forza di questo pacchetto sono:
1. Adattabile per l'uso su tablet, smartphone, PC;
2. Macchina a stati finiti per ricavare lo stato della lavatrice (per la versione _advanced_);
3. Utilizzo di codice YAML non obsoleto e riduzioni del "codice inutile";
4. Uso estensivo degli "_anchor_" per centralizzare le parti YAML da personalizzare nel package e nella GUI;
5. Versioni per chi utilizza grafica "_storage_ o "_yaml_";
6. Riduzione del numero di componenti custom necessari;
7. Utilizzo dei dati statistici conservati nel DB di HA senza appesantire il DB stesso;

<span style="color:red">**🚨 Come usuale prestate attenzione a collegare la vostra lavatrice ad un dispositivo smart che sia in grado di supportarne il carico, purtroppo gli incidenti domestici sono sempre dietro l'angolo. 🚨**</span>

## Prerequisiti 

Per poter utilizzare il packages occorrono alcune card e alcune configurazioni abbastanza comuni, le card e i custom sono disponibili sul community store [HACS](https://hacs.xyz/) , sul sito [HassioHelp.eu](https://hassiohelp.eu) sono presenti numerose guide, prestate particolare attenzione alla darta di rilascio della guida, alcune sono datate e potrebbero non essere più valide, in questo caso il gruppo Telegram [Hassiohelp](https://t.me/HassioHelp) è un vaildo aiuto.

| Card/Custom | Uso |
| :---: | --- |
| **[Button Card](https://github.com/custom-cards/button-card)** | Obbligatorio |
| **[ApexChart Card](https://github.com/RomRider/apexcharts-card)** | Obbligatorio |
| **[Browser Mod](https://github.com/thomasloven/hass-browser_mod)** | Obbligatorio |
| **[Card Mod](https://github.com/thomasloven/lovelace-card-mod)** | Obbligatorio |
| **[Layout Card](https://github.com/thomasloven/lovelace-layout-card)** | Facoltativo |
| **[Bar Card](https://github.com/custom-cards/bar-card)** | Facoltativo |
| **[Multiple Entity Row](https://github.com/benct/lovelace-multiple-entity-row)** | Facoltativo |

L'utilizzo delle card _facoltative_ permette una migliore visualizzazione delle informazioni soprattutto con i dispositivi smartphone ma nulla vieta di poterle rimuovere utilizzando dei layout più scomodi ma comunque fruibili (questo vale per la Layout Card e la Multiple Entity Row). La rimozione dei componenti custom e dl relativo adattamento del codice YAML è lasciato al lettore "evoluto" in grado di procedere in autonomia.

| Configurazioni obbligatorie |
| :---: |

Per poter procedere con l'installazione del package ci sono alcuni passi da effettuare:
* abilitare i packages come descritto qui: [Packages](https://www.home-assistant.io/docs/configuration/packages/);
* configurare Home Assistant per avere i sensori di tempo e di data come spiegato qui: [Time & Date](https://www.home-assistant.io/integrations/time_date/) o nelle guide [HassioHelp](https://hassiohelp.eu);
* configurare il sensore che restituisce il costo dell'energia (package accessorio ad hoc presente nella configurazione);
* impostazione dei servizi di notifica: ad esempio [Telegram](https://www.home-assistant.io/integrations/telegram/), [Google](https://www.home-assistant.io/integrations/google_assistant/), [Mobile App](https://companion.home-assistant.io/) la scelta migliore rimane sempre l'uso del [Centro Notifiche](https://github.com/caiosweet/Package-Notification-HUB-AppDaemon) che centralizza la configurazione di tutti i servizi di notifica.

| Guide Hassiohelp |
| :---: |

Ecco alcune guide pubblicate da [HassioHelp.eu](https://hassiohelp.eu) che sicuramente sono meno aggiornate della documentazione ufficiale ma restano valide: 
* [Packages](https://hassiohelp.eu/2018/11/30/package-configurazione/)
* [ESPHome](https://hassiohelp.eu/2019/06/09/esphome/)
* [HACS](https://hassiohelp.eu/2019/10/06/hacs-guida-allinstallazione/)
* [Google](https://hassiohelp.eu/2018/11/29/google-home/)
* [Alexa](https://hassiohelp.eu/2019/12/11/alexa-su-home-assistant-gratis/)
* [Blitwolf WiFi Plug](https://hassiohelp.eu/2019/11/06/blitzwolf-bw-shp6/)
* [Shelly 1PM](https://hassiohelp.eu/2019/10/31/shelly-1pm/)
* [Shelly EM](https://hassiohelp.eu/2020/01/13/shelly-em/)
* [PZEM 004T](https://hassiohelp.eu/2019/01/02/consumi-pzem/)
* [PZEM 016](https://hassiohelp.eu/2019/03/27/pzem-016/)
* [Centro Notifiche](https://hassiohelp.eu/2020/11/09/centro-notifiche-3-0-appdaemon/)
* [Animazioni CSS](https://hassiohelp.eu/2020/04/09/css-lovelace/)


## Dispositivi

E' fondamentale avere una presa, o un relay “smart” (come la famiglia Shelly PM) o altro sistema smart basato su pinza amperometrica come Shelly EM o PZEM che restituisca la ***potenza assorbita in watt/Kw***  della lavatrice. Per ottenere il massimo risultato ed utilizzare quindi la FSM occorre un dispositivo in grado di essere configurato con il firmware ESPHome, se non è possibile ci sono due alternative:
1. utilizzare una versione ridotta (_lite_) del package;
2. adattare le automazioni già sviluppate nll'articolo del 2020 al proprio caso.

Nel repository su Github sono presenti due packages già pronti per l'uso, la versione ***FSM*** e la versione ***lite***, lasciamo agli utenti adattare il codice YAML per realizzare la FSM con le automazioni YAML.

## Funzionamento

L’idea alla base dell'articolo è che grazie alle informazioni di potenza restituite dalla presa smart siamo in grado di capire in che stato si trova il nostro elettrodomestico e quindi possiamo costruire una serie di sensori che diano delle informazioni da visualizzare nella UI di Home Assistant o piuttosto per avvertirci quando stendere i panni tramite un servizio di notifica.

Vediamo in dettaglio quali sono gli stati per la lavatrice, le transizioni da uno stato ad un altro sono guidate dalla potenza assorbita dalla lavatrice stessa:

| Stato | Caratteristiche |
| :---: | --- |
| **Idle** | Stato spento della della lavatrice | 
| **Riempimento** | Stato iniziale del lavaggio con il carico dell'acqua |
| **Lavaggio** | Avvio del programma con il riscaldamento dell'acqua e lavaggio dei panni vero e proprio |
| **Risciacquo** | Fase di risciacquo in cui sono eliminati i residui di detersivo |
| **Centrifuga** | Fase di rotazione del cestello ed eliminazione dell'acqua |
| **Svuotare** | Stato finale del programma di lavaggio |

Questo stati sono calcolati nella versione FSM del package e nella versione _lite_ rispettivamente da:
* FSM implementata nel codice ESPHome e restituita dal sensore `sensor.washing_machine_status`
* template sensor `sensor.washing_machine_status` 

Ovviamente la versione FSM sarà molto più precisa, _se opportunamente configurata con i dati di potenza della propria lavatrice_, perché lo stato della lavatrice dipenderà sia dalla potenza assorbita che dallo stato attuale, mentre la versione con template sensor solo dalla potenza assorbita. Anche chi possiede una lavatrice smart che espone in HA lo stato dell'elettrodomestico potrà utilizzare il package aggiustando il codice in maniera minimale adattandolo ai dati esposti dall'integrazione smart.

---

Se l'utente possiede una lavatrice smart è possibile adattare il package e la card Lovelace: il lavoro non è immediato ma modificando opportunamente le principali entità con i dati provenienti dall'integrazione è fattibile.

A titolo di esempio l'integrazione [Home Connect](https://www.home-assistant.io/integrations/home_connect/) Bosch espone alcune tipologie di identità che possono sostituire le principali entità del package, oltre alle entità dei programmi di lavaggio:

| Entità Home Connect| Contenuto | Entità Package |
| :---: | --- | --- | 
| sensor.**lavatrice**_operation_state  | stato operativo | sensor.washing_machine_status |
| sensor.**lavatrice**_remaining_program_time | tempo rimasto | sensor.washing_machine_time_left |
| switch.**lavatrice**_program_auto1 | programma 1 | da esporre nella card |
| switch.**lavatrice**_program_auto2 | programma 2 | da esporre nella card |

---

Il package espone una grande serie di dati, funzionalità, grafici e configurazioni, proviamo a riassumerle:

**Dati**
* Dati giornalieri, settimanali, mensili ed annuali di energia (kWh) consumata e relativo costo in €
* Numero dei cicli giornalieri, settimanali, mensili ed annuali di lavaggio effettuati 
* Durata dei cicli giornalieri, settimanali, mensili ed annuali di lavaggio effettuati
* Numero e durata totale dei cicli effettuati
* Durata ultimo lavaggio

**Grafici**
* Grafico X-Y della potenza consumata
* Grafico a barre dei cicli di funzionamento per programmare la manutenzione
* Grafico a istogramma dell'energia consumata negli ultimi 30 giorni
* Grafico a barre per corrente, tensione, potenza attiva, apparente e reattiva


**Funzionalità presenti**
* Timer con vari programmi lavatrice per tenere sotto controllo il tempo trascorso
* Integrazione con [Grocy](https://grocy.info/) per tenere traccia delle quantità di detersivo ed ammorbidente utilizzati
* _Actionable Notification_ configurabili con Telegram e Companion app alla fine del ciclo di lavaggio
* Notifiche per i cambi di stato

Per evitare l'uso inutile di entità per configurare alcune aspetti "statici" o comunque poco variabili, relativi al funzionamento, abbiamo preferito usare gli [anchor](https://github.com/thomasloven/hass-config/wiki/Misc-tricks) impostabili nella sezione **"IMPOSTAZIONI DEL PACKAGES"**.
Al contrario gli aspetti di configurazione che sono più soggetti a variazioni sono configurabili dalla card.  Per i **template sensor** sarà comunque necessario personalizzare leggerrmente il codice visto che non è possibile usare gli anchor, ma in questo caso è chiarmaente indicato.

***Altra funzionalità innovativa del package è l'uso delle funzionalità di esposizione dei dati statistici delle card standard Lovelace e Apex senza quindi incidere nelle dimensioni del DB***, il `recorder` può quindi rimanere configurato con i classici 5-10 giorni di memorizzazione dei dati ma è possibile visualizzare i dati di energia consumata degli ultimi 30 giorni o più se uno desidera.

## User Interface

<table align="center">
	<tr>
	    <th>Desktop</th>
      <th>Mobile</th>
	</tr>
    <tr>
        <td><div align=center><img width = "500" src="img/lavatrice_1.png"/></div></td>
        <td><div align=center><img width = 400 src="img/lavatrice_2.png"/></div></td>
    </tr>
</table>

La card è, in sostanza, una _custom button-card_ con funzionalità di _container_ che al suo interno contiene due importanti sezioni:
* la _parte superiore_ è costituita da una _picture-elements card_
* la _parte inferiore_ è costituita da una fila orizzontale di 5 bottoni a loro volta realizzati con _custom button-card_

La ***picture-elements*** card ha la funzione di _contenitore_ sia per elementi grafici che informazioni testuali:
* **sulla parte sinistra** è presente l'immagine grafica della lavatrice, i CSS presenti nella configurazione fanno in modo che ad ogni stato corrisponda una animazione.
* **nella parte centrale** è collocato il grafico della potenza assorbita dalla lavatrice.
* **nella parte destra** è presente il grafico a barre dei cicli di lavaggio che indica quanti cicli sono stati effettuati e dove il 100% rappresenta il numero di cicli dopo il quale è  necessario effettuare una manutenzione.
* **in alto a destra** troviamo le informazioni testuali relative ad energia, potenza, stato, n° cicli.
* **in basso** sotto l'immagine della lavatrice è presente la scelta del programma della lavatrice con il tempo rimasto.

La sezione orizzontale di bottoni in basso ("***button container***") presenta le seguenti informazioni:
* **Info**: cliccando si apre una finestra con le informazioni di dettaglio relative ai consumi/cicli/costi per giorno, settimana, mese, anno oltre alle durate e cicli totali. Sono inoltre presenti le informazioni relative alla manutenzione da effettuare e la sua configurazione e le impostazioni relative alle notifiche.
* **Settimana** / **Mese** / **Anno**: informazioni relative all'energia consumata e i costi associati.
* **Lavatrice**: bottone che con il tocco singolo spegne/accende la presa collegata all'elettrodomestico, con il tocco prolungato apre la finestra con i dati e i grafici di energia recuperati dalle informazioni statistiche contenute nel DB di HA.

Come detto la card è adattabile al dispositivo usato e al suo orientamento, non si tratta ina card pienamente _responsive_ ma si è cercato di rendere la fruizione buona sia su smartphone che su PC o tablet.

<table align="center">
	<tr>
	    <th>Info Card</th>
      <th>Energy Card</th>
	</tr>
    <tr>
        <td><div align=center><img width = 400 src="img/lavatrice_3.png"/></div></td>
        <td><div align=center><img width = 400 src="img/lavatrice_4.png"/></div></td>
    </tr>
	<tr>
	    <th>🌀 Centrifuga in corso 🌀</th>
      <th>🎽 E' l'ora di tendere i panni 🎽 </th>
	</tr>
    <tr>
        <td><div align=center><img width = 400 src="img/centrifuga.png"/></div></td>
        <td><div align=center><img width = 400 src="img/svuotare.png"/></div></td>
    </tr>
</table>

## Installazione
| Download |
| :---: |

[Github](https://github.com/jumping2000/ha-packages/elettrodomestici2023) permette di effettuare il completo download dei file che costituiscono il pacchetto, quindi file yaml e immagini. Per quanto riguarda il package la scelta è tra la versione _FSM_ e la versione _lite_, quindi l'utente dovrà cancellare la versione che non interessa.

| Struttura dei file |
| :---: |

La struttura dei file è rappresentata di seguito, quindi occorre rispettare la posizione dei file nel filesystem come da schema sottostante, in alternativa l'utente esperto può riposizionare i files nella maniera che più preferisce. 
L'unica eccezione è la card Lovelace che può essere posizionata nelle viste - [View Lovelace](https://www.home-assistant.io/dashboards/views/) - già presenti nella propria configurazione.

Per chi usa la modalità [storage](https://www.home-assistant.io/dashboards/dashboards/) è presente un file ad hoc che include tutta la parte Lovelace.

```bash
.
└── addons/
└── backup/
│
├── config/
│   │
│   ├── button_card_templates/
│   │   └── pkg_elettrodomestici/
│   │       └── button_card_templates.yaml
│   │
|   ├── esphome/
|   │   ├── common/
|   │   │    └── device_base.yaml
|   |   └── plug_lavatrice.yaml
│   │
│   ├── lovelace/
│   │   └── card_elettrodomestici/
│   │       └── washing_machine_card.yaml
|   |
│   ├── packages/
│   │   └── elettrodomestici/
│   │       ├── washing_machine_fsm.yaml
│   │       └── washing_machine_lite.yaml
│   │
│   ├── www/
│   │   └── hassiohelp/
│   │       └── pkg_elettrodomestici/
│   │           ├── lavatrice.png
│   │           ├── lavatrice_oblo.png
│   │           ├── lavatrice_panni.png
│   │           ├── sfondo_black.png
│   │           ├── sfondo_white.png
│   │           ├── sfondo_gray.png
│   │           └── sfondo_gray2.png
│   │ 
│   ├── home-assistant.log
│   └── secret.yaml
└── share/
└── ssl/
```

## Configurazione
| Impostazioni Package |
| :---: |

Nella sezione **"IMPOSTAZIONI DEL PACKAGE"** presente nella parte iniziale nel file _washing_machine_xxx.yaml_ sono da configurare una serie di parametri:
1. servizi di notifica;
2. i dati necessari per il funzionamento come lo switch della presa a cui è collegata la lavatrice o il sensore di potenza.

Per i **servizi di notifica** sono da configurare i seguenti parametri, con le entitù corrette:
* _SCRIPT Centro notifiche: &DEFAULT_SCRIPT_ se utilizzate il famoso ***Centro Notifiche di HassioHelp*** basta lasciare solo questo parametro e non mettere nulla nei prossimi;
* _SERVIZIO Notify: &DEFAULT_NOTIFY_ dove inserire l'entità _notify_ principale, ad esempio _notify.telegram_;
* _SERVIZIO Mobile: &DEFAULT_NOTIFY_MOBILE_ dove inserire l'entità _notify_ del servizio di notifica della [Companion App](https://companion.home-assistant.io/) di HA;
* _MEDIA PLAYER Alexa: &DEFAULT_MEDIA_PLAYER_ALEXA_ deve inserire un' entità media player tra quelle configurate, ad esempio _media_player.alexa_sala;
* _MEDIA PLAYER Google: &DEFAULT_MEDIA_PLAYER_GOOGLE_ deve inserire un'entità media player Google Home, ad esempio _media_player.google_sala;
* _SERVICE TTS: &DEFAULT_SERVICE_TTS_ dove inserire il servizio TTS, ad esempio _tts.google_translate_say_.

Andando nel dettaglio i seguenti sono i paramentri che si possono modificare, quindi **l'utilizzatore deve necessariamente inserire la correttà entità**:, gli altri presenti non sono da cambiare:
* _PLUG LAVATRICE SWITCH: &CONF_SWITCH_ENTITY_ dove inserire l'entità _switch_ che comanda la presa smart;
* _PLUG LAVATRICE POTENZA (W): &CONF_POWER_ENTITY_ dove inserire l'entità _sensor_ che espone la potenza;
* _PLUG LAVATRICE ENERGIA (kWh): &CONF_ENERGY_ENTITY_ dove inserire l'entità _sensor_ che espone l'energia;
* _GROCY DETERSIVO ID: &CONF_DETERSIVO_ID_ dove inserire l'ID corrispondente al detersivo;
* _GROCY DETERSIVO (mm): &CONF_DETERSIVO_AMOUNT_ dove inserire la quantità di detersivo;
* _GROCY AMMORBIDENTE ID: &CONF_AMMORBIDENTE_ID_ dove inserire l'ID corrispondente all'ammorbidente;
* _GROCY AMMORBIDENTE (mm): &CONF_AMMORBIDENTE_AMOUNT_ dove inserire la quantità di ammorbidente;
* _RITARDO TRA LE VARIE NOTIFICHE IN MINUTI: &DELAY_NOTIFICATION_ indica quanti minuti passano tra una notifica ed un altra.

Altri parametri di configurazione sono presenti nell'interfaccia utente:
* "_Ripetizioni Notifica_" indica il numero di ripetizioni della notifica di fine lavaggio.
* "_Cicli di avviso manutenzione_" indica dopo quanti cicli il sistema manda una notifica per effettuare operazioni di manutenzione (esempio lavaggio con anticalcare).
* "_Lavatrice Grocy_": per selezionare se si utilizza l'ERP [Grocy](https://grocy.info/) per tenere conto dei consumi.

| Lovelace |
| :---: |

Anche nella parte lovelace è stato fatto un uso estensivo degli [anchor](https://github.com/thomasloven/hass-config/wiki/Misc-tricks) in modo da centralizzare le impostazioni da personalizzare, purtroppo questo tipo di modifica è possibile solo con la modalità lovelace YAML, per la modalità storage non è possibile inserire _anchor_.

Vediamo i principali aspetti di configurazione dell'interfaccia Lovelace, **per ogni parametro va impostata da parte dell'utilizzatore la correttà entità**:
* _SFONDO_IMMAGINE: &CONF_BACKGROUND_IMAGE_ scelta dell'immagine di sfondo tra quelle presenti;
* _GRANDEZZA_CARATTERI_BASE: &CONF_FONT_SIZE_ grandezza caratteri per gli elementi della picture-elements card;
* _GRANDEZZA_CARATTERI_APEX: &CONF_FONT_SIZE_APEX_  grandezza caratteri per gli elementi di APex Card;
* _ALTEZZA_LINEA: &CONF_LINE_HEIGHT_ altezza dell'elemento di stile CSS _line-height_;
* _COLORSCHEME_RGB_XXX: &CONF_COLOR_XXX_ definizione di colori;
* _PLUG_LAVATRICE_XXX_: associazione con le entità relative a vari parametri come potenza energia etc.

Per quanto riguarda le impostazioni grafiche è possibili, oltre alle personalizzazioni appena descritte, agire sul proprio "tema" del [Frontend](https://www.home-assistant.io/integrations/frontend/)
e su alcuni parametri relativi alla parte inferiore realizzata con button-card, in particolare:
1. raggio del bordo
2. colore del bordo
3. colore di background
4. altezza dei button inferiori

Il codice da modificare è il seguente, nella parte "_variables_"; nulla vieta, nel caso si voglia standardizzare le card, di riportare queste configurazioni nel ***button template***.

```yaml
              ###########################################################
              ## BOTTONI IN BASSO
              ###########################################################
              ### 1 ###
              - type: custom:button-card
                template: device_button_vertical_icon
                name: Info
                icon: mdi:information
                variables:
                  border_radius: 0px 0px 0px 0px
                  border_color: '#333333'
                  button_height: 60px
                  button_background: '#0d0d0d'

```

| Template button card |
| :---: |

Per utilizzare i button-card templates occorre procedere alla seguente configurazione nel proprio file ui-lovelace.yaml o in altro se avete configurate più interfacce Lovelace in modalità YAML.

```yaml
button_card_templates:
  !include_dir_merge_named /button_card_templates/pkg_elettrodomestici
```


| Principali entità |
| :---: |

Di seguito sono elencate le principali entità e il loro ruolo all'interno del package:
* `sensor.washing_machine_status`: sensore che riporta lo stato in cui si trova la lavatrice;
* `sensor.washing_machine_time_left`: l'entità contiene il tempo alla fine del programma di lavaggio;
* `binary_sensor.washing_machine_status`: sensore che riporta lo stato on/off;
* `binary_sensor.washing_machine_maintenance`: indica che è venuto il momento di fare un lavaggio con un anticalcare 😜;
* `input_boolean.lavatrice_grocy_utilization`: helper che abilità l'utilizzo di Grocy;
* `input_number.lavatrice_ripetizioni_notifica`: numero di ripetizioni della notifiche a fine lavaggio;
* `input_number.lavatrice_avviso_manutenzione`: numero di cicli di manutenzione dopo i quali **HA** invia una notifica di avviso;
* `automation.lavatrice_status`: è la principale automazione del package che notifica gli eventi di cambio di stato;
* `automation.avviso_manutenzione_lavatrice`: notifica l'avvertimento per fare le operazioni di manutenzione programmata;
* `automation.lavatrice_program`: è l'automazione che permette il cambio di programma.

| ESPHome |
| :---: |

Questa parte di configurazione è relativa alla versione _FSM_ del package, **se si è scelto di utilizzare la versione _lite_ si può saltare**. Nel file su Github è riportata la configurazione relativa alla presa Blitzwolf BW-SHP2, sul sito [Esphome Devices](https://www.esphome-devices.com/) si trovano configurazioni relative a diverse decine di prese diverse.

I passi necessari per effettuare la configurazione [ESPHome](https://esphome.io/) sono:
* inserire la configurazione relativa alla presa in proprio possesso;
* inserire la configurazione relativa alla macchina a stati finiti;
* effettuare la calibrazione dei valori di tensione, corrente, e potenza della presa.

La **configurazione FSM** è basata sul componente aggiuntivo [ESPHome State Machine](https://github.com/muxa/esphome-state-machine), consiglio di leggere le informazioni contenute in questa pagina.
Il **cuore** della configurazione è il seguente che riassume gli stati e le transizioni permesse a fronte degli input ricevuti che in questo caso sono livelli di potenza esposti dalla presa smart.


```yaml
state_machine:
  - name: Lavatrice State Machine
    states:
      - "Idle"
      - "Riempimento"
      - "Lavaggio"
      - "Risciacquo"
      - "Centrifuga"
      - "Svuotare"
    inputs:
      - name: POWER_LOW
        transitions:
          - Idle -> Riempimento
          - Lavaggio -> Risciacquo
      - name: POWER_HIGH
        transitions:
          - Riempimento -> Lavaggio
          - Risciacquo -> Lavaggio
      - name: POWER_MEDIUM
        transitions:
          - Riempimento -> Lavaggio
          - Risciacquo -> Centrifuga
      - name: CLEANING
        transitions:
          - Centrifuga -> Svuotare
          - Risciacquo -> Svuotare
      - name: OPENING
        transitions:
          - Svuotare -> Idle
    diagram: mermaid
```

Questo è il diagramma FSM.

```mermaid
stateDiagram-v2
  direction LR
  [*] --> Idle
  Idle --> Riempimento: POWER_LOW
  Lavaggio --> Risciacquo: POWER_LOW
  Riempimento --> Lavaggio: POWER_HIGH
  Risciacquo --> Lavaggio: POWER_HIGH
  Riempimento --> Lavaggio: POWER_MEDIUM
  Risciacquo --> Centrifuga: POWER_MEDIUM
  Centrifuga --> Svuotare: CLEANING
  Risciacquo --> Svuotare: CLEANING
  Svuotare --> Idle: OPENING
```

La parte di **calibrazione** é piuttosto noiosa ma di vitale importanza per avere dei dati di potenza che si avvicinano il più possibile alla realtà, esistono alcuni siti che spiegano come effettuare questa operazione:
* https://www.danielmartingonzalez.com/en/calibrate-sensors-esphome/
* https://frenck.dev/calibrating-an-esphome-flashed-power-plug/


## Conclusioni e Supporto

| Ispirazione |
| :---: |
