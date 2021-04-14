Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF406C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 20:29:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0FFBC61090
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 20:29:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FFBC61090
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A59B74B3CC;
	Wed, 14 Apr 2021 16:29:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yeQPumSESBam; Wed, 14 Apr 2021 16:29:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BA844B3E3;
	Wed, 14 Apr 2021 16:29:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3FB4B3CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 16:29:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QxAzmsO4xrZ1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 16:29:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A60F4B1C8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 16:29:52 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB62F61090;
 Wed, 14 Apr 2021 20:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618432191;
 bh=0/g8QgxcPByWv4b4UdJd4FLad687IHnLM2vVf0ZWjRY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=bqtXXI6cAJ95seHOi/o4nAFhJ6cmvJJ3iQYMhPzjIWkExHdlx8qW3SiuEYaM0ZbZI
 SqlG/khazIjpgkFsNZeYJE0YqMrUJBpSpOb/xeXncRBxBxvk8HcF5jTAdCcBeYu7UA
 dqeZ3w4s4t1e9PzpKaAW9T5x3oV5xw05JxqA4W/nk8pXWO/6lnOH4YGoyD3Y5hOxOK
 OLkp3g6pY7ZhKS3tdc02Vjmlo9GL43D5mcxMnU+nN507gzFgo8NFsOTj8RiIGfH3EY
 3jGFfEVngjqnmqUHYKFS/ghGTuTXbRfPGslgr+/4hS6QkesNPAlwppYYSbuFF52+4J
 /QjLAfgysF3YQ==
Date: Wed, 14 Apr 2021 23:29:42 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Subject: Re: [RFC/RFT PATCH 2/3] arm64: decouple check whether pfn is normal
 memory from pfn_valid()
Message-ID: <YHdQtmuxpqi4wCE/@kernel.org>
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-3-rppt@kernel.org>
 <4a788546-b854-fd35-644a-f1d9075a9a78@arm.com>
 <9c0956f0-494e-5c6b-bdc2-d4213afd5e2f@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9c0956f0-494e-5c6b-bdc2-d4213afd5e2f@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
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

On Wed, Apr 14, 2021 at 05:58:26PM +0200, David Hildenbrand wrote:
> On 08.04.21 07:14, Anshuman Khandual wrote:
> > 
> > On 4/7/21 10:56 PM, Mike Rapoport wrote:
> > > From: Mike Rapoport <rppt@linux.ibm.com>
> > > 
> > > The intended semantics of pfn_valid() is to verify whether there is a
> > > struct page for the pfn in question and nothing else.
> > 
> > Should there be a comment affirming this semantics interpretation, above the
> > generic pfn_valid() in include/linux/mmzone.h ?
> > 
> > > 
> > > Yet, on arm64 it is used to distinguish memory areas that are mapped in the
> > > linear map vs those that require ioremap() to access them.
> > > 
> > > Introduce a dedicated pfn_is_memory() to perform such check and use it
> > > where appropriate.
> > > 
> > > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > > ---
> > >   arch/arm64/include/asm/memory.h | 2 +-
> > >   arch/arm64/include/asm/page.h   | 1 +
> > >   arch/arm64/kvm/mmu.c            | 2 +-
> > >   arch/arm64/mm/init.c            | 6 ++++++
> > >   arch/arm64/mm/ioremap.c         | 4 ++--
> > >   arch/arm64/mm/mmu.c             | 2 +-
> > >   6 files changed, 12 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > > index 0aabc3be9a75..7e77fdf71b9d 100644
> > > --- a/arch/arm64/include/asm/memory.h
> > > +++ b/arch/arm64/include/asm/memory.h
> > > @@ -351,7 +351,7 @@ static inline void *phys_to_virt(phys_addr_t x)
> > >   #define virt_addr_valid(addr)	({					\
> > >   	__typeof__(addr) __addr = __tag_reset(addr);			\
> > > -	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
> > > +	__is_lm_address(__addr) && pfn_is_memory(virt_to_pfn(__addr));	\
> > >   })
> > >   void dump_mem_limit(void);
> > > diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> > > index 012cffc574e8..32b485bcc6ff 100644
> > > --- a/arch/arm64/include/asm/page.h
> > > +++ b/arch/arm64/include/asm/page.h
> > > @@ -38,6 +38,7 @@ void copy_highpage(struct page *to, struct page *from);
> > >   typedef struct page *pgtable_t;
> > >   extern int pfn_valid(unsigned long);
> > > +extern int pfn_is_memory(unsigned long);
> > >   #include <asm/memory.h>
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 8711894db8c2..ad2ea65a3937 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -85,7 +85,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> > >   static bool kvm_is_device_pfn(unsigned long pfn)
> > >   {
> > > -	return !pfn_valid(pfn);
> > > +	return !pfn_is_memory(pfn);
> > >   }
> > >   /*
> > > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > > index 3685e12aba9b..258b1905ed4a 100644
> > > --- a/arch/arm64/mm/init.c
> > > +++ b/arch/arm64/mm/init.c
> > > @@ -258,6 +258,12 @@ int pfn_valid(unsigned long pfn)
> > >   }
> > >   EXPORT_SYMBOL(pfn_valid);
> > > +int pfn_is_memory(unsigned long pfn)
> > > +{
> > > +	return memblock_is_map_memory(PFN_PHYS(pfn));
> > > +}
> > > +EXPORT_SYMBOL(pfn_is_memory);> +
> > 
> > Should not this be generic though ? There is nothing platform or arm64
> > specific in here. Wondering as pfn_is_memory() just indicates that the
> > pfn is linear mapped, should not it be renamed as pfn_is_linear_memory()
> > instead ? Regardless, it's fine either way.
> 
> TBH, I dislike (generic) pfn_is_memory(). It feels like we're mixing
> concepts.

Yeah, at the moment NOMAP is very much arm specific so I'd keep it this way
for now.

>  NOMAP memory vs !NOMAP memory; even NOMAP is some kind of memory
> after all. pfn_is_map_memory() would be more expressive, although still
> sub-optimal.
>
> We'd actually want some kind of arm64-specific pfn_is_system_memory() or the
> inverse pfn_is_device_memory() -- to be improved.

In my current version (to be posted soon) I've started with
pfn_lineary_mapped() but then ended up with pfn_mapped() to make it
"upward" compatible with architectures that use direct rather than linear
map :)

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
