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

<div class="flex flex-col gap-4">Home app</div>
