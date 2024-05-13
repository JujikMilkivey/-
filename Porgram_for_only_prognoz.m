function values = only_prognoz(variables_for_posts, data1_for_corr,data2_for_corr,data3_for_corr, data2)

% 1)Вычислить среднюю скорость движения паводка для бесприточных участков:

%Зададим площади:
F_upper = variables_for_posts(6);
F_pritok = variables_for_posts(8);

tau1 = VzaimnayaCorrelation(data1_for_corr); %1;
tau2 = VzaimnayaCorrelation(data2_for_corr); %2;




%3)Вычислить время добегания на главной реке и на притоке:

% Заблаговременность:
[LoadTime, a, b, c] = Opredelenie_dobeganiya(variables_for_posts, data1_for_corr,data2_for_corr,data3_for_corr, data2);

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
    %Заполним колонку номер 12:
column_12_function_at_Area = NaN(size(column_11_normir_level_Pritok));
for i = 1:length(column_11_normir_level_Pritok)
    column_12_function_at_Area(i) = round(column_11_normir_level_Pritok(i) * F_pritok_to_upper,4);
end
   



% Запрос ввода массива у пользователя
current_upper_level = input('Введите массив данных по верхнему створу: ');
current_pritok_level = input('Введите массив данных по приточному участку: ');

current_upper_normir = round((current_upper_level - min(column_7_upper_level_at_Tau1)) / (max(column_7_upper_level_at_Tau1) - min(column_7_upper_level_at_Tau1)),2);

current_pritok_normir = round((current_pritok_level - min(column_10_Pritok_level_at_Tau2)) / (max(column_10_Pritok_level_at_Tau2) - min(column_10_Pritok_level_at_Tau2)),2);
current_pritok_with_AREA = round((current_pritok_normir) * F_pritok_to_upper,4);

summary_coordinate_for_forecasted = current_upper_normir + current_pritok_with_AREA;

values = round((a * summary_coordinate_for_forecasted.^2) + (b * summary_coordinate_for_forecasted) + c,0);

% Шаг 4: Отображение прогноза
fprintf('Прогноз уровня реки на один шаг вперед: %.0f\n', values);



end