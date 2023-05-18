<script lang="ts">
	import YesNoAnswer from './YesNoAnswer.svelte';

	export let poll;

	let pollId = poll[0].poll.id;
	let question = poll[0].poll.question;

	let voteCount = poll[0].poll.voteCount;
	let creator = poll[0].poll.creator;
	let yesVotes = BigInt(poll[0].yesNoStats[0]);
	let noVotes = BigInt(poll[0].yesNoStats[1]);
	let voted: boolean = poll[1];
</script>

<!-- border-[1px] border-solid border-slate-500 -->
<div class="flex flex-col bg-dark-700 rounded-xl p-2 gap-2 w-11/12 md:w-9/12 mx-auto">
	<div class="flex text-xl gap-1">
		<p class="text-teal-200/20">#{pollId}</p>
		<p>{question}</p>
	</div>

	<p class="text-sm text-teal-200/40">{creator}</p>

	<div class="flex gap-5">
		<p class="text-teal-200/40">voted: {voteCount}</p>
		+ {yesVotes}
		/ - {noVotes}
	</div>

	{#if !voted}
		<YesNoAnswer {pollId} />
	{/if}
</div>
