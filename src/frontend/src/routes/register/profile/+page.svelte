<script lang="ts">
	import { actor, regiStore, user } from '$lib/stores/';
	import Input from '$lib/components/utils/Input.svelte';
	import Spinner from '$lib/components/utils/Spinner.svelte';
	import type { Profile } from 'src/declarations/backend/backend.did';
	import { RegiState } from '$lib/stores/types';
	import { syncAuth } from '$lib/stores/auth';

	let pending = false;

	//a user object to temporary store and change OUR values , no type on purpose
	let profileObj = {
		username: $user.username,
		contact: " ",
		about: " "
	};

	async function submit() {
		pending = true;
		let newProfile: Profile = {
			username: profileObj.username,
			contact: profileObj.contact,
			about: profileObj.about
		};

		const result = await $actor.updateProfile(newProfile);
		if (result.hasOwnProperty('ok')) {
			// goto('/register/profile');
			await syncAuth();
			regiStore.set(RegiState.Finished);
		} else {
			console.error(result);
		}
		pending = false;
	}
</script>

<h2>Setup your profile</h2>

<Input text="Contact">
	<input class="sub-btn rounded-md" type="email" slot="input" bind:value={profileObj.contact} disabled={pending} />
</Input>

<Input text="About">
	<textarea class="sub-btn rounded-md" slot="input" bind:value={profileObj.about} disabled={pending} />
</Input>

<button on:click={submit} class="main-btn">
	{#if pending} <Spinner /> {:else} Continue {/if}
</button>
