Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA67C43460
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 06:01:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAA09601FF
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 06:01:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAA09601FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 484F94BA62;
	Thu,  8 Apr 2021 02:01:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YlIE5eUouHj9; Thu,  8 Apr 2021 02:01:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E173F4BA44;
	Thu,  8 Apr 2021 02:01:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65D8C4BA2A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 02:01:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ujo4129w4vG3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 02:01:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24EB54BA28
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 02:01:02 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC1B6100B;
 Thu,  8 Apr 2021 06:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617861661;
 bh=2Eu5FGZcoEwFjJBfMlTrnu1Jy+7SZBKfEYnq+Fc+yHI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qoQ88h08KbR8llNDs8V7fGpplG9CMS8nt7qciDzymERLEPnTApBcfAICM7mdUDJD6
 feqJqwJn78ho9Z4rOfLmFDDxf/BziSTQV4Vp7kW4xWJTNezvtbQ1ABw+TW+n+Adqi/
 94jtFe8dMIaDnVVMmhR6wP7QcAIhkWX6isQFC93RglzzlgoIv9oa1dRIvauLbWESCW
 AGRobznqaUup4FR1QPg8acnwT1coMMkvb+A4sSTfEiQ9kfFZtnRv6vDiAj7a3y/hKv
 UYET33Xz/JQCnzYWoA1Y/oiinfDLomxxA6oNP2gzK6HEcdoh6r2/F5h1jjLXdVve5u
 v/nltmUtIqplA==
Date: Thu, 8 Apr 2021 09:00:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [RFC/RFT PATCH 2/3] arm64: decouple check whether pfn is normal
 memory from pfn_valid()
Message-ID: <YG6cFKKimksg+FX3@kernel.org>
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-3-rppt@kernel.org>
 <4a788546-b854-fd35-644a-f1d9075a9a78@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4a788546-b854-fd35-644a-f1d9075a9a78@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Thu, Apr 08, 2021 at 10:44:58AM +0530, Anshuman Khandual wrote:
> 
> On 4/7/21 10:56 PM, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > The intended semantics of pfn_valid() is to verify whether there is a
> > struct page for the pfn in question and nothing else.
> 
> Should there be a comment affirming this semantics interpretation, above the
> generic pfn_valid() in include/linux/mmzone.h ?

Yeah, that would have been helpful :)
 
> > 
> > Yet, on arm64 it is used to distinguish memory areas that are mapped in the
> > linear map vs those that require ioremap() to access them.
> > 
> > Introduce a dedicated pfn_is_memory() to perform such check and use it
> > where appropriate.
> > 
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > ---
> >  arch/arm64/include/asm/memory.h | 2 +-
> >  arch/arm64/include/asm/page.h   | 1 +
> >  arch/arm64/kvm/mmu.c            | 2 +-
> >  arch/arm64/mm/init.c            | 6 ++++++
> >  arch/arm64/mm/ioremap.c         | 4 ++--
> >  arch/arm64/mm/mmu.c             | 2 +-
> >  6 files changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index 0aabc3be9a75..7e77fdf71b9d 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -351,7 +351,7 @@ static inline void *phys_to_virt(phys_addr_t x)
> >  
> >  #define virt_addr_valid(addr)	({					\
> >  	__typeof__(addr) __addr = __tag_reset(addr);			\
> > -	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
> > +	__is_lm_address(__addr) && pfn_is_memory(virt_to_pfn(__addr));	\
> >  })
> >  
> >  void dump_mem_limit(void);
> > diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> > index 012cffc574e8..32b485bcc6ff 100644
> > --- a/arch/arm64/include/asm/page.h
> > +++ b/arch/arm64/include/asm/page.h
> > @@ -38,6 +38,7 @@ void copy_highpage(struct page *to, struct page *from);
> >  typedef struct page *pgtable_t;
> >  
> >  extern int pfn_valid(unsigned long);
> > +extern int pfn_is_memory(unsigned long);
> >  
> >  #include <asm/memory.h>
> >  
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 8711894db8c2..ad2ea65a3937 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -85,7 +85,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> >  
> >  static bool kvm_is_device_pfn(unsigned long pfn)
> >  {
> > -	return !pfn_valid(pfn);
> > +	return !pfn_is_memory(pfn);
> >  }
> >  
> >  /*
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index 3685e12aba9b..258b1905ed4a 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -258,6 +258,12 @@ int pfn_valid(unsigned long pfn)
> >  }
> >  EXPORT_SYMBOL(pfn_valid);
> >  
> > +int pfn_is_memory(unsigned long pfn)
> > +{
> > +	return memblock_is_map_memory(PFN_PHYS(pfn));
> > +}
> > +EXPORT_SYMBOL(pfn_is_memory);> +
> 
> Should not this be generic though ? There is nothing platform or arm64
> specific in here.

As NOMAP itself is quite ARM specific, this check is currently only
relevant for arm64 and maybe arm32.
But probably having an EXPORT_SYMBOL wrapper for memblock_is_map_memory(),
say in memblock does make sense for all architectures that have
KEEP_MEMBLOCK.

> Wondering as pfn_is_memory() just indicates that the
> pfn is linear mapped, should not it be renamed as pfn_is_linear_memory()
> instead ? Regardless, it's fine either way.

Yeah, I agree that naming could be better here. I think that for a generic name
we'd need pfn_is_directly_mapped() so that it can be used on x86 ;-)
 
> >  static phys_addr_t memory_limit = PHYS_ADDR_MAX;
> >  
> >  /*
> > diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> > index b5e83c46b23e..82a369b22ef5 100644
> > --- a/arch/arm64/mm/ioremap.c
> > +++ b/arch/arm64/mm/ioremap.c
> > @@ -43,7 +43,7 @@ static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
> >  	/*
> >  	 * Don't allow RAM to be mapped.
> >  	 */
> > -	if (WARN_ON(pfn_valid(__phys_to_pfn(phys_addr))))
> > +	if (WARN_ON(pfn_is_memory(__phys_to_pfn(phys_addr))))
> >  		return NULL;
> >  
> >  	area = get_vm_area_caller(size, VM_IOREMAP, caller);
> > @@ -84,7 +84,7 @@ EXPORT_SYMBOL(iounmap);
> >  void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
> >  {
> >  	/* For normal memory we already have a cacheable mapping. */
> > -	if (pfn_valid(__phys_to_pfn(phys_addr)))
> > +	if (pfn_is_memory(__phys_to_pfn(phys_addr)))
> >  		return (void __iomem *)__phys_to_virt(phys_addr);
> >  
> >  	return __ioremap_caller(phys_addr, size, __pgprot(PROT_NORMAL),
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index 5d9550fdb9cf..038d20fe163f 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -81,7 +81,7 @@ void set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
> >  pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
> >  			      unsigned long size, pgprot_t vma_prot)
> >  {
> > -	if (!pfn_valid(pfn))
> > +	if (!pfn_is_memory(pfn))
> >  		return pgprot_noncached(vma_prot);
> >  	else if (file->f_flags & O_SYNC)
> >  		return pgprot_writecombine(vma_prot);
> > 

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
