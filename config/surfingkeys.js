/*
Usage: Surfingkeys options => Advanced mode => Load settings from => paste `https://github.com/specv/nix-dotfiles/blob/main/config/surfingkeys.js` => save
*/

const {
  map,
  unmap,
  mapkey,
  vmap,
  vunmap,
  cmap,
  addSearchAlias,
  removeSearchAlias,
} = api;

/* Map */
//// Search
// baidu
removeSearchAlias('b');
// bing
removeSearchAlias('w');
// google
map('<Space>sg', 'og');
unmap('og');
map('<Space>sG', 'sG');
map('<Space>Sg', 'sg');
// duckduckgo
map('<Space>sd', 'od');
unmap('od');
map('<Space>sD', 'sD');
map('<Space>Sd', 'sd');
// wikipedia
map('<Space>sw', 'oe');
unmap('oe');
map('<Space>sW', 'sE');
map('<Space>Sw', 'se');
// github (default mapping `oh` conflict with `Open url from history`)
addSearchAlias('gh', 'github', 'https://github.com/search?q=', 's', 'https://api.github.com/search/repositories?order=desc&q=', function(response) {
    var res = JSON.parse(response.text)['items'];
    return res ? res.map(function(r){
        return {
            title: r.description,
            url: r.html_url
        };
    }) : [];
});
map('<Space>sh', 'ogh');
unmap('ogh');
map('<Space>sH', 'sGH');
map('<Space>Sh', 'sgh');
// stackoverflow
map('<Space>ss', 'os');
unmap('os');
map('<Space>sS', 'sS');
map('<Space>Ss', 'ss');
// youtube
map('<Space>sy', 'oy');
unmap('oy');
map('<Space>sY', 'sY');
map('<Space>Sy', 'sy');

//// Omnibar
map('<Space><Space>', 't');
unmap('t');
// [t]ab
map('<Space>t', 'T');
unmap('T');
// [w]indow
map('<Space>ww', 'W');
unmap('W');
//map('<Space>wa', ';gw');
unmap(';gw');
// [b]ookmark
map('<Space>bb', 'b');
unmap('b');
// [b]ookmark [c]reate 
map('<Space>bc', 'ab');
unmap('ab');
// [b]ookmark [d]elete
map('<Space>bd', ';db');
unmap(';db');
// [h]istory
map('<Space>hh', 'oh');
unmap('oh');
// [h]istory [t]ab
map('<Space>ht', 'H');
unmap('H');
// recently closed
map('<Space>x', 'ox');
unmap('ox');
// vim [m]arks
map('<Space>m', 'om');
unmap('om');

//// Open
map('ou', 'cc');
map('tup', 'cc');
map('oe', ';u');

//// Tab
// go to last used tab
map('<Ctrl-r>', '<Ctrl-6>');
unmap('<Ctrl-6>');
// go one tab left
map(';h', '<Ctrl-h>');
unmap('<Ctrl-h>');
map('<Ctrl-h>', 'E');
unmap('E');
// go one tab right
map('<Ctrl-l>', 'R');
unmap('R');
// go one tab history back
map('<Ctrl-b>', 'B');
unmap('B');
// go one tab history forward
map('<Ctrl-f>', 'F');
unmap('F');
// go back history
map('b', 'S');
map('thb', 'S');
unmap('S');
// go forward history
unmap('B');
map('B', 'D');
map('thf', 'D');
unmap('D');
// go to first history
map('th0', 'gt');
unmap('gt');
// go to last history
map('th$', 'gT');
unmap('gT');
// [o]pen [n]ew tab
map('ton', 'on');
map('ot', 'on');
unmap('on');
// [o]pen tab with selected [u]rl or urls from clipboard
map('tou', 'cc');
unmap('cc');
// [o]pen tab by [e]dit current url
map('toe', ';u');
// [o]pen tab by edit current [u]rl
map('tuo', ';u');
unmap(';u')
// go to the first tab
map('t0', 'g0');
unmap('g0');
// go to the last tab
map('t$', 'g$');
unmap('g$');
// switch [i]frame
map('ti', 'w');
unmap('w');
// switch [s]croll
map('ts', ';fs');
unmap(';fs');
// [e]dit current [u]rl
map('tue', ';U');
unmap(';U');
map('tu.', 'gu');
map('t..', 'gu');
map('g..', 'gu');
unmap('gu');
unmap('gU');
// [r]eplace current [u]rl
map('tur', 'go');
unmap('go');
// duplicate current tab
map('ty', 'yt');
// [c]lear all urls in [q]ueue to be opened
map('tcq', ';cq');
unmap(';cq');
// close all tabs to end
map('tx$', 'gx$');
unmap('gx$');
// close all tabs to begin
map('tx0', 'gx0');
unmap('gx0');
// close tab on [r]ight
map('txr', 'gxT');
unmap('gxT');
// close tab on [l]eft
map('txl', 'gxt');
unmap('gxt');
// close [p]laying tab
map('txp', 'gxp');
unmap('gxp');
// close all tabs except current one
map('txx', 'gxx');
unmap('gxx');

//// Visual
map('v', 'zv');
unmap('zv');

// Translate
vunmap('t');
vunmap('q');

//// Click 
// [c]lick multiple links
map('ca', 'cf');
unmap('cf');
// [f]ollow link in new tab
map('cf', 'f');
map('cF', 'af')
map('a', 'af');
unmap('af');
// [c]lick [i]mages or buttons
map('ci', 'q');
unmap('q');
// [c]lick detected [u]rls
map('cu', 'O');
unmap('O');

// disable toggle omnibar's position
map(';j', '<Ctrl-h>');
unmap('<Ctrl-j>');
// forward in omnibar
cmap('<Ctrl-j>', '<ArrowDown>');
// backward in omnibar
cmap('<Ctrl-k>', '<ArrowUp>');

// restart: unable triggered from extension, use bookmark instead
//mapkey(';r', 'Restart browser', function() {
//  api.tabOpenLink("chrome://restart");
//});


/* Theme */
// Based on Doom One theme. https://github.com/foldex/surfingkeys-config
api.Hints.style('div {border: solid 2px #282C34; color: #98be65; background: initial; background-color: #2E3440;} div.hint-scrollable { border: solid 2px #282C34; padding: 1px; color: #51AFEF; background: #2E3440; }');
api.Hints.style('div { border: solid 2px #282C34; padding: 1px; color: #51AFEF; background: #2E3440; } div.begin { color: #98be65; }', 'text');
api.Visual.style('marks', 'background-color: #98be65;');
api.Visual.style('cursor', 'background-color: #51AFEF;');

settings.theme = `
:root {
  --font: 'CaskaydiaCove Nerd Font', 'Source Code Pro', Ubuntu, sans;
  --font-size: 12;
  --font-weight: bold;
  --fg: #51AFEF;
  --bg: #2E3440;
  --bg-dark: #21242B;
  --border: #2257A0;
  --main-fg: #51AFEF;
  --accent-fg: #98be65;
  --info-fg: #C678DD;
  --select: #4C566A;
}

/* ---------- Generic ---------- */
.sk_theme {
  color: var(--fg);
  background-color: #000;
  border-color: var(--border);
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
}

input {
  font-family: var(--font);
  font-weight: var(--font-weight);
}

.sk_theme tbody {
  color: var(--fg);
}

.sk_theme input {
  color: var(--fg);
}

/* Hints */
#sk_hints .begin {
  color: var(--accent-fg) !important;
}

#sk_tabs .sk_tab:nth-child(odd) {
  background: var(--bg-dark) !important;
}

#sk_tabs .sk_tab:nth-child(even) {
  background: #2E3440 !important;
}

#sk_tabs .sk_tab {
  background: var(--bg-dark);
  border: 0px solid var(--border);
  font-family: var(--font);
  font-size: var(--font-size);
  box-shadow: none !important;
  border-radius: 5px;
  padding: 0.5rem 0.5rem;
}

#sk_tabs .sk_tab_title {
  color: var(--fg);
}

#sk_tabs .sk_tab_url {
  color: var(--main-fg);
}

#sk_tabs .sk_tab_hint {
  background: var(--bg);
  border: 1px solid var(--border);
  color: var(--accent-fg);
}

#sk_tabs .sk_tab_icon {
  width: 16px;
  height: 16px;
  padding-left: 4px;
}

#sk_tabs .sk_tab_icon>img {
  width: 16px;
  height: 16px;
}

.sk_theme #sk_frame {
  background: var(--bg);
  opacity: 0.2;
  color: var(--accent-fg);
}

/* ---------- Omnibar ---------- */
/* Uncomment this and use settings.omnibarPosition = 'bottom' for Pentadactyl/Tridactyl style bottom bar */
/* .sk_theme#sk_omnibar {
  width: 100%;
  left: 0;
} */

.sk_theme .title {
  color: var(--accent-fg);
}

.sk_theme .url {
  color: var(--main-fg);
}

.sk_theme .annotation {
  color: var(--accent-fg);
}

.sk_theme .omnibar_highlight {
  color: var(--accent-fg);
}

.sk_theme .omnibar_timestamp {
  color: var(--info-fg);
}

.sk_theme .omnibar_visitcount {
  color: var(--accent-fg);
}

.sk_theme #sk_omnibarSearchResult ul li {
  border-radius: 5px;
  padding: 0.8rem 0.8rem;
  margin: 1px;
}

.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: var(--bg-dark);
}

.sk_theme #sk_omnibarSearchResult ul li:nth-child(even) {
  background: #2E3440;
}

.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: var(--border);
}

.sk_theme #sk_omnibarSearchArea {
  border: none;
}

.sk_theme #sk_omnibarSearchArea input,
.sk_theme #sk_omnibarSearchArea span {
  font-size: var(--font-size);
}

.sk_theme .separator {
  color: var(--accent-fg);
}

.sk_omnibar_middle #sk_omnibarSearchArea {
  margin: 1rem 1rem;
}

#sk_omnibar #sk_omnibarSearchResult {
  margin: 0;
}

.sk_omnibar_middle #sk_omnibarSearchResult>ul {
  margin: 0;
}

#sk_omnibar #sk_omnibarSearchResult .icon {
  width: 20px;
  height: 20px;
}

/* ---------- Popup Notification Banner ---------- */
#sk_banner {
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
  background: var(--bg);
  border-color: var(--border);
  color: var(--fg);
  opacity: 0.9;
}

/* ---------- Popup Keys ---------- */
#sk_keystroke {
  background-color: var(--bg);
}

.sk_theme kbd .candidates {
  color: var(--info-fg);
}

.sk_theme span.annotation {
  color: var(--accent-fg);
}

/* ---------- Popup Translation Bubble ---------- */
#sk_bubble {
  background-color: var(--bg) !important;
  color: var(--fg) !important;
  border-color: var(--border) !important;
}

#sk_bubble * {
  color: var(--fg) !important;
}

#sk_bubble div.sk_arrow div:nth-of-type(1) {
  border-top-color: var(--border) !important;
  border-bottom-color: var(--border) !important;
}

#sk_bubble div.sk_arrow div:nth-of-type(2) {
  border-top-color: var(--bg) !important;
  border-bottom-color: var(--bg) !important;
}

/* ---------- Search ---------- */
#sk_status,
#sk_find {
  font-size: var(--font-size);
  border-color: var(--border);
}

.sk_theme kbd {
  background: var(--bg-dark);
  border-color: var(--border);
  box-shadow: none;
  color: var(--fg);
}

.sk_theme .feature_name span {
  color: var(--main-fg);
}

/* ---------- ACE Editor ---------- */
#sk_editor {
  background: var(--bg-dark) !important;
  height: 50% !important;
  /* Remove this to restore the default editor size */
}

.ace_dialog-bottom {
  border-top: 1px solid var(--bg) !important;
}

.ace-chrome .ace_print-margin,
.ace_gutter,
.ace_gutter-cell,
.ace_dialog {
  background: var(--bg) !important;
}

.ace-chrome {
  color: var(--fg) !important;
}

.ace_gutter,
.ace_dialog {
  color: var(--fg) !important;
}

.ace_cursor {
  color: var(--fg) !important;
}

.normal-mode .ace_cursor {
  background-color: var(--fg) !important;
  border: var(--fg) !important;
  opacity: 0.7 !important;
}

.ace_marker-layer .ace_selection {
  background: var(--select) !important;
}

.ace_editor,
.ace_dialog span,
.ace_dialog input {
  font-family: var(--font);
  font-size: 14px !important;
  font-weight: var(--font-weight);
}
`;
