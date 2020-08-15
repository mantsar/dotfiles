config.load_autoconfig()

# General options
c.downloads.location.directory = "~/Downloads"
c.tabs.close_mouse_button = 'right'
c.scrolling.smooth = True
c.editor.command = ['termite', '-e', 'nvim', '{file}', '-c', 'normal {line}G{column0}l']

# Bindings
config.bind('<Alt-e>', 'open-editor', mode='insert')
config.bind('<Alt-e>', 'open-editor', mode='normal')
config.bind('f', 'hint all current')
config.bind('pp', 'open --tab {clipboard}')
config.bind('pP', 'open {clipboard}')
config.bind('PP', 'open {primary}')
config.bind('Pp', 'open --tab {primary}')
config.bind('o', 'set-cmd-text -s :open -t')
config.bind('O', 'set-cmd-text -s :open')
# links
config.bind(',F', 'follow-selected')
config.bind(',f', 'follow-selected -t')
config.bind(',p', 'spawn --userscript qute-pass')
# tabs
config.bind('gp', 'tab-pin')
config.bind('tm', 'tab-only')
config.bind('ty', 'tab-clone')
config.bind('x', 'tab-close')
config.bind('K', 'tab-next')
config.bind('J', 'tab-prev')
config.bind('gh', 'tab-move -')
config.bind('gl', 'tab-move +')
config.bind('X', 'undo')
config.bind('<Alt-Tab>', 'tab-focus last')
# Moving
config.bind('j', 'scroll-page 0 0.055')
config.bind('k', 'scroll-page 0 -0.055')
config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')
# Readline bindings in insert mode
config.bind('<Ctrl-e>', 'fake-key <end>', mode='insert')
config.bind('<Ctrl-a>', 'fake-key <home>', mode='insert')
config.bind('<Ctrl-h>', 'fake-key <Backspace>', mode='insert')
config.bind('<Ctrl-d>', 'fake-key <delete>', mode='insert')
config.bind('<Ctrl-f>', 'fake-key <right>', mode='insert')
config.bind('<Ctrl-b>', 'fake-key <left>', mode='insert')
config.bind('<Ctrl-u>', 'fake-key <shift+home> ;; fake-key <delete>', mode='insert')
config.bind('<Ctrl-k>', 'fake-key <shift+end> ;; fake-key <delete>', mode='insert')
config.bind('<Ctrl-w>', 'fake-key <Ctrl+backspace>', mode='insert')
config.bind('<Alt-f>', 'fake-key <Ctrl+right>', mode='insert')
config.bind('<Alt-b>', 'fake-key <Ctrl+left>', mode='insert')
# config.bind('<Ctrl-->', 'fake-key <Ctrl+z>', mode='insert')
config.bind('<Ctrl-m>', 'fake-key <Enter>', mode='insert')
# Saving
config.bind('sc', 'config-source')
config.bind('sb', 'quickmark-save')
# Bookmarks/quickmarks
config.bind('b', 'set-cmd-text -s :quickmark-load -t')
config.bind('B', 'set-cmd-text -s :quickmark-load')
# mpv (requires umpv script) https://github.com/mpv-player/mpv/blob/master/TOOLS/umpv
config.bind(',m', 'spawn umpv {url}')
config.bind(',M', 'hint links spawn umpv {hint-url}')
config.bind(';M', 'hint --rapid links spawn umpv {hint-url}')

config.bind(",a", "spawn --userscript youtubedl_mp3")
config.bind(",A", "hint links userscript youtubedl_mp3")

# UI
c.tabs.padding = {'top': 2, 'bottom': 2, 'left': 5, 'right': 5}
c.tabs.favicons.scale = 1.2
c.tabs.indicator.padding = {'top': 2, 'bottom': 2, 'left': 0, 'right': 4}
c.fonts.default_family = ["Ubuntu Mono"]
c.fonts.default_size = "12pt"
# c.fonts.tabs = 'bold 12pt UbuntuMono'
# c.fonts.tabs.selected = 'bold 12pt UbuntuMono'
# c.fonts.completion.category = 'bold 12pt UbuntuMono'
# c.fonts.completion.entry = '12pt UbuntuMono'
# c.fonts.debug_console = '12pt UbuntuMono'
# c.fonts.downloads = '12pt UbuntuMono'
# c.fonts.hints = 'bold 12pt UbuntuMono'
# c.fonts.keyhint = '12pt UbuntuMono'
# c.fonts.messages.error = '12pt UbuntuMono'
# c.fonts.messages.info = '12pt UbuntuMono'
# c.fonts.messages.warning = '12pt UbuntuMono'
# c.fonts.prompts = '12pt UbuntuMono'
# c.fonts.statusbar = '12pt UbuntuMono'
# c.fonts.tabs.selected = '12pt UbuntuMono'
# c.fonts.tabs.unselected = '12pt UbuntuMono'

#searchengines
c.url.searchengines = {
        'DEFAULT': 'https://duckduckgo.com/?q={}',
        '!': 'https://duckduckgo.com/bang?q={}',
        'g': 'https://www.google.com/search?q={}',
        'e': 'https://www.ecosia.org/search?q={}',
        'a': 'https://duckduckgo.com/?q=!a {}',
        'eb': 'https://ebay.com/sch/{}',
        'ap': 'https://duckduckgo.com/?q=!apck {}',
        'wa': 'https://duckduckgo.com/?q=!aw {}',
        'wg': 'https://wiki.gentoo.org/index.php?title=Special%3ASearch&search={}',
        'wv': 'https://wiki.voidlinux.eu/index.php?search={}&title=Special%3ASearch',
        'aur': 'https://duckduckgo.com/?q=!aur {}',
        'y': 'https://www.youtube.com/results?search_query={}',
        'yy': 'invidio.us/search?q={}',
        'w': 'https://www.wikipedia.org/search-redirect.php?family=wikipedia&language=en&search={}&language=en&go=Go',
        'wt': 'http://en.wiktionary.org/?search={}',
        'ud': 'https://www.urbandictionary.com/define.php?term={}',
        'r': 'https://old.reddit.com/search?q={}',
        'vim': 'https://old.reddit.com/r/vim/search?q={}&restrict_sr=on',
        'nvim': 'https://old.reddit.com/r/neovim/search?q={}&restrict_sr=on',
        'wvim': 'http://vim.wikia.com/wiki/Special:Search?fulltext=Search&query={}',
        'osm': 'http://www.openstreetmap.org/search?query={}',
        'lib': 'http://gen.lib.rus.ec/search.php?req={}',
        's': 'https://stackoverflow.com/search?q={}',
        'sr': 'https://stackoverflow.com/search?tab=relevance&q=[r] {}',
        'git': 'https://github.com/search?q={}',
        'tw': 'https://www.twitch.tv/search?term={}'
        }
