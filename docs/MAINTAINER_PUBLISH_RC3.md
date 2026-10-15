# Maintainer: publish v1.3.8 RC3 Beta 1

The maintainer approved **MIT licensing** for the project's first-party miner
and distribution under a limited public beta. The miner executable is supplied
as a GitHub Release **asset**, not as a Git-tracked source file.

## 1. Obtain the verified archive

Go to the [PRIVATE engineering action](https://github.com/Larppak/nightfall-miner/actions/runs/38763893508)
in the private development repository, while signed into the owner's GitHub.

Download the artifact named:
`nightfall-miner-v1.3.8-rc3-beta.1-MIT-READY-FOR-UPLOAD`.

Extract the downloaded ZIP in a trusted local folder. It contains exactly
the beta's miner tarball, companion SHA-256 file and internal audit reports.
**Only upload the two Release assets below**; never upload audit JSON, Git
sources or private development materials.

```text
nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz
nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz.sha256
```

SHA-256 of the actual **miner .tar.gz**:

`6b94518283bd777518f0968745c509f94d16e8c46b0f01c02b4b152d55cb991f`

Verify locally:

```bash
sha256sum -c nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz.sha256
```

The GitHub Actions **outer ZIP** has its own unrelated checksum; do not
confuse its digest with the distributed miner tarball.

The artifact expires on **2026-10-29**. If it has expired, rerun the
private builder workflow in the private development repository; never
substitute an older `PRIVATE-UNAPPROVED` EULA draft or RC3 preview.

## 2. Check the destination repo is safe

`Larppak/Nightfall-GPU-Miner` is the **clean distribution repository**.

Check that only README/docs, MIT LICENSE, .gitignore and the dashboard
image exist in its Git history; no `.cu`, fee source, protected implementation,
credentials, test material or `.tar.gz` should be committed.

Do **not** change visibility of `Larppak/nightfall-miner` (development).

## 3. GitHub UI — create the limited public beta

1. Open https://github.com/Larppak/Nightfall-GPU-Miner
2. In **Settings → General → Danger Zone**, change *this clean repo* to
   **Public** (requires owner approval/confirmation).
3. In **Releases → Draft a new release**, choose a new tag
   `v1.3.8-rc3-beta.1`, targeting `main`.
4. Title: `Nightfall GPU Miner v1.3.8 RC3 Beta 1`.
5. Paste the prepared text from
   [release notes](RELEASE_NOTES_RC3_BETA.md).
6. Upload the exact `.tar.gz` and `.sha256` files listed above.
7. Check **Set as a pre-release** (not stable).
8. Publish the Release.

Never upload the 141 internal miner files individually or commit the archive
into Git history. Do not include the private audit / proprietary EULA drafts.

## 4. Verify release as an unauthenticated user

After publication, check both Release asset downloads:

```bash
ASSET=nightfall-miner-v1.3.8-rc3-beta.1-linux-x86_64.tar.gz
BASE=https://github.com/Larppak/Nightfall-GPU-Miner/releases/download/v1.3.8-rc3-beta.1
curl -fL --retry 3 -o "$ASSET" "$BASE/$ASSET"
curl -fL --retry 3 -o "$ASSET.sha256" "$BASE/$ASSET.sha256"
sha256sum -c "$ASSET.sha256"
```

The checksum must say `OK` and match the exact SHA-256 above.
Check the release's OS requirements, MIT rights, 4.5% GPU / 0% CPU fee
disclosure and untested hardware caveats are visible.

No third-party uploads or cloud data services are required.
