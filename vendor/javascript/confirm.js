// confirm@0.1.1 downloaded from https://ga.jspm.io/npm:confirm@0.1.1/lib/confirm.js

import t from"read";import r from"process";var n={};var u=r;(function(){var r,e,o;e=t;o=u.nextTick||u.nextTick;n=r=function(t,n){var u,i,a,l,p,c;p=t.stdin,c=t.stdout,l=t.query,a=t.positive,i=t.negative;u=arguments;return e({input:p,output:c,prompt:l},(function(t,e){return t?n(t):e===a?n(null,true):e===i?n(null,false):o((function(){return r.apply(null,u)}))}))}}).call(n);var e=n;export default e;

