<script lang="ts">
	import { actor, user } from '$lib/stores/index';
	import type { Profile } from 'src/declarations/backend/backend.did';

	import Spinner from '$lib/components/utils/Spinner.svelte';
	import { updateProfile } from '$lib/stores/tasks/updateProfile';
	import { get } from 'svelte/store';

	let pending = false;
	let userData = get(user);
	let imgInput: Uint8Array;
	let imgRes: Uint8Array;

	let profileObj: Profile = {
		username: userData.username,
		contact: userData.contact,
		about: userData.about,
		img: []
	};
	$: {
	}
	const handleFileInput = async () => {
		//const uint8Array = await convertImageToUInt8Array(imgInput);
		// const reader = new FileReader();
		// let x = new Uint8Array(reader.result);
		let image = new Uint8Array(imgInput);
		let blob = new Blob([image]);
		console.log(imgInput, '///', image, '////', blob);
		let reader = new FileReader();
		reader.onload = function (e) {
			console.log('res:', reader.target.result.img());
		};
		reader.readAsDataURL(blob);
		//reader.readAsArrayBuffer(blob)

		//console.log(x)

		//const blob = new Blob([uint8Array]);
		//testBlob = blob;
		//profileObj.img = uint8Array;
		//let imgUrl = URL.createObjectURL(blob);
	};

	async function update() {
		pending = true;

		const newProfile: Profile = {
			username: profileObj.username,
			contact: profileObj.contact,
			about: profileObj.about,
			img: userData.img
		};
		// let image = new Uint8Array();
		// let blob = new Blob([image]);
		// let reader = new FileReader();
		// reader.onload = function(e) {
		// }
		// reader.readAsDataURL(blob);
		// console.log("test 1 ", profileObj.img)

		await updateProfile(newProfile)
			.catch((err) => {
				console.log(err.message);
			})
			.then(() => {
				pending = false;
			});
	}
</script>

<div class="flex flex-col gap-3 w-fit h-fit mx-auto p-8 rounded-xl justify-start items-center">
	<h3>Username</h3>
	<input
		class="sub-btn rounded-md"
		type="text"
		bind:value={profileObj.username}
		disabled={pending}
	/>
	<h3>Social Contact / Email</h3>
	<input
		class="sub-btn rounded-md"
		type="email"
		bind:value={profileObj.contact}
		disabled={pending}
	/>

	<h3>About yourself</h3>
	<textarea class="sub-btn rounded-md" bind:value={profileObj.about} disabled={pending} />

	<h3>Profile picture</h3>
	<input
		type="file"
		alt="submit img"
		class="sub-btn rounded-md"
		bind:value={imgInput}
		on:change={handleFileInput}
		disabled={pending}
	/>

	{#if pending}
		<Spinner />
	{:else}
		<button on:click={update} class="main-btn"> Update Profile </button>
	{/if}
</div>
