Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A56B16CD0E;
	Mon, 19 Aug 2024 14:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724076805; cv=none; b=XSPF3eb80ZPyBJrK5XPwo7C2jSxAC/icSL0P9ivEkI3V+EyYkPfWICp0PgoCn+hmQfAbje5ZnMHGNnUnz95nQ2txSswdLsSR2aBEXx+J6RqX0GykBmLxd4RnZ/xQ7GLQzMKBCEXjuiBIhwx8rlJlAwLQAzyVOJSj5KpckWEuR9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724076805; c=relaxed/simple;
	bh=FtywNzPYFeb8fTHXzo+TIBaYvwGku+MpTkeQW/3Pudg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ji1bBfUTo0XCXdPKNChuKk6XFqBn1R5kPpkj4TTJZWaqeJQWJspEYJAkVshAfb9WPW4Hnaeipm19p68u0Kwm0wO18L1UYlDvY6LT/+jJ9kFIjq26rzRu3JK9X7jlPzngbJ5pkdvBK0lcpV8vtlLCXYjd3GKlvtDEEyrIKrfruFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C37B339;
	Mon, 19 Aug 2024 07:13:49 -0700 (PDT)
Received: from [10.1.36.36] (FVFF763DQ05P.cambridge.arm.com [10.1.36.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD7443F73B;
	Mon, 19 Aug 2024 07:13:20 -0700 (PDT)
Message-ID: <13bc77b7-5f68-44ca-93ce-578ffe029437@arm.com>
Date: Mon, 19 Aug 2024 15:13:19 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/19] arm64: Override set_fixmap_io
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-11-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240819131924.372366-11-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/08/2024 14:19, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Override the set_fixmap_io to set shared permission for the host
> in case of a CC guest. For now we mark it shared unconditionally.
> 
> If/when support for device assignment and device emulation in the realm
> is added in the future then this will need to filter the physical
> address and make the decision accordingly.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v5
> ---
>   arch/arm64/include/asm/fixmap.h |  2 ++
>   arch/arm64/mm/mmu.c             | 17 +++++++++++++++++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
> index 87e307804b99..2c20da3a468c 100644
> --- a/arch/arm64/include/asm/fixmap.h
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -108,6 +108,8 @@ void __init early_fixmap_init(void);
>   #define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
>   
>   extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
> +#define set_fixmap_io set_fixmap_io
> +void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys);
>   
>   #include <asm-generic/fixmap.h>
>   
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 353ea5dc32b8..06b66c23c124 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1193,6 +1193,23 @@ void vmemmap_free(unsigned long start, unsigned long end,
>   }
>   #endif /* CONFIG_MEMORY_HOTPLUG */
>   
> +void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
> +{
> +	pgprot_t prot = FIXMAP_PAGE_IO;
> +
> +	/*
> +	 * The set_fixmap_io maps a single Page covering phys.
> +	 * To make better decision, we stick to the smallest page
> +	 * size supported (4K).
> +	 */
> +	if (!arm64_is_iomem_private(phys, SZ_4K))
> +		prot = pgprot_decrypted(prot);
> +	else
> +		prot = pgprot_encrypted(prot);

With the ioremap_prot_hook introduction, this one looks like should use
that, instead of open coding the same thing. Thoughts ?

Suzuki
