// Specific schemas for different types of interactives

const solutionSchema = require('./solutions.schema')
const schema = require('../../../schemas')

const interactiveDraggableOrderingSchema = {
  type: 'object',
  additionalProperties: false,
  title: 'Draggable Ordering interactive data',
  properties: {
    labels: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          text: { type: 'string' },
          textStyleCode: { type: 'boolean', title: 'Text Style Is Code?', default: true },
          i18n: { type: 'object', format: 'i18n', props: ['text'], description: 'Help translate this interactive.' }
        }
      }
    },
    elements: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          text: { type: 'string' },
          textStyleCode: { type: 'boolean', title: 'Text Style Is Code?', default: true },
          elementId: schema.stringID({ readOnly: true }),
          i18n: { type: 'object', format: 'i18n', props: ['text'], description: 'Help translate this interactive.' }
        }
      }
    },
    solution: solutionSchema.elementOrderingSolutionSchema
  }
}

const interactiveInsertCodeSchema = {
  type: 'object',
  additionalProperties: false,
  title: 'Insert Code interactive data',
  properties: {
    starterCode: { type: 'string', format: 'ace' }, // codeLanguage will be determined by unitCodeLanguage in interactives schema
    choices: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          text: { type: 'string' },
          choiceId: schema.stringID({ readOnly: true }),
          triggerArt: { type: 'string', format: 'image-file' }
        }
      }
    },
    lineToReplace: { type: 'number', title: 'Line number to replace' },
    solution: solutionSchema.singleSolutionSchema
  }
}

const interactiveDraggableClassificationSchema = {
  type: 'object',
  additionalProperties: false,
  title: 'Draggable Classification interactive data',
  properties: {
    categories: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          categoryId: schema.stringID({ readOnly: true }),
          text: { type: 'string' },
          i18n: { type: 'object', format: 'i18n', props: ['text'], description: 'Help translate this interactive.' }
        }
      }
    },
    elements: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          text: { type: 'string' },
          elementId: schema.stringID({ readOnly: true }),
          i18n: { type: 'object', format: 'i18n', props: ['text'], description: 'Help translate this interactive.' }
        }
      }
    },
    solution: solutionSchema.classificationSolutionSchema
  }
}

const interactiveMultipleChoiceSchema = {
  type: 'object',
  additionalProperties: false,
  title: 'Multiple Choice interactive data',
  properties: {
    choices: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          text: { type: 'string' },
          choiceId: schema.stringID({ readOnly: true }),
          i18n: { type: 'object', format: 'i18n', props: ['text'], description: 'Help translate this interactive.' }
        }
      }
    },
    solution: solutionSchema.singleSolutionSchema
  }
}

const interactiveFillInCodeSchema = {
  type: 'object',
  additionalProperties: false,
  title: 'Fill-in Code interactive data',
  properties: {
    starterCode: { type: 'string', format: 'ace' }, // codeLanguage will be determined by unitCodeLanguage in interactives schema
    commonResponses: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          text: { type: 'string' },
          responseId: schema.stringID({ readOnly: true }),
          triggerArt: { type: 'string', format: 'image-file' }
        }
      }
    },
    solution: solutionSchema.singleSolutionSchema
  }
}

const interactiveDraggableStatementCompletionSchema = {
  type: 'object',
  additionalProperties: false,
  title: 'Draggable Statement Completion interactive data',
  properties: _.extend({}, interactiveDraggableOrderingSchema.properties)
}

module.exports = {
  interactiveDraggableOrderingSchema,
  interactiveInsertCodeSchema,
  interactiveDraggableClassificationSchema,
  interactiveMultipleChoiceSchema,
  interactiveFillInCodeSchema,
  interactiveDraggableStatementCompletionSchema
}
