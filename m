Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63203C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 15:58:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9BDC613C3
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 15:58:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9BDC613C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 029494B301;
	Tue, 20 Apr 2021 11:58:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lIhFJ4iFPAk8; Tue, 20 Apr 2021 11:58:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FDAA4B3C3;
	Tue, 20 Apr 2021 11:58:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E271E4B3B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 11:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eAQPDYjOFljs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 11:58:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85BFF4B301
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 11:58:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618934282;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=kRUjVbp/xhnBKh4OUO4qLwF9cw2sRaU2IDxMzgRt9EE=;
 b=WKy233fWkxUbPOls6EwSxRu7rUlxpiH33DQymgc/cpKaIfWk7+X2+qxn6ZAJaBwoS//AsB
 tIhLSUpKHGWlb1yKyZU8QPBMRvPCex3VUItozDXcGBazP1uKqpuDCn3mpeKOetMQH1kWHX
 uAFx5Dy8tzqPxqPDx5TEjuXqedHtuOc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-Fqm-tLNHPimOXO_XlvX_3w-1; Tue, 20 Apr 2021 11:58:00 -0400
X-MC-Unique: Fqm-tLNHPimOXO_XlvX_3w-1
Received: by mail-wr1-f70.google.com with SMTP id
 k1-20020adfd2210000b02901040d1dbcaeso11053306wrh.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 08:58:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:organization:subject
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=kRUjVbp/xhnBKh4OUO4qLwF9cw2sRaU2IDxMzgRt9EE=;
 b=D9nBq3VaGaW0Jea0B9kZU2RvTg1hxLtZ2xrXL3BYP8dPsu2Kwpw9mIc6BMC0i2jEx2
 gebCTb9IYXJAEhFQ1ZjubQtG9Qdwo8jPiWWxoXH3vXljjMtGEGrbLB7Li0Zu0AiA5SLR
 Ybkcl0GlJe0xCAw19hClQBY2NC9EFAW1TEfYhW+1MQAL1c65SsYPLNA8MBeMUI/whaGz
 hm5Xjv6OEy78TXm8S+PrbOMV/ux+Q937FS/uP3FwvGOYtI6URpuUswM8MeKOCx8XYmi0
 sIv4Fl5Oz+Savd5r07cuodiYtlPVGz6TNu/jcGuNB+QEIatTepwqgLyu0GKPZjEbjnR9
 YxZg==
X-Gm-Message-State: AOAM530+fnYwm3DkOVIbiCAXB7Y23e3JPQUmsTxiT6jiEthZtwRaWz6z
 Hagc3zg9An2x3mCeXkUdIvuvM2droNz49i6btN+ARuRL7tlwDqHg6gBxQ0lbSDJAhZGXTN636/b
 GxvC9xi/9hfmtjfgIVQlel8JI
X-Received: by 2002:a7b:c312:: with SMTP id k18mr5229610wmj.89.1618934279119; 
 Tue, 20 Apr 2021 08:57:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHImaAxee8YH0d/aTWDGKEJNDp2XNJZPNDFkBuyM4cK1Nn3spewv6GbBlRucz+5ba84q6ojQ==
X-Received: by 2002:a7b:c312:: with SMTP id k18mr5229585wmj.89.1618934278815; 
 Tue, 20 Apr 2021 08:57:58 -0700 (PDT)
Received: from [192.168.3.132] (p4ff2390a.dip0.t-ipconnect.de. [79.242.57.10])
 by smtp.gmail.com with ESMTPSA id
 b12sm9569161wmj.1.2021.04.20.08.57.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 20 Apr 2021 08:57:58 -0700 (PDT)
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-4-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1 3/4] arm64: decouple check whether pfn is in linear map
 from pfn_valid()
Message-ID: <29b51a80-1543-fcec-6f5b-5ae21b78e1e9@redhat.com>
Date: Tue, 20 Apr 2021 17:57:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210420090925.7457-4-rppt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 20.04.21 11:09, Mike Rapoport wrote:
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
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>   arch/arm64/include/asm/memory.h | 2 +-
>   arch/arm64/include/asm/page.h   | 1 +
>   arch/arm64/kvm/mmu.c            | 2 +-
>   arch/arm64/mm/init.c            | 6 ++++++
>   arch/arm64/mm/ioremap.c         | 4 ++--
>   arch/arm64/mm/mmu.c             | 2 +-
>   6 files changed, 12 insertions(+), 5 deletions(-)
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
> index 012cffc574e8..99a6da91f870 100644
> --- a/arch/arm64/include/asm/page.h
> +++ b/arch/arm64/include/asm/page.h
> @@ -38,6 +38,7 @@ void copy_highpage(struct page *to, struct page *from);
>   typedef struct page *pgtable_t;
>   
>   extern int pfn_valid(unsigned long);
> +extern int pfn_is_map_memory(unsigned long);
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
> index 3685e12aba9b..c54e329aca15 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -258,6 +258,12 @@ int pfn_valid(unsigned long pfn)
>   }
>   EXPORT_SYMBOL(pfn_valid);
>   
> +int pfn_is_map_memory(unsigned long pfn)
> +{

I think you might have to add (see pfn_valid())

if (PHYS_PFN(PFN_PHYS(pfn)) != pfn)
	return 0;

to catch false positives.

> +	return memblock_is_map_memory(PFN_PHYS(pfn));
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

As discussed, in the future it would be nice if we could just rely on 
the memmap state. There are cases where pfn_is_map_memory() will now be 
slower than pfn_valid() -- e.g., we don't check for valid_section() in 
case of CONFIG_SPARSEMEM. This would apply where pfn_valid() would have 
returned "0".

As we're not creating the direct map, kern_addr_valid() shouldn't need 
love. It'd be some kind of ugly if some generic code used by arm64 would 
be relying in case of arm64 on pfn_valid() to return the expected 
result; I doubt it.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
