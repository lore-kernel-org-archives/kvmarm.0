Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07876168C4
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 07:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709539172; cv=none; b=CP2GnZpCv6zwV0/6MLtuFz8NfHsj0/ffK9XZLNjGhQElyijA6VEi7rgeHF0Zaj8vd+hWOFYITDlrsj0vlCJHnQVV7XFXZAeaJTtACjMIq3qfQ7D/N3XaMyGALzxX7AEMhbGU5turODi6v7KP6OGSt4DmVdcvnGGKu3ofhdXYqGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709539172; c=relaxed/simple;
	bh=+nJ1r/7CdPXhY6mmgRjpOzaiV8J/Wa7cYMW+D3Ru0gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mOCWYXuFHCW5fnrXcqXKFuAB4Bk75APPUtnerrxbvL+KVW7Kv6vDxVvuayw8t1S+YB906tsSAEdxKYSBzFKN23n43Y75q+hMMmBA6EEP9AFswT4ljAMTM+o/9ySJxWeDYCU/AYUkPcRdRo6XSSG6PcvMrHgsZZtTlJZgXEVyAxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2747F1FB;
	Mon,  4 Mar 2024 00:00:07 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 577E73F762;
	Sun,  3 Mar 2024 23:59:29 -0800 (PST)
Message-ID: <fc22d6ee-7868-4203-bcac-eb21f8cd22c6@arm.com>
Date: Mon, 4 Mar 2024 07:59:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 11/18] arm/arm64: Factor out some
 initial setup
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-31-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-31-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> Factor out some initial setup code into separate functions in order
> to share more code between setup() and setup_efi().
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   lib/arm/setup.c | 81 ++++++++++++++++++++++++++++---------------------
>   1 file changed, 47 insertions(+), 34 deletions(-)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 76aae4627a7b..f96ee04ddd68 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -182,32 +182,57 @@ static void mem_init(phys_addr_t freemem_start)
>   	page_alloc_ops_enable();
>   }
>   
> -void setup(const void *fdt, phys_addr_t freemem_start)
> +static void freemem_push_fdt(void **freemem, const void *fdt)
>   {
> -	void *freemem;
> -	const char *bootargs, *tmp;
>   	u32 fdt_size;
>   	int ret;
>   
> -	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
> -	freemem = (void *)(unsigned long)freemem_start;
> -
> -	/* Move the FDT to the base of free memory */
>   	fdt_size = fdt_totalsize(fdt);
> -	ret = fdt_move(fdt, freemem, fdt_size);
> +	ret = fdt_move(fdt, *freemem, fdt_size);
>   	assert(ret == 0);
> -	ret = dt_init(freemem);
> +	ret = dt_init(*freemem);
>   	assert(ret == 0);
> -	freemem += fdt_size;
> +	*freemem += fdt_size;
> +}
> +
> +static void freemem_push_dt_initrd(void **freemem)
> +{
> +	const char *tmp;
> +	int ret;
>   
> -	/* Move the initrd to the top of the FDT */
>   	ret = dt_get_initrd(&tmp, &initrd_size);
>   	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
>   	if (ret == 0) {
> -		initrd = freemem;
> +		initrd = *freemem;
>   		memmove(initrd, tmp, initrd_size);
> -		freemem += initrd_size;
> +		*freemem += initrd_size;
>   	}
> +}
> +
> +static void initrd_setup(void)
> +{
> +	char *env;
> +
> +	if (!initrd)
> +		return;
> +
> +	/* environ is currently the only file in the initrd */
> +	env = malloc(initrd_size);
> +	memcpy(env, initrd, initrd_size);
> +	setup_env(env, initrd_size);
> +}
> +
> +void setup(const void *fdt, phys_addr_t freemem_start)
> +{
> +	void *freemem;
> +	const char *bootargs;
> +	int ret;
> +
> +	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
> +	freemem = (void *)(unsigned long)freemem_start;
> +
> +	freemem_push_fdt(&freemem, fdt);
> +	freemem_push_dt_initrd(&freemem);
>   
>   	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
>   	memregions_add_dt_regions(MAX_DT_MEM_REGIONS);
> @@ -229,12 +254,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>   	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
>   	setup_args_progname(bootargs);
>   
> -	if (initrd) {
> -		/* environ is currently the only file in the initrd */
> -		char *env = malloc(initrd_size);
> -		memcpy(env, initrd, initrd_size);
> -		setup_env(env, initrd_size);
> -	}
> +	initrd_setup();
>   
>   	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
>   		setup_vm();
> @@ -277,7 +297,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>   	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
>   	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
>   	const void *fdt = efi_bootinfo->fdt;
> -	int fdt_size, ret;
>   
>   	/*
>   	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
> @@ -344,14 +363,13 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>   	}
>   
>   	if (efi_bootinfo->fdt_valid) {
> -		/* Move the FDT to the base of free memory */
> -		fdt_size = fdt_totalsize(fdt);
> -		ret = fdt_move(fdt, (void *)free_mem_start, fdt_size);
> -		assert(ret == 0);
> -		ret = dt_init((void *)free_mem_start);
> -		assert(ret == 0);
> -		free_mem_start += ALIGN(fdt_size, EFI_PAGE_SIZE);
> -		free_mem_pages -= ALIGN(fdt_size, EFI_PAGE_SIZE) >> EFI_PAGE_SHIFT;
> +		unsigned long old_start = free_mem_start;
> +		void *freemem = (void *)free_mem_start;
> +
> +		freemem_push_fdt(&freemem, fdt);
> +
> +		free_mem_start = ALIGN((unsigned long)freemem, EFI_PAGE_SIZE);
> +		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
>   	}
>   
>   	__phys_end &= PHYS_MASK;
> @@ -419,13 +437,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>   	io_init();
>   
>   	timer_save_state();
> -	if (initrd) {
> -		/* environ is currently the only file in the initrd */
> -		char *env = malloc(initrd_size);
>   
> -		memcpy(env, initrd, initrd_size);
> -		setup_env(env, initrd_size);
> -	}
> +	initrd_setup();
>   
>   	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
>   		setup_vm();
