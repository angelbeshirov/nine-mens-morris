# Проект "Дама"

## Описание
Дама е игра, която се играе от двама играчи с пулове, като всеки от тях избира в началото свой цвят (единият играе с пулове в светъл цвят, а другият – в тъмен). Играчите разполагат с по девет пула, които последователно поставят на дъската на определените места.

## Правила
Играта "Дама", позната още като "Коран", се играе от двама играчи на дъска с три квадрата един в друг със свързани среди на страните, като пресечните точки на линиите образуват 24 позиции за поставяне на пуловете. Всеки играч в началото има девет пула.

#### Поставяне на пуловете
Играта започва върху празна дъска, на която играчите поставят пуловете си на свободни позиции, като се редуват.

Ако играч успее да подреди три свои пула по една от правите линии на дъската, той има "дама" и премахва един от пуловете на противника. Премахнат пул не се поставя обратно на дъската. От направена "дама" не може да се премахва пул, освен в случай, че няма други свободни пулове.

#### Местене на пуловете
След като играчите поставят всички свои пулове на дъската, започват да ги местят. Пул може да бъде преместен по линия на дъската до съседна свободна позиция. Ако играч не може да премести нито един свой пул, той губи играта.

Както при поставянето, ако играч подреди "дама", той премахва един от пуловете на противника, като по възможност не разваля направена противникова "дама". Ако играч остане само с два пула, той вече не може да прави "дама" и да взема пулове на противника, при което губи играта.

#### Летене
Ако играч остане само с три пула, той може да ги мести на всяка свободна позиция, не само на съседните. Това се нарича "летене" или "скачане".

#### Общи
Целта на играта е да се прави "дама", при което се взема по един пул на противника, докато той остане само с два пула, или да се затворят пуловете на противника, така че той да не може да мести.
Добра стратегия е правенето на съседни "дами", при което с всяко местене на единия пул се затваря една от тях и се взема по един противников пул (както на схемата – с черните пулове - ●, местим от Е5 на D5 и обратно).
```
    A   B   C   D   E   F   G
1   · - - - - - · - - - - - ·
    |           |           |
2   |   · - - - · - - - ○   |
    |   |       |       |   |
3   |   |   · - · - ●   |   |
    |   |   |       |   |   |
4   · - ○ - ○       ● - ○ - ·
    |   |   |       |   |   |
5   |   |   · - · - ●   |   |
    |   |       |       |   |
6   |   ○ - - - ● - - - ○   |
    |           |           |
7   · - - - - - ● - - - - - ·
```

## Интерфейс
Началната дъска, върху която играчите ще поставят своите пулове изглежда така:
```
    A   B   C   D   E   F   G
   
1   ·-----------·-----------·
    |           |           |
2   |   ·-------·-------·   |
    |   |       |       |   |
3   |   |   ·---·---·   |   |
    |   |   |       |   |   |
4   ·---·---·       ·---·---·
    |   |   |       |   |   |
5   |   |   ·---·---·   |   |
    |   |       |       |   |
6   |   ·-------·-------·   |
    |           |           |
7   ·-----------·-----------·
```

* Място, което **не** е заето от пул, се отбелязва с `·`;
* Белите пулове се маркират със специалният символ: `○`;
* Черните пулове се маркират с: `●`;
* Хоризонталните линии, по които могат да се движат пуловете, се отбелязват с тирета `-`;
* Вертикалните линии, по които могат да се движат пуловете, се отбелязват с: `|`;

Белите и черните пулове заместват празните места при "поставяне" върху дъската.

## Реализация
Проектът е написан на Swift версия 5.1.4-RELEASE. Пакетът е разделен на три модула:
* модул, който съдържа входната точка към приложението и го стартира
* модул, който съдържа отделните интерфейси, класове, типове и модели свързани с игровата логика
* модул, който съдържа интерфейси, типове и класове свързани с входно-изходни операции с потребителя

Разделението на модули, както и зависимостите между тях могат да бъдат видяни в [Package.swift](https://github.com/angelbeshirov/nine-mens-morris/blob/master/Package.swift) файла.

Класовете, които имплементират даден протoкол могат да бъдат заменяни с различни имплементации, така че играта да се надгради или промени по някакъв начин. Например може да бъде добавен нов мод към играта - игра срещу компютър, като за целта ще се имплементира [Player](https://github.com/angelbeshirov/nine-mens-morris/blob/master/Sources/GameModule/Player.swift) протоколът и ще се добави логика за избор на мод и AI за определяне на ходовете. Друг пример за надграждане може да бъде да се имплементира [InputHandler](https://github.com/angelbeshirov/nine-mens-morris/blob/master/Sources/IOModule/InputHandler.swift) за да се получават координатите чрез някакъв друг интерфейс различен от конзолния. 

В проекта е използван един външен пакет, който може да бъде намерен [тук](https://github.com/onevcat/Rainbow), таг версията е след 3.0.0. Целта на пакета е при показване на грешките в конзолата (напр. невалиден вход от потребителя) да се добави червен цвят към текста при визуализация. Всички интерфейси и класове, както и методите към тях са описани и обяснени подробно, също така където има по-сложна логика в кода са добавени допълнителни коментари. 

# За мен
<b>Име:</b> Ангел Беширов <br />
<b>Факултетен номер: </b> 62012 <br />
<b>Специалност: </b> Софтуерно инженерство <br />
<b>Курс: </b> 4 <br />
