# ICS2025 Programming Assignment

This project is the programming assignment of the ICS (Introduction to Computer Systems) course in the Department of Computer Science and Technology, Nanjing University.

For the guide of this programming assignment, refer to the official documentation:
[ICS2025 Programming Assignment Guide](https://nju-projectn.github.io/ics-pa-gitbook/ics2025/)

---

## Subprojects / Components

This repository includes the following subprojects. Some of them may not be fully implemented:

* [NEMU](https://github.com/NJU-ProjectN/nemu)
* [Abstract-Machine](https://github.com/NJU-ProjectN/abstract-machine)
* [Nanos-lite](https://github.com/NJU-ProjectN/nanos-lite)
* [Navy-apps](https://github.com/NJU-ProjectN/navy-apps)
* [AM Kernels](https://github.com/NJU-ProjectN/am-kernels)

---

## Initialization

This project now uses **git submodules** and a **justfile** to manage subprojects and environment variables.

1. **Initialize all submodules:**

```bash
just init_all
```

1. **Load environment variables for the current shell**

Add the following to your shell startup file (`~/.bashrc` / `~/.zshrc`) to automatically load project environment variables:

```bash
# ICS2025 environment variables
just load_env PROJECT_DIR="$HOME/path/to/project"
```

> This ensures that environment variables like `NEMU_HOME`, `AM_HOME`, etc., are always available in your shell without changing your current working directory.

1. **Initialize a single submodule (optional):**

```bash
just init_nemu       # or init_am, init_navy, init_nanos, init_amk
```

> Environment variables for single submodules are also handled automatically via the `.bashrc` snippet above.

---

## Notes

* The `init.sh` script has been replaced by the **justfile** for better maintainability and submodule management.
* Forking or using your own repository URLs can be configured by updating the `base_url` in the justfile.
* Make sure `git` and `just` are installed before running the initialization commands.
