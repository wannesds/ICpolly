<script lang="ts">
	export let text: string;
</script>

<div class="flex flex-col justify-center items-center gap-2">
	<p>{text}</p>
	<div class="flex gap-2">
		<slot name="input" />
	</div>
</div>
