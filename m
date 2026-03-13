Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3611D313E1B
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 16:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773419241; cv=none; b=j3uFcQq69ceOIBum0puFzunbGjKJP+2fEa3iYrZbVWh0D2WJtrrLZtpm8NyzIi0H+3gI/6L1Ui5Fsu/Riq3dVTRCU8DK9XLBoNWHmK82eyLPuDcxTTeBFyHMIDCZtwDNk2dLFfprA3WSrQkQL6+jVAHx5xdUWtmf/eivbGOvdMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773419241; c=relaxed/simple;
	bh=kkyLv62qlJHf/Oyvh79kEZKuaf7Pk/8Ws1HHzymRYZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RS+Oxpi6i8bBZBdTC0h2WVFpAIjv12HaNSEVWQbZmpQNBaAahkJ1egHpbjGwRFGrEsuE1C66R9pGBhvGM15DrfrZeNOcOBZ/mrA0/nfCxxxMWQinFKkQ0vifSmEZBzwDmt3UCRnnyQ+Bt1aiR6zcar3UPvoLrEU9YbRcIIUft4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A59E176A;
	Fri, 13 Mar 2026 09:27:13 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 127A93F7BD;
	Fri, 13 Mar 2026 09:27:17 -0700 (PDT)
Date: Fri, 13 Mar 2026 16:27:11 +0000
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
Message-ID: <abQ633aFVj4SnUjs@arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-3-catalin.marinas@arm.com>
 <aamULrOkm8jd_9UY@willie-the-truck>
 <aanXM7YWMAJW6qk7@arm.com>
 <aaq3Vun0ZSSdXyXV@arm.com>
 <abLU-cJLxgdpJ9C4@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abLU-cJLxgdpJ9C4@willie-the-truck>

On Thu, Mar 12, 2026 at 03:00:09PM +0000, Will Deacon wrote:
> On Fri, Mar 06, 2026 at 11:15:34AM +0000, Catalin Marinas wrote:
> > On Thu, Mar 05, 2026 at 07:19:15PM +0000, Catalin Marinas wrote:
> > > On Thu, Mar 05, 2026 at 02:33:18PM +0000, Will Deacon wrote:
> > > > On Mon, Mar 02, 2026 at 04:57:55PM +0000, Catalin Marinas wrote:
> > > > > @@ -391,7 +391,7 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
> > > > >   */
> > > > >  static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
> > > > >  {
> > > > > -	__tlbi_sync_s1ish();
> > > > > +	__tlbi_sync_s1ish(NULL);
> > > > 
> > > > Hmm, it seems a bit rubbish to pass NULL here as that means that we'll
> > > > deploy the mitigation regardless of the mm flags when finishing the
> > > > batch.
> > > > 
> > > > It also looks like we could end up doing the workaround multiple times
> > > > if arch_tlbbatch_add_pending() is passed a large enough region that we
> > > > call __flush_tlb_range_limit_excess() fires.
> > > > 
> > > > So perhaps we should stash the mm in 'struct arch_tlbflush_unmap_batch'
> > > > alongside some state to track whether or not we have uncompleted TLB
> > > > maintenance in flight?
> > > 
> > > The problem is that arch_tlbbatch_flush() can be called to synchronise
> > > multiple mm structures that were touched by TTU. We can't have the mm in
> > > arch_tlbflush_unmap_batch. But we can track if any of the mms had
> > > MMCF_SME_DVMSYNC flag set, something like below (needs testing, tidying
> > > up). TBH, I did not notice any problem in benchmarking as I guess we
> > > haven't exercised the TTU path much, so did not bother to optimise it.
> > > 
> > > For the TTU case, I don't think we need to worry about the excess limit
> > > and doing the IPI twice. But I'll double check the code paths tomorrow.
> > > 
> > > diff --git a/arch/arm64/include/asm/tlbbatch.h b/arch/arm64/include/asm/tlbbatch.h
> > > index fedb0b87b8db..e756eaca6cb8 100644
> > > --- a/arch/arm64/include/asm/tlbbatch.h
> > > +++ b/arch/arm64/include/asm/tlbbatch.h
> > > @@ -7,6 +7,8 @@ struct arch_tlbflush_unmap_batch {
> > >  	 * For arm64, HW can do tlb shootdown, so we don't
> > >  	 * need to record cpumask for sending IPI
> > >  	 */
> > > +
> > > +	bool sme_dvmsync;
> > >  };
> > > 
> > >  #endif /* _ARCH_ARM64_TLBBATCH_H */
> > > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> > > index e3ea0246a4f4..c1141a684854 100644
> > > --- a/arch/arm64/include/asm/tlbflush.h
> > > +++ b/arch/arm64/include/asm/tlbflush.h
> > > @@ -201,10 +201,15 @@ do {										\
> > >   * Complete broadcast TLB maintenance issued by the host which invalidates
> > >   * stage 1 information in the host's own translation regime.
> > >   */
> > > -static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
> > > +static inline void __tlbi_sync_s1ish_no_sme_dvmsync(void)
> > >  {
> > >  	dsb(ish);
> > >  	__repeat_tlbi_sync(vale1is, 0);
> > > +}
> > > +
> > > +static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
> > > +{
> > > +	__tlbi_sync_s1ish_no_sme_dvmsync();
> > >  	sme_dvmsync(mm);
> > >  }
> > > 
> > > @@ -408,7 +413,11 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
> > >   */
> > >  static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
> > >  {
> > > -	__tlbi_sync_s1ish(NULL);
> > > +	__tlbi_sync_s1ish_no_sme_dvmsync();
> > > +	if (batch->sme_dvmsync) {
> > > +		batch->sme_dvmsync = false;
> > > +		sme_dvmsync(NULL);
> > > +	}
> > >  }
> > > 
> > >  /*
> > > @@ -613,6 +622,8 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
> > >  		struct mm_struct *mm, unsigned long start, unsigned long end)
> > >  {
> > >  	__flush_tlb_range_nosync(mm, start, end, PAGE_SIZE, true, 3);
> > > +	if (test_bit(ilog2(MMCF_SME_DVMSYNC), &mm->context.flags))
> > > +		batch->sme_dvmsync = true;
> > >  }
> > 
> > While writing a reply to your other comments, I realised why this
> > wouldn't work (I had something similar but dropped it) - we can have the
> > flag cleared here (or mm_cpumask() if we are to track per-mm) but we
> > have not issued the DVMSync yet. The task may start using SME before
> > arch_tlbbatch_flush() and we just missed it. Any checks on whether to
> > issue the IPI like reading flags needs to be after the DVMSync.
> 
> Ah, yeah. I wonder if it's worth detecting the change of mm in
> arch_tlbbatch_add_pending() and then pro-actively doing the DSB on CPUs
> with the erratum? I suppose it depends on how often SME is being used.

I don't think it's worth it with the current use of SME (short bursts).
sme_do_dvmsync() already tracks which CPUs run with the SME enabled at
EL0, so it's not like we always broadcast to all. But if you want it,
something like below with more ifs and ifdefs when the erratum is
disabled:

diff --git a/arch/arm64/include/asm/tlbbatch.h b/arch/arm64/include/asm/tlbbatch.h
index fedb0b87b8db..948d6f248250 100644
--- a/arch/arm64/include/asm/tlbbatch.h
+++ b/arch/arm64/include/asm/tlbbatch.h
@@ -2,11 +2,12 @@
 #ifndef _ARCH_ARM64_TLBBATCH_H
 #define _ARCH_ARM64_TLBBATCH_H
 
+struct mm_struct;
+
+#define ARCH_TLBBATCH_MULTIPLE_MMS	((struct mm_struct *)-1UL)
+
 struct arch_tlbflush_unmap_batch {
-	/*
-	 * For arm64, HW can do tlb shootdown, so we don't
-	 * need to record cpumask for sending IPI
-	 */
+	struct mm_struct *mm;
 };
 
 #endif /* _ARCH_ARM64_TLBBATCH_H */
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 2c77ca41cb14..1ed19480305f 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -408,7 +408,13 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
  */
 static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
-	__tlbi_sync_s1ish(NULL);
+	struct mm_struct *mm = batch->mm;
+
+	batch->mm = NULL;
+	if (mm == ARCH_TLBBATCH_MULTIPLE_MMS)
+		mm = NULL;
+
+	__tlbi_sync_s1ish(mm);
 }
 
 /*
@@ -612,6 +618,11 @@ static inline void __flush_tlb_kernel_pgtable(unsigned long kaddr)
 static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
 		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
+	if (!batch->mm)
+		batch->mm = mm;
+	else if (batch->mm != mm && batch->mm != ARCH_TLBBATCH_MULTIPLE_MMS)
+		batch->mm = ARCH_TLBBATCH_MULTIPLE_MMS;
+
 	__flush_tlb_range_nosync(mm, start, end, PAGE_SIZE, true, 3);
 }
 
