<script lang="ts">
	import type { BugReport } from 'src/declarations/backend/backend.did';

	export let bug: BugReport;

	let img: any;

	let image = new Uint8Array(bug.img);
	let blob = new Blob([image], { type: 'image/png' });
	let reader = new FileReader();
	reader.readAsDataURL(blob);
	reader.onload = (res) => {
		img = res.target?.result;
	};
</script>

<!-- border-[1px] border-solid border-slate-500 -->
<div
	class="flex flex-col sub-btn text-base dark:shadow-none shadow-none rounded-xl p-2 gap-2 w-11/12 md:9/12 mx-auto"
>
	<h2>{bug.message}</h2>
	<p>{bug.creator}</p>
	<img src={img} alt="." class=" rounded-md" />
</div>
