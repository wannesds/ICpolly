<script lang="ts">
	import YesNoAnswer from './YesNoAnswer.svelte';
	import UserSvg from '$lib/assets/icons/user.svg?component';
	import UpSvg from '$lib/assets/icons/chevronUp.svg?component';
	import DownSvg from '$lib/assets/icons/chevronDown.svg?component';

	export let poll;
	let expand = false;

	let pollId = poll[0].poll.id;
	let question = poll[0].poll.question;

	let voteCount = poll[0].poll.voteCount;
	let creator = poll[0].poll.creator;
	let yesVotes = BigInt(poll[0].yesNoStats[0]);
	let noVotes = BigInt(poll[0].yesNoStats[1]);
	let voted: boolean = poll[1];

	function toggleExpand() {
		expand = !expand;
	}
</script>

<!-- border-[1px] border-solid border-slate-500 -->
<div
	class="flex flex-col sub-btn text-base dark:shadow-none shadow-none rounded-xl p-2 gap-2 w-11/12 sm:w-9/12 md:w-8/12 mx-auto"
>
	<div class="flex text-xl gap-2">
		<div class=" px-2 py-1 rounded-md bg-teal-400/10">
			# {pollId}
			<span class="flex -ml-1">
				<UserSvg class="w-5 mr-0.5" />{voteCount}
			</span>
		</div>

		<h3 class="text-2xl ">{question}</h3>
	</div>

	<div class="flex flex-row gap-2 justify-between">
		<div class="font-semibold rounded-md bg-teal-400/10 px-2 py-1">
			<p>Yes: {yesVotes}</p>
			<p>No: {noVotes}</p>
		</div>

		{#if !voted}
			<YesNoAnswer {pollId} />
		{/if}
		<button class="hover-color mt-4" on:click={toggleExpand}>
			{#if expand}
				<UpSvg class="w-7" />
			{:else}
				<DownSvg class="w-7" />
			{/if}
		</button>
	</div>
	{#if expand}
		<p class="text-sm text-slate-400/50">
			Creator Id:
			{creator}
		</p>
	{/if}
</div>
