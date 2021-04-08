Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA88C433B4
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 05:14:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1F4861182
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 05:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1F4861182
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0EB4B3D8;
	Thu,  8 Apr 2021 01:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AcaaRy73MYId; Thu,  8 Apr 2021 01:14:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA00F4B50B;
	Thu,  8 Apr 2021 01:14:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54A844B3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 01:14:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GQeZoJYyj8q2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 01:14:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C942B4B88E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 01:14:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D6251424;
 Wed,  7 Apr 2021 22:14:11 -0700 (PDT)
Received: from [10.163.67.84] (unknown [10.163.67.84])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 174233F73D;
 Wed,  7 Apr 2021 22:14:07 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [RFC/RFT PATCH 2/3] arm64: decouple check whether pfn is normal
 memory from pfn_valid()
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-3-rppt@kernel.org>
Message-ID: <4a788546-b854-fd35-644a-f1d9075a9a78@arm.com>
Date: Thu, 8 Apr 2021 10:44:58 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210407172607.8812-3-rppt@kernel.org>
Content-Language: en-US
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


On 4/7/21 10:56 PM, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> The intended semantics of pfn_valid() is to verify whether there is a
> struct page for the pfn in question and nothing else.

Should there be a comment affirming this semantics interpretation, above the
generic pfn_valid() in include/linux/mmzone.h ?

> 
> Yet, on arm64 it is used to distinguish memory areas that are mapped in the
> linear map vs those that require ioremap() to access them.
> 
> Introduce a dedicated pfn_is_memory() to perform such check and use it
> where appropriate.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/arm64/include/asm/memory.h | 2 +-
>  arch/arm64/include/asm/page.h   | 1 +
>  arch/arm64/kvm/mmu.c            | 2 +-
>  arch/arm64/mm/init.c            | 6 ++++++
>  arch/arm64/mm/ioremap.c         | 4 ++--
>  arch/arm64/mm/mmu.c             | 2 +-
>  6 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 0aabc3be9a75..7e77fdf71b9d 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -351,7 +351,7 @@ static inline void *phys_to_virt(phys_addr_t x)
>  
>  #define virt_addr_valid(addr)	({					\
>  	__typeof__(addr) __addr = __tag_reset(addr);			\
> -	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
> +	__is_lm_address(__addr) && pfn_is_memory(virt_to_pfn(__addr));	\
>  })
>  
>  void dump_mem_limit(void);
> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> index 012cffc574e8..32b485bcc6ff 100644
> --- a/arch/arm64/include/asm/page.h
> +++ b/arch/arm64/include/asm/page.h
> @@ -38,6 +38,7 @@ void copy_highpage(struct page *to, struct page *from);
>  typedef struct page *pgtable_t;
>  
>  extern int pfn_valid(unsigned long);
> +extern int pfn_is_memory(unsigned long);
>  
>  #include <asm/memory.h>
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8711894db8c2..ad2ea65a3937 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -85,7 +85,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>  
>  static bool kvm_is_device_pfn(unsigned long pfn)
>  {
> -	return !pfn_valid(pfn);
> +	return !pfn_is_memory(pfn);
>  }
>  
>  /*
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 3685e12aba9b..258b1905ed4a 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -258,6 +258,12 @@ int pfn_valid(unsigned long pfn)
>  }
>  EXPORT_SYMBOL(pfn_valid);
>  
> +int pfn_is_memory(unsigned long pfn)
> +{
> +	return memblock_is_map_memory(PFN_PHYS(pfn));
> +}
> +EXPORT_SYMBOL(pfn_is_memory);> +

Should not this be generic though ? There is nothing platform or arm64
specific in here. Wondering as pfn_is_memory() just indicates that the
pfn is linear mapped, should not it be renamed as pfn_is_linear_memory()
instead ? Regardless, it's fine either way.

>  static phys_addr_t memory_limit = PHYS_ADDR_MAX;
>  
>  /*
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index b5e83c46b23e..82a369b22ef5 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -43,7 +43,7 @@ static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
>  	/*
>  	 * Don't allow RAM to be mapped.
>  	 */
> -	if (WARN_ON(pfn_valid(__phys_to_pfn(phys_addr))))
> +	if (WARN_ON(pfn_is_memory(__phys_to_pfn(phys_addr))))
>  		return NULL;
>  
>  	area = get_vm_area_caller(size, VM_IOREMAP, caller);
> @@ -84,7 +84,7 @@ EXPORT_SYMBOL(iounmap);
>  void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
>  {
>  	/* For normal memory we already have a cacheable mapping. */
> -	if (pfn_valid(__phys_to_pfn(phys_addr)))
> +	if (pfn_is_memory(__phys_to_pfn(phys_addr)))
>  		return (void __iomem *)__phys_to_virt(phys_addr);
>  
>  	return __ioremap_caller(phys_addr, size, __pgprot(PROT_NORMAL),
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 5d9550fdb9cf..038d20fe163f 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -81,7 +81,7 @@ void set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>  pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>  			      unsigned long size, pgprot_t vma_prot)
>  {
> -	if (!pfn_valid(pfn))
> +	if (!pfn_is_memory(pfn))
>  		return pgprot_noncached(vma_prot);
>  	else if (file->f_flags & O_SYNC)
>  		return pgprot_writecombine(vma_prot);
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
