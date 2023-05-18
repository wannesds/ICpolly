<script lang="ts">
	import { actor, user } from '$lib/stores/index';
	import type { Profile } from 'src/declarations/backend/backend.did';

	import Spinner from '$lib/components/utils/Spinner.svelte';
	import Input from '$lib/components/utils/Input.svelte';
	import { syncAuth } from '$lib/stores/auth';
	import { goto } from '$app/navigation';

	let pending = false;

	let profileObj : Profile = {
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
			await syncAuth();
			goto('./profile');
		} else {
			console.error(result);
		}
		pending = false;
	}
</script>

{#if $user}
<div
	class="flex flex-col gap-7 w-fit h-fit mx-auto p-8 rounded-xl justify-start items-center"
>
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

	<button on:click={update} class="main-btn">
		{#if pending} <Spinner /> {:else} Update Profile{/if}
	</button>
</div>
{:else}
Loading profile
{/if}