Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFF4C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 17:57:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF2F120709
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 17:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYIl2/io"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF2F120709
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44EA84B272;
	Thu,  3 Sep 2020 13:57:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WLpdZbupi0fP; Thu,  3 Sep 2020 13:57:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE494B2AE;
	Thu,  3 Sep 2020 13:57:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C92C24B275
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 13:57:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YTLywGyt8d9H for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 13:57:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEFE14B272
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 13:57:09 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1B16B20709;
 Thu,  3 Sep 2020 17:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599155828;
 bh=2XdIHt52yGXUwXroS4penvSseXtOpwUM7768fr+Nxs0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=OYIl2/iooQM9oQC0nlZG9sDIqd/xYwgtOg6VMWOLVBG4LJQzN18kpFAz5sd852tDv
 NG33WdJFquZEcbGDKCg7hi+/v8nnMY+vsl1pUFPfNaSfswAIS5v34skZcsjyVr76Rb
 pcUgNYMtgvTMaN7siXy1EFuzPJvLsIQH4el3Jw1A=
Date: Thu, 3 Sep 2020 18:57:03 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 09/21] KVM: arm64: Convert unmap_stage2_range() to
 generic page-table API
Message-ID: <20200903175702.GA8078@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-10-will@kernel.org>
 <1f2e88b7-0265-195f-3bd8-4e1d5b8694e3@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1f2e88b7-0265-195f-3bd8-4e1d5b8694e3@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

On Wed, Sep 02, 2020 at 05:23:08PM +0100, Alexandru Elisei wrote:
> On 8/25/20 10:39 AM, Will Deacon wrote:
> > Convert unmap_stage2_range() to use kvm_pgtable_stage2_unmap() instead
> > of walking the page-table directly.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/mmu.c | 57 +++++++++++++++++++++++++-------------------
> >  1 file changed, 32 insertions(+), 25 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 704b471a48ce..751ce2462765 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -39,6 +39,33 @@ static bool is_iomap(unsigned long flags)
> >  	return flags & KVM_S2PTE_FLAG_IS_IOMAP;
> >  }
> >  
> > +/*
> > + * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
> > + * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
> > + * CONFIG_LOCKUP_DETECTOR, CONFIG_LOCKDEP. Additionally, holding the lock too
> > + * long will also starve other vCPUs. We have to also make sure that the page
> > + * tables are not freed while we released the lock.
> > + */
> > +#define stage2_apply_range(kvm, addr, end, fn, resched)			\
> > +({									\
> > +	int ret;							\
> > +	struct kvm *__kvm = (kvm);					\
> > +	bool __resched = (resched);					\
> > +	u64 next, __addr = (addr), __end = (end);			\
> > +	do {								\
> > +		struct kvm_pgtable *pgt = __kvm->arch.mmu.pgt;		\
> > +		if (!pgt)						\
> > +			break;						\
> 
> I'm 100% sure there's a reason why we've dropped the READ_ONCE, but it still looks
> to me like the compiler might decide to optimize by reading pgt once at the start
> of the loop and stashing it in a register. Would you mind explaining what I am
> missing?

The load always happens with the mmu_lock held, so I think it's not a
problem because it means that the pointer is stable.
spin_lock()/spin_unlock() imply compiler barriers.

> > +		next = stage2_pgd_addr_end(__kvm, __addr, __end);	\
> > +		ret = fn(pgt, __addr, next - __addr);			\
> > +		if (ret)						\
> > +			break;						\
> > +		if (__resched && next != __end)				\
> > +			cond_resched_lock(&__kvm->mmu_lock);		\
> > +	} while (__addr = next, __addr != __end);			\
> > +	ret;								\
> > +})
> 
> This seems unusual to me. We have a non-trivial, multiline macro which calls
> cond_resched(), has 6 local variables, and is called from exactly one place.I am
> curious why we are not open coding the loop in __unmap_stage2_range() or using a
> function.

It's called from three places. That said, I think it's like this because in
an earlier life it was used as an iterator and therefore had to be a macro.
I can try moving it into a function instead.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
