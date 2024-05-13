%Начинается функция для определения времени добегания:
function rounded_Tau =  Vzaimnaya_Correlation(data)
    % задаем массивы уровней верхнего и нижнего створов
    date = data(:, 1);
    upper = data(:, 2);
    lower = data(:, 3);
    %посмотрим СКО каждого ряда:
    std_upper = std(upper);
    std_lower = std(lower);
    
    % построим промежуточную таблицу для дальнейших расчетов:
    
    % Рассчитываем средние значения для каждого ряда
    average_upper = mean(upper);
    average_lower = mean(lower);
    
    %Заполним первую таблицу
    upper_result = zeros(size(data));%созданиe массива result с нулевыми значениями и той же размерностью, что и у массива data
    lower_result = zeros(size(data));
    % Проходим по набору данных и вычитаем среднее значение
    for i = 1:length(data)
        upper_result(i) = upper(i) - average_upper;
        lower_result(i) = lower(i) - average_lower;
    end
    %Создадим из этих переменных нужную нам промежуточную таблицу:
    data_table = table(date,upper,lower,upper_result,lower_result,'VariableNames', {'Date','Upper_Level', 'Lower_Level','Нвс-Нср','Ннс-Нср'});
    
        %Переходим к построению второй таблицы: 
    shift = 1:10; % Сдвижка
    second_column = zeros(size(shift));
    N = length(data);
    for i = 1:length(shift)
        second_column(i) = 1/(N-shift(i));
    end
    
    % Заполним эту таблицу:
    % Создаем пустой массив для результатов
    advanced_table = zeros(size(lower_result));
    % Выполняем умножение с заданным сдвигом от 1 до 10:
    for shift = 1:10
        for i = 1:(length(lower_result) - shift)
            advanced_table(i, shift) = upper_result(i) * lower_result(i + shift);
        end
    end
        % Посчитаем суммы по каждому столбцу:
        summ = sum(advanced_table);
        %Осталось рассчитать коэффициент корреляции (последний столбик таблички):
    % Создаем пустой массив R_corr
    R_corr = zeros(size(shift));
    % Вычисляем значения для R_corr
    for i = 1:10
        R_corr(i) = second_column(i) * (summ(i) / (std_lower * std_upper));
    end
    %Создаем итоговую таблицу:
    summary_table = table(second_column, std_upper,std_lower,R_corr, 'VariableNames', {'1/(N-δ', 'δBC','δHC','R(δ)'});
    Tau = max(R_corr);
    % Округление числа до ближайшего целого и вывод на экран целевой переменной:
    rounded_Tau = round(Tau);
    fprintf('Время добегания: %d\n', rounded_Tau);
end