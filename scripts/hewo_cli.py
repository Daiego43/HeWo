#!/usr/bin/env python3

import argparse
import subprocess
import yaml
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
MODULES_DIR = PROJECT_ROOT / "modules"

def build(modules):
    if "all" in modules:
        modules = [m.name for m in MODULES_DIR.iterdir()
                   if (m / "Dockerfile").exists()]

    for module in modules:
        path = MODULES_DIR / module
        dockerfile = path / "Dockerfile"
        if dockerfile.exists():
            tag = f"hewo_{module}:latest"
            print(f"Building {module} → {tag}")
            subprocess.run(["docker", "build", "-t", tag, str(path)], check=True)
        else:
            print(f"Module '{module}' has no Dockerfile, skipping.")

def deploy(modules, run_after=True):
    services = []
    for module in modules:
        service_file = MODULES_DIR / module / "docker_service.yaml"
        if service_file.exists():
            with open(service_file) as f:
                services.append(yaml.safe_load(f))
        else:
            print(f"No docker_service.yaml in '{module}', skipping.")

    full_compose = {
        "services": {}
    }
    for s in services:
        full_compose["services"].update(s)

    deploy_path = Path.cwd() / "hewo_deploy.yaml"
    with open(deploy_path, "w") as f:
        yaml.dump(full_compose, f, sort_keys=False)

    print(f"Generated deploy file with: {', '.join(modules)}")
    if run_after:
        subprocess.run(["docker", "compose", "-f", str(deploy_path), "up", "--force-recreate"], check=True)

def stop():
    deploy_path = Path.cwd() / "hewo_deploy.yaml"
    subprocess.run(["docker", "compose", "-f", str(deploy_path), "down", "--volumes", "--remove-orphans"], check=True)

def run(module):
    print(f"Running {module} with deploy logic")
    deploy([module])

def main():
    parser = argparse.ArgumentParser(description="HeWo CLI Tool")
    subparsers = parser.add_subparsers(dest="command")

    parser_build = subparsers.add_parser("build")
    parser_build.add_argument("modules", nargs="+")

    parser_run = subparsers.add_parser("run")
    parser_run.add_argument("module")

    parser_deploy = subparsers.add_parser("deploy")
    parser_deploy.add_argument("modules", nargs="+")

    parser_stop = subparsers.add_parser("stop")

    args = parser.parse_args()

    if args.command == "build":
        build(args.modules)
    elif args.command == "run":
        run(args.module)
    elif args.command == "deploy":
        deploy(args.modules)
    elif args.command == "stop":
        stop()
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
