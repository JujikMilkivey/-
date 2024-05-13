function result = prognoz_itog(variables_for_posts, data1_for_corr,data2_for_corr,data3_for_corr, data2, data3)
%считываем данные за второй год!:
date = data3(:, 1);
upper = data3(:, 2);
lower = data3(:, 3);
pritok = data3(:, 4);
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

tau1 = VzaimnayaCorrelation(data1_for_corr); %1;
tau2 = VzaimnayaCorrelation(data2_for_corr); %2;
tau3 = VzaimnayaCorrelation(data3_for_corr); %1; 


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
[LoadTime, a, b, c] = Opredelenie_dobeganiya(variables_for_posts, data1_for_corr,data2_for_corr,data3_for_corr, data2);

%СКОПИРУЕМ КОД ПРЕДЫДУЩЕГО ЭТАПА:

    %Заполняем столбцы по нижнему створу:
    
% Берем середину массива^
total_rows = length(data3);
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

 %Теперь сделаем еще колонки от 0 до 20 (c шагом 1) , но по такому порядку, который дан
 %в примере:
column9 = column_2_t;
column10 = column_4_lower_Level;

column0 = (1:25)';
column1 = column_6_t_Tau1;
column2 = column_7_upper_level_at_Tau1;
column3 = column_8_normir_level_upper;
column4 = column_9_t_Tau2;
column5 = column_10_Pritok_level_at_Tau2;
column6 = column_11_normir_level_Pritok;
column7 = column_12_function_at_Area;
column8 = column_13_summary;

% Получение коэффициентов a и b
% % % a = p(1); % Коэффициент наклона (наклон линии)
% % % b = p(2); % Коэффициент сдвига (пересечение с осью Y)

% % % a = 101.4422; %%%p(1); % Коэффициент при x^2
% % % b = 143.7122; %%%p(2); % Коэффициент при x
% % % c = 385.0566; %%%p(3); % Свободный член (коэффициент при x^0, т.е., константа)


column11 = NaN(size(column10));
for i = 1:length(column10)
    column11(i) = round((a * column8(i)^2) + (b * column8(i)) + c,0);% округлили до целого! 
end

column12 = column10 - column11;

% %Зададим для примера заблаговременность 1:
% LoadTime = 1;%input("Введите значение LoadTime:");
% Вычисляем размеры column13 как size_column12 с вычетом LoadTime из первого измерения
size_column13 = size(column12) - [LoadTime, 0];
% Создаем массив column13 с NaN значениями и нужными размерами
column13 = NaN(size_column13);
for i = (1 + LoadTime):length(column12)
    column13(i - LoadTime+1, :) = column11(i, :) - column12(i - LoadTime, :);
end

column14 = column10 - column13;
column15 = column14.^2;
column16 =NaN(size(column15)) ;
for i = (0 + LoadTime + 1):length(column15)
    column16(i) = column10(i - 1) - column10(i);
end

column17 = column16.^2;
%Рассчитываем эмпирическую обеспеченность:
column18 = NaN(size_column13);
for i = 1:length(column13)
    column18(i) = round((i / (length(column13) + 1) * 100),2);
end
column19 = sort(abs(column14), 'descend'); % Сортируем значения в порядке убывания
column20 = sort(abs(column16), 'descend'); % Сортируем значения в порядке убывания


    %Построим кривые обеспеченностей для фактических и прогнозных значений
    %уровней воды: 

% Создаем данные для оси x (столбец 18)
x = column18;
% Создаем данные для осей y (столбцы 19 и 20)
y1 = column19;y2 = column20;
%кривые с прямыми отрезками и маркерами
figure;
plot(x, y1, '-o', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b'); % Строим кривую для столбца 19 (синий цвет)
hold on;
plot(x, y2, '-s', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r'); % Строим кривую для столбца 20 (красный цвет)

% Настройте оси и добавьте метки
xlabel('Обеспеченность Р, %');
ylabel('∆H, см');
title('Кривые обеспеченностей фактических и прогнозных значений уровней воды');
legend("|∆H,t'|", "|∆H,t''|");
grid on;
% Подпись оси x в процентах
xticks(0:5:100); % Задайте желаемые!!! метки оси x (с шагом 5 от 0 до 100)


%Построим гидрографы в нижнем створе:
% Создаем данные для оси x (столбец 18)
x = column0;
% Создаем данные для осей y (столбцы 19 и 20)
y_fact = column10;y_prognoz = column11;
%кривые с прямыми отрезками и маркерами
figure;
plot(x, y_fact, '-o', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b'); % Строим кривую для столбца 19 (синий цвет)
hold on;
plot(x, y_prognoz, '-s', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r'); % Строим кривую для столбца 20 (красный цвет)

% Настройте оси и добавьте метки
xlabel('t');
ylabel('H, см');
title('Прогнозный и фактический гидрографы на нижнем створе');
legend("Фактический", "Прогнозный");
grid on;

    %Создадим теперь таблицу для удобствия:
% Зададим имена переменных в виде строковых значений:
variablesNames = {'№ п/п', 't-τ1', 'HB,t-τ1', 'HB*,t-τ1', 't-τ2', 'HB,t-τ2', 'HB*,t-τ2', 'PHB*,t-τ2', 'HB*,t-τ1+PHB*,t-τ2', 't', 'Hн,t', ...
                    'Hн,t^', '∆H,t','HH,t^^','∆H,t''','(∆H,t'')^2','∆H,t"','(∆H,t")^2','P, %','|∆H,t''|','|∆H,t"|'};
% Затем создадим таблицу с этими именами переменных:
summary_table = table(column0, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12,column13,column14,column15,column16, ...
    column17,column18,column19,column20,'VariableNames', variablesNames);
    %ОСТАЛОСЬ ГЛАВНОЕ! Проверка эффективности методики:
N = length(column13);
    
% Реализуем функцию nansum:
function result = nansum(data)
    % Инициализируем переменную для хранения суммы
    total = 0;
    
    % Итерируемся по элементам массива
    for i = 1:numel(data)
        % Проверяем, что элемент не является NaN
        if ~isnan(data(i))
            % Суммируем только числовые значения
            total = total + data(i);
        end
    end
    
    % Возвращаем результат
    result = total;
end

Sigma_to_Delta = round((sqrt(nansum(column17)/(N - 1))),2); % nansum!
Sigma_dopust = 0.674 * Sigma_to_Delta;
S =  round((sqrt(nansum(column15)/(N - 2))),2); % nansum!
    % Рассчитаем главное значение:
S_to_Sigma = S / Sigma_to_Delta;
disp("S/σ∆: " + S_to_Sigma);
result=summary_table;


%  Вычисление прогноза на один шаг вперед
current_upper_level = upper(end); % Последнее известное значение уровня реки
current_pritok_level = upper(end); % Последнее известное значение уровня реки

current_upper_normir = round((current_upper_level - min(column_7_upper_level_at_Tau1)) / (max(column_7_upper_level_at_Tau1) - min(column_7_upper_level_at_Tau1)),2);

current_pritok_normir = round((current_pritok_level - min(column_10_Pritok_level_at_Tau2)) / (max(column_10_Pritok_level_at_Tau2) - min(column_10_Pritok_level_at_Tau2)),2);
current_pritok_with_AREA = round((current_pritok_normir) * F_pritok_to_upper,4);

summary_coordinate_for_forecasted = current_upper_normir + current_pritok_with_AREA;

forecasted_river_level = round((a * summary_coordinate_for_forecasted^2) + (b * summary_coordinate_for_forecasted) + c,0);

% Шаг 4: Отображение прогноза
fprintf('Прогноз уровня реки на один шаг вперед: %.0f\n', forecasted_river_level);


end
