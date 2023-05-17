<script lang="ts">
	import { actor, user } from '$lib/stores/index';
	import type { Profile } from 'src/declarations/backend/backend.did';

	import Spinner from '$lib/components/utils/Spinner.svelte';
	import Input from '$lib/components/utils/Input.svelte';

	let pending = false;

	let profileObj = {
		username: $user.username,
		contact: $user.contact,
		about: $user.about
	};

	async function update() {
		pending = true;
		const newProfile: Profile = {
			username: profileObj.username,
			contact: profileObj.contact,
			about: profileObj.about
		};

		const result = await $actor.updateProfile(newProfile);
		if (result.hasOwnProperty('ok')) {
		} else {
			console.error(result);
		}
		pending = false;
	}
</script>

<h2 class="p-0 text-center ">Profile settings</h2>

<Input text="Username">
	<input type="text" slot="input" bind:value={profileObj.username} disabled={pending} />
</Input>

<Input text="Contact">
	<input type="email" slot="input" bind:value={profileObj.contact} disabled={pending} />
</Input>

<Input text="About">
	<textarea slot="input" bind:value={profileObj.about} disabled={pending} />
</Input>

<button on:click={update} class="hover:bg-slate-500/30">
	{#if pending} <Spinner /> {:else} Update {/if}
</button>
