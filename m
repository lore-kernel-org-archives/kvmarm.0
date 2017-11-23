From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH] kvm: arm64: handle single-step of hyp emulated mmio
 instructions
Date: Thu, 23 Nov 2017 11:20:07 +0100
Message-ID: <20171123102007.GX28855@cbox>
References: <20171122170747.12192-1-alex.bennee@linaro.org>
 <20171122204158.GW28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171122204158.GW28855@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, David Daney <david.daney@cavium.com>, Eric Auger <eric.auger@redhat.com>, James Morse <james.morse@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Replying to myself here, because I'm an idiot...

On Wed, Nov 22, 2017 at 09:41:58PM +0100, Christoffer Dall wrote:

[...]
> 
> >  	case ARM_EXCEPTION_TRAP:
> >  		return handle_trap_exceptions(vcpu, run);
> >  	case ARM_EXCEPTION_HYP_GONE:
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 945e79c641c4..a6712f179b52 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -22,6 +22,7 @@
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/fpsimd.h>
> > +#include <asm/debug-monitors.h>
> >  
> >  static bool __hyp_text __fpsimd_enabled_nvhe(void)
> >  {
> > @@ -263,7 +264,11 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
> >  	return true;
> >  }
> >  
> > -static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
> > +/* Skip an instruction which has been emulated. Returns true if
> > + * execution can continue or false if we need to exit hyp mode because
> > + * single-step was in effect.
> > + */
> > +static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
> >  {
> >  	*vcpu_pc(vcpu) = read_sysreg_el2(elr);
> >  
> > @@ -276,6 +281,14 @@ static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	write_sysreg_el2(*vcpu_pc(vcpu), elr);
> > +
> > +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> > +		vcpu->arch.fault.esr_el2 =
> > +			(ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT) | 0x22;
> > +		return false;
> > +	} else {
> > +		return true;
> > +	}
> >  }
> >  
> >  int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> > @@ -336,13 +349,21 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  			int ret = __vgic_v2_perform_cpuif_access(vcpu);
> >  
> >  			if (ret == 1) {
> > -				__skip_instr(vcpu);
> > -				goto again;
> > +				if (__skip_instr(vcpu))
> > +					goto again;
> > +				else
> > +					exit_code = ARM_EXCEPTION_TRAP;
> >  			}
> >  
> >  			if (ret == -1) {
> > -				/* Promote an illegal access to an SError */
> > -				__skip_instr(vcpu);
> > +				/* Promote an illegal access to an
> > +				 * SError. If we would be returning
> > +				 * due to single-step clear the SS
> > +				 * bit so handle_exit knows what to
> > +				 * do after dealing with the error.
> > +				 */
> > +				if (!__skip_instr(vcpu))
> > +					*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
> 
> Could this be overriding guest state if the guest is debugging itself
> and we don't have (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) ?
> 

... this is nonsense, __kvm_skip_intr will check for
KVM_GUESTDBG_SINGLESTEP, so there's no issue here.

Sorry about the noise.
-Christoffer
