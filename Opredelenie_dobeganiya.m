        % Начинается функция:
function [LoadTime, a, b, c] = Opredelenie_dobeganiya(variables_for_posts, data1_for_corr,data2_for_corr,data3_for_corr, data2)

% 1)Вычислить среднюю скорость движения паводка для бесприточных участков:
L1=variables_for_posts(1);
L2=variables_for_posts(2);
L3=variables_for_posts(3);
L_1_3=variables_for_posts(4);
L__=variables_for_posts(5);
%Зададим площади:
F_upper = variables_for_posts(6);
F_lower = variables_for_posts(7);
F_pritok = variables_for_posts(8);

tau1 = VzaimnayaCorrelation(data1_for_corr); 
tau2 = VzaimnayaCorrelation(data2_for_corr); 
tau3 = VzaimnayaCorrelation(data3_for_corr); 

V1=L1/tau1;
V2=L2/tau2;
V3=L3/tau3;
%2)	Вычислить среднюю скорость течения на главной реке и на притоке:
Vriver=(V1+V3)/2;%скорость главной реки
Vpritok=(V2+V3)/2;%скорость приточного участка
%3)Вычислить время добегания на главной реке и на притоке:
TauRiver=L_1_3/Vriver;
TauPritok=L__/Vpritok;


% Заблаговременность:
LoadTime = round( min(TauRiver,TauPritok));%Заблаговременность (округляем до целого);
    fprintf("Заблаговременность: "+LoadTime+" сутки");

%строим таблицу «Данные для построения прогностических зависимостей»:

date = data2(:, 1);
upper = data2(:, 2);
lower = data2(:, 3);
pritok = data2(:, 4);


    %Заполняем столбцы по нижнему створу:
% Берем середину массива^
total_rows = length(data2);
desired_rows = 25;
if mod(total_rows, 2) == 0
    % Если общее количество строк четное
    start_row = round((total_rows - desired_rows) / 2) + 1;
    end_row = start_row + desired_rows - 1;
else
    % Если общее количество строк нечетное
    start_row = round((total_rows - desired_rows + 1) / 2);
    end_row = start_row + desired_rows - 1;
end

%%column_2_t = date(34:58);

% Создаем новый массив, включая только нужные строки из середины
column_2_t = date(start_row:end_row, :);
  
column_3_t_gamma = column_2_t - LoadTime;

column_4_lower_Level = zeros(size(column_2_t)); % Инициализация новой колонки (4 столбец таблицы)
for i = 1:length(column_2_t)
    % Найдем соответствующий индекс даты в наборе данных:
    index = find(date == column_2_t(i));
    if ~isempty(index)
        % Если найден индекс, присвоим значение уровня воды в колонку:
        column_4_lower_Level(i) = lower(index);
    else
        % Если дата не найдена, можно присвоить значение NaN 
        column_4_lower_Level(i) = NaN; % Например, NaN для неизвестных значений
    end
end

% Заполним 5 колонку таблицы:
column_5_lower_level_at_LoadTime = NaN(size(column_3_t_gamma)); % Инициализация новой колонки (5 столбец таблицы)
for i = 1:length(column_3_t_gamma)
    % Найдем соответствующий индекс даты в наборе данных:
    index = find(date == column_3_t_gamma(i));
    if ~isempty(index)
        % Если найден индекс, присвоим значение уровня воды в колонку:
        column_5_lower_level_at_LoadTime(i) = lower(index);
    else
        % Если дата не найдена, можно присвоить значение NaN 
        column_5_lower_level_at_LoadTime(i) = NaN; % Например, NaN для неизвестных значений
    end
end

    %Заполняем столбцы по верхнему створу:
column_6_t_Tau1 = column_2_t - tau1;
column_7_upper_level_at_Tau1 = NaN(size(column_6_t_Tau1)); % Инициализация новой колонки (7 столбец таблицы)
for i = 1:length(column_6_t_Tau1)
    % Найдем соответствующий индекс даты в наборе данных:
    index = find(date == column_6_t_Tau1(i));
    if ~isempty(index)
        % Если найден индекс, присвоим значение уровня воды в колонку:
        column_7_upper_level_at_Tau1(i) = upper(index);
    else
        % Если дата не найдена, можно присвоить значение NaN 
        column_7_upper_level_at_Tau1(i) = NaN; % Например, NaN для неизвестных значений
    end
end

column_8_normir_level_upper = NaN(size(column_7_upper_level_at_Tau1)); % Инициализация новой колонки (8 столбец таблицы)
for i = 1:length(column_7_upper_level_at_Tau1)
    column_8_normir_level_upper(i) = round((column_7_upper_level_at_Tau1(i) - min(column_7_upper_level_at_Tau1)) / (max(column_7_upper_level_at_Tau1) - min(column_7_upper_level_at_Tau1)),2);
end

    %Заполняем столбцы по приточному участку:
column_9_t_Tau2 = column_2_t - tau2;
column_10_Pritok_level_at_Tau2 = NaN(size(column_9_t_Tau2)); % Инициализация новой колонки (10 столбец таблицы)
for i = 1:length(column_9_t_Tau2)
    % Найдем соответствующий индекс даты в наборе данных:
    index = find(date == column_9_t_Tau2(i));
    if ~isempty(index)
        % Если найден индекс, присвоим значение уровня воды в колонку:
        column_10_Pritok_level_at_Tau2(i) = pritok(index);
    else
        % Если дата не найдена, можно присвоить значение NaN 
        column_10_Pritok_level_at_Tau2(i) = NaN; % Например, NaN для неизвестных значений
    end
end

column_11_normir_level_Pritok = NaN(size(column_10_Pritok_level_at_Tau2)); % Инициализация новой колонки (8 столбец таблицы)
for i = 1:length(column_10_Pritok_level_at_Tau2)
    column_11_normir_level_Pritok(i) = round((column_10_Pritok_level_at_Tau2(i) - min(column_10_Pritok_level_at_Tau2)) / (max(column_10_Pritok_level_at_Tau2) - min(column_10_Pritok_level_at_Tau2)),2);
end

F_pritok_to_upper = F_pritok / F_upper;
F_pritok_to_lower = F_pritok / F_lower;
    %Заполним колонку номер 12:
column_12_function_at_Area = NaN(size(column_11_normir_level_Pritok));
for i = 1:length(column_11_normir_level_Pritok)
    column_12_function_at_Area(i) = round(column_11_normir_level_Pritok(i) * F_pritok_to_upper,4);
end

    %Заполним колонку номер 13:
 column_13_summary = column_12_function_at_Area + column_8_normir_level_upper;

%Создадим теперь таблицу для удобствия:
summary_table = table(column_2_t, column_3_t_gamma,column_4_lower_Level,column_5_lower_level_at_LoadTime, ...
    column_6_t_Tau1, column_7_upper_level_at_Tau1, column_8_normir_level_upper, column_9_t_Tau2, ...
    column_10_Pritok_level_at_Tau2, column_11_normir_level_Pritok, column_12_function_at_Area, ...
    column_13_summary,'VariableNames',{'t','t-γ','Hн,t','Hн,t-γ','t-τ1','Hв,t-τ1','Hв*,t-τ1','t-τ2','Hв,t-τ2','Hв*,t-τ2','PHв*,t-τ2','Hв*,t-τ1+PHв*,t-τ2'});

    %Построим прогностические зависимости:
%Первая зависимость:
subplot(3, 1, 1);
scatter(column_7_upper_level_at_Tau1, column_4_lower_Level);
xlabel('Hв,t-τ2');
ylabel('Hн,t');
title('График зависимости уровней воды верхнего створа от нижнего');
grid on;

%Вторая зависимость:
subplot(3, 1, 2);
scatter(column_13_summary,column_4_lower_Level);
% Аппроксимация полинома
% Удаление строк с NaN
valid_indices = ~isnan(column_13_summary) & ~isnan(column_4_lower_Level);
x = column_13_summary(valid_indices);
y = column_4_lower_Level(valid_indices);
%degree = input("Введите степень полинома для зависимости верхнего и нижнего створа: "); %выбираем степень полинома!!!
degree = 2; %по умолчанию
[p, S] = polyfit(x, y, degree); % Автоматический выбор степени полинома
x_fit = min(x):0.01:max(x); % Генерация значений для построения линии тренда
y_fit = polyval(p, x_fit); % Вычисление значений линии тренда
hold on; 
plot(x_fit, y_fit, 'r', 'LineWidth', 2); % Построение красной линии тренда
xlabel('HB*,t-τ2+P1HB*,t-τ1');
ylabel('HH,t');
title('График зависимости уровней воды с линией тренда (автоматически выбранной степенью полинома)');
grid on;
% Вывод уравнения тренда
fprintf('Уравнение тренда: ');
disp(poly2str(p, 'x'));
a = p(1); % Коэффициент при x^2
b = p(2); % Коэффициент при x
if degree >= 2
    c = p(3); % Свободный член (коэффициент при x^0, т.е., константа)
end

%Третья зависимость:
subplot(3, 1, 3);
scatter(column_13_summary, column_4_lower_Level);
xlabel('HB*,t-τ2+P1HB*,t-τ1');
ylabel('Hн,t');
title('График зависимости нормированных уровней воды притока от нижнего створа');
grid on;

end
