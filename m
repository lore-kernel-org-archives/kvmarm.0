From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/5] arm64: KVM: vgic-v2: Add the GICV emulation
 infrastructure
Date: Thu, 1 Sep 2016 16:55:45 +0200
Message-ID: <20160901145545.GA22749@cbox>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
 <1471610295-1456-4-git-send-email-marc.zyngier@arm.com>
 <20160901124629.GF10162@cbox>
 <57C83B14.6020501@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57C83B14.6020501@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Alex Bennee <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 01, 2016 at 03:28:36PM +0100, Marc Zyngier wrote:
> On 01/09/16 13:46, Christoffer Dall wrote:
> > On Fri, Aug 19, 2016 at 01:38:13PM +0100, Marc Zyngier wrote:
> >> In order to efficiently perform the GICV access on behalf of the
> >> guest, we need to be able to do avoid going back all the way to
> > 
> > s/do//
> > 
> >> the host kernel.
> >>
> >> For this, we introduce a new hook in the world switch code,
> >> conveniently placed just after populating the fault info.
> >> At that point, we only have saved/restored the GP registers,
> >> and we can quickly perform all the required checks (data abort,
> >> translation fault, valid faulting syndrome, not an external
> >> abort, not a PTW).
> >>
> >> Coming back from the emulation code, we need to skip the emulated
> >> instruction. This involves an additional bit of save/restore in
> >> order to be able to access the guest's PC (and possibly CPSR if
> >> this is a 32bit guest).
> >>
> >> At this stage, no emulation code is provided.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_hyp.h |  1 +
> >>  arch/arm64/kvm/hyp/switch.c      | 32 ++++++++++++++++++++++++++++++++
> >>  include/kvm/arm_vgic.h           |  3 +++
> >>  virt/kvm/arm/hyp/vgic-v2-sr.c    |  7 +++++++
> >>  virt/kvm/arm/vgic/vgic-v2.c      |  2 ++
> >>  5 files changed, 45 insertions(+)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> >> index cff5105..88ec3ac 100644
> >> --- a/arch/arm64/include/asm/kvm_hyp.h
> >> +++ b/arch/arm64/include/asm/kvm_hyp.h
> >> @@ -123,6 +123,7 @@ typeof(orig) * __hyp_text fname(void)					\
> >>  
> >>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
> >>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
> >> +bool __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
> >>  
> >>  void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
> >>  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
> >> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >> index ae7855f..0be1594 100644
> >> --- a/arch/arm64/kvm/hyp/switch.c
> >> +++ b/arch/arm64/kvm/hyp/switch.c
> >> @@ -17,6 +17,7 @@
> >>  
> >>  #include <linux/types.h>
> >>  #include <asm/kvm_asm.h>
> >> +#include <asm/kvm_emulate.h>
> >>  #include <asm/kvm_hyp.h>
> >>  
> >>  static bool __hyp_text __fpsimd_enabled_nvhe(void)
> >> @@ -232,6 +233,21 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
> >>  	return true;
> >>  }
> >>  
> >> +static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
> >> +{
> >> +	vcpu->arch.ctxt.gp_regs.regs.pc	= read_sysreg_el2(elr);
> >> +
> >> +	if (vcpu_mode_is_32bit(vcpu)) {
> >> +		vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(spsr);
> >> +		kvm_skip_aarch32_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> >> +		write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pstate, spsr);
> >> +	} else {
> >> +		*vcpu_pc(vcpu) += 4;
> >> +	}
> >> +
> >> +	write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pc, elr);
> >> +}
> >> +
> >>  static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
> >>  {
> >>  	struct kvm_cpu_context *host_ctxt;
> >> @@ -270,6 +286,22 @@ again:
> >>  	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
> >>  		goto again;
> >>  
> >> +	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
> >> +	    exit_code == ARM_EXCEPTION_TRAP) {
> > 
> > do you get the static branch benefit when the test contains an &&
> > clause?  (I haven't looked at the generated assembly, no)
> 
> You do, otherwise the C semantics would be broken. This is strictly
> equivalent to:
> 
> 	if (static_branch_unlikely()) {
> 		if (exit_code == ...) {
> 			[...]
> 		}
> 	}
> 
> > Also, if you flip this static branch for code both mapped in EL1 and
> > EL2, would you potentially need some form of additional icache
> > maintenance here?
> > 
> > Or are you relying on the static branch being set at boot time and hold
> > forever true/false?
> 
> I asked myself this exact question when I did this, and became convinced
> that this was OK for two reasons:
> - we do it only once
> - when we do it, we haven't executed that code yet, so it cannot be in
> the cache yet
> 
> > 
> >> +		bool valid;
> >> +
> >> +		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
> >> +			kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
> >> +			kvm_vcpu_dabt_isvalid(vcpu) &&
> >> +			!kvm_vcpu_dabt_isextabt(vcpu) &&
> >> +			!kvm_vcpu_dabt_iss1tw(vcpu);
> >> +
> >> +		if (valid &&  __vgic_v2_perform_cpuif_access(vcpu)) {
> > 
> > extra whitespace
> > 
> >> +			__skip_instr(vcpu);
> > 
> > does this interact in any amusing way with single-step guest debugging?
> 
> Ouch. Good point. Actually, nothing that uses kvm_skip_instr() works for
> singlestep/watchpoint either (trapped sysreg, WFx, spurious traps,
> MMIO). I guess that's something we need to fix overall.
> 
I suppose, yes.  I discretely cc'ed this e-mail to Alex :)

-Christoffer
