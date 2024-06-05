import subprocess
import os


def replace_icon(exe_path, icon_path, output_path, resource_hacker_path):
    """
    使用Resource Hacker替换exe文件中的图标

    :param exe_path: 原始exe文件的路径
    :param icon_path: 新的图标文件的路径
    :param output_path: 保存修改后的exe文件的路径
    :param resource_hacker_path: Resource Hacker可执行文件的路径
    """
    command = [
        resource_hacker_path,
        '-open', exe_path,
        '-save', output_path,
        '-action', 'addoverwrite',
        '-res', icon_path,
        '-mask', 'ICONGROUP,MAINICON,'
    ]
    try:
        subprocess.run(command, check=True)
        print(f"Replaced icon in {exe_path} and saved as {output_path}")
    except subprocess.CalledProcessError as e:
        print(f"Failed to replace icon: {e}")


if __name__ == "__main__":
    # 路径设置
    exe_path = "path_to_your_executable.exe"  # 你的可执行文件路径
    icon_path = "path_to_your_icon.ico"       # 你的图标文件路径
    output_path = "path_to_output_executable.exe"  # 修改后的可执行文件保存路径
    resource_hacker_path = "path_to_ResourceHacker.exe"  # Resource Hacker可执行文件的路径

    # 执行替换
    replace_icon(exe_path, icon_path, output_path, resource_hacker_path)
