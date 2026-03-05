Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA1D1F7916
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 19:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772738363; cv=none; b=PkAZ0E0A85a0hEp7MscZhodweRHzc1Mm2RRaCAXbWcAYmdTak87/WXl/s9KBEzoZ0U8z9GB0sRUQ1ijxM3ndbxKi6QmOKkclClZf/cnnndWJ0Qf3wUCC3T6oLTyuCVEsSgKw8oRlJYpznWG98jxa17TSXjpI88LgJkuwFhWeUyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772738363; c=relaxed/simple;
	bh=J3okvfMBInsqxIlz861wpiBu9FRYB9FbAHKO4Qy5oyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bmm4GoiUAOJ3Ksbx8UXszXjSVUQahG/412stwkeZSXpKdE+ElR8Xwjv/0YAWcOVXq+uDolJ83Ey98MV0LPw/pNts8KjGt8m0Cl/zCCG4LLn7+XxiVe5C+BYRs2cEilmvExsN8WM/VX8GV1rOYAf9ZhaTs29+hN6AJXVkn7+lHV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8799497;
	Thu,  5 Mar 2026 11:19:13 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 888263F694;
	Thu,  5 Mar 2026 11:19:18 -0800 (PST)
Date: Thu, 5 Mar 2026 19:19:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/4] arm64: tlb: Pass the corresponding mm to
 __tlbi_sync_s1ish()
Message-ID: <aanXM7YWMAJW6qk7@arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-3-catalin.marinas@arm.com>
 <aamULrOkm8jd_9UY@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamULrOkm8jd_9UY@willie-the-truck>

On Thu, Mar 05, 2026 at 02:33:18PM +0000, Will Deacon wrote:
> On Mon, Mar 02, 2026 at 04:57:55PM +0000, Catalin Marinas wrote:
> > The mm structure will be used for workarounds that need limiting to
> > specific tasks.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > ---
> >  arch/arm64/include/asm/tlbflush.h | 10 +++++-----
> >  arch/arm64/kernel/sys_compat.c    |  2 +-
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> > index 19be0f7bfca5..14f116bfec73 100644
> > --- a/arch/arm64/include/asm/tlbflush.h
> > +++ b/arch/arm64/include/asm/tlbflush.h
> > @@ -185,7 +185,7 @@ do {										\
> >   * Complete broadcast TLB maintenance issued by the host which invalidates
> >   * stage 1 information in the host's own translation regime.
> >   */
> > -static inline void __tlbi_sync_s1ish(void)
> > +static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
> >  {
> >  	dsb(ish);
> >  	__repeat_tlbi_sync(vale1is, 0);
> > @@ -317,7 +317,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
> >  	asid = __TLBI_VADDR(0, ASID(mm));
> >  	__tlbi(aside1is, asid);
> >  	__tlbi_user(aside1is, asid);
> > -	__tlbi_sync_s1ish();
> > +	__tlbi_sync_s1ish(mm);
> >  	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
> >  }
> >  
> > @@ -371,7 +371,7 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
> >  				  unsigned long uaddr)
> >  {
> >  	flush_tlb_page_nosync(vma, uaddr);
> > -	__tlbi_sync_s1ish();
> > +	__tlbi_sync_s1ish(vma->vm_mm);
> >  }
> >  
> >  static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
> > @@ -391,7 +391,7 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
> >   */
> >  static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
> >  {
> > -	__tlbi_sync_s1ish();
> > +	__tlbi_sync_s1ish(NULL);
> 
> Hmm, it seems a bit rubbish to pass NULL here as that means that we'll
> deploy the mitigation regardless of the mm flags when finishing the
> batch.
> 
> It also looks like we could end up doing the workaround multiple times
> if arch_tlbbatch_add_pending() is passed a large enough region that we
> call __flush_tlb_range_limit_excess() fires.
> 
> So perhaps we should stash the mm in 'struct arch_tlbflush_unmap_batch'
> alongside some state to track whether or not we have uncompleted TLB
> maintenance in flight?

The problem is that arch_tlbbatch_flush() can be called to synchronise
multiple mm structures that were touched by TTU. We can't have the mm in
arch_tlbflush_unmap_batch. But we can track if any of the mms had
MMCF_SME_DVMSYNC flag set, something like below (needs testing, tidying
up). TBH, I did not notice any problem in benchmarking as I guess we
haven't exercised the TTU path much, so did not bother to optimise it.

For the TTU case, I don't think we need to worry about the excess limit
and doing the IPI twice. But I'll double check the code paths tomorrow.

diff --git a/arch/arm64/include/asm/tlbbatch.h b/arch/arm64/include/asm/tlbbatch.h
index fedb0b87b8db..e756eaca6cb8 100644
--- a/arch/arm64/include/asm/tlbbatch.h
+++ b/arch/arm64/include/asm/tlbbatch.h
@@ -7,6 +7,8 @@ struct arch_tlbflush_unmap_batch {
 	 * For arm64, HW can do tlb shootdown, so we don't
 	 * need to record cpumask for sending IPI
 	 */
+
+	bool sme_dvmsync;
 };

 #endif /* _ARCH_ARM64_TLBBATCH_H */
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index e3ea0246a4f4..c1141a684854 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -201,10 +201,15 @@ do {										\
  * Complete broadcast TLB maintenance issued by the host which invalidates
  * stage 1 information in the host's own translation regime.
  */
-static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
+static inline void __tlbi_sync_s1ish_no_sme_dvmsync(void)
 {
 	dsb(ish);
 	__repeat_tlbi_sync(vale1is, 0);
+}
+
+static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
+{
+	__tlbi_sync_s1ish_no_sme_dvmsync();
 	sme_dvmsync(mm);
 }

@@ -408,7 +413,11 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
  */
 static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
-	__tlbi_sync_s1ish(NULL);
+	__tlbi_sync_s1ish_no_sme_dvmsync();
+	if (batch->sme_dvmsync) {
+		batch->sme_dvmsync = false;
+		sme_dvmsync(NULL);
+	}
 }

 /*
@@ -613,6 +622,8 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
 		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	__flush_tlb_range_nosync(mm, start, end, PAGE_SIZE, true, 3);
+	if (test_bit(ilog2(MMCF_SME_DVMSYNC), &mm->context.flags))
+		batch->sme_dvmsync = true;
 }

 static inline bool __pte_flags_need_flush(ptdesc_t oldval, ptdesc_t newval)

