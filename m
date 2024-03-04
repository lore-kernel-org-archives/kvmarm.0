Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95521758D
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709540171; cv=none; b=pfW4UJP0owaFWI0ffyjuraHdZVWCIvX7em1428yibQ2Y3HSsMacEJ1012ZutEmJj6wXQ0gbbnB7SFjR3cpn3TvdSGbod7RBDSuWBobQ0k8jJZkISm0GoDXbmWifuchHqyAEwLnjhOI3ocgy9FLrsRDMK+f6f0cP8AvoqP5ESW1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709540171; c=relaxed/simple;
	bh=Usn/sL9LmRYWnweK4AfrZj7rSaXKFerzMl0pVZdtcy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NM3U/aIAuVoit4kewma4ejubO9Gn+eb26octELYlub8VrZbvWuxbGdbAIL1bVOL6uOxR8P/M9BT6OnVb3BXNlEWTO8x+c0qMbBrdCJl7sTzdaZpyPsO8joWc/MZyxVJDOTj1USgw6TPC5UpL42I1XJ8bePbmcbtHAUvzpkZaWPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23F9A1FB;
	Mon,  4 Mar 2024 00:16:44 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 501DC3F762;
	Mon,  4 Mar 2024 00:16:06 -0800 (PST)
Message-ID: <8923581b-5ca9-448e-86ff-d7b8b1c2542c@arm.com>
Date: Mon, 4 Mar 2024 08:16:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 14/18] arm64: Add memregions_efi_init
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-34-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-34-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> Provide a memregions function which initialized memregions from an
> EFI memory map. Add a new memregions flag (MR_F_PERSISTENT) for
> EFI_PERSISTENT_MEMORY since that type should not be reserved, but it
> should also be distinct from conventional memory. The function also
> points out the largest conventional memory region by returning a
> pointer to it in the freemem parameter. Immediately apply this
> function to arm64's efi_mem_init(). riscv will make use of it as well.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   lib/arm/setup.c  | 76 ++++++++----------------------------------------
>   lib/memregions.c | 51 ++++++++++++++++++++++++++++++++
>   lib/memregions.h |  6 ++++
>   3 files changed, 69 insertions(+), 64 deletions(-)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 631597b343f1..521928186fb0 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -295,58 +295,13 @@ static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
>   
>   static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>   {
> -	int i;
> -	unsigned long free_mem_pages = 0;
> -	unsigned long free_mem_start = 0;
> -	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
> -	efi_memory_desc_t *buffer = *map->map;
> -	efi_memory_desc_t *d = NULL;
> -	struct mem_region r, *code, *data;
> -	const void *fdt = efi_bootinfo->fdt;
> -
> -	/*
> -	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
> -	 * which will be used to set up the memory allocator, so that
> -	 * the memory allocator can work in the largest free
> -	 * continuous memory region.
> -	 */
> -	for (i = 0; i < *(map->map_size); i += *(map->desc_size)) {
> -		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
> -
> -		r.start = d->phys_addr;
> -		r.end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE;
> -		r.flags = 0;
> -
> -		switch (d->type) {
> -		case EFI_RESERVED_TYPE:
> -		case EFI_LOADER_DATA:
> -		case EFI_BOOT_SERVICES_CODE:
> -		case EFI_BOOT_SERVICES_DATA:
> -		case EFI_RUNTIME_SERVICES_CODE:
> -		case EFI_RUNTIME_SERVICES_DATA:
> -		case EFI_UNUSABLE_MEMORY:
> -		case EFI_ACPI_RECLAIM_MEMORY:
> -		case EFI_ACPI_MEMORY_NVS:
> -		case EFI_PAL_CODE:
> -			r.flags = MR_F_RESERVED;
> -			break;
> -		case EFI_MEMORY_MAPPED_IO:
> -		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
> -			r.flags = MR_F_IO;
> -			break;
> -		case EFI_LOADER_CODE:
> -			r.flags = MR_F_CODE;
> -			break;
> -		case EFI_CONVENTIONAL_MEMORY:
> -			if (free_mem_pages < d->num_pages) {
> -				free_mem_pages = d->num_pages;
> -				free_mem_start = d->phys_addr;
> -			}
> -			break;
> -		}
> +	struct mem_region *freemem_mr = NULL, *code, *data;
> +	phys_addr_t freemem_start;
> +	void *freemem;
>   
> -		memregions_add(&r);
> -	}
> +	memregions_efi_init(&efi_bootinfo->mem_map, &freemem_mr);
> +	if (!freemem_mr)
> +		return EFI_OUT_OF_RESOURCES;
>   
>   	memregions_split((unsigned long)&_etext, &code, &data);
>   	assert(code && (code->flags & MR_F_CODE));
> @@ -366,24 +321,17 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>   	}
>   	__phys_end &= PHYS_MASK;
>   
> -	if (efi_bootinfo->fdt_valid) {
> -		unsigned long old_start = free_mem_start;
> -		void *freemem = (void *)free_mem_start;
> +	freemem = (void *)PAGE_ALIGN(freemem_mr->start);
>   
> -		freemem_push_fdt(&freemem, fdt);
> +	if (efi_bootinfo->fdt_valid)
> +		freemem_push_fdt(&freemem, efi_bootinfo->fdt);
>   
> -		free_mem_start = ALIGN((unsigned long)freemem, EFI_PAGE_SIZE);
> -		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
> -	}
> +	freemem_start = PAGE_ALIGN((unsigned long)freemem);
> +	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
>   
>   	asm_mmu_disable();
>   
> -	if (free_mem_pages == 0)
> -		return EFI_OUT_OF_RESOURCES;
> -
> -	assert(sizeof(long) == 8 || free_mem_start < (3ul << 30));
> -
> -	mem_allocator_init(free_mem_start, free_mem_start + (free_mem_pages << EFI_PAGE_SHIFT));
> +	mem_allocator_init(freemem_start, freemem_mr->end);
>   
>   	return EFI_SUCCESS;
>   }
> diff --git a/lib/memregions.c b/lib/memregions.c
> index 96de86b27333..9cdbb639ab62 100644
> --- a/lib/memregions.c
> +++ b/lib/memregions.c
> @@ -80,3 +80,54 @@ void memregions_add_dt_regions(size_t max_nr)
>   		});
>   	}
>   }
> +
> +#ifdef CONFIG_EFI
> +/*
> + * Add memory regions based on the EFI memory map. Also set a pointer to the
> + * memory region which corresponds to the largest EFI_CONVENTIONAL_MEMORY
> + * region, as that region is the largest free, continuous region, making it
> + * a good choice for the memory allocator.
> + */
> +void memregions_efi_init(struct efi_boot_memmap *mem_map,
> +			 struct mem_region **freemem)
> +{
> +	u8 *buffer = (u8 *)*mem_map->map;
> +	u64 freemem_pages = 0;
> +
> +	*freemem = NULL;
> +
> +	for (int i = 0; i < *mem_map->map_size; i += *mem_map->desc_size) {
> +		efi_memory_desc_t *d = (efi_memory_desc_t *)&buffer[i];
> +		struct mem_region r = {
> +			.start = d->phys_addr,
> +			.end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE,
> +			.flags = 0,
> +		};
> +
> +		switch (d->type) {
> +		case EFI_MEMORY_MAPPED_IO:
> +		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
> +			r.flags = MR_F_IO;
> +			break;
> +		case EFI_LOADER_CODE:
> +			r.flags = MR_F_CODE;
> +			break;
> +		case EFI_PERSISTENT_MEMORY:
> +			r.flags = MR_F_PERSISTENT;
> +			break;
> +		case EFI_CONVENTIONAL_MEMORY:
> +			if (freemem_pages < d->num_pages) {
> +				freemem_pages = d->num_pages;
> +				*freemem = memregions_add(&r);
> +				continue;
> +			}
> +			break;
> +		default:
> +			r.flags = MR_F_RESERVED;
> +			break;
> +		}
> +
> +		memregions_add(&r);
> +	}
> +}
> +#endif /* CONFIG_EFI */
> diff --git a/lib/memregions.h b/lib/memregions.h
> index 9a8e33182fe5..1600530ad7bf 100644
> --- a/lib/memregions.h
> +++ b/lib/memregions.h
> @@ -9,6 +9,7 @@
>   #define MR_F_IO				BIT(0)
>   #define MR_F_CODE			BIT(1)
>   #define MR_F_RESERVED			BIT(2)
> +#define MR_F_PERSISTENT			BIT(3)
>   #define MR_F_UNKNOWN			BIT(31)
>   
>   struct mem_region {
> @@ -26,4 +27,9 @@ uint32_t memregions_get_flags(phys_addr_t paddr);
>   void memregions_split(phys_addr_t addr, struct mem_region **r1, struct mem_region **r2);
>   void memregions_add_dt_regions(size_t max_nr);
>   
> +#ifdef CONFIG_EFI
> +#include <efi.h>
> +void memregions_efi_init(struct efi_boot_memmap *mem_map, struct mem_region **freemem);
> +#endif
> +
>   #endif /* _MEMREGIONS_H_ */
