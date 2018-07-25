From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 12/16] KVM: arm64/sve: Context switch the SVE registers
Date: Wed, 25 Jul 2018 12:50:45 +0100
Message-ID: <20180725115045.GJ4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-13-git-send-email-Dave.Martin@arm.com>
 <20180719131338.jsgezassnjhdbotd@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC5E24A0C7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 07:50:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ef+j+--3sWb7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 07:50:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7591340493
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 07:50:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180719131338.jsgezassnjhdbotd@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 19, 2018 at 03:13:38PM +0200, Andrew Jones wrote:
> On Thu, Jun 21, 2018 at 03:57:36PM +0100, Dave Martin wrote:
> > In order to give each vcpu its own view of the SVE registers, this
> > patch adds context storage via a new sve_state pointer in struct
> > vcpu_arch.  An additional member sve_max_vl is also added for each
> > vcpu, to determine the maximum vector length visible to the guest
> > and thus the value to be configured in ZCR_EL2.LEN while the is
> > active.  This also determines the layout and size of the storage in
> > sve_state, which is read and written by the same backend functions
> > that are used for context-switching the SVE state for host tasks.
> > 
> > On SVE-enabled vcpus, SVE access traps are now handled by switching
> > in the vcpu's SVE context and disabling the trap before returning
> > to the guest.  On other vcpus, the trap is not handled and an exit
> > back to the host occurs, where the handle_sve() fallback path
> > reflects an undefined instruction exception back to the guest,
> > consistently with the behaviour of non-SVE-capable hardware (as was
> > done unconditionally prior to this patch).
> > 
> > No SVE handling is added on non-VHE-only paths, since VHE is an
> > architectural and Kconfig prerequisite of SVE.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/kvm/fpsimd.c           |  5 +++--
> >  arch/arm64/kvm/hyp/switch.c       | 43 ++++++++++++++++++++++++++++++---------
> >  3 files changed, 38 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f331abf..d2084ae 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -211,6 +211,8 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
> >  
> >  struct kvm_vcpu_arch {
> >  	struct kvm_cpu_context ctxt;
> > +	void *sve_state;
> > +	unsigned int sve_max_vl;
> >  
> >  	/* HYP configuration */
> >  	u64 hcr_el2;
> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> > index 872008c..44cf783 100644
> > --- a/arch/arm64/kvm/fpsimd.c
> > +++ b/arch/arm64/kvm/fpsimd.c
> > @@ -86,10 +86,11 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
> >  
> >  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> >  		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
> > -					 NULL, sve_max_vl);
> > +					 vcpu->arch.sve_state,
> > +					 vcpu->arch.sve_max_vl);
> >  
> >  		clear_thread_flag(TIF_FOREIGN_FPSTATE);
> > -		clear_thread_flag(TIF_SVE);
> > +		update_thread_flag(TIF_SVE, vcpu_has_sve(&vcpu->arch));
> >  	}
> >  }
> >  
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index d496ef5..98df5c1 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -98,8 +98,13 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
> >  	val = read_sysreg(cpacr_el1);
> >  	val |= CPACR_EL1_TTA;
> >  	val &= ~CPACR_EL1_ZEN;
> > -	if (!update_fp_enabled(vcpu))
> > +
> > +	if (update_fp_enabled(vcpu)) {
> > +		if (vcpu_has_sve(&vcpu->arch))
> > +			val |= CPACR_EL1_ZEN;
> > +	} else {
> >  		val &= ~CPACR_EL1_FPEN;
> > +	}
> >  
> >  	write_sysreg(val, cpacr_el1);
> >  
> > @@ -114,6 +119,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> >  
> >  	val = CPTR_EL2_DEFAULT;
> >  	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> > +
> >  	if (!update_fp_enabled(vcpu))
> >  		val |= CPTR_EL2_TFP;
> >  
> > @@ -329,16 +335,22 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
> >  	}
> >  }
> >  
> > -static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> > +static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu,
> > +					   bool guest_has_sve)
> >  {
> >  	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
> >  
> > -	if (has_vhe())
> > -		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
> > -			     cpacr_el1);
> > -	else
> > +	if (has_vhe()) {
> > +		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
> > +
> > +		if (system_supports_sve() && guest_has_sve)
> 
> guest_has_sve is only true when vcpu_arch->flags & KVM_ARM64_GUEST_HAS_SVE
> is true, which can only be true when system_supports_sve() is true. So
> I don't think we need system_supports_sve() here. guest_has_sve should be
> enough.
> 
> > +			reg |= CPACR_EL1_ZEN;
> > +
> > +		write_sysreg(reg, cpacr_el1);
> > +	} else {
> >  		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
> >  			     cptr_el2);
> > +	}
> >  
> >  	isb();
> >  
> > @@ -361,7 +373,13 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> >  		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
> >  	}
> >  
> > -	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
> > +	if (system_supports_sve() && guest_has_sve)
> 
> here too

As elsewhere, the system_supports_sve() check uses a static key and
should be very cheap (or free in a CONFIG_ARM64_SVE=n kernel).

The aim here is to reduce wasted effort on non-SVE systems.

Cheers
---Dave
