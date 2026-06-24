#!/usr/bin/env python3
"""
Gera a Quick Action do Finder "Smart Unzip" (bundle .workflow do Automator).

A Quick Action apenas chama o motor instalado em ~/.local/bin/smart-unzip,
passando os arquivos selecionados como argumentos. Toda a lógica vive no
smart-unzip.sh — aqui só montamos o "atalho" que aparece no botão direito.

Uso:
    python3 build-quick-action.py            # gera ./SmartUnzip.workflow
"""
import os
import plistlib

HERE = os.path.dirname(os.path.abspath(__file__))
BUNDLE = os.path.join(HERE, "SmartUnzip.workflow")
CONTENTS = os.path.join(BUNDLE, "Contents")

# Comando que a Quick Action executa. Com inputMethod = "as arguments",
# os caminhos dos arquivos selecionados chegam em "$@".
COMMAND_STRING = r'''#!/bin/bash
ENGINE="$HOME/.local/bin/smart-unzip"
if [ -x "$ENGINE" ]; then
    exec "$ENGINE" "$@"
fi
osascript -e 'display alert "Smart Unzip" message "O motor nao esta instalado. Rode o install.sh do projeto mac-smart-unzip."' >/dev/null 2>&1
exit 1
'''

INFO_PLIST = {
    "NSServices": [
        {
            "NSBackgroundColorName": "background",
            "NSIconName": "NSActionTemplate",
            "NSMenuItem": {"default": "Smart Unzip (pasta única)"},
            "NSMessage": "runWorkflowAsService",
            "NSRequiredContext": {"NSApplicationIdentifier": "com.apple.finder"},
            # aparece só para .zip
            "NSSendFileTypes": ["public.zip-archive"],
        }
    ]
}

# Estrutura canônica de uma ação "Run Shell Script" do Automator.
RUN_SHELL_ACTION = {
    "action": {
        "AMAccepts": {
            "Container": "List",
            "Optional": True,
            "Types": ["com.apple.cocoa.path"],
        },
        "AMActionVersion": "2.0.3",
        "AMApplication": ["Automator"],
        "AMParameterProperties": {
            "COMMAND_STRING": {},
            "CheckedForUserDefaultShell": {},
            "inputMethod": {},
            "shell": {},
            "source": {},
        },
        "AMProvides": {"Container": "List", "Types": ["com.apple.cocoa.path"]},
        "ActionBundlePath": "/System/Library/Automator/Run Shell Script.action",
        "ActionName": "Run Shell Script",
        "ActionParameters": {
            "COMMAND_STRING": COMMAND_STRING,
            "CheckedForUserDefaultShell": True,
            "inputMethod": 1,  # 1 = "como argumentos" (os arquivos viram "$@")
            "shell": "/bin/bash",
            "source": "",
        },
        "BundleIdentifier": "com.apple.RunShellScript",
        "CFBundleVersion": "2.0.3",
        "CanShowSelectedItemsWhenRun": False,
        "CanShowWhenRun": True,
        "Category": ["AMCategoryUtilities"],
        "Class Name": "RunShellScriptAction",
        "InputUUID": "B1F1A001-0000-4000-A000-000000000001",
        "Keywords": ["Shell", "Script", "Command", "Run", "Unix"],
        "OutputUUID": "B1F1A001-0000-4000-A000-000000000002",
        "UUID": "B1F1A001-0000-4000-A000-000000000003",
        "UnlocalizedApplications": ["Automator"],
        "arguments": {
            "0": {"default value": 0, "name": "inputMethod", "required": "0", "type": "0", "uuid": "0"},
            "1": {"default value": False, "name": "CheckedForUserDefaultShell", "required": "0", "type": "0", "uuid": "1"},
            "2": {"default value": "", "name": "source", "required": "0", "type": "0", "uuid": "2"},
            "3": {"default value": "", "name": "COMMAND_STRING", "required": "0", "type": "0", "uuid": "3"},
            "4": {"default value": "/bin/sh", "name": "shell", "required": "0", "type": "0", "uuid": "4"},
        },
        "isViewVisible": 1,
        "location": "309.000000:253.000000",
        "nibPath": "/System/Library/Automator/Run Shell Script.action/Contents/Resources/main.nib",
    },
    "isViewVisible": 1,
}

DOCUMENT_WFLOW = {
    "AMApplicationBuild": "521",
    "AMApplicationVersion": "2.10",
    "AMDocumentVersion": "2",
    "actions": [RUN_SHELL_ACTION],
    "connectors": {},
    "workflowMetaData": {
        "serviceInputTypeIdentifier": "com.apple.Automator.fileSystemObject",
        "serviceOutputTypeIdentifier": "com.apple.Automator.nothing",
        "serviceProcessesInput": 0,
        "workflowTypeIdentifier": "com.apple.Automator.servicesMenu",
    },
}


def write_plist(path, data):
    with open(path, "wb") as fh:
        plistlib.dump(data, fh)
    print("gerado:", path)


def main():
    os.makedirs(CONTENTS, exist_ok=True)
    write_plist(os.path.join(CONTENTS, "Info.plist"), INFO_PLIST)
    write_plist(os.path.join(CONTENTS, "document.wflow"), DOCUMENT_WFLOW)
    print("Quick Action pronta em:", BUNDLE)


if __name__ == "__main__":
    main()
