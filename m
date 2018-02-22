From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 24/40] KVM: arm64: Rewrite system register accessors
 to read/write functions
Date: Thu, 22 Feb 2018 10:22:37 +0100
Message-ID: <20180222092237.GI29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-25-christoffer.dall@linaro.org>
 <86a7w2lb7m.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <86a7w2lb7m.wl-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 21, 2018 at 01:32:45PM +0000, Marc Zyngier wrote:
> On Thu, 15 Feb 2018 21:03:16 +0000,
> Christoffer Dall wrote:
> > 
> > From: Christoffer Dall <cdall@cs.columbia.edu>
> > 
> > Currently we access the system registers array via the vcpu_sys_reg()
> > macro.  However, we are about to change the behavior to some times
> > modify the register file directly, so let's change this to two
> > primitives:
> > 
> >  * Accessor macros vcpu_write_sys_reg() and vcpu_read_sys_reg()
> >  * Direct array access macro __vcpu_sys_reg()
> > 
> > The first primitive should be used in places where the code needs to
> > access the currently loaded VCPU's state as observed by the guest.  For
> > example, when trapping on cache related registers, a write to a system
> > register should go directly to the VCPU version of the register.
> > 
> > The second primitive can be used in places where the VCPU is known to
> > never be running (for example userspace access) or for registers which
> > are never context switched (for example all the PMU system registers).
> > 
> > This rewrites all users of vcpu_sys_regs to one of the two primitives
> > above.
> > 
> > No functional change.
> > 
> > Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
> > ---
> > 
> > Notes:
> >     Changes since v2:
> >      - New patch (deferred register handling has been reworked)
> > 
> >  arch/arm64/include/asm/kvm_emulate.h | 13 ++++---
> >  arch/arm64/include/asm/kvm_host.h    | 13 ++++++-
> >  arch/arm64/include/asm/kvm_mmu.h     |  2 +-
> >  arch/arm64/kvm/debug.c               | 27 +++++++++-----
> >  arch/arm64/kvm/inject_fault.c        |  8 ++--
> >  arch/arm64/kvm/sys_regs.c            | 71 ++++++++++++++++++------------------
> >  arch/arm64/kvm/sys_regs.h            |  4 +-
> >  arch/arm64/kvm/sys_regs_generic_v8.c |  4 +-
> >  virt/kvm/arm/pmu.c                   | 37 ++++++++++---------
> >  9 files changed, 102 insertions(+), 77 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 3cc535591bdf..d313aaae5c38 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -290,15 +290,18 @@ static inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
> >  
> >  static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> >  {
> > -	return vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
> > +	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
> >  }
> >  
> >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> >  {
> > -	if (vcpu_mode_is_32bit(vcpu))
> > +	if (vcpu_mode_is_32bit(vcpu)) {
> >  		*vcpu_cpsr(vcpu) |= COMPAT_PSR_E_BIT;
> > -	else
> > -		vcpu_sys_reg(vcpu, SCTLR_EL1) |= (1 << 25);
> > +	} else {
> > +		u64 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> > +		sctlr |= (1 << 25);
> > +		vcpu_write_sys_reg(vcpu, SCTLR_EL1, sctlr);
> 
> General comment: it is slightly annoying that vcpu_write_sys_reg takes
> its parameters in an order different from that of write_sysreg
> (register followed with value, instead of value followed with
> register). Not a deal breaker, but slightly confusing.
> 

Ah, I didn't compare to write_sysreg, I was thinking that

  vcpu_read_sys_reg(vcpu, SCTLR_EL1);
  vcpu_write_sys_reg(vcpu, SCTLR_EL1, val);

looked more symmetrical because the write just takes an extra value, but
I can see your argument as well.

I don't mind changing it if it matters to you?

> > +	}
> >  }
> >  
> >  static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
> > @@ -306,7 +309,7 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
> >  	if (vcpu_mode_is_32bit(vcpu))
> >  		return !!(*vcpu_cpsr(vcpu) & COMPAT_PSR_E_BIT);
> >  
> > -	return !!(vcpu_sys_reg(vcpu, SCTLR_EL1) & (1 << 25));
> > +	return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & (1 << 25));
> >  }
> >  
> >  static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f2a6f39aec87..68398bf7882f 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -287,7 +287,18 @@ struct kvm_vcpu_arch {
> >  };
> >  
> >  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
> > -#define vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
> > +
> > +/*
> > + * Only use __vcpu_sys_reg if you know you want the memory backed version of a
> > + * register, and not the one most recently accessed by a runnning VCPU.  For
> > + * example, for userpace access or for system registers that are never context
> > + * switched, but only emulated.
> > + */
> > +#define __vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
> > +
> > +#define vcpu_read_sys_reg(v,r)	__vcpu_sys_reg(v,r)
> > +#define vcpu_write_sys_reg(v,r,n)	do { __vcpu_sys_reg(v,r) = n; } while (0)
> > +
> >  /*
> >   * CP14 and CP15 live in the same array, as they are backed by the
> >   * same system registers.
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index 9679067a1574..95f46e73c4dc 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -249,7 +249,7 @@ struct kvm;
> >  
> >  static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
> >  {
> > -	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
> > +	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
> >  }
> >  
> >  static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index feedb877cff8..db32d10a56a1 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -46,7 +46,8 @@ static DEFINE_PER_CPU(u32, mdcr_el2);
> >   */
> >  static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
> >  {
> > -	vcpu->arch.guest_debug_preserved.mdscr_el1 = vcpu_sys_reg(vcpu, MDSCR_EL1);
> > +	vcpu->arch.guest_debug_preserved.mdscr_el1 =
> > +		vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> >  
> >  	trace_kvm_arm_set_dreg32("Saved MDSCR_EL1",
> >  				vcpu->arch.guest_debug_preserved.mdscr_el1);
> > @@ -54,10 +55,11 @@ static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
> >  
> >  static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
> >  {
> > -	vcpu_sys_reg(vcpu, MDSCR_EL1) = vcpu->arch.guest_debug_preserved.mdscr_el1;
> > +	vcpu_write_sys_reg(vcpu, MDSCR_EL1,
> > +			   vcpu->arch.guest_debug_preserved.mdscr_el1);
> >  
> >  	trace_kvm_arm_set_dreg32("Restored MDSCR_EL1",
> > -				vcpu_sys_reg(vcpu, MDSCR_EL1));
> > +				vcpu_read_sys_reg(vcpu, MDSCR_EL1));
> >  }
> >  
> >  /**
> > @@ -108,6 +110,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
> >  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >  {
> >  	bool trap_debug = !(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY);
> > +	unsigned long mdscr;
> >  
> >  	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
> >  
> > @@ -152,9 +155,13 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >  		 */
> >  		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> >  			*vcpu_cpsr(vcpu) |=  DBG_SPSR_SS;
> > -			vcpu_sys_reg(vcpu, MDSCR_EL1) |= DBG_MDSCR_SS;
> > +			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> > +			mdscr |= DBG_MDSCR_SS;
> > +			vcpu_write_sys_reg(vcpu, MDSCR_EL1, mdscr);
> 
> I have the feeling that we're going to need some clearbits/setbits
> variants of vcpu_write_sysreg at some point.
> 

I can introduce these now if you prefer?

> It otherwise looks correct to me.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
Thanks,
-Christoffer
