 update monitoring.replicate_syscorr set entity =
        'Выгрузка из ФВ в область DMOUT остатков по компаниям'
  where entity = 'Остатки компаний в Adhoc'

  INSERT INTO monitoring.replicate_syscorr
VALUES('Выгрузка из DMOUT в ADHOC остатков по компаниям',358);

INSERT INTO monitoring.replicate_syscorr
  VALUES   ('Корректировки 653', 358);
