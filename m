Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61386C43460
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 08:57:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B29D661460
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 08:57:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B29D661460
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F8F4B4FA;
	Thu, 22 Apr 2021 04:57:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6JczpQ7PakI2; Thu, 22 Apr 2021 04:57:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E947A4B4EB;
	Thu, 22 Apr 2021 04:57:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9375F4B4D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 04:57:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c7a4LS7qySuZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 04:57:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68CFD4B49F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 04:57:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619081859;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oIBj66zrZyUe4ZvWNAXgo+JuFRJz0vbgrSJAOGRSdws=;
 b=W72Wnm570B4XmKtmVf6MBWE2e3gyyY11WaRxylyQAF25PC+cQij0IeW/FdpfZW7tUpc5iK
 Bk7h3SJPoDAkE/RHmWHDB9k7Y6LuOTgvh97HudaJeKMOZfKxxOIfZ474DT4Ry83SerorNF
 rKd0qfrxo9BlYvghjxZRvf7R32eiriE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-6j9ykLmTOfK4Nkf-VIOxIg-1; Thu, 22 Apr 2021 04:57:37 -0400
X-MC-Unique: 6j9ykLmTOfK4Nkf-VIOxIg-1
Received: by mail-wr1-f69.google.com with SMTP id
 j16-20020adfd2100000b02901022328749eso13482265wrh.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 01:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=oIBj66zrZyUe4ZvWNAXgo+JuFRJz0vbgrSJAOGRSdws=;
 b=luoeguTV5vhf2R0gM7bTwTvcgH3QyAXOhYN3vX4fW6ENojJtrtkse4KxNkoYgRjmts
 2obIHN9T+1xx6Dw6lyJoiDTCGsYg4cdYq6q4IPJoogoPjhoGXEYzr9LFR9ZCp+pzmKlX
 xrKZ90WXx/gFx5VkNQLEWjM2Qb57HWe6Ts9oBEwKZLUAoohjhpB4T6Qe/LVxN2630KH/
 jtZUcb8AhLLoR0YRNkm13X9wT6pe3+j0PFiKXevFKb2IbrWRiJeOePCo8si+7KTE1Mp8
 hUa9wqyVM/jwwKvdFmklJ0OQf32oCTccV8bgP8CXprXsPbavFIzarNumR/xB7RVztJbx
 DILg==
X-Gm-Message-State: AOAM5335Dped6IHW4dP1QHR9kkfdIEL2VmuytBapMLsFnfIai6ktq+30
 lJ2DSBO/oFydG7nQq24SlQQg6aIgh+heuN5mhKNW8xnSheWu2eXhszxdlTXyk2YCVsrZax6bqcn
 qOoy5gTHjXOBQ7zBFkckZUp1k
X-Received: by 2002:a5d:4d92:: with SMTP id b18mr2781998wru.269.1619081856137; 
 Thu, 22 Apr 2021 01:57:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9GgNZ576++3awjONvNnTZg6aX15DKGFHF5B2kOpG6WOphS2Kg3Qfdb7AfYfoZjofNzuVBag==
X-Received: by 2002:a5d:4d92:: with SMTP id b18mr2781956wru.269.1619081855793; 
 Thu, 22 Apr 2021 01:57:35 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23eb0.dip0.t-ipconnect.de. [79.242.62.176])
 by smtp.gmail.com with ESMTPSA id h8sm2072267wmq.19.2021.04.22.01.57.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 22 Apr 2021 01:57:35 -0700 (PDT)
Subject: Re: [PATCH v3 3/4] arm64: decouple check whether pfn is in linear map
 from pfn_valid()
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210422061902.21614-1-rppt@kernel.org>
 <20210422061902.21614-4-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <041411e9-0fba-f053-d901-10f1d7a8cc5e@redhat.com>
Date: Thu, 22 Apr 2021 10:57:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210422061902.21614-4-rppt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 22.04.21 08:19, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> The intended semantics of pfn_valid() is to verify whether there is a
> struct page for the pfn in question and nothing else.
> 
> Yet, on arm64 it is used to distinguish memory areas that are mapped in the
> linear map vs those that require ioremap() to access them.
> 
> Introduce a dedicated pfn_is_map_memory() wrapper for
> memblock_is_map_memory() to perform such check and use it where
> appropriate.
> 
> Using a wrapper allows to avoid cyclic include dependencies.
> 
> While here also update style of pfn_valid() so that both pfn_valid() and
> pfn_is_map_memory() declarations will be consistent.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>   arch/arm64/include/asm/memory.h |  2 +-
>   arch/arm64/include/asm/page.h   |  3 ++-
>   arch/arm64/kvm/mmu.c            |  2 +-
>   arch/arm64/mm/init.c            | 12 ++++++++++++
>   arch/arm64/mm/ioremap.c         |  4 ++--
>   arch/arm64/mm/mmu.c             |  2 +-
>   6 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 0aabc3be9a75..194f9f993d30 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -351,7 +351,7 @@ static inline void *phys_to_virt(phys_addr_t x)
>   
>   #define virt_addr_valid(addr)	({					\
>   	__typeof__(addr) __addr = __tag_reset(addr);			\
> -	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
> +	__is_lm_address(__addr) && pfn_is_map_memory(virt_to_pfn(__addr));	\
>   })
>   
>   void dump_mem_limit(void);
> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> index 012cffc574e8..75ddfe671393 100644
> --- a/arch/arm64/include/asm/page.h
> +++ b/arch/arm64/include/asm/page.h
> @@ -37,7 +37,8 @@ void copy_highpage(struct page *to, struct page *from);
>   
>   typedef struct page *pgtable_t;
>   
> -extern int pfn_valid(unsigned long);
> +int pfn_valid(unsigned long pfn);
> +int pfn_is_map_memory(unsigned long pfn);
>   
>   #include <asm/memory.h>
>   
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8711894db8c2..23dd99e29b23 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -85,7 +85,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   
>   static bool kvm_is_device_pfn(unsigned long pfn)
>   {
> -	return !pfn_valid(pfn);
> +	return !pfn_is_map_memory(pfn);
>   }
>   
>   /*
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 3685e12aba9b..966a7a18d528 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -258,6 +258,18 @@ int pfn_valid(unsigned long pfn)
>   }
>   EXPORT_SYMBOL(pfn_valid);
>   
> +int pfn_is_map_memory(unsigned long pfn)
> +{
> +	phys_addr_t addr = PFN_PHYS(pfn);
> +
> +	/* avoid false positives for bogus PFNs, see comment in pfn_valid() */
> +	if (PHYS_PFN(addr) != pfn)
> +		return 0;
> +
> +	return memblock_is_map_memory(addr);
> +}
> +EXPORT_SYMBOL(pfn_is_map_memory);
> +
>   static phys_addr_t memory_limit = PHYS_ADDR_MAX;
>   
>   /*
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index b5e83c46b23e..b7c81dacabf0 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -43,7 +43,7 @@ static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
>   	/*
>   	 * Don't allow RAM to be mapped.
>   	 */
> -	if (WARN_ON(pfn_valid(__phys_to_pfn(phys_addr))))
> +	if (WARN_ON(pfn_is_map_memory(__phys_to_pfn(phys_addr))))
>   		return NULL;
>   
>   	area = get_vm_area_caller(size, VM_IOREMAP, caller);
> @@ -84,7 +84,7 @@ EXPORT_SYMBOL(iounmap);
>   void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
>   {
>   	/* For normal memory we already have a cacheable mapping. */
> -	if (pfn_valid(__phys_to_pfn(phys_addr)))
> +	if (pfn_is_map_memory(__phys_to_pfn(phys_addr)))
>   		return (void __iomem *)__phys_to_virt(phys_addr);
>   
>   	return __ioremap_caller(phys_addr, size, __pgprot(PROT_NORMAL),
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 5d9550fdb9cf..26045e9adbd7 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -81,7 +81,7 @@ void set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>   pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>   			      unsigned long size, pgprot_t vma_prot)
>   {
> -	if (!pfn_valid(pfn))
> +	if (!pfn_is_map_memory(pfn))
>   		return pgprot_noncached(vma_prot);
>   	else if (file->f_flags & O_SYNC)
>   		return pgprot_writecombine(vma_prot);
> 

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
