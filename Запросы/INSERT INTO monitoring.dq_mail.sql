
INSERT INTO monitoring.dq_mail (EMAIL, COMMENTS, LIST_ID)
VALUES ('ANKrivoshein@alfabank.ru', '', '');

SELECT * FROM monitoring.dq_mail;

DELETE FROM monitoring.dq_mail 
WHERE email = 'mlpak@alfabank.ru'; 