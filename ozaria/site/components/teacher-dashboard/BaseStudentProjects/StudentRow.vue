<script>
import ProgressDot from '../common/progress/progressDot'
import CapstoneCodeComponent from '../common/CapstoneCodeComponent'
export default {
  components: {
    'progress-dot': ProgressDot,
    'capstone-code-component': CapstoneCodeComponent
  },
  props: {
    studentName: {
      type: String,
      default: '',
      required: true
    },
    status: {
      type: String,
      default: '',
      required: true
    },
    code: {
      type: String,
      default: ''
    },
    language: {
      type: String,
      default: ''
    },
    projectUrl: {
      type: String,
      default: ''
    },
    goals: {
      type: Array,
      default: () => []
    },
    trackCategory: {
      type: String,
      default: ''
    }
  },
  data: () => {
    return {
      codeContainerVisible: false
    }
  },
  computed: {
    arrowDirection () {
      if (this.codeContainerVisible) {
        return { 'arrow-up': true }
      } else {
        return { 'arrow-down': true }
      }
    },
    inactiveAccordion () {
      return !this.status || this.status.length === 0
    },
    viewProjectIconName () {
      if (this.inactiveAccordion) {
        return 'IconViewProject_Gray'
      } else {
        return 'IconViewProject_Blue'
      }
    }
  },
  methods: {
    clickArrow () {
      if (!this.inactiveAccordion) {
        this.codeContainerVisible = !this.codeContainerVisible
        if (this.codeContainerVisible) {
          window.tracker?.trackEvent('Student Projects: View Student Code Arrow Opened', { category: this.trackCategory || 'Teachers' })
        }
      }
    },
    openProjectUrl () {
      if (!this.inactiveAccordion && this.projectUrl) {
        window.tracker?.trackEvent('Student Projects: View Project Clicked', { category: this.trackCategory || 'Teachers' })
        window.open(this.projectUrl, '_blank')
      }
    }
  }
}
</script>

<template>
  <div class="student-row">
    <div class="student-details margin-top">
      <div class="student-sub-div">
        <progress-dot
          v-if="status"
          :status="status"
        />
        <progress-dot v-else />
        <span class="margin-left"> {{ studentName }} </span>
      </div>
      <div class="student-sub-div">
        <div
          class="view-project"
          :class="{'inactive': inactiveAccordion}"
          @click="openProjectUrl"
        >
          <img
            class="project-icon"
            :src="'/images/ozaria/teachers/dashboard/svg_icons/'+viewProjectIconName+'.svg'"
          >
          <span class="bottom-align view-project-text"> {{ $t('courses.view_project') }} </span>
        </div>
        <div
          v-tooltip.top="{
            content: `See Student Code`,
            classes: 'dark-teacher-dashboard'
          }"
          class="arrow-toggle"
          :class="{'inactive': inactiveAccordion}"
          @click="clickArrow"
        >
          <div
            class="arrow-icon"
            :class="arrowDirection"
          />
        </div>
      </div>
    </div>
    <div
      v-if="!inactiveAccordion"
      v-show="codeContainerVisible"
      class="session-details"
    >
      <capstone-code-component
        :game-goals="goals"
        :capstone-session-code="code"
        :capstone-session-language="language"
      />
    </div>
  </div>
</template>

<style lang="scss" scoped>
@import "app/styles/bootstrap/variables";
@import "ozaria/site/styles/common/variables.scss";
@import "app/styles/ozaria/_ozaria-style-params.scss";

.student-details {
  background: #FFFFFF;
  border: 0.5px solid #D8D8D8;
  box-shadow: -1px 0px 1px rgba(0, 0, 0, 0.06), 3px 0px 8px rgba(0, 0, 0, 0.15);
  height: 50px;
  padding-left: 5px;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  @include font-p-3-small-button-text-black;
  font-weight: normal;
}

.session-details {
  background: #FFFFFF;
  border: 0.5px solid #E6E6E6;
  box-shadow: -1px 0px 1px rgba(0, 0, 0, 0.06), 3px 0px 8px rgba(0, 0, 0, 0.15);
  padding: 15px;
  display: inline-block;
  width: 100%;
  @include font-p-4-paragraph-smallest-gray;
}

.student-sub-div {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  text-transform: capitalize;
}

.view-project {
  cursor: pointer;
  color: $twilight;
  margin-right: 20px;
}

.view-project.inactive {
  cursor: default;
  color: #ADADAD;
}

.view-project-text {
  margin-left: -10px;
}

.arrow-toggle {
  width: 60px;
  height: 50px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  &:not(.inactive) {
    cursor: pointer;
    box-shadow: -1px 0px 1px rgba(0, 0, 0, 0.06), 3px 0px 8px rgba(0, 0, 0, 0.15);
    &:hover {
      background: #FFFFFF;
      border: 0.5px solid #D8D8D8;
      box-shadow: inset 0px 5px 10px rgba(0, 0, 0, 0.15);
    }
    .arrow-icon {
      border: 3px solid $twilight;
      border-bottom: unset;
      border-right: unset;
    }
  }
}

.arrow-icon {
  border: 3px solid #ADADAD;
  box-sizing: border-box;
  border-bottom: unset;
  border-right: unset;
  width: 12px;
  height: 12px;
}

.arrow-up {
  transform: rotate(45deg);
}

.arrow-down {
  transform: rotate(225deg);
}

.margin-right {
  margin-right: 10px;
}

.margin-top {
  margin-top: 10px;
}

.margin-left {
  margin-left: 5px;
}

.bottom-align {
  vertical-align: bottom;
}
</style>
