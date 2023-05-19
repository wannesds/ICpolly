<script lang="ts">
	import { actor, user } from '$lib/stores/index';
	import type { Profile } from 'src/declarations/backend/backend.did';

	import Spinner from '$lib/components/utils/Spinner.svelte';
	import { updateProfile } from '$lib/stores/tasks/updateProfile';
	import { get } from 'svelte/store';
	import { onMount } from 'svelte';

	let pending = false;
	let userData = get(user);
	// let imgInput: any;
	// let imgRes: Uint8Array;

	let profileObj: Profile = {
		username: userData.username,
		contact: userData.contact,
		about: userData.about,
		img: userData.img
	};
	

	let avatar : any;
	let avatarArr: any;
	let fileInput : any;


	console.log($user)

	//FROM BACKEND ARR TO FILE
	onMount(() => {
		let image = new Uint8Array($user.img)

		console.log("init image", image)

		let blob = new Blob([image], { type: 'image/png' });
		let reader = new FileReader();
		reader.readAsDataURL(blob)
		reader.onload = res => {
			avatar = res.target?.result
			console.log("avatarOnMount : ",avatar)
		};
	})
	
	//FROM FILE TO BACKEND ARR
	const onFileSelected = (e:any) => {
		//reads file and shows in UI
  		let image = e.target?.files[0];
		console.log("image:",image)
		let reader = new FileReader();
		reader.readAsDataURL(image);
		reader.onload = res => {
			avatar = res.target?.result
			console.log("avatarAfter : ",avatar)
		};
		//transforms file to array for backend
		let writer = new FileReader();
		writer.readAsArrayBuffer(image);
		writer.onload = res => {
			avatarArr = res.target?.result
			profileObj.img = new Uint8Array(avatarArr)
		};
	}

	async function update() {
		pending = true;

		const newProfile: Profile = {
			username: profileObj.username,
			contact: profileObj.contact,
			about: profileObj.about,
			img: profileObj.img
		};

		console.log("update :", newProfile.img)

		await updateProfile(newProfile)
			.catch((err) => {
				console.log(err.message);
			})
			.then(() => {
				pending = false;
			});
	}
</script>

<div class="flex flex-col gap-2 w-fit bg-slate-500/10 h-fit mx-auto p-8 rounded-xl items-center">
	
	<button class="sub-btn mx-auto" on:click={()=>{fileInput.click();}}>
		<img src="{avatar}" alt="d" class="rounded-full w-40 h-40"/>
		<input  
			style="display:none"
			type="file" accept=".jpg, .jpeg, .png" 
			on:change={(e) => onFileSelected(e)}
			bind:this={fileInput}
			disabled={pending}
		>
	</button> 

	<p class="">Username</p>
	<input
		class="sub-btn rounded-md text-xl w-full"
		type="text"
		bind:value={profileObj.username}
		disabled={pending}
	/>
	<p>Social Contact / Email</p>
	<input
		class="sub-btn rounded-md w-full"
		type="email"
		bind:value={profileObj.contact}
		disabled={pending}
	/>

	<p>About yourself</p>
	<textarea class="sub-btn rounded-md w-full h-32" bind:value={profileObj.about} disabled={pending} />

	<!-- <input
		type="file"
		alt="submit img"
		class="sub-btn rounded-md"
		accept="image/gif, image/jpeg, image/png"
		bind:value={imgInput}
		on:change={handleFileInput}
		disabled={pending}
	/> -->
	
	
	

	{#if pending}
		<Spinner />
	{:else}
		<button on:click={update} class="main-btn"> Update Profile </button>
	{/if}
</div>
