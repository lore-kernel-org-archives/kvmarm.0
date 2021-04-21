Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7562C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 12:20:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37DD36144E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 12:20:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37DD36144E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6B784B4A5;
	Wed, 21 Apr 2021 08:19:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gu2NdnWQmGfu; Wed, 21 Apr 2021 08:19:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52FFF4B443;
	Wed, 21 Apr 2021 08:19:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E58BE4B384
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 08:19:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FLfaWXgg4t6n for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 08:19:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A70E14B36F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 08:19:55 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 530AD6145E;
 Wed, 21 Apr 2021 12:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619007594;
 bh=0a/68dskNDkLo1uroY57KwbRLZLoROR0e1l6xfjDK20=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=vKCh5xS88oZEFh3+M2mJmlwblhZLKM9ca2XwXEkYyFGXs/vJENDTcp2+xVkbz/Mzj
 a336WGXWzU9a73VFVT3k//XwYrweCrOwX9FoEZ+l+wMJLIS6ZWccT0MXaPLhgkIcoW
 Xn/V1hwDCFfL9dCpaHCPUWV8flXl+ZDAdyfpfjvTPz9BhcB5j2/YiiIP8EDCvXkMTa
 SGZLlMLO3ygFxsXJzDB/5B+/T9wRSQ+Lh7rx5YMShZc41aJh9h/IMyNNdqcC5Xvk2k
 jILPvY/LEsPWuJkwDiIP0ddmDjA84qv4go3Q++WnfolKm5AxJlm7flKGb1N5EeO33H
 huVQegj1NaxhQ==
Date: Wed, 21 Apr 2021 15:19:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v2 3/4] arm64: decouple check whether pfn is in linear
 map from pfn_valid()
Message-ID: <YIAYYcWtuwszHMux@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <20210421065108.1987-4-rppt@kernel.org>
 <0a7cc0d4-5d3d-7d6d-f4c3-bb2965b810e6@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0a7cc0d4-5d3d-7d6d-f4c3-bb2965b810e6@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Apr 21, 2021 at 04:29:48PM +0530, Anshuman Khandual wrote:
> 
> On 4/21/21 12:21 PM, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > The intended semantics of pfn_valid() is to verify whether there is a
> > struct page for the pfn in question and nothing else.
> > 
> > Yet, on arm64 it is used to distinguish memory areas that are mapped in the
> > linear map vs those that require ioremap() to access them.
> > 
> > Introduce a dedicated pfn_is_map_memory() wrapper for
> > memblock_is_map_memory() to perform such check and use it where
> > appropriate.
> > 
> > Using a wrapper allows to avoid cyclic include dependencies.
> > 
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > ---
> >  arch/arm64/include/asm/memory.h |  2 +-
> >  arch/arm64/include/asm/page.h   |  1 +
> >  arch/arm64/kvm/mmu.c            |  2 +-
> >  arch/arm64/mm/init.c            | 11 +++++++++++
> >  arch/arm64/mm/ioremap.c         |  4 ++--
> >  arch/arm64/mm/mmu.c             |  2 +-
> >  6 files changed, 17 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index 0aabc3be9a75..194f9f993d30 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -351,7 +351,7 @@ static inline void *phys_to_virt(phys_addr_t x)
> >  
> >  #define virt_addr_valid(addr)	({					\
> >  	__typeof__(addr) __addr = __tag_reset(addr);			\
> > -	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
> > +	__is_lm_address(__addr) && pfn_is_map_memory(virt_to_pfn(__addr));	\
> >  })
> >  
> >  void dump_mem_limit(void);
> > diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> > index 012cffc574e8..99a6da91f870 100644
> > --- a/arch/arm64/include/asm/page.h
> > +++ b/arch/arm64/include/asm/page.h
> > @@ -38,6 +38,7 @@ void copy_highpage(struct page *to, struct page *from);
> >  typedef struct page *pgtable_t;
> >  
> >  extern int pfn_valid(unsigned long);
> > +extern int pfn_is_map_memory(unsigned long);
> 
> Check patch is complaining about this.
> 
> WARNING: function definition argument 'unsigned long' should also have an identifier name
> #50: FILE: arch/arm64/include/asm/page.h:41:
> +extern int pfn_is_map_memory(unsigned long);
> 
> 
> >  
> >  #include <asm/memory.h>
> >  
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 8711894db8c2..23dd99e29b23 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -85,7 +85,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> >  
> >  static bool kvm_is_device_pfn(unsigned long pfn)
> >  {
> > -	return !pfn_valid(pfn);
> > +	return !pfn_is_map_memory(pfn);
> >  }
> >  
> >  /*
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index 3685e12aba9b..dc03bdc12c0f 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -258,6 +258,17 @@ int pfn_valid(unsigned long pfn)
> >  }
> >  EXPORT_SYMBOL(pfn_valid);
> >  
> > +int pfn_is_map_memory(unsigned long pfn)
> > +{
> > +	phys_addr_t addr = PFN_PHYS(pfn);
> > +
> 
> Should also bring with it, the comment regarding upper bits in
> the pfn from arm64 pfn_valid().

I think a reference to the comment in pfn_valid() will suffice.

BTW, I wonder how is that other architectures do not need this check?
 
> > +	if (PHYS_PFN(addr) != pfn)
> > +		return 0;
> > +	
> 
>  ^^^^^ trailing spaces here.
> 
> ERROR: trailing whitespace
> #81: FILE: arch/arm64/mm/init.c:263:
> +^I$

Oops :)
 
> > +	return memblock_is_map_memory(addr);
> > +}
> > +EXPORT_SYMBOL(pfn_is_map_memory);
> > +
> 
> Is the EXPORT_SYMBOL() required to build drivers which will use
> pfn_is_map_memory() but currently use pfn_valid() ?

Yes, this is required for virt_addr_valid() that is used by modules.

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
