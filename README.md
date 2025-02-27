# app-secure-lock

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**app-secure-lock** 是一个基于 Theos 开发的通用应用锁工具，适用于 TrollStore 环境。它通过将动态库（dylib）注入到目标应用中，使用当前日期作为密码来锁定应用。例如，如果今天是 2025 年 2 月 26 日，密码就是 `250226`。

## 功能特性

- **动态库注入**：以 dylib 形式注入到目标应用中，无需修改应用原始代码。
- **时间密码**：使用当前日期作为动态密码，格式为 `YYMMDD`。
- **TrollStore 兼容**：专为 TrollStore 环境设计，支持未签名应用。
- **轻量高效**：代码简洁，资源占用低。

## 使用场景

- 保护敏感应用，防止他人随意访问。
- 临时锁定应用，基于时间动态生成密码。
- 学习和研究 iOS 动态库注入技术。

## 安装与使用

### 前提条件

- 已安装 [Theos](https://theos.dev/) 开发环境。
- 设备已安装 TrollStore。
- 目标应用支持 dylib 注入。

### 安装步骤

1. 克隆本仓库：
   ```bash
   git clone https://github.com/jiangdequan/app-secure-lock.git
   cd app-secure-lock
   ```
2. 编译项目：
   ```bash
   // dylib
   make clean && make
   // deb
   make clean && make package
   ```
3. 将生成的 .dylib 文件注入到目标应用中（具体注入方法请参考 TrollStore 文档）。

### 使用方法
1. 启动目标应用时，会弹出密码输入框。
2. 输入当前日期的密码，格式为 YYMMDD。例如，今天是 2025 年 2 月 26 日，则输入 250226。
3. 密码正确即可解锁应用。

## 实际运行效果
### 主界面
![主界面截图](screenshots/main-interface.png)

### 密码输入
![密码输入界面](screenshots/password-input.png)

### 解锁失败
![解锁失败界面](screenshots/unlock-failed.png)

## 代码结构
```
app-secure-lock/
├── Makefile              # Theos 编译配置
├── Tweak.xm              # 主要逻辑代码
├── control               # 包信息
├── LICENSE               # 开源协议
└── README.md             # 项目说明
```

## 贡献指南
欢迎提交 Issue 和 Pull Request！请确保代码风格一致，并附上详细的描述。

## 许可证
本项目基于 [MIT 许可证](https://mit-license.org/) 开源。

## 参考
* [Theos 官方文档](https://theos.dev/)
* [TrollStore 使用指南](https://github.com/opa334/TrollStore)
* [阮一峰的 README 风格指南](https://www.ruanyifeng.com/blog/2016/10/style_guide_for_technical_writing.html)