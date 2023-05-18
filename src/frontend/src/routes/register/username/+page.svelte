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

<Input text="Username">
	<input
		class="sub-btn rounded-md"
		type="text"
		disabled={pending}
		id="username"
		slot="input"
		bind:value={username}
	/>
</Input>

<!-- show error -->

<button on:click={register} class="main-btn">
	{#if pending}
		<Spinner />
	{:else}
		Register
	{/if}
</button>
