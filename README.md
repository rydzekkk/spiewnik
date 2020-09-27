# Hej ho :)
Śpiewniki - są ich miliony, każdy ma czy to na dysku, w internecie, czy w wersji papierowej, wiele różnych. Nie ma jednak żadnej spójnej wersji, a przy starcie każdego kursu jest dylemat "a co by tu dać kursantom do wydrukowania"? Może czas stworzyć coś bardziej uniwersalnego? Może czas na Śpiewnik v2.0? :D

## Trochę historii
Na początku był Kraków...
W maju 2018 ekipa z Krakowa zaczęła tworzyć "Śpiewnik krakowskich śpiewanek okołogórskich", dostępny pod rydzekkk/spiewnik (repo które aktualnie widzisz jest jego forkiem). Pomysł zacny: zamiast trzymać śpiewnik w jednym pliku worda, użyć struktury rozproszonej - pojedynczych plików latexa z jednym utworem na plik, całość wrzucić na githuba i pozwolić projektowi się rozrastać. Projekt żył przez rok, powstała wersja jest całkiem użyteczna, ale jej rozwój się zatrzymał. Kilka poprawek zostało wrzuconych, do rozwoju dołączyłem się również ja oraz Kijek z SKPB Katowice. Powoli zaczyna coś sensownego z tego powstawać :)

## W czym to jest lepsze od obecnych śpiewników?
Teraz każdy trzyma w jakimś losowym formacie wybrane teksty piosenek, często muszą one być kombinowane z wielu miejsc, mają niespójną formę zapisu. Idea stojąca za tym śpiewnikiem jest następująca: prosty format bazy piosenek i jej otwartość na wszelkie utwory. Do bazy piosenek możemy wrzucić wszystko, co tylko ma chwyty i może być piosenką zagraną na gitarze. Dzięki temu, cała baza tekstów będzie rozległa, a każdy będzie mógł znaleźć w niej interesujące go utwory i utworzyć własną wersję śpiewnika w PDFie do wydrukowania. Czy też odpalić aplikację na telefon, gdzie wyszuka sobie każdy tekst z pełnej bazy. Jeśli jakiejś piosenki brakuje lub jest błędna, każdy może zaproponować do niej poprawkę, i ta od razu pojawi się we wszystkich nowszych instancjach śpiewnika.

## Co mamy dziś?
Mamy bazę piosenek odziedziczonych po Krakowie, mamy też automatyczny generator listy wszystkich piosenek - pierwotnie trzeba było trochę małpiej roboty, żeby po dodaniu nowej piosenki ręcznie dopisać w odpowiednich miejscach nazwy plików, teraz robi to za nas github action. Możemy także w miarę bezboleśnie wygenerować z tej listy piosenek PDFa z wszystkimi utworam. Mamy też długą listę rzeczy, które trzeba jeszcze zrobić :)

# Struktura repozytorium
- .github: folder zawierający githubowy workflow, który utworzy nam paczkę ZIP ze śpiewnikiem.
- SonglistGenerator: program w C# .NET Core, który na podstawie plików master.tex z nazwami zespołów oraz poszczególnymi piosenkami, tworzy nowe pliki master.tex z alfabetycznie posortowaną listą piosenek każdego zespołu, oraz plik main.tex z listą wszystkich zespołów. Wynik jego działania jest dostępny w artefaktach każdego builda, to z nich należy kompilować śpiewnik.
- main: folder z ręcznie tworzonymi latexowymi plikami, z których należy zbudować śpiewnik. Pierwotnie bezpośrednio z niego tworzyło się śpiewnik, teraz jest to tylko katalog źródłowy do którego wrzucamy teksty piosenek - sam śpiewnik budowany jest z artefaktów builda (dostępne na githubie w zakłdace Actions).

# Dodawanie nowych piosenek
Czysto teoretycznie, do dodawania piosenek nie potrzeba nic prócz edytora tekstowego, wystarczy trzymać się schematu z pliku main\template.tex i dodawać każdą piosenkę w osobnym pliku.
Struktura śpiewnika jest oparta na zespołach, więc jeżeli chcemy dodać zespół którego nie ma, tworzymy folder o możliwie krótkiej nazwie, używając _ zamiast spacji.
W folderze tworzymy plik master.tex o zawartości:

\chapter{Nazwa zespołu}

Poza plikiem master.tex, w folderze zespołu mogą znaleźć się tylko pliki .tex z poszczególnymi piosenkami.

Założeniem projektu jest stworzenie bazy tekstów, którą potencjalnie wykorzystać może każdy wg własnych potrzeb, tworząc swoją własną wersję pliku master.tex, czy to modyfikując style czy samą zawartość śpiewnika.
Dopisywanie piosenek jest proste i nie trzeba znać się tutaj na żadnym programowaniu. Z przetworzeniem dodanych rzeczy już jest trochę więcej zabawy.

# Składanie śpiewnika:
Najprościej używać edytora z prawdziwego zdarzenia (nie notatnika :) ) do tworzenia projektu, zdecydowanie ułatwia to pracę. Ja korzystam z InteliJ IDEA, natomiast jest to kwestią preferencji.
Pełna instrukcja instalacji krok po kroku od samego początku znajduje się tutaj:
https://github.com/Ruben-Sten/TeXiFy-IDEA#installation-instructions
Idąc za tymi instrukcjami będziecie już gotowi do pracy nad projektem :)
Komentarz ode mnie (qamil95): powyższy fragment istniał tu "od zawsze", aczkolwiek ja nie korzystam z żadnego edytora projektu - wystarcza mi do tego notepad++ i eksplorator windows, ale co kto lubi :) To co jest niżej jest faktycznie niezbędne.

Potrzebujemy co najmniej instalacji LaTeXa, którego można pobrać tu: https://www.latex-project.org/get/
Pod Windowsem ja korzystam z MiKTeX i najlepiej będzie się w tym względzie unifikować, różne implementacje mogą mieć swoje smaczki.
Instalacja sprowadza sie do klikania "dalej" :)
W MiKTeXie jest też dostępny podstawowy edytor LaTeXa, ale zwykły notatnik wystarczy, polecam natomiast Notepad++ jako prostą alternatywę.
Jeżeli już mamy zainstalowanego LaTeXa, wystarczy otworzyć cmd i wpisać pdflatex (ścieżka do pliku)\Spiewnik_xxx.tex, zamiast xxx podając wybraną wersję śpiewnika. Można również uruchomić skrypt compile_windows.bat w głównym folderze śpiewnika, on automatycznie skompiluje wszystkie dostępne wersje.
Rzecz jasna najpierw trzeba ten projekt gdzieś na dysk zassać :) Najnowsza wersja jest do pobrania z zakładki Actions (https://github.com/qamil95/spiewnik/actions), należy wejść w najnowszego builda (najlepiej mastera dla stabilnej wersji) i ściągnąć archiwym Songbook v2.0, po czym wypakować je na dysk.

Do współtworzenia projektu potrzebny nam będzie git, dostępny do pobrania tu: https://git-scm.com/downloads
konto na GitHubie i zgłoszenie się do mnie z prośbą o współtworzenie.

Poczytajcie też trochę o gicie, podczas rejestracji na githubie wyskoczy Wam instrukcja z podstawowymi informacjami, które w zupełności tutaj wystarczą.
Wielka prośba o przemyślenie 2 razy, czy na pewno chcecie pushować do mastera. Najlepiej robić to jednak do jakiegoś brancha i wystawić pull requesta ;)

Przy każdym commicie starajcie się opisywać zmiany zwięźle, ale i konkretnie.
Powodzenia!
