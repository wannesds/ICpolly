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
	let avatar: any;
	let fileInput: any;

	//a user object to temporary store and change OUR values , no type on purpose
	let profileObj: Profile = {
		username: userData.username,
		contact: userData.contact,
		about: userData.about,
		img: []
	};

	const onFileSelected = (e: any) => {
		//reads file and shows in UI
		let image = e.target?.files[0];
		let reader = new FileReader();
		reader.readAsDataURL(image);
		reader.onload = (res) => {
			avatar = res.target?.result;
		};

		//transforms file to array for backend
		let writer = new FileReader();
		writer.readAsArrayBuffer(image);
		writer.onload = (res) => {
			let avatarArr: any = res.target?.result;
			profileObj.img = new Uint8Array(avatarArr);
		};
	};

	async function submit() {
		pending = true;

		const newProfile: Profile = {
			username: profileObj.username,
			contact: profileObj.contact,
			about: profileObj.about,
			img: profileObj.img
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

<button
	class="sub-btn mx-auto"
	on:click={() => {
		fileInput.click();
	}}
>
	<img src={avatar} alt="" class="rounded-full w-40 h-40" />
	<input
		style="display:none"
		type="file"
		accept=".jpg, .jpeg, .png"
		on:change={(e) => onFileSelected(e)}
		bind:this={fileInput}
		disabled={pending}
	/>
</button>

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
