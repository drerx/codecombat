require('app/styles/editor/level/tasks-tab.sass')
CocoView = require 'views/core/CocoView'
template = require 'app/templates/editor/level/tasks-tab'
Level = require 'models/Level'
utils = require 'core/utils'

module.exports = class TasksTabView extends CocoView
  id: 'editor-level-tasks-tab-view'
  className: 'tab-pane'
  template: template
  events:
    'click .task-row': 'onClickTaskRow'
    'click .task-input': 'onClickTaskInput'
    'click .start-edit': 'onClickStartEdit'
    'click #create-task': 'onClickCreateTask'
    'keydown #cur-edit': 'onKeyDownCurEdit'
    'blur #cur-edit': 'onBlurCurEdit'

  subscriptions:
    'editor:level-loaded': 'onLevelLoaded'

  applyTaskName: (_task, _input) ->
    name = _input.value
    potentialTask = @tasks.findWhere({'name':_input})
    if potentialTask and potentialTask isnt _task
      noty
        timeout: 5000
        text: 'Task with name already exists!'
        type: 'error'
        layout: 'topCenter'
      _input.focus()
    else if name is ''
      @tasks.remove _task
      @pushTasks()
      @render()
    else
      _task.set 'name', name
      _task.set 'curEdit', false
      @pushTasks()
      @render()

  focusEditInput: ->
    editInput = @$('#cur-edit')[0]
    if editInput
      editInput.focus()
      len = editInput.value.length * 2
      editInput.setSelectionRange len, len

  getTaskByCID: (_cid) ->
    return @tasks.get _cid

  taskMap: ->
    return @tasks?.map((_obj) -> return (name: _obj.get('name'), complete: (_obj.get('complete') || false)))

  taskArray: ->
    return @tasks?.toArray()

  onLevelLoaded: (e) ->
    @level = e.level
    @defaultTasks = tasksForLevel @level
    @level.set 'tasks', _.clone @defaultTasks
    Task = Backbone.Model.extend({
      initialize: ->
        # We want to keep track of the revertAttributes easily without digging back into the level every time.
        # So per TaskModel we check to see if there is a revertAttribute associated with the task's name.
        # If there is a reversion available, we use it, otherwise (e.g. new tasks without a reversion) we just use the Task's current name/completion status.
        if e?.level?._revertAttributes?.tasks?
          if _.find(e.level._revertAttributes.tasks, {name:arguments[0].name})
            @set 'revert', _.find(e.level._revertAttributes.tasks, {name:arguments[0].name})
          else
            @set 'revert', arguments[0]
        else
          @set 'revert', arguments[0]
    })
    TaskList = Backbone.Collection.extend({
      model: Task
    })
    @tasks = new TaskList(@level.get 'tasks')
    @pushTasks()
    @render()

  pushTasks: ->
    @level.set 'tasks', @taskMap()

  onClickTaskRow: (e) ->
    if not $(e.target).is('input') and not $(e.target).is('a') and not $(e.target).hasClass('start-edit') and @$('#cur-edit').length is 0
      task = @tasks.get $(e.target).closest('tr').data('task-cid')
      checkbox = $(e.currentTarget).find('.task-input')[0]
      if task.get 'complete'
        task.set 'complete', false
      else
        task.set 'complete', true
      checkbox.checked = task.get 'complete'
      @pushTasks()

  onClickTaskInput: (e) ->
    task = @tasks.get $(e.target).closest('tr').data('task-cid')
    task.set 'complete', e.currentTarget.checked
    @pushTasks()

  onClickStartEdit: (e) ->
    if @$('#cur-edit').length is 0
      task = @tasks.get $(e.target).closest('tr').data('task-cid')
      task.set 'curEdit', true
      @render()
      @focusEditInput()

  onKeyDownCurEdit: (e) ->
    if e.keyCode is 13
      editInput = @$('#cur-edit')[0]
      editInput.blur()

  onBlurCurEdit: (e) ->
    editInput = @$('#cur-edit')[0]
    task = @tasks.get $(e.target).closest('tr').data('task-cid')
    @applyTaskName(task, editInput)

  onClickCreateTask: (e) ->
    if @$('#cur-edit').length is 0
      @tasks.add
        name: ''
        complete: false
        curEdit: true
        revert:
          name: 'null'
          complete: false
      @render()
      @focusEditInput()

  getTaskURL: (_n) ->
    if _.find(@defaultTasks, {name:_n})?
      return _.string.slugify(_n)
    return null


notWebDev = ['hero', 'course', 'hero-ladder', 'course-ladder', 'game-dev']
notIntros = ['hero', 'course', 'hero-ladder', 'course-ladder', 'game-dev']
heroBased = ['hero', 'course', 'hero-ladder', 'course-ladder']
ladder = ['hero-ladder', 'course-ladder', 'ladder']

if utils.isCodeCombat
  defaultTasks = [
    {name: 'Set level type.', complete: (level) -> level.get('type')}
    {name: 'Name the level.'}
    {name: 'Create a Referee stub, if needed.', types: notWebDev}
    {name: 'Replace "Hero Placeholder" with mcp.', types: ['game-dev']}
    {name: 'Do basic set decoration.', types: notWebDev}
    {name: 'Publish.', complete: (level) -> level.isPublished()}
    {name: 'Choose the Existence System lifespan and frame rate.', types: notWebDev}
    {name: 'Choose the UI System paths and coordinate hover if needed.', types: notWebDev}
    {name: 'Choose the AI System pathfinding and Vision System line of sight.', types: notWebDev}
    {name: 'Build the level.'}
    {name: 'Set up goals.'}
    {name: 'Add the "win-game" goal.', types: ['game-dev']}
    {name: 'Write the sample code.', complete: (level) -> if level.isType('web-dev') then level.getSampleCode().html else level.getSampleCode().javascript and level.getSampleCode().python}
    {name: 'Write the solution.', complete: (level) -> if level.isType('web-dev') then _.find(level.getSolutions(), language: 'html') else _.find(level.getSolutions(), language: 'javascript') and _.find(level.getSolutions(), language: 'python')}
    {name: 'Make both teams playable and non-defaulted.', types: ladder}
    {name: 'Set up goals for both teams.', types: ladder}
    {name: 'Fill out the sample code for both Hero Placeholders.', types: ladder}
    {name: 'Fill out default AI for both Hero Placeholders.', types: ladder}
    {name: 'Make sure the level ends promptly on success and failure.'}
    {name: 'Adjust script camera bounds.', types: notWebDev}
    {name: 'Choose music file in Introduction script.', types: notWebDev}
    {name: 'Choose autoplay in Introduction script.', types: heroBased}
    {name: 'Write the description.'}
    {name: 'Write the guide.'}
    {name: 'Write intro guide.'}
    {name: 'Write a loading tip, if needed.', complete: (level) -> level.get('loadingTip')}
    {name: 'Add programming concepts covered.'}
    {name: 'Set level kind.', complete: (level) -> level.get('kind')}
    {name: 'Mark whether it requires a subscription.', complete: (level) -> level.get('requiresSubscription')?}
    {name: 'Choose leaderboard score types.', types: ['hero', 'course'], complete: (level) -> level.get('scoreTypes')?}
    {name: 'Do thorough set decoration.', types: notWebDev}
    {name: 'Playtest with a slow/tough hero.', types: ['hero', 'hero-ladder']}
    {name: 'Playtest with a fast/weak hero.', types: ['hero', 'hero-ladder']}
    {name: 'Playtest with a couple random seeds.', types: heroBased}
    {name: 'Remove/simplify unnecessary doodad collision.', types: notWebDev}
    {name: 'Add to a campaign.'}
    {name: 'Choose level options like required/restricted gear.', types: ['hero', 'hero-ladder']}
    {name: 'Create achievements, including unlocking next level.'}
    {name: 'Configure the hero\'s expected equipment.', types: ['hero', 'course', 'course-ladder']}
    {name: 'Configure the API docs.', types: ['web-dev', 'game-dev']}
    {name: 'Write victory text.', complete: (level) -> level.get('victory')?.body}
    {name: 'Write level hints.'}
    {name: 'Set up solutions for the Verifier.'}
    {name: 'Click the Populate i18n button.'}
    {name: 'Add slug to ladder levels that should be simulated, if needed.', types: ladder}
    {name: 'Write the advanced AIs (shaman, brawler, chieftain, etc).', types: ladder}
    {name: 'Add achievements for defeating the advanced AIs.', types: ['hero-ladder']}
    {name: 'Release to adventurers.'}
    {name: 'Release to everyone.'}
    {name: 'Create two sample projects.', types: ['game-dev', 'web-dev']}
  ]
else
  defaultTasks = [
    {name: '--PROTOTYPE--', types: notIntros}
    {name: 'Set level type', }
    {name: 'Create base layout', types: heroBased}
    {name: 'Define Movement system', types: heroBased}
    {name: 'Setup the Hero Placeholder', types: heroBased}
    {name: 'Base instruction through scripts', types: notIntros}
    {name: 'Sample code combined with solution', types: notIntros}
    {name: 'Level is Published', complete: (level) -> level.isPublished()}
    {name: 'Setup main game goals', types: heroBased}
    {name: 'Game and unit logic', types: notIntros}
    {name: 'Set Existence/Random type', types: notIntros}
    {name: 'Set timespan for level and framerate', types: notIntros}
    {name: 'Setup camera (size and bounds)', types: heroBased}
    {name: 'Check the slug'}
    {name: 'Set ozariaType.', types: notIntros}
    {name: 'Playtest prototype to be sure it\'s playable', types: notIntros}

    {name: '--IMPLEMENTATION--', types: notIntros}
    {name: 'Apply Prototype feedback', types: notIntros}
    {name: 'Added Learning Goals', types: heroBased}
    {name: 'Write Display Name'}
    {name: 'Added Intermediate/concept goals', types: heroBased}
    {name: 'Setup the clear sample code', types: heroBased}
    {name: 'Add solution', types: heroBased}
    {name: 'Set draft decorations', types: heroBased}
    {name: 'Set Code Bank', types: heroBased}
    {name: 'Move to components logic that can be moved', types: heroBased}
    {name: 'Playtest functional level to be sure it\'s playable', types: heroBased}

    {name: '--POLISHING--', types: notIntros}
    {name: 'Update Outlines for the level (layout, code, description)', types: notIntros}
    {name: 'Put final art/assets', types: notIntros}
    {name: 'Added Hints through scripts', types: heroBased}
    {name: 'Added Tutorial', types: heroBased}
    {name: 'Check and remove redundant collision and special zones', types: heroBased}
    {name: 'Programming concepts', types: notIntros}
    {name: 'Choose music', types: notIntros}
    {name: 'Clear code from prints/asserts', types: notIntros}
    {name: 'Setup solution verifier', types: notIntros}

    {name: '--AFTERMATH--', types: notIntros}
    {name: 'Playtest as a student', types: notIntros}
    {name: 'Add more tests for verifier', types: heroBased}
    {name: 'Populate i18n'}
  ]



if utils.isCodeCombat
  deprecatedTaskNames = [
    'Add Io/Clojure/Lua/CoffeeScript.'
    'Add Lua/CoffeeScript/Java.'
    'Translate the sample code comments.'
    'Add i18n field for the sample code comments.'
    'Check completion/engagement/problem analytics.'
    'Add a walkthrough video.'
    'Do any custom scripting, if needed.'
    'Write a really awesome description.'
    'Write Lua sample code.'
    'Write Java sample code.'
    'Write C++ sample code.'
    'Write CoffeeScript sample code.'
    'Write Lua solution.'
    'Write Java solution.'
    'Write C++ solution.'
    'Write CoffeeScript solution.'
  ]
else
  deprecatedTaskNames = [
    'Add Io/Clojure/Lua/CoffeeScript.'
    'Add Lua/CoffeeScript/Java.'
    'Translate the sample code comments.'
    'Add i18n field for the sample code comments.'
    'Check completion/engagement/problem analytics.'
    'Add a walkthrough video.'
    'Do any custom scripting, if needed.'
    'Write a really awesome description.'
    'Name the level.'
    'Create a Referee stub, if needed.'
    'Replace "Hero Placeholder" with mcp.'
    'Do basic set decoration.'
    'Publish.'
    'Choose the Existence System lifespan and frame rate.'
    'Choose the UI System paths and coordinate hover if needed.'
    'Choose the AI System pathfinding and Vision System line of sight.'
    'Build the level.'
    'Set up goals.'
    'Add the "win-game" goal.'
    'Write the sample code.'
    'Write the solution.'
    'Make both teams playable and non-defaulted.'
    'Set up goals for both teams.'
    'Fill out the sample code for both Hero Placeholders.'
    'Fill out default AI for both Hero Placeholders.'
    'Make sure the level ends promptly on success and failure.'
    'Adjust script camera bounds.'
    'Choose music file in Introduction script.'
    'Choose autoplay in Introduction script.'
    'Write the description.'
    'Write the guide.'
    'Write intro guide.'
    'Write a loading tip, if needed.'
    'Add programming concepts covered.'
    'Set level kind.'
    'Mark whether it requires a subscription.'
    'Choose leaderboard score types.'
    'Do thorough set decoration.'
    'Playtest with a slow/tough hero.'
    'Playtest with a fast/weak hero.'
    'Playtest with a couple random seeds.'
    'Remove/simplify unnecessary doodad collision.'
    'Add to a campaign.'
    'Choose level options like required/restricted gear.'
    'Create achievements, including unlocking next level.'
    'Configure the hero\'s expected equipment.'
    'Configure the API docs.'
    'Write victory text.'
    'Write level hints.'
    'Set up solutions for the Verifier.'
    'Click the Populate i18n button.'
    'Add slug to ladder levels that should be simulated, if needed.'
    'Write the advanced AIs (shaman, brawler, chieftain, etc).'
    'Add achievements for defeating the advanced AIs.'
    'Release to adventurers.'
    'Release to everyone.'
    'Create two sample projects.'
    'Write Lua sample code.'
    'Write Java sample code.'
    'Write CoffeeScript sample code.'
    'Write Lua solution.'
    'Write Java solution.'
    'Write CoffeeScript solution.'
  ]


if utils.isCodeCombat
  renamedTaskNames = {
    'Release to adventurers.': 'Release to adventurers via MailChimp.'
    'Release to everyone.': 'Release to everyone via MailChimp.'
  }
else
  renamedTaskNames = {}

tasksForLevel = (level) ->
  tasks = []
  inappropriateTasks = {}
  for task in defaultTasks
    if utils.isCodeCombat and task.name is 'Create two sample projects' and level.get('shareable') isnt 'project'
      inappropriateTasks[task.name] = task
    else if task.types and ((level.get('realType') or level.get('type', true)) not in task.types)
      inappropriateTasks[task.name] = task
    else
      tasks.push task
  oldTasks = (level.get('tasks') ? []).slice()
  newTasks = []
  for task in tasks
    oldName = renamedTaskNames[task.name] or task.name
    if oldTask = (_.find(oldTasks, name: oldName) or _.find(oldTasks, name: task.name))
      complete = oldTask.complete or Boolean task.complete?(level)
      _.remove oldTasks, name: oldTask.name
    else
      complete = Boolean task.complete?(level)
      continue if not complete and task.optional
    newTasks.push name: task.name, complete: complete
  for oldTask in oldTasks
    unless oldTask.name in deprecatedTaskNames or inappropriateTasks[oldTask.name]
      newTasks.push oldTask
  newTasks
