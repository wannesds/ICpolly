<script lang="ts">
	import { actor } from '$lib/stores';

	let input: string = '';
	let result: bigint;
	//let showRes = false;
	let question: string = '';

	const handleCreatePoll = async () => {
		promise = await $actor.createPoll(input);
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
		question = input;
		promise = handleCreatePoll();
	};
</script>

<div class="flex flex-col p-2 gap-4">
	<input bind:value={input} class="w-full sub-btn" placeholder="type your question..." />

	<button class="main-btn mx-auto" on:click={handleClick}> Create poll </button>

	{#if question}
		<div class="m-auto">
			{#await promise}
				<p>Creating Poll ...</p>
			{:then result}
				<p>Poll created!</p>
			{:catch error}
				<p class="text-red-500">{error.message}</p>
			{/await}
		</div>
	{/if}
</div>
