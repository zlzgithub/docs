# 文件说明

```sh
docs # 仓库根目录
├── book.json    # gitbook配置
├── deploy       # 部署脚本
├── Dockerfile
├── docs/        # 文档目录
│   │ 
│   ├── assets/              # 图片目录
│   ├── log-analysis/        # 日志分析
│   ├── cicd/                # 持续集成
│   ├── deployment/          # 应用部署
│   ├── xxl-job/             # 任务调度
│   ├── config-management/   # 配置管理
│   ├── monitoring/          # 运维监控
│   ├── HELP.md
│   ├── my-gitbook.md
│   └── README.md            # 文件说明
│
├── README.md    # 首页
├── styles/      # css
└── SUMMARY.md   # 目录
```

示例book.json


```json
{
    "title": "DevOps Pages",
    "author": "Zeng",
    "description": "运维笔记",
    "output.name": "site",
    "language": "zh-hans",
    "gitbook": "3.2.3",
    "root": ".",
    "styles": {
        "website": "/styles/website.css"
    },
    "plugins": [
        "-lunr",
        "-search",
        "-highlight",
        "-livereload",
        "-sharing",
        "search-plus",
        "simple-page-toc",
        "editlink",
        "splitter",
        "tbfed-pagefooter",
        "chapter-fold",
        "sectionx",
        "anchor-navigation-ex",
        "code",
        "todo",
		"insert-logo",
        "pageview-count",
        "hide-element",
        "fancybox",
        "versions-select"
    ],
    "pluginsConfig": {
        "theme-default": {
            "showLevel": false
        },
        "tbfed-pagefooter": {
            "copyright": "Copyright © Zeng 2019",
            "modify_label": "Modified @",
            "modify_format": "YYYY-MM-DD HH:mm:ss"
        },
        "simple-page-toc": {
            "maxDepth": 3,
            "skipFirstH1": true
        },
        "editlink": {
            "base": "https://github.com/<your_github_repo_url>/",
            "label": "编辑本页"
        },
        "hide-element": {
            "elements": [".gitbook-link", ".treeview__container-title"]
        },
        "anchor-navigation-ex": {
            "showLevel": false,
            "associatedWithSummary": true,
            "printLog": false,
            "multipleH1": true,
            "mode": "float",
            "showGoTop": true,
            "float": {
                "floatIcon": "fa fa-navicon",
                "showLevelIcon": false,
                "level1Icon": "fa fa-hand-o-right",
                "level2Icon": "fa fa-hand-o-right",
                "level3Icon": "fa fa-hand-o-right"
            }
        },
        "sectionx": {
            "tag": "b"
        },
		"insert-logo": {
            "url": "/docs/styles/logo.png",
            "style": "background: none; max-height: 60px; min-height: 60px"
        },
        "versions": {
            "options": [
                {
                    "value": "https://<your page url>",
                    "text": "latest"
                }
            ]
        }
    }
}
```
