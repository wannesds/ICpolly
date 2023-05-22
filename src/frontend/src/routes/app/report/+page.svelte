<script lang="ts">
	import BugBanner from '$lib/components/app/BugBanner.svelte';
	import { actor } from '$lib/stores';

	let input: string = '';
	let inputImg: any;
	let result: bigint;
	//let showRes = false;
	let message: string = '';

	let avatar: any;
	let avatarArr: any;
	let fileInput: any;

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
			avatarArr = res.target?.result;
			inputImg = new Uint8Array(avatarArr);
		};
	};

	const handleCreateReport = async () => {
		promise = await $actor.createBugReport(input, inputImg);
		if (promise.Ok) {
			result = BigInt(promise.Ok());

			input = '';
			return promise.Ok;
		} else {
			throw new Error(promise.Err);
		}
	};

	let promise: any;

	const handleClick = () => {
		message = input;
		promise = handleCreateReport();
	};

	const getBugReports = async () => {
		let res = await $actor.getAllBugReports();
		if (res) {
			return res;
		} else {
			throw new Error('Could not fetch polls');
		}
	};
	let bugs = getBugReports();
</script>

<div class="flex flex-col justify-start h-full items-center w-full md:w-8/12 mx-auto gap-5 p-4 ">
	Post a screen shot and description of a bug you found on this app.
	<input bind:value={input} class="w-full sub-btn" placeholder="type your question..." />
	<button
		class="sub-btn rounded-md mx-auto"
		on:click={() => {
			fileInput.click();
		}}
	>
		<img src={avatar} alt="screenshot" class=" w-7/12 h-4/12" />
		<input
			style="display:none"
			type="file"
			accept=".jpg, .jpeg, .png"
			on:change={(e) => onFileSelected(e)}
			bind:this={fileInput}
		/>
	</button>

	<button class="main-btn mx-auto" on:click={handleClick}>Send Report</button>

	{#if message}
		<div class="m-auto">
			{#await promise}
				<p>Creating bug report...</p>
			{:then result}
				<p>Report created!</p>
			{:catch error}
				<p class="text-red-500">{error.message}</p>
			{/await}
		</div>
	{/if}

	<h2>Bug Report Wall</h2>

	{#await bugs}
		<p>Loading Bug Report wall...</p>
	{:then bugs}
		{#each bugs as bug}
			<!-- <BugBanner {bug} /> -->
			<BugBanner {bug} />
		{/each}
	{:catch error}
		<p class="text-red-500">{error.message}</p>
	{/await}
</div>
