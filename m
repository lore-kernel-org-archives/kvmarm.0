Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F23014A93
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 08:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709539300; cv=none; b=Xbo3Yi44JBgkuZFd5qMi3aOpeENsS1k5jxGpoeTgZ1OMptmNgCxeITD6qdnYMtcHXPS8L8NbO6vsYo3FztWjtMbTJrhaCy1j8bua1iaNCNqInL+oyDCtXomp11UfQHILQKoXxzSjxCSLjyCQdKf/5ZvU3hzJuJPaJJ8u7lr4XkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709539300; c=relaxed/simple;
	bh=24ilfTvIHZAgDbAn3/mPUrT2s/PSGlsyNOGlSO6DnFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NbPGHWLLnC4xfL9FWdQ+JYB/KwbnCGX6wZJqKIdbtnh8bR89ccKhW7zmctoR6+1ekttfbeqgLBYJKIBmMidg3LA4hi+396J2PCluRkFE0it3rzqPB4EGD0qnyd/ZlAsrZtljiEjvzhPiZmVW7/N7vSuHmUgksW1oZDG2UgCd6mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5D721FB;
	Mon,  4 Mar 2024 00:02:13 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 027723F762;
	Mon,  4 Mar 2024 00:01:35 -0800 (PST)
Message-ID: <ee84ddaa-83cb-42cd-a70e-7f96774a7d99@arm.com>
Date: Mon, 4 Mar 2024 08:01:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 12/18] arm/arm64: Factor out allocator
 init from mem_init
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-32-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-32-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> The allocator init is identical for mem_init() and efi_mem_init().
> Share it.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   lib/arm/setup.c | 46 ++++++++++++++++++++++------------------------
>   1 file changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index f96ee04ddd68..d0be4c437708 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -136,9 +136,28 @@ static void arm_memregions_add_assumed(void)
>   #endif
>   }
>   
> -static void mem_init(phys_addr_t freemem_start)
> +static void mem_allocator_init(phys_addr_t freemem_start, phys_addr_t freemem_end)
>   {
>   	phys_addr_t base, top;
> +
> +	freemem_start = PAGE_ALIGN(freemem_start);
> +	freemem_end &= PAGE_MASK;
> +
> +	phys_alloc_init(freemem_start, freemem_end - freemem_start);
> +	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
> +
> +	phys_alloc_get_unused(&base, &top);
> +	base = PAGE_ALIGN(base);
> +	top &= PAGE_MASK;
> +	assert(sizeof(long) == 8 || !(base >> 32));
> +	if (sizeof(long) != 8 && (top >> 32) != 0)
> +		top = ((uint64_t)1 << 32);
> +	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
> +	page_alloc_ops_enable();
> +}
> +
> +static void mem_init(phys_addr_t freemem_start)
> +{
>   	struct mem_region *freemem, *r, mem = {
>   		.start = (phys_addr_t)-1,
>   	};
> @@ -169,17 +188,7 @@ static void mem_init(phys_addr_t freemem_start)
>   	__phys_offset = mem.start;	/* PHYS_OFFSET */
>   	__phys_end = mem.end;		/* PHYS_END */
>   
> -	phys_alloc_init(freemem_start, freemem->end - freemem_start);
> -	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
> -
> -	phys_alloc_get_unused(&base, &top);
> -	base = PAGE_ALIGN(base);
> -	top = top & PAGE_MASK;
> -	assert(sizeof(long) == 8 || !(base >> 32));
> -	if (sizeof(long) != 8 && (top >> 32) != 0)
> -		top = ((uint64_t)1 << 32);
> -	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
> -	page_alloc_ops_enable();
> +	mem_allocator_init(freemem_start, freemem->end);
>   }
>   
>   static void freemem_push_fdt(void **freemem, const void *fdt)
> @@ -292,7 +301,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>   	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
>   	efi_memory_desc_t *buffer = *map->map;
>   	efi_memory_desc_t *d = NULL;
> -	phys_addr_t base, top;
>   	struct mem_region r;
>   	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
>   	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
> @@ -380,17 +388,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>   
>   	assert(sizeof(long) == 8 || free_mem_start < (3ul << 30));
>   
> -	phys_alloc_init(free_mem_start, free_mem_pages << EFI_PAGE_SHIFT);
> -	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
> -
> -	phys_alloc_get_unused(&base, &top);
> -	base = PAGE_ALIGN(base);
> -	top = top & PAGE_MASK;
> -	assert(sizeof(long) == 8 || !(base >> 32));
> -	if (sizeof(long) != 8 && (top >> 32) != 0)
> -		top = ((uint64_t)1 << 32);
> -	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
> -	page_alloc_ops_enable();
> +	mem_allocator_init(free_mem_start, free_mem_start + (free_mem_pages << EFI_PAGE_SHIFT));
>   
>   	return EFI_SUCCESS;
>   }
