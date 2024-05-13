% Очистить все переменные из рабочего пространства
clear
clc
imagePath = 'Схема.jpg'; 
img = imread(imagePath);
figure; % Создать новое окно для изображения
imshow(img); % Отобразить изображение
title('Схема речной системы'); 
pause;
data1_for_corr = load("data1_for_correlation.txt"); % Загрузить данные
data2_for_corr = load("data2_for_correlation.txt"); % Загрузить данные
data3_for_corr = load("data3_for_correlation.txt"); % Загрузить данные

variables_for_posts = load("variables_for_posts.txt");
data2 = load("VKF.txt","-ascii"); % загрузить данные из файла txt (по врхнему, нижнему и приточному за первый год)

disp('Выполняется первая часть программы:');
Opredelenie_dobeganiya = Opredelenie_dobeganiya(variables_for_posts, data1_for_corr, data2_for_corr,data3_for_corr,data2);
data3 = load("VKF2019.txt"); % загрузить данные из файла txt

% Запрос у пользователя о выборе программы
disp('Выберите программу для запуска:');
disp('1. Программа для поверочного прогноза');
disp('2. Программа для одного прогноза');
choice = input('Введите номер выбранной программы: ');

if choice == 1
    disp('Вы выбрали программу 1. Запуск программы 1...');
    summary_table = prognoz(variables_for_posts, data1_for_corr, data2_for_corr,data3_for_corr, data2, data3);
elseif choice == 2
    disp('Вы выбрали программу 2. Запуск программы 2...');
    only__prognoz = Porgram_for_only_prognoz(variables_for_posts, data1_for_corr, data2_for_corr,data3_for_corr,data2);
else
    disp('Ошибка: Введен неверный номер программы.');
end