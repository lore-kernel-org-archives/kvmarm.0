From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 01/10] KVM: arm/arm64: Split dcache/icache flushing
Date: Tue, 17 Oct 2017 07:28:34 -0700
Message-ID: <20171017142834.GG5886@lvm>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-2-marc.zyngier@arm.com>
 <20171016200735.GE1845@lvm>
 <33ad478f-dcd7-5a9e-d353-d564e09c3254@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <33ad478f-dcd7-5a9e-d353-d564e09c3254@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 09:57:34AM +0100, Marc Zyngier wrote:
> On 16/10/17 21:07, Christoffer Dall wrote:
> > On Mon, Oct 09, 2017 at 04:20:23PM +0100, Marc Zyngier wrote:
> >> As we're about to introduce opportunistic invalidation of the icache,
> >> let's split dcache and icache flushing.
> > 
> > I'm a little confused abut the naming of these functions now,
> > because where I believe the current function ensures coherency between
> > the I-cache and D-cache (and overly so) if you just call one or the
> > other function after this change, what exactly is the coherency you get?
> 
> Yeah, in retrospect, this is a pretty stupid naming scheme. I guess I'll
> call them clean/invalidate, with the overarching caller still being
> called coherent_cache_guest for the time being.
> 

Sounds good.

> > 
> > 
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm/include/asm/kvm_mmu.h   | 60 ++++++++++++++++++++++++++++------------
> >>  arch/arm64/include/asm/kvm_mmu.h | 13 +++++++--
> >>  virt/kvm/arm/mmu.c               | 20 ++++++++++----
> >>  3 files changed, 67 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> >> index fa6f2174276b..f553aa62d0c3 100644
> >> --- a/arch/arm/include/asm/kvm_mmu.h
> >> +++ b/arch/arm/include/asm/kvm_mmu.h
> >> @@ -126,21 +126,12 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
> >>  	return (vcpu_cp15(vcpu, c1_SCTLR) & 0b101) == 0b101;
> >>  }
> >>  
> >> -static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
> >> -					       kvm_pfn_t pfn,
> >> -					       unsigned long size)
> >> +static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
> >> +						kvm_pfn_t pfn,
> >> +						unsigned long size)
> >>  {
> >>  	/*
> >> -	 * If we are going to insert an instruction page and the icache is
> >> -	 * either VIPT or PIPT, there is a potential problem where the host
> >> -	 * (or another VM) may have used the same page as this guest, and we
> >> -	 * read incorrect data from the icache.  If we're using a PIPT cache,
> >> -	 * we can invalidate just that page, but if we are using a VIPT cache
> >> -	 * we need to invalidate the entire icache - damn shame - as written
> >> -	 * in the ARM ARM (DDI 0406C.b - Page B3-1393).
> >> -	 *
> >> -	 * VIVT caches are tagged using both the ASID and the VMID and doesn't
> >> -	 * need any kind of flushing (DDI 0406C.b - Page B3-1392).
> >> +	 * Clean the dcache to the Point of Coherency.
> >>  	 *
> >>  	 * We need to do this through a kernel mapping (using the
> >>  	 * user-space mapping has proved to be the wrong
> >> @@ -155,19 +146,52 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
> >>  
> >>  		kvm_flush_dcache_to_poc(va, PAGE_SIZE);
> >>  
> >> -		if (icache_is_pipt())
> >> -			__cpuc_coherent_user_range((unsigned long)va,
> >> -						   (unsigned long)va + PAGE_SIZE);
> >> -
> >>  		size -= PAGE_SIZE;
> >>  		pfn++;
> >>  
> >>  		kunmap_atomic(va);
> >>  	}
> >> +}
> >>  
> >> -	if (!icache_is_pipt() && !icache_is_vivt_asid_tagged()) {
> >> +static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
> >> +						kvm_pfn_t pfn,
> >> +						unsigned long size)
> >> +{
> >> +	/*
> >> +	 * If we are going to insert an instruction page and the icache is
> >> +	 * either VIPT or PIPT, there is a potential problem where the host
> >> +	 * (or another VM) may have used the same page as this guest, and we
> >> +	 * read incorrect data from the icache.  If we're using a PIPT cache,
> >> +	 * we can invalidate just that page, but if we are using a VIPT cache
> >> +	 * we need to invalidate the entire icache - damn shame - as written
> >> +	 * in the ARM ARM (DDI 0406C.b - Page B3-1393).
> >> +	 *
> >> +	 * VIVT caches are tagged using both the ASID and the VMID and doesn't
> >> +	 * need any kind of flushing (DDI 0406C.b - Page B3-1392).
> >> +	 */
> >> +
> >> +	VM_BUG_ON(size & ~PAGE_MASK);
> >> +
> >> +	if (icache_is_vivt_asid_tagged())
> >> +		return;
> >> +
> >> +	if (!icache_is_pipt()) {
> >>  		/* any kind of VIPT cache */
> >>  		__flush_icache_all();
> >> +		return;
> >> +	}
> >> +
> >> +	/* PIPT cache. As for the d-side, use a temporary kernel mapping. */
> >> +	while (size) {
> >> +		void *va = kmap_atomic_pfn(pfn);
> >> +
> >> +		__cpuc_coherent_user_range((unsigned long)va,
> >> +					   (unsigned long)va + PAGE_SIZE);
> >> +
> >> +		size -= PAGE_SIZE;
> >> +		pfn++;
> >> +
> >> +		kunmap_atomic(va);
> >>  	}
> >>  }
> >>  
> >> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> >> index 672c8684d5c2..4c4cb4f0e34f 100644
> >> --- a/arch/arm64/include/asm/kvm_mmu.h
> >> +++ b/arch/arm64/include/asm/kvm_mmu.h
> >> @@ -230,19 +230,26 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
> >>  	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
> >>  }
> >>  
> >> -static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
> >> -					       kvm_pfn_t pfn,
> >> -					       unsigned long size)
> >> +static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
> >> +						kvm_pfn_t pfn,
> >> +						unsigned long size)
> >>  {
> >>  	void *va = page_address(pfn_to_page(pfn));
> >>  
> >>  	kvm_flush_dcache_to_poc(va, size);
> >> +}
> >>  
> >> +static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
> >> +						kvm_pfn_t pfn,
> >> +						unsigned long size)
> >> +{
> >>  	if (icache_is_aliasing()) {
> >>  		/* any kind of VIPT cache */
> >>  		__flush_icache_all();
> >>  	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
> >>  		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
> > 
> > unrelated: I went and read the comment in __kvm_tlb_flush_vmid_ipa, and
> > I don't really understand why there is only a need to flush the icache
> > if the host is running at EL1.
> > 
> > The text seems to describe the problem of remapping executable pages
> > within the guest.  That seems to me would require icache maintenance of
> > the page that gets overwritten with new code, regardless of whether the
> > host runs at EL1 or EL2.
> > 
> > Of course it's easier done on VHE because we don't have to take a trap,
> > but the code seems to not invalidate the icache at all for VHE systems
> > that have VPIPT.  I'm confused.  Can you help?
> 
> [+ Will, as he wrote that code and can reply if I say something stupid]
> 
> Here's the trick: The VMID-tagged aspect of VPIPT only applies if the
> CMO is used at EL0 or EL1. When used at EL2, it behaves exactly like a
> VPIPT operation (see D4.10.2 in the ARMv8 ARM version B_b).
> 
> So in the end, we deal with VPIPT the following way:
> 
> - Without VHE, we perform the icache invalidation on unmap, blatting the
> whole icache.

ok, but why can't we do the invalidation by jumping to EL2 like we do
for some of the other CMOs ?

> 
> - With VHE, we do it the usual way (at map time), using the PIPT
> flavour, as the invalidation is done from EL2
> 

Thanks,
-Christoffer
