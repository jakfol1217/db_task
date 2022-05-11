# PLIKI:
create_database.txt zawiera kod tworzący bazę danych
insert_test_values.txt zawiera kod wypełniający bazę przykładowymi danymi
procedures.sql zawiera kod tworzący pakiet oraz same procedury z zadania nr 2
raports.sql zawiera kod sql generujący raporty z zadania 3

# OPIS TABEL:
movies- zawiera dane o filmach (tytuł, reżyser itd)
rooms- zawiera informacje o salach kinowych (liczba miejsc, czy imax)
screenings- zawiera informacje o sensach (sala, data, film)
seats- zawiera inforamcje o siedzeniach, w praktyce wykorzystywana by nie zarezerwowano siedzenia, które nie istnieje
tickets- zawiera informacje o biletach, m.in. miejsce, sala, seans, data ważności

# UWAGI:
-Przy uzupełnianiu przykładowymi danymi uzupełnianie dwóch ostatnich tabel (seats i tickets) należy uruchomić ręcznie
-Procedury rezerwacji/kupowania biletu można testować na ostatnim seansie w tabeli, ewentualnie utworzyć nowy seans
-Gdy kupujemy niezarezerwowany bilet, rezerwacja jest tworzona automatycznie
-Bilet możemy zarezerwować, gdy ważność poprzedniej rezerwacji wygasła (pole valid_to) (lub gdy tej rezerwacji nie było)
-W ten sposób anulowanie rezerwacji można zaimplementować procedurą, która dla danego biletu ustawia pole valid_to na np. chwilę obecną


