# Hej ho :)

Czysto teoretycznie, do dodawania piosenek nie potrzeba nic prócz edytora tekstowego, wystarczy trzymać się schematu z pliku main\template.tex i dodawać każdą piosenkę w osobnym pliku.
Struktura śpiewnika jest oparta na zespołach, więc jeżeli chcemy dodać zespół którego nie ma, tworzymy folder o możliwie krótkiej nazwie, używając _ zamiast spacji.
W folderze tworzymy plik master.tex o zawartości:

\chapter{Nazwa zespołu}

Poza plikiem master.tex, w folderze zespołu mogą znaleźć się tylko pliki .tex z poszczególnymi piosenkami.

Założeniem projektu jest stworzenie bazy tekstów, którą potencjalnie wykorzystać może każdy wg własnych potrzeb, tworząc swoją własną wersję pliku master.tex, czy to modyfikując style czy samą zawartość śpiewnika.
Dopisywanie piosenek jest proste i nie trzeba znać się tutaj na żadnym programowaniu. Z przetworzeniem dodanych rzeczy już jest trochę więcej zabawy.

# Struktura repozytorium
- .github: folder zawierający githubowy workflow, który utworzy nam paczkę ZIP ze śpiewnikiem.
- SonglistGenerator: program w C# .NET Core, który na podstawie plików master.tex z nazwami zespołów oraz poszczególnymi piosenkami, tworzy nowe pliki master.tex z alfabetycznie posortowaną listą piosenek każdego zespołu, oraz plik main.tex z listą wszystkich zespołów. Wynik jego działania jest dostępny w artefaktach każdego builda, to z nich należy kompilować śpiewnik.
- main: folder z ręcznie tworzonymi latexowymi plikami, z których należy zbudować śpiewnik. Pierwotnie bezpośrednio z niego tworzyło się śpiewnik, teraz jest to tylko katalog źródłowy do którego wrzucamy teksty piosenek - sam śpiewnik budowany jest z artefaktówbuilda (dostępne na githubie w zakłdace Actions).

# Składanie śpiewnika:
Najprościej używać edytora z prawdziwego zdarzenia (nie notatnika :) ) do tworzenia projektu, zdecydowanie ułatwia to pracę. Ja korzystam z InteliJ IDEA, natomiast jest to kwestią preferencji.
Pełna instrukcja instalacji krok po kroku od samego początku znajduje się tutaj:
https://github.com/Ruben-Sten/TeXiFy-IDEA#installation-instructions
Idąc za tymi instrukcjami będziecie już gotowi do pracy nad projektem :)

Potrzebujemy co najmniej instalacji LaTeXa, którego można pobrać tu: https://www.latex-project.org/get/
Pod Windowsem ja korzystam z MiKTeX i najlepiej będzie się w tym względzie unifikować, różne implementacje mogą mieć swoje smaczki.
Instalacja sprowadza sie do klikania "dalej" :)
W MiKTeXie jest też dostępny podstawowy edytor LaTeXa, ale zwykły notatnik wystarczy, polecam natomiast Notepad++ jako prostą alternatywę.
Jeżeli już mamy zainstalowanego LaTeXa, wystarczy otworzyć cmd i wpisać pdflatex (ścieżka do pliku)\Spiewnik_xxx.tex, zamiast xxx podając wybraną wersję śpiewnika.
Rzecz jasna najpierw trzeba ten projekt gdzieś na dysk zassać :) Najnowsza wersja jest do pobrania z zakładki Actions (https://github.com/qamil95/spiewnik/actions), należy wejść w najnowszego builda mastera i ściągnąć Songbook v2.0

Do współtworzenia projektu potrzebny nam będzie git, dostępny do pobrania tu: https://git-scm.com/downloads
konto na GitHubie i zgłoszenie się do mnie z prośbą o współtworzenie.

Poczytajcie też trochę o gicie, podczas rejestracji na githubie wyskoczy Wam instrukcja z podstawowymi informacjami, które w zupełności tutaj wystarczą.
Wielka prośba o przemyślenie 2 razy, czy na pewno chcecie pushować do mastera. Najlepiej robić to jednak do jakiegoś brancha ;)

Przy każdym commicie starajcie się opisywać zmiany zwięźle, ale i konkretnie.
Powodzenia!
