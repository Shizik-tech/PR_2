% rebase('layout.tpl', title="Метод Краскала")

<script src="/static/scripts/mermaid.min.js"></script>
<script src="/static/scripts/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>


<script>
    document.addEventListener('DOMContentLoaded', function () {
        mermaid.initialize({startOnLoad: true});
    });</script>

<script>

</script>
<script>

    /// Форматирование строки матрицы
    function formatMatrix(value) {
        return value.replace(' ', '') // Удаление всех пробелов, которые вводит пользователь
    }

    /// Проверка матрицы на корректность
    function isCorrectMatrix(value) {
        let matrix = parseMatrix(value)
        console.log(matrix)
        for (const arr of matrix) {
            if (arr.length !== matrix.length || isNaN(arr.slice(-1)[0])) {
                document.getElementById("alert").style.display = "block"
                document.getElementById("alert_message").textContent = "Матрица должна быть квадратной"
                return false;
            }
        }

        document.getElementById("alert").style.display = "none"
        return true;
    }


    function parseMatrix(input) {
        const rows = input.split('\n');
        const matrix = [];

        for (let i = 0; i < rows.length; i++) {
            const rowValues = rows[i].split(',');

            // Преобразование строковых значений в числа
            const parsedRow = rowValues.map((value) => parseFloat(value));

            matrix.push(parsedRow);
        }
        return matrix;
    }

    /// Отображение графа
    async function drawGraph(value) {
        let matrix = parseMatrix(value)
        var graph = "graph LR\n"
        for (let i = 0; i < matrix.length; i++) {
            const row = matrix[i];
            for (let j = 0; j < row.length; j++) {
                const weight = row[j];
                if (weight > 0) {
                    graph += `${i} -- ${weight} --- ${j}\n`
                }
            }
        }

        let output = document.getElementById("graph_parent");


        const {svg} = await mermaid.render("graph_view", graph);
        output.innerHTML = `<div id="graph_view" class="mermaid">${svg}</div>`;
    }

    function printSolution()
    {
      html2canvas(document.querySelector("#solution")).then(canvas => {
            var a = document.createElement('a');
            // toDataURL defaults to png, so we need to request a jpeg, then convert for file download.
            a.href = canvas.toDataURL("image/jpeg").replace("image/jpeg", "image/octet-stream");
            a.download = 'somefilename.jpg';
            a.click();
        });
    }
</script>

<div class="px-12">
    <h2 class="text-3xl font-semibold text-gray-800 my-12">Алгоритм Краскала</h2>
    <div style="display: none" class="bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4" id="alert"
         role="alert">
        <p class="font-bold">К вниманию!</p>
        <p id="alert_message">Введённая матрица некорректная</p>
    </div>
    <form action="/crascal" method="post">
        <div class="mt-10 grid grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-6">
            <div class="sm:col-span-3">
        <textarea id="matrix" name="matrix" oninput="this.value = formatMatrix(this.value); "
                  onchange="if (isCorrectMatrix(this.value)) drawGraph(this.value);"
                  class="w-full h-32 p-2 bg-white rounded shadow h-full"
                  placeholder="Введите матрицу весов ребер, разделяя элементы запятыми и строки переносами строки">{{matrix}}</textarea>
            </div>
            <div class="sm:col-span-3">
                <div id="graph_parent"
                     class="w-full h-32 p-2 bg-white rounded shadow  h-full flex items-center justify-center">
                    <div id="graph_view" class="mermaid">
                        {{graph}}
                    </div>

                </div>
            </div>
            <div class="sm:col-span-6 flex justify-end">
                <div class="flex gap-x-4">
                    <button onclick="" class="px-4 py-2 bg-blue-500 text-white rounded shadow">Сгенерировать задачу
                    </button>
                    <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded shadow">Решить</button>
                </div>
            </div>
        </div>
    </form>


</div>
 % if len(solve) > 0:
<div id="solution" class="max-w-3xl mx-auto">

    <h2 class="text-2xl font-semibold text-gray-800 my-12 text-center">Решение</h2>
    <div class="w-full h-64 bg-gray-100 rounded shadow flex items-center justify-center mb-8">
        <div class="mermaid">
            {{solve[0]["graph"]}}
        </div>
    </div>
    <h2 class="text-2xl font-semibold text-gray-800 my-12 text-center">Шаги выполнения:</h2>
    <div class="grid grid-cols-1 gap-8 sm:grid-cols-2">
    % for step_i in range(1, len(solve) - 1):
        <div class="bg-white rounded-lg p-6">
            <div class="w-full h-48 bg-gray-100 rounded shadow mb-4 flex items-center justify-center">
                <div class="mermaid">
                    {{solve[step_i]["graph"]}}
                </div>
            </div>
            <p class="text-lg">Шаг {{step_i}}: {{solve[step_i]["message"]}}.</p>
        </div>
    % end
    </div>
    <p class="text-lg mt-8">Кратчайшее остовное дерево:</p>
    <div class="w-full h-64 bg-gray-100 rounded shadow mb-8 flex items-center justify-center">
        <div class="mermaid">
             {{solve[-1]["graph"]}}
        </div>
    </div>
    <button onclick="printSolution()" class="px-4 py-2 bg-blue-500 text-white rounded shadow">Сохранить
                    </button>

</div>
% end
<div class="max-w-3xl mx-auto">
    <h2 class="text-2xl font-semibold text-gray-800 my-12 text-center">Пример</h2>

    <div class="w-full h-64 bg-gray-100 rounded shadow flex items-center justify-center mb-8">
        <div class="mermaid">
            graph LR
            A -- 5 --- B
            A -- 7 --- C
            B -- 2 --- C
            B -- 9 --- D
            C -- 1 --- D
            C -- 8 --- E
            D -- 4 --- E
        </div>
    </div>

    <p class="text-lg mb-4">Описание алгоритма Краскала:</p>

    <ol class="list-decimal list-inside mb-8">
        <li>Сортируйте все ребра графа в порядке возрастания их весов.</li>
        <li>Проходите по отсортированным ребрам и добавляйте их в остовное дерево, если они не создают цикл.</li>
        <li>Повторяйте шаг 2 до тех пор, пока не будут добавлены все вершины в остовное дерево.</li>
    </ol>

    <h2 class="text-2xl font-semibold text-gray-800 my-12 text-center">Шаги выполнения алгоритма Краскала:</h2>

    <div class="grid grid-cols-1 gap-8 sm:grid-cols-2">
        <div class="bg-white rounded-lg p-6">
            <div class="w-full h-48 bg-gray-100 rounded shadow mb-4">
                <div class="mermaid">
                    graph LR
                    A -- 5 --- B
                    A -- 7 --- C
                    B -- 2 --- C
                    B -- 9 --- D
                    C -- 1 --- D
                    C -- 8 --- E
                    D -- 4 --- E
                    style C fill:#f9f
                    style D fill:#f9f
                    linkStyle 4 stroke-width:2px,fill:none,stroke:#f9f
                </div>
            </div>
            <p class="text-lg">Шаг 1: Добавлено ребро C-D (вес 1).</p>
        </div>

        <div class="bg-white rounded-lg p-6">
            <div class="w-full h-48 bg-gray-100 rounded shadow mb-4">
                <div class="mermaid">
                    graph LR
                    A -- 5 --- B
                    A -- 7 --- C
                    B -- 2 --- C
                    B -- 9 --- D
                    C -- 1 --- D
                    C -- 8 --- E
                    D -- 4 --- E
                    style B fill:#f9f
                    style C fill:#f9f
                    style D fill:#f9f
                    linkStyle 4 stroke-width:2px,fill:none,stroke:#f9f
                    linkStyle 2 stroke-width:2px,fill:none,stroke:#f9f
                </div>
            </div>
            <p class="text-lg">Шаг 2: Добавлено ребро B-C (вес 2).</p>
        </div>

        <div class="bg-white rounded-lg p-6">
            <div class="w-full h-48 bg-gray-100 rounded shadow mb-4">
                <div class="mermaid">
                    graph LR
                    A -- 5 --- B
                    A -- 7 --- C
                    B -- 2 --- C
                    B -- 9 --- D
                    C -- 1 --- D
                    C -- 8 --- E
                    D -- 4 --- E
                    style B fill:#f9f
                    style C fill:#f9f
                    style D fill:#f9f
                    style E fill:#f9f
                    linkStyle 4 stroke-width:2px,fill:none,stroke:#f9f
                    linkStyle 2 stroke-width:2px,fill:none,stroke:#f9f
                    linkStyle 6 stroke-width:2px,fill:none,stroke:#f9f
                </div>
            </div>
            <p class="text-lg">Шаг 3: Добавлено ребро D-E (вес 4).</p>
        </div>

        <div class="bg-white rounded-lg p-6">
            <div class="w-full h-48 bg-gray-100 rounded shadow mb-4">
                <div class="mermaid">
                    graph LR
                    A -- 5 --- B
                    A -- 7 --- C
                    B -- 2 --- C
                    B -- 9 --- D
                    C -- 1 --- D
                    C -- 8 --- E
                    D -- 4 --- E
                    style B fill:#f9f
                    style C fill:#f9f
                    style D fill:#f9f
                    style E fill:#f9f
                    style A fill:#f9f
                    linkStyle 4 stroke-width:2px,fill:none,stroke:#f9f
                    linkStyle 2 stroke-width:2px,fill:none,stroke:#f9f
                    linkStyle 6 stroke-width:2px,fill:none,stroke:#f9f
                    linkStyle 0 stroke-width:2px,fill:none,stroke:#f9f
                </div>
            </div>
            <p class="text-lg">Шаг 4: Добавлено ребро A-B (вес 5).</p>
        </div>
    </div>

    <p class="text-lg mt-8">Кратчайшее остовное дерево:</p>

    <div class="w-full h-64 bg-gray-100 rounded shadow mb-8 flex items-center justify-center">
        <div class="mermaid">
            graph LR
            C -- 1 --- D
            B -- 2 --- C
            D -- 4 --- E
            A -- 5 --- B
        </div>
    </div>
</div>

<script>

    % if len(error) > 0:
    document.getElementById("alert").style.display = "block"
    document.getElementById("alert_message").textContent = "{{error}}"
    % end
</script>