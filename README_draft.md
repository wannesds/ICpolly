# sveltekit-create-ic-auth

SvelteKit framework setup for building on the IC with auth implemented and showcased.

TEMP:

- TODO: FOR LOCAL DEV FIX II PLUGIN AS DEFAULT (option for locally II can install)
- TODO: EXPLAIN FLOW IN AUTH AND CONFIG
- TODO: ADD RUNSCRIPTS + FIX DFX CMDS
- TODO: REMOVE ANY NNS INFO IN README, JUST NEED II FOR DEV

setup with:

- svelte/adapter-static
- vite
- tailwind
- dfinity IC agents
- II Authentication setup

To modify auth/client setup check lib/stores/tasks/auth.ts and `vite.config.ts

Currently needs II canister locally to test locally auths.
complete nns install provides II see step 2. (makes use of local test identities)
(beware: this also deployes nns and other canisters, install II only for just II-can)

Currently uses dfx deploy only (build, generate not propperly implemented yet)

(TODO updATE) Requires Node v18, DFX v0.13.1 , Motoko v0.8.5+ see [mocv](https://forum.dfinity.org/t/moc-version-management/19011)

1. `dfx start --clean --background`
2. `dfx nns install`
3. `TODO command setup`
4. `npm install`
5. `dfx deploy`
6. `npm run dev`
