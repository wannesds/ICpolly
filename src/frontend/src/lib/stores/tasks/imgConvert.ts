export const convertImageToUInt8Array = async (file: any): Promise<Uint8Array> => {
	//not working properly yet
	return new Promise<Uint8Array>((resolve, reject) => {
		const reader = new FileReader();
		reader.onload = () => {
			if (reader.result instanceof ArrayBuffer) {
				const uint8Array = new Uint8Array(reader.result);
				resolve(uint8Array);
			} else {
				reject(new Error('Unable to convert file to UInt8Array'));
			}
		};
		reader.onerror = () => {
			reject(reader.error);
		};
		reader.readAsArrayBuffer(file);
	});
};
