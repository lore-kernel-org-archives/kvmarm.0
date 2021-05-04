Return-Path: <SRS0=Rb5J=J7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7D6C433ED
	for <kvmarm@archiver.kernel.org>; Tue,  4 May 2021 15:29:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D7E5610E6
	for <kvmarm@archiver.kernel.org>; Tue,  4 May 2021 15:29:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D7E5610E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1034B23F;
	Tue,  4 May 2021 11:29:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dxiVAq44vxox; Tue,  4 May 2021 11:29:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B54E64B6C5;
	Tue,  4 May 2021 11:29:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EDD94B6B7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 May 2021 11:29:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uOTj2z2NM5jc for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 May 2021 11:29:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 595C44B6B6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 May 2021 11:29:47 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BDA060FDC;
 Tue,  4 May 2021 15:29:42 +0000 (UTC)
Date: Tue, 4 May 2021 16:29:40 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v11 1/6] arm64: mte: Sync tags for pages where PTE is
 untagged
Message-ID: <20210504152938.GC8078@arm.com>
References: <20210416154309.22129-1-steven.price@arm.com>
 <20210416154309.22129-2-steven.price@arm.com>
 <20210427174357.GA17872@arm.com>
 <0ab0017c-1eaf-201e-587f-101e03da6b80@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0ab0017c-1eaf-201e-587f-101e03da6b80@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Apr 29, 2021 at 05:06:05PM +0100, Steven Price wrote:
> On 27/04/2021 18:43, Catalin Marinas wrote:
> > On Fri, Apr 16, 2021 at 04:43:04PM +0100, Steven Price wrote:
> > > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > > index e17b96d0e4b5..cf4b52a33b3c 100644
> > > --- a/arch/arm64/include/asm/pgtable.h
> > > +++ b/arch/arm64/include/asm/pgtable.h
> > > @@ -312,7 +312,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
> > >   		__sync_icache_dcache(pte);
> > >   	if (system_supports_mte() &&
> > > -	    pte_present(pte) && pte_tagged(pte) && !pte_special(pte))
> > > +	    pte_present(pte) && (pte_val(pte) & PTE_USER) && !pte_special(pte))
> > 
> > I would add a pte_user() macro here or, if we restore the tags only when
> > the page is readable, use pte_access_permitted(pte, false). Also add a
> > comment why we do this.
> 
> pte_access_permitted() looks like it describes what we want (user space can
> access the memory). I'll add the following comment:
> 
>  /*
>   * If the PTE would provide user space will access to the tags

I think drop "will".

>   * associated with it then ensure that the MTE tags are synchronised.
>   * Exec-only mappings don't expose tags (instruction fetches don't
>   * check tags).
>   */

Sounds fine.

> > There's also the pte_user_exec() case which may not have the PTE_USER
> > set (exec-only permission) but I don't think it matters. We don't do tag
> > checking on instruction fetches, so if the user adds a PROT_READ to it,
> > it would go through set_pte_at() again. I'm not sure KVM does anything
> > special with exec-only mappings at stage 2, I suspect they won't be
> > accessible by the guest (but needs checking).
> 
> It comes down to the behaviour of get_user_pages(). AFAICT that will fail if
> the memory is exec-only, so no stage 2 mapping will be created. Which of
> course means the guest can't do anything with that memory. That certainly
> seems like the only sane behaviour even without MTE.

That's my understanding as well. The get_user_pages_fast() path uses
pte_access_permitted() and should return false. The slower
get_user_pages() relies on checking the vma flags and it checks for
VM_READ.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
