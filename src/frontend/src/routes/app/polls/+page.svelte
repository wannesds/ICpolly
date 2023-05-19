<script lang="ts">
	import { getAllPollsWithYesNoAnswers } from '$lib/stores/tasks/getAllPollsWithYesNoAnswers';
	import PollBanner from '$lib/components/app/PollBanner.svelte';

	const getPolls = async () => {
		let res = await getAllPollsWithYesNoAnswers();
		if (res) {
			return res.ok;
		} else {
			throw new Error('Could not fetch polls');
		}
	};
	let polls = getPolls();
	console.log(polls);
</script>

<div class="flex flex-col h-full mt-5 w-full gap-2">
	{#await polls}
		<p>Loading polls...</p>
	{:then polls}
		{#each polls as poll}
			<PollBanner {poll} />
		{/each}
	{:catch error}
		<p class="text-red-500">{error.message}</p>
	{/await}
</div>
