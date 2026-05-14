# exportz-zowe

`exportz-zowe` is a small wrapper around Endevor TeamBuild `exportz`.
It reads Zowe team configuration and derives the Endevor flags you would
otherwise have to type repeatedly.

```sh
bin/exportz-zowe --dataset-hlq USER1.TEAMBUILD
```

Requirements:

- Bash
- Python 3
- Endevor TeamBuild `exportz` on `PATH`, or pass `--exportz-bin <path>`
- A Zowe team config containing `endevor` and `endevor-location` profiles

Use `--dry-run` to see the command without running `exportz`:

```sh
bin/exportz-zowe --dry-run --dataset-hlq USER1.TEAMBUILD
```

Run the test script directly:

```sh
bash test/exportz-zowe.test.sh
```

Derived from the Zowe `endevor` profile:

- `host`, `port`, `protocol`, and `basePath` become `--base-url`
- `user` becomes `--username`
- `password` becomes `--password`
- `rejectUnauthorized: false` becomes `--insecure`

Derived from the Zowe `endevor-location` profile:

- `environment` becomes `--environment`
- `stageNumber` becomes `--stage-number`
- `system` becomes `--system`
- `subsystem` becomes `--subsystem`
- `instance` becomes `--instance`

The wrapper finds `zowe.config.json` in this order:

1. Use `--config <path>` if provided.
2. Walk up from the current directory and use the first `zowe.config.json` found.
3. Check `${ZOWE_CLI_HOME:-$HOME/.zowe}/zowe.config.json`.

If `--user-config <path>` is provided, that file is merged over the base config.
Otherwise, if `zowe.config.user.json` exists next to the selected config, it is
merged automatically. For credentials stored outside JSON, set `ZOWE_OPT_USER`
and `ZOWE_OPT_PASSWORD`.

`exportz` still needs values that Zowe Endevor profiles do not define, such as
`--dataset-hlq`; pass those through normally.
