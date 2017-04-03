From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3] kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd
Date: Mon, 3 Apr 2017 16:31:27 +0200
Message-ID: <20170403143127.GA11752@cbox>
References: <1491228763-23450-1-git-send-email-suzuki.poulose@arm.com>
 <20170403142211.GE18905@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170403142211.GE18905@leverpostej>
Sender: stable-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, andreyknvl@google.com, dvyukov@google.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, ard.biesheuvel@linaro.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 03, 2017 at 03:22:11PM +0100, Mark Rutland wrote:
> Hi,
> 
> On Mon, Apr 03, 2017 at 03:12:43PM +0100, Suzuki K Poulose wrote:
> > In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while calling
> > unmap_stage2_range() on the entire memory range for the guest. This could
> > cause problems with other callers (e.g, munmap on a memslot) trying to
> > unmap a range. And since we have to unmap the entire Guest memory range
> > holding a spinlock, make sure we yield the lock if necessary, after we
> > unmap each PUD range.
> > 
> > Fixes: commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> > Cc: stable@vger.kernel.org # v3.10+
> > Cc: Paolo Bonzini <pbonzin@redhat.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > [ Avoid vCPU starvation and lockup detector warnings ]
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > 
> > ---
> > Changes since V2:
> >  - Restrict kvm->mmu_lock relaxation to bigger ranges in unmap_stage2_range(),
> >    to avoid possible issues like [0]
> > 
> >  [0] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-March/498210.html
> 
> Sorry if I'm being thick, but how does restricting this to a larger
> range help with the "sleeping function called from invalid context"
> issue?
> 
> Surely that just makes it rarer?

As far as I can tell, the unmap_stage2_range() function is only called
in the problematic path which has the extra lock taken rom
try_to_unmap_one() via the kvm_unmap_hva() function, which always
passes PAGE_SIZE as the argument, which is always smaller than
S2_PUD_SIZE.

Did I miss something?

Thanks,
-Christoffer
> 
> > 
> > Changes since V1:
> >  - Yield the kvm->mmu_lock if necessary in unmap_stage2_range to prevent
> >    vCPU starvation and lockup detector warnings.
> > ---
> >  arch/arm/kvm/mmu.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > index 13b9c1f..db94f3a 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -292,8 +292,15 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
> >  	phys_addr_t addr = start, end = start + size;
> >  	phys_addr_t next;
> >  
> > +	assert_spin_locked(&kvm->mmu_lock);
> >  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
> >  	do {
> > +		/*
> > +		 * If the range is too large, release the kvm->mmu_lock
> > +		 * to prevent starvation and lockup detector warnings.
> > +		 */
> > +		if (size > S2_PUD_SIZE)
> > +			cond_resched_lock(&kvm->mmu_lock);
> >  		next = stage2_pgd_addr_end(addr, end);
> >  		if (!stage2_pgd_none(*pgd))
> >  			unmap_stage2_puds(kvm, pgd, addr, next);
> > @@ -831,7 +838,10 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
> >  	if (kvm->arch.pgd == NULL)
> >  		return;
> >  
> > +	spin_lock(&kvm->mmu_lock);
> >  	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
> > +	spin_unlock(&kvm->mmu_lock);
> > +
> >  	/* Free the HW pgd, one page at a time */
> >  	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
> >  	kvm->arch.pgd = NULL;
> > -- 
> > 2.7.4
> > 
