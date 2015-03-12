From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/3] arm/arm64: KVM: Optimize handling of Access Flag
 faults
Date: Thu, 12 Mar 2015 15:04:51 +0000
Message-ID: <20150312150451.43bd42b5@arm.com>
References: <1421865733-20034-1-git-send-email-marc.zyngier@arm.com>
	<1421865733-20034-4-git-send-email-marc.zyngier@arm.com>
	<20150312114024.GC28863@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150312114024.GC28863@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Steve Capper <steve.capper@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 12 Mar 2015 11:40:24 +0000
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> On Wed, Jan 21, 2015 at 06:42:13PM +0000, Marc Zyngier wrote:
> > Now that we have page aging in Stage-2, it becomes obvious that
> > we're doing way too much work handling the fault.
> > 
> > The page is not going anywhere (it is still mapped), the page
> > tables are already allocated, and all we want is to flip a bit
> > in the PMD or PTE. Also, we can avoid any form of TLB invalidation,
> > since a page with the AF bit off is not allowed to be cached.
> > 
> > An obvious solution is to have a separate handler for FSC_ACCESS,
> > where we pride ourselves to only do the very minimum amount of
> > work.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm/kvm/mmu.c   | 46
> > ++++++++++++++++++++++++++++++++++++++++++++++ arch/arm/kvm/trace.h
> > | 15 +++++++++++++++ 2 files changed, 61 insertions(+)
> > 
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > index ffe89a0..112bae1 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -1073,6 +1073,46 @@ out_unlock:
> >  	return ret;
> >  }
> >  
> > +/*
> > + * Resolve the access fault by making the page young again.
> > + * Note that because the faulting entry is guaranteed not to be
> > + * cached in the TLB, we don't need to invalidate anything.
> > + */
> > +static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t
> > fault_ipa) +{
> > +	pmd_t *pmd;
> > +	pte_t *pte;
> > +	pfn_t pfn;
> > +	bool pfn_valid = false;
> 
> I think you can just initialize pfn to KVM_PFN_ERR_FAULT and use
> is_error_pfn() if you like, not sure if it's cleaner.

I can have a look...

> > +
> > +	trace_kvm_access_fault(fault_ipa);
> > +
> > +	spin_lock(&vcpu->kvm->mmu_lock);
> > +
> > +	pmd = stage2_get_pmd(vcpu->kvm, NULL, fault_ipa);
> > +	if (!pmd || pmd_none(*pmd))	/* Nothing there */
> > +		goto out;
> > +
> > +	if (kvm_pmd_huge(*pmd)) {	/* THP, HugeTLB */
> > +		*pmd = pmd_mkyoung(*pmd);
> > +		pfn = pmd_pfn(*pmd);
> > +		pfn_valid = true;
> > +		goto out;
> > +	}
> > +
> > +	pte = pte_offset_kernel(pmd, fault_ipa);
> > +	if (pte_none(*pte))		/* Nothing there either
> > */
> > +		goto out;
> > +
> > +	*pte = pte_mkyoung(*pte);	/* Just a page... */
> > +	pfn = pte_pfn(*pte);
> > +	pfn_valid = true;
> > +out:
> > +	spin_unlock(&vcpu->kvm->mmu_lock);
> 
> do you have a race here if the page is swapped out before you go and
> set pfn accessed?  Does that cause any harm?

I don't think it really matters. The physical page is still there, and
is actually being accessed. The fact that the data is being evicted is
an interesting side effect... ;-)

> > +	if (pfn_valid)
> > +		kvm_set_pfn_accessed(pfn);
> > +}
> > +
> >  /**
> >   * kvm_handle_guest_abort - handles all 2nd stage aborts
> >   * @vcpu:	the VCPU pointer
> > @@ -1140,6 +1180,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu
> > *vcpu, struct kvm_run *run) /* Userspace should not be able to
> > register out-of-bounds IPAs */ VM_BUG_ON(fault_ipa >=
> > KVM_PHYS_SIZE); 
> > +	if (fault_status == FSC_ACCESS) {
> > +		handle_access_fault(vcpu, fault_ipa);
> > +		ret = 1;
> > +		goto out_unlock;
> > +	}
> > +
> >  	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva,
> > fault_status); if (ret == 0)
> >  		ret = 1;
> > diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
> > index 364b5382..5665a16 100644
> > --- a/arch/arm/kvm/trace.h
> > +++ b/arch/arm/kvm/trace.h
> > @@ -64,6 +64,21 @@ TRACE_EVENT(kvm_guest_fault,
> >  		  __entry->hxfar, __entry->vcpu_pc)
> >  );
> >  
> > +TRACE_EVENT(kvm_access_fault,
> > +	TP_PROTO(unsigned long ipa),
> > +	TP_ARGS(ipa),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	unsigned long,
> > ipa		)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->ipa		= ipa;
> > +	),
> > +
> > +	TP_printk("IPA: %lx", __entry->ipa)
> > +);
> > +
> >  TRACE_EVENT(kvm_irq_line,
> >  	TP_PROTO(unsigned int type, int vcpu_idx, int irq_num, int
> > level), TP_ARGS(type, vcpu_idx, irq_num, level),

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
