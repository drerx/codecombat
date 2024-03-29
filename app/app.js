global.$ = window.$ = global.jQuery = window.jQuery = require('jquery');
import 'bootstrap';
import './app.sass';
import 'core-js/stable';
import 'regenerator-runtime/runtime';

/**
 * Fonts dynamically imported based on infra location
 */
if (window.features && window.features.chinaUx) {
  import(/* webpackChunkName: "ChinaFont" */ 'app/styles/common/fontChina.sass');
} else {
  import(/* webpackChunkName: "UsFont" */ 'app/styles/common/fontUS.sass');
}

require('app/vendor.js'); // can be loaded separately and cached for a longer time

// require.context('app/schemas', true, /.*\.(coffee|jade)/)
// require.context('app/models', true, /.*\.(coffee|jade)/)
// require.context('app/collections', true, /.*\.(coffee|jade)/)
// require.context('app/core', true, /.*\.(coffee|jade)/)
// require.context('app/views/core', true, /.*\.(coffee|jade)/)

require('core/initialize');
