<script lang="ts">
	import Input from '$lib/components/utils/Input.svelte';
	import Spinner from '$lib/components/utils/Spinner.svelte';
	import { regiStore, actor } from '$lib/stores/';
	import { syncAuth } from '$lib/stores/auth';
	import { RegiState } from '$lib/stores/types';

	let username: string;
	let pending = false;

	async function register() {
		pending = true;

		const result = await $actor.createUser(username);
		if (result.hasOwnProperty('ok')) {
			await syncAuth();
			regiStore.set(RegiState.Profile);
		} else {
			// catch and show error
			console.error(result);
		}

		pending = false;
	}
</script>

<h2>Choose a username</h2>

<Input text="">
	<input
		class="sub-btn"
		type="text"
		disabled={pending}
		id="username"
		slot="input"
		bind:value={username}
	/>
</Input>

<!-- show error -->

{#if pending}
	<Spinner />
{:else}
	<button on:click={register} class="main-btn"> Register </button>
{/if}
