Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10516C07E9D
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 19:43:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A04D4B2B7;
	Tue, 27 Sep 2022 15:43:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eXJREI16yp-1; Tue, 27 Sep 2022 15:43:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E2B74B648;
	Tue, 27 Sep 2022 15:43:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D5244B3C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 15:43:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id viSmHj6F82+M for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 15:43:17 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E375B4B2B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 15:43:16 -0400 (EDT)
Date: Tue, 27 Sep 2022 12:43:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1664307795;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3hEHVsZpxELrmfMYWxboxBch3S1HxgT4B9JtEXIyMdM=;
 b=UeuakMtB+3SYed27wXoNTVLPWpp5/h+HaZi99tV8lAroNvCYiNWwqy37CxBga7K0ppjgAq
 gelaQtUJ90lwvJk1CDzOZaJr7oY4j4oSUJOKmYdTvphBM60cW0OMB7TNw/CnCSiuTuikzw
 wXg/JadMBIXbeXW3+QVyab1wCy9jhkY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Limit stage2_apply_range() batch size to
 1GB
Message-ID: <YzNSToqnQidglUg9@google.com>
References: <20220926222146.661633-1-oliver.upton@linux.dev>
 <86v8p96og1.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86v8p96og1.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Tue, Sep 27, 2022 at 07:34:22AM -0400, Marc Zyngier wrote:

[...]

> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index c9a13e487187..5d05bb92e129 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -31,6 +31,12 @@ static phys_addr_t hyp_idmap_vector;
> >  
> >  static unsigned long io_map_base;
> >  
> > +static inline phys_addr_t stage2_apply_range_next(phys_addr_t addr, phys_addr_t end)
> 
> Please drop the inline. I'm sure the compiler will perform its
> magic.
> 
> Can I also bikeshed a bit about the name? This doesn't "apply"
> anything, nor does it return the next range. It really computes the
> end of the current one.
> 
> Something like stage2_range_addr_end() would at least be consistent
> with the rest of the arm64 code (grep for _addr_end ...).

Bikeshed all you want :) But yeah, I like your suggestion.

> > +{
> > +	phys_addr_t boundary = round_down(addr + SZ_1G, SZ_1G);
> 
> nit: the rest of the code is using ALIGN_DOWN(). Any reason why this
> can't be used here?

Nope!

> > +
> > +	return (boundary - 1 < end - 1) ? boundary : end;
> > +}
> >  
> >  /*
> >   * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
> > @@ -52,7 +58,7 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
> >  		if (!pgt)
> >  			return -EINVAL;
> >  
> > -		next = stage2_pgd_addr_end(kvm, addr, end);
> > +		next = stage2_apply_range_next(addr, end);
> >  		ret = fn(pgt, addr, next - addr);
> >  		if (ret)
> >  			break;
> > 
> 
> The main problem I see with this is that some entries now get visited
> multiple times if they cover more than a single 1GB entry (like a
> 512GB level-0 entry with 4k pages and 48bit IPA) . As long as this
> isn't destructive (CMOs, for example), this is probably OK. For
> operations that are not idempotent (such as stage2_unmap_walker), this
> is a significant change in behaviour.
> 
> My concern is that we have on one side a walker that is strictly
> driven by the page-table sizes, and we now get an arbitrary value that
> doesn't necessarily a multiple of block sizes. Yes, this works right
> now because you can't create a block mapping larger than 1GB with any
> of the supported page size.
> 
> But with 52bit VA/PA support, this changes: we can have 512GB (4k),
> 64GB (16k) and 4TB (64k) block mappings at S2. We don't support this
> yet at S2, but when this hits, we'll be in potential trouble.

Ah, I didn't fully capture the reasoning about the batch size. I had
thought about batching by operating on at most 1 block of the largest
supported granularity, but that felt like an inefficient walk restarting
from root every 32M (for 16K paging).

OTOH, if/when we add support for larger blocks in S2 we will run into
the same exact problem if we batch on the largest block size. If
dirty logging caused the large blocks to be shattered down to leaf
granularity then we will visit a crazy amount of PTEs before releasing
the lock.

I guess what I'm getting at is we need to detect lock contention and the
need to reschedule in the middle of the walk instead of at some
predetermined boundary, though that ventures into the territory of 'TDP
MMU' features...

So, seems to me we can crack this a few ways:

  1.Batch at the arbitrary 1GB since it works currently and produces a
    more efficient walk for all page sizes. I can rework some of the
    logic in kvm_level_supports_block_mapping() such that we can
    BUILD_BUG_ON() if the largest block size exceeds 1GB. Kicks the can
    down the road on a better implementation.

  2.Batch by the largest supported block mapping size. This will result
    in less efficient walks for !4K page sizes and likely produce soft
    lockups when we support even larger blocks. Nonetheless, the
    implementation will remain correct regardless of block size.

  3.Test for lock contention and need_resched() in the middle of the
    walk, rewalking from wherever we left off when scheduled again. TDP
    MMU already does this, so it could be a wasted effort adding support
    for it to the ARM MMU if we are to switch over at some point.

WDYT?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
