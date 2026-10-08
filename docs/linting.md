# Проверка и линтинг

Часть правил руководства проверяется автоматически.
Так ревьюер тратит время на смысл текста, а не на кавычки и отступы.

Используем два линтера:

- **markdownlint** проверяет разметку Markdown: заголовки, списки, блоки кода. Настройки — в файле `.markdownlint-cli2.yaml`.
- **Vale** проверяет текст: термины, кавычки, тире, канцелярит. Настройки — в файле `.vale.ini`, правила — в каталоге `styles/SQLHunt/`.

## Какие правила проверяются автоматически

| Правило руководства | Линтер | Правило линтера | Уровень |
| --- | --- | --- | --- |
| СИ-3. Короткие предложения | Vale | `SQLHunt.SentenceLength` | suggestion |
| СИ-4. Без канцелярита | Vale | `SQLHunt.Bureaucratese` | warning |
| СИ-5. Без обесценивания | Vale | `SQLHunt.Condescending` | warning |
| ОП-2. Кавычки-«ёлочки» | Vale | `SQLHunt.Quotes` | error |
| ОП-3. Тире и дефис | Vale | `SQLHunt.Dash` | error |
| ОП-6. Иноязычные названия | Vale | `SQLHunt.Brands`, `SQLHunt.Words` | error |
| ОП-7. Сокращения | Vale | `SQLHunt.Abbreviations` | warning |
| ОП-8. Заголовки без точки | markdownlint | `MD026` | error |
| ОП-9. Смешение алфавитов | Vale | `SQLHunt.MixedScript` | error |
| ОТ-1. Иерархия заголовков | markdownlint | `MD001`, `MD025`, `MD041` | error |
| MD-2. Заголовки через решётку | markdownlint | `MD003`, `MD018`, `MD022` | error |
| MD-3. Списки | markdownlint | `MD004`, `MD007`, `MD029` | error |
| MD-4. Блоки кода с языком | markdownlint | `MD040`, `MD046`, `MD048` | error |
| MD-5. Без HTML | markdownlint | `MD033` | error |
| MD-6. Выделение звёздочками | markdownlint | `MD049`, `MD050` | error |
| MD-8. Оформление файлов | markdownlint | `MD009`, `MD041`, `MD047` | error |
| MD-9. Без голых ссылок | markdownlint | `MD034` | error |
| ТР-1. Название продукта | Vale | `SQLHunt.ProductName`, `SQLHunt.ProductNameSpaced` | error |
| ДС-1. Структура заголовков | markdownlint | `MD001` | error |
| ДС-2. Текст ссылки | Vale | `SQLHunt.LinkText` | error |
| ДС-3. Альтернативный текст | markdownlint, Vale | `MD045`, `SQLHunt.AltText` | error |
| ТИ-3. Многоточие одним символом | Vale | `SQLHunt.Ellipsis` | warning |

Ошибки уровня `error` блокируют merge.
Предупреждения `warning` и `suggestion` видны в выводе линтера, но сборку не останавливают.

Остальные правила проверяет ревьюер.

## Как запустить проверку локально

1. Установите [Node.js](https://nodejs.org/) версии 20 или выше и [Vale](https://vale.sh/docs/install).
2. Проверьте разметку:

    ```bash
    npx markdownlint-cli2
    ```

3. Проверьте текст:

    ```bash
    vale docs *.md
    ```

Обе проверки можно запустить одной командой `make lint`.

## Как отключить проверку для примера

Примеры неправильного текста нарушают правила намеренно.
Чтобы Vale не ругался на них, оберните пример комментариями:

```markdown
<!-- vale off -->

| Неправильно | Правильно |
| --- | --- |
| Откройте дело "Серебряный Ключ". | Откройте дело «Серебряный Ключ». |

<!-- vale on -->
```

Отключайте проверку только для примеров.
Если правило мешает в обычном тексте, предложите изменить правило через Pull Request.

## Проверка в CI

При каждом Pull Request и при каждом push в `main` GitHub Actions запускает workflow `.github/workflows/docs.yml`:

1. markdownlint проверяет разметку.
2. Vale проверяет текст.
3. MkDocs собирает сайт командой `mkdocs build --strict`. Битая ссылка или страница вне навигации остановят сборку.
4. После merge в `main` сайт публикуется на GitHub Pages.
