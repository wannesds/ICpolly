<script lang="ts">
	import { actor, regiStore, user } from '$lib/stores/';
	import Input from '$lib/components/utils/Input.svelte';
	import Spinner from '$lib/components/utils/Spinner.svelte';
	import type { Profile } from 'src/declarations/backend/backend.did';
	import { RegiState } from '$lib/stores/types';
	import { get } from 'svelte/store';
	import { updateProfile } from '$lib/stores/tasks/updateProfile';

	let pending = false;
	let userData = get(user);

	//a user object to temporary store and change OUR values , no type on purpose
	let profileObj = {
		username: userData.username,
		contact: userData.contact,
		about: userData.about
	};

	async function submit() {
		pending = true;

		const newProfile: Profile = {
			username: profileObj.username,
			contact: profileObj.contact,
			about: profileObj.about
		};

		await updateProfile(newProfile)
			.catch((err) => {
				console.log(err.message);
			})
			.then(() => {
				pending = false;
				regiStore.set(RegiState.Finished);
			});
	}
</script>

<h2>Setup your profile</h2>

<Input text="Contact">
	<input
		class="sub-btn rounded-md"
		type="email"
		slot="input"
		bind:value={profileObj.contact}
		disabled={pending}
	/>
</Input>

<Input text="About">
	<textarea
		class="sub-btn rounded-md"
		slot="input"
		bind:value={profileObj.about}
		disabled={pending}
	/>
</Input>

{#if pending}
	<Spinner />
{:else}
	<button on:click={submit} class="main-btn"> Continue </button>
{/if}
