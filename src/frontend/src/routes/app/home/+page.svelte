<script lang="ts">
	let expandWindow: boolean = false;
	let newQ: string;
	let pending: boolean = false;

	// onMount(async () => {
	// 	await SOMEFUNCGETS
	// });

	const submit = async () => {
		pending = true;

		// await SOMEFUNCSENDS().catch((error) => {
		// 	console.log('errorcatch', error);
		// });
		pending = false;
		newQ = '';
	};
</script>

<div class="flex flex-col gap-4 justify-start px-4 md:px-8">
	Motoko Bootcamp Final Project idea:
	<h1 class="">
		Decentralized <span class="highlight">Polling</span> & <span class="highlight">Survey</span> service
	</h1>
	<p>ICRC still in development , not launched yet</p>

	<h2>- Earn POLL by <span class="highlight">Voting</span></h2>
	<h2>
		- Spend POLL on creating <span class="highlight"> Polls</span>
		or <span class="highlight"> Sell </span> to the market
	</h2>

	<div class="h-[0.5px] w-10/12 mx-auto my-10 bg-slate-700" />

	Currently In Development:
	<h3>
		<h3>- <span class="highlight">POLL</span>-ICRC integrated + Airdrop + App integration</h3>
		-<span class="highlight">MultipleChoice</span> + Choose QuestionType on create poll
	</h3>
</div>
