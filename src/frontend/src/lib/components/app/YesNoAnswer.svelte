<script lang="ts">
	import { actor, user } from '$lib/stores';
	import Spinner from '../utils/Spinner.svelte';

	export let pollId: bigint;

	let answer: boolean;
	//AnswerType
	//{ 'YesNo' : boolean } | { 'MultiChoice' : string }

	const handleAnswerPoll = async () => {
		//showRes = true;
		promise = await $actor.answerPoll(pollId, answer);
		if (promise.Ok) {
			return promise.Ok;
		} else {
			throw new Error(promise.Err);
		}
	};
	let promise: any;

	const handleClick = (input: boolean) => {
		answer = input;

		promise = handleAnswerPoll();
	};
</script>

<div class="flex gap-2 items-center">
	{#if answer}
		{#await promise}
			<Spinner />
			<p>Sending Answer</p>
		{:then}
			<p>Voted!</p>
		{:catch error}
			<p class="text-red-500">{error.message}</p>
		{/await}
	{:else if $user}
		<button
			on:click={() => handleClick(true)}
			class="main-btn dark:shadow-none w-16 sm:w-24 h-8 p-0">Yes</button
		>
		<button
			on:click={() => handleClick(false)}
			class="main-btn dark:shadow-none w-16 sm:w-24 h-8 p-0">No</button
		>
	{:else}
		<p>Connect with Internet-Identity to vote</p>
	{/if}
</div>
