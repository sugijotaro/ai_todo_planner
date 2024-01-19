[<img alt="AI ToDo プランナー" align="right" src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/4e341dbc-65fe-46c2-933c-ef6bd699c8fa" width="15%">](https://ai-todo-planner.onrender.com/)

# AI ToDo プランナー

AI ToDo プランナーは、タスクの完了を促進するためのWebサービスです。

メインのタスクを入力するだけで、自動的にサブタスクが作成されるので、やるべきことの解像度が高まり、タスクに取り組みやすくなります。

https://github.com/sugijotaro/ai_todo_planner/assets/52352924/a51bb1f6-b684-456c-9236-0defd2723e49

[こちら](https://ai-todo-planner.onrender.com/)から試すことができます。 |　[レポート](https://sugijotaro.github.io/ai_todo_planner/)

> [!WARNING]
> - Renderのデータベース無料期間が90日なので、2024年4月以降は使用できない可能性があります。
> - OpenAIのAPIは5ドル分しか割り当てていないので、上限を超えると動かなくなる可能性があります。

## プロジェクトの背景

最近、ChatGPTなどのAI技術の発展が目まぐるしく、これを活用したWebサービスの作成に取り組みたいと考えていました。

また、私自身がタスク管理に苦手意識を持っていたため、AIを利用してタスク管理を助けるツールを開発することにしました。

## アプリケーションの使い方

### タスクの追加

<img src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/76386875-bda6-44ec-b8c9-d0435ec4c6ee" width="30%">
<img src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/7d5f72bf-65ef-42e1-9680-0efc1da89922" width="30%">

- タスク一覧ページから「+ タスクを作成」ボタンをクリックして、新しいタスクを追加します。
- タスクのタイトルと詳細を入力し、期限を設定します。
- 「タスクを作成」ボタンをクリックすると、タスクがリストに追加されます。

### サブタスクの活用

<img src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/747bfeaf-1502-4e05-b67e-c1a320552ae0" width="30%">

- タスクを作成すると、AIが自動的に関連するサブタスクを生成します。
- サブタスクもメインタスクと同様に管理できます。

### タスクの管理

<img src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/1982cbe1-39bc-4fdd-942e-603832859a37" width="30%">

- メインページで、すべてのタスクが一覧で表示されます。
- 各タスクには、そのタスクの状態（完了/未完了）を変更するためのボタンがあります。
- タスクのタイトルをクリックすると、そのタスクの詳細ページに遷移します。

## アプリケーションの内部構造

### モデル構造

#### Task モデル

Task モデルは、ユーザーが作成するメインタスクを表します。以下の項目を持ちます。

- `id`: タスクの一意識別子
- `title`: タスクのタイトル　ユーザーがタスクを識別するための短い記述
- `description`: タスクの詳細説明　タスクに関する追加情報を提供します
- `due_date`: タスクの期限日　タスクを完了するための期日
- `completed`: タスクの完了状態　タスクが完了したかどうかを示すブール値（true/false）
- `created_at`: レコードの作成日時
- `updated_at`: レコードの最終更新日時

#### SubTask モデル

SubTask モデルは、AIによって生成されるサブタスクを表します。以下の項目を持ちます。

- `id`: サブタスクの一意識別子
- `content`: サブタスクの内容　AIによって提案された具体的なアクション項目
- `completed`: サブタスクの完了状態　サブタスクが完了したかどうかを示すブール値（true/false）
- `task_id`: 関連するメインタスク（Task）のID　外部キーとして機能し、TaskとSubTask間の関連を定義します
- `created_at`: レコードの作成日時
- `updated_at`: レコードの最終更新日時

### ViewsとUIの詳細

#### /tasks（タスク一覧ページ）

- **URL:** `/tasks`
- **内容:**
  - 「AI ToDo プランナー」というヘッダー
  - 「+ タスクを作成」: 新しいタスクを追加するためのリンク
  - タスクの一覧: 各タスクには、そのタイトル、未完了のサブタスクの数、タスクの状態を変更するための「✅/🔲」ボタンが表示される
  - タスクのタイトルをクリックすると、そのタスクの詳細ページに遷移する

#### /tasks/new（タスク追加ページ）

- **URL:** `/tasks/new`
- **内容:**
  - 新しいタスクを作成するためのフォーム
  - タスクのタイトル、説明、期限日を入力するフィールドがある
  - 「タスクを作成」ボタンをクリックすると、タスクが追加され、タスク一覧ページにリダイレクトされる

#### /tasks/:id（タスク詳細ページ）

- **URL:** `/tasks/:id`
- **内容:**
  - タスクのタイトル、説明、期限日が表示される
  - 「編集」と「削除」のボタンがあり、タスクの編集や削除ができる
  - サブタスクの一覧が表示され、各サブタスクには完了/未完了の状態を変更するボタンと、サブタスクの内容が表示される
  - サブタスクの内容をクリックすると、そのサブタスクの詳細ページに遷移する

#### /tasks/:id/edit（タスク編集ページ）

- **URL:** `/tasks/:id/edit`
- **内容:**
  - タスクの編集を行うフォーム
  - タイトル、説明、期限日を編集できる
  - 「タスクを更新」ボタンで変更を保存し、タスク詳細ページにリダイレクトされる

#### /tasks/:task_id/sub_tasks/:id（サブタスク詳細ページ）

- **URL:** `/tasks/:task_id/sub_tasks/:id`
- **内容:**
  - 特定のサブタスクの内容が表示される
  - 「完了にする/未完了にする」ボタンでサブタスクの状態を変更できる
  - 「削除」ボタンでサブタスクを削除できる
  - 「戻る」ボタンで関連するメインタスクの詳細ページに戻る

### AI統合

- `OpenaiClient`: OpenAI APIを利用して、メインタスクに基づいてサブタスクを自動生成します。

### データベースとActiveRecord

- アプリケーションのデータストレージとして、PostgreSQLデータベースを使用しています。

## 工夫した点

- UIはToDoアプリとして使いやすいデザインにすることを心がけました。
- AIのイメージと緑色を連想させるChatGPTのカラーを反映して、緑を基調としたアプリケーションにしました。
- 絵文字（✅や🔲）を活用することで、直感的に理解しやすいUIを実現しました。また、工数を削減することにも成功しました。

## 反省点と学び

- Ruby on Railsを使用した開発は初めてで、多くの新しい概念に直面しましたが、ChatGPTと対話しながら開発することで、新しい概念もすんなりと理解することができました。
- Renderにデプロイし、Webサービスを公開する際に、エラーの解消に苦労しました。

---

# AI ToDo Planner

The AI ToDo Planner is a web service designed to facilitate the completion of tasks. 

Simply input a main task, and it automatically generates sub-tasks, increasing the resolution of what needs to be done and making it easier to tackle tasks.

https://github.com/sugijotaro/ai_todo_planner/assets/52352924/a51bb1f6-b684-456c-9236-0defd2723e49

You can try it out [here](https://ai-todo-planner.onrender.com/). | [Report](https://sugijotaro.github.io/ai_todo_planner/)

> [!WARNING]
> - The free period for Render's database is 90 days, so the service may become unavailable after April 2024.
> - Only $5 worth of the OpenAI API has been allocated, so exceeding this limit may cause the service to stop functioning.

## Project Background

Recently, the rapid development of AI technologies like ChatGPT has been remarkable, and I was inspired to create a web service utilizing these advancements. 

Additionally, as I've always found task management challenging, I decided to develop a tool that uses AI to assist in managing tasks.

## How to Use the Application

### Adding Tasks

<img src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/76386875-bda6-44ec-b8c9-d0435ec4c6ee" width="30%">
<img src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/7d5f72bf-65ef-42e1-9680-0efc1da89922" width="30%">

- From the task list page, click the "+ Create Task" button to add a new task.
- Enter the title and details of the task and set a deadline.
- Clicking the "Create Task" button adds the task to the list.

### Utilizing Sub-Tasks

<img src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/747bfeaf-1502-4e05-b67e-c1a320552ae0" width="30%">

- Upon creating a task, AI automatically generates related sub-tasks.
- Sub-tasks can be managed just like main tasks.

### Managing Tasks

<img src="https://github.com/sugijotaro/ai_todo_planner/assets/52352924/1982cbe1-39bc-4fdd-942e-603832859a37" width="30%">

- On the main page, all tasks are displayed in a list.
- Each task has a button to change its status (completed/not completed).
- Clicking on the title of a task will take you to its detail page.

## Internal Structure of the Application

### Model Structure

#### Task Model

The Task model represents the main tasks created by users. It includes the following attributes:

- `id`: A unique identifier for the task
- `title`: The title of the task, a brief description for user identification
- `description`: Detailed description of the task, providing additional information about it
- `due_date`: The deadline for the task completion
- `completed`: The completion status of the task, a boolean value (true/false) indicating whether the task is completed
- `created_at`: The date and time the record was created
- `updated_at`: The date and time the record was last updated

#### SubTask Model

The SubTask model represents the sub-tasks generated by AI. It includes the following attributes:

- `id`: A unique identifier for the sub-task
- `content`: The content of the sub-task, specific action items proposed by AI
- `completed`: The completion status of the sub-task, a boolean value (true/false) indicating whether the sub-task is completed
- `task_id`: The ID of the related main task (Task). Functions as a foreign key and defines the relationship between Task and SubTask
- `created_at`: The date and time the record was created
- `updated_at`: The date and time the record was last updated

### Views and UI Details

#### /tasks (Task List Page)

- **URL:** `/tasks`
- **Content:**
  - A header titled "AI ToDo Planner"
  - A link to "+ Create Task" for adding new tasks
  - A list of tasks, each displaying the title, the number of incomplete sub-tasks, and a button to change the task's status (✅/🔲)
  - Clicking a task title navigates to its detail page

#### /tasks/new (Add Task Page)

- **URL:** `/tasks/new`
- **Content:**
  - A form to create new tasks
  - Fields to enter the task's title, description, and due date
  - Clicking the "Create Task" button adds the task and redirects to the task list page

#### /tasks/:id (Task Detail Page)

- **URL:** `/tasks/:id`
- **Content:**
  - Displays the task's title, description, and due date
  - Buttons for "Edit" and "Delete" allowing task modification or deletion
  - A list of sub-tasks, each with a button to change its completion status and displaying the sub-task content
  - Clicking a sub-task content navigates to its detail page

#### /tasks/:id/edit (Edit Task Page)

- **URL:** `/tasks/:id/edit`
- **Content:**
  - A form for editing tasks
  - Allows editing the title, description, and due date
  - "Update Task" button saves changes and redirects to the task detail page

#### /tasks/:task_id/sub_tasks/:id (Sub-Task Detail Page)

- **URL:** `/tasks/:task_id/sub_tasks/:id`
- **Content:**
  - Displays the content of a specific sub-task
  - "Complete/Incomplete" button changes the sub-task's status
  - "Delete" button removes the sub-task
  - "Back" button navigates back to the related main task's detail page

### AI Integration

- `OpenaiClient`: Utilizes the OpenAI API to automatically generate sub-tasks based on the main task.

### Database and ActiveRecord

- The application uses a PostgreSQL database for data storage.

## Innovative Aspects

- We focused on creating a user-friendly design for the UI, suitable for a ToDo application.
- Reflecting the image of AI and the green color associated with ChatGPT, we developed an application with a green color scheme.
- By utilizing emojis (✅ and 🔲), we achieved an intuitive and easy-to-understand UI. This approach also helped in reducing development efforts.

## Reflections and Learnings

- This was my first time developing with Ruby on Rails, and I faced many new concepts. However, developing while conversing with ChatGPT allowed me to smoothly understand these new ideas.
- Deploying on Render and making the web service public was challenging, especially in resolving errors.
