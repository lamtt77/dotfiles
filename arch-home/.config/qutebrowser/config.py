# ui
config.source("gruvbox.py")
c.colors.webpage.prefers_color_scheme_dark = True
c.completion.shrink = True
c.completion.use_best_match = True
c.statusbar.widgets = ["progress", "keypress", "url", "history"]
# LamT
#c.scrolling.bar = "always"
#c.tabs.position = "left"
#c.tabs.width = "15%"
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"

# general
c.auto_save.session = True
c.content.default_encoding = "utf-8"
c.content.javascript.can_access_clipboard = True
c.content.notifications = True  # notifications aren't supported now anyway
c.content.pdfjs = True
# LamT: sorry, `vim` still rule!
#c.editor.command = ["kitty", "kak", "-e", "exec {line}g{column0}l", "{file}"]
c.downloads.location.prompt = False
c.input.insert_mode.auto_load = True
c.spellcheck.languages = ["en-US"]
c.tabs.background = True
c.tabs.mousewheel_switching = False
c.tabs.last_close = "close"
# LamT: only enable gpu for `real` hardware acceleration
#c.qt.args += ["enable-gpu-rasterization", "enable-features=WebRTCPipeWireCapturer"]
c.qt.args += ["enable-features=WebRTCPipeWireCapturer"]

# per-domain settings
config.set("content.register_protocol_handler", True, "*://calendar.google.com")

config.set("content.media.audio_video_capture", True, "*://app.wire.com")
config.set("content.media.audio_capture", True, "*://app.wire.com")
config.set("content.media.video_capture", True, "*://app.wire.com")
config.set("content.desktop_capture", True, "*://app.wire.com")

config.set("content.register_protocol_handler", True, "*://teams.microsoft.com")
config.set("content.media.audio_video_capture", True, "*://teams.microsoft.com")
config.set("content.media.audio_capture", True, "*://teams.microsoft.com")
config.set("content.media.video_capture", True, "*://teams.microsoft.com")
config.set("content.desktop_capture", True, "*://teams.microsoft.com")
config.set("content.cookies.accept", "all", "*://teams.microsoft.com")

config.set("content.register_protocol_handler", True, "*://app.slack.com")
config.set("content.media.audio_video_capture", True, "*://app.slack.com")
config.set("content.media.audio_capture", True, "*://app.slack.com")
config.set("content.media.video_capture", True, "*://app.slack.com")
config.set("content.desktop_capture", True, "*://app.slack.com")

# privacy
c.content.cookies.accept = "no-3rdparty"
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.site_specific_quirks = False
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36"

# urls
c.url.searchengines = {
    "DEFAULT": "https://google.com/search?q={}",
    "?": "https://google.com/search?q={}",
}
c.url.default_page = "~/.config/qutebrowser/blank.html"
c.url.start_pages = ["~/.config/qutebrowser/blank.html"]

# keys
bindings = {
    ",m": "spawn --userscript view_in_mpv",
    ",M": "hint links spawn mpv {hint-url}",
    ",p": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p credentials'",
    ",P": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p password' --password-only",
    ",b": "config-cycle colors.webpage.bg '#32302f' 'white'",
    "<Ctrl-Shift-J>": "tab-move +",
    "<Ctrl-Shift-K>": "tab-move -",
    "M": "nop",
    "co": "nop",
    # LamT: I get used to `vimium` bindings, which make senses for scrolling
    "d": "scroll-page 0 0.5",
    "u": "scroll-page 0 -0.5",
    "x": "tab-close",
    "X": "undo",
    # LamT: mapping from xo and xO, tab-close uses much more than set-cmd-text
    "zO": "set-cmd-text :open -b -r {url:pretty}",
    "zo": "set-cmd-text -s :open -b",
}

for key, bind in bindings.items():
    config.bind(key, bind)
