<script lang="ts">
	import { actor, user } from '$lib/stores/index';
	import type { Profile } from 'src/declarations/backend/backend.did';

	import Spinner from '$lib/components/utils/Spinner.svelte';
	import Input from '$lib/components/utils/Input.svelte';
	import { updateProfile } from '$lib/stores/tasks/updateProfile';
	import { get } from 'svelte/store';
	import { onDestroy, onMount } from 'svelte';
	import { syncAuth } from '$lib/stores/auth';

	let pending = false;
	let userData = get(user);

	let profileObj: Profile = {
		username: userData.username,
		contact: userData.contact,
		about: userData.about
	};

	async function update() {
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
			});
	}
</script>

<div class="flex flex-col gap-7 w-fit h-fit mx-auto p-8 rounded-xl justify-start items-center">
	<Input text="Username">
		<input
			class="sub-btn rounded-md"
			type="text"
			slot="input"
			bind:value={profileObj.username}
			disabled={pending}
		/>
	</Input>

	<Input text="Contact / Email">
		<input
			class="sub-btn rounded-md"
			type="email"
			slot="input"
			bind:value={profileObj.contact}
			disabled={pending}
		/>
	</Input>

	<Input text="Intro">
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
		<button on:click={update} class="main-btn"> Update Profile </button>
	{/if}
</div>
