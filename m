From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 13/37] KVM: arm64: Introduce VHE-specific kvm_vcpu_run
Date: Fri, 1 Dec 2017 19:10:00 +0100
Message-ID: <20171201181000.GE6615@lvm>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-14-christoffer.dall@linaro.org>
 <20171107152529.taszxq37f35yw3ga@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107152529.taszxq37f35yw3ga@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 07, 2017 at 04:25:29PM +0100, Andrew Jones wrote:
> On Thu, Oct 12, 2017 at 12:41:17PM +0200, Christoffer Dall wrote:
> > So far this is just a copy of the legacy non-VHE switch function, where
> > we only change the existing calls to has_vhe() in both the original and
> > new functions.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm/include/asm/kvm_asm.h   |  4 +++
> >  arch/arm64/include/asm/kvm_asm.h |  2 ++
> >  arch/arm64/kvm/hyp/switch.c      | 57 ++++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/arm/arm.c               |  5 +++-
> >  4 files changed, 67 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> > index 36dd296..1a7bc5f 100644
> > --- a/arch/arm/include/asm/kvm_asm.h
> > +++ b/arch/arm/include/asm/kvm_asm.h
> > @@ -70,8 +70,12 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
> >  
> >  extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
> >  
> > +/* no VHE on 32-bit :( */
> > +static inline int kvm_vcpu_run(struct kvm_vcpu *vcpu) { return 0; }
> > +
> >  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> >  
> > +
> 
> stray new blank line
> 
> >  extern void __init_stage2_translation(void);
> >  
> >  extern u64 __vgic_v3_get_ich_vtr_el2(void);
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 7e48a39..2eb5b23 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -57,6 +57,8 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
> >  
> >  extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
> >  
> > +extern int kvm_vcpu_run(struct kvm_vcpu *vcpu);
> > +
> >  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> >  
> >  extern u64 __vgic_v3_get_ich_vtr_el2(void);
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index ed30af5..8a0f38f 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -319,6 +319,63 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >  	return false;
> >  }
> >  
> > +/* Switch to the guest for VHE systems running in EL2 */
> > +int kvm_vcpu_run(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpu_context *host_ctxt;
> > +	struct kvm_cpu_context *guest_ctxt;
> > +	u64 exit_code;
> > +
> > +	vcpu = kern_hyp_va(vcpu);
> > +
> > +	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > +	host_ctxt->__hyp_running_vcpu = vcpu;
> > +	guest_ctxt = &vcpu->arch.ctxt;
> > +
> > +	__sysreg_save_host_state(host_ctxt);
> > +
> > +	__activate_traps(vcpu);
> > +	__activate_vm(vcpu);
> > +
> > +	__vgic_restore_state(vcpu);
> > +	__timer_enable_traps(vcpu);
> > +
> > +	/*
> > +	 * We must restore the 32-bit state before the sysregs, thanks
> > +	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
> > +	 */
> > +	__sysreg32_restore_state(vcpu);
> > +	__sysreg_restore_guest_state(guest_ctxt);
> > +	__debug_switch_to_guest(vcpu);
> > +
> > +	/* Jump in the fire! */
> > +again:
> > +	exit_code = __guest_enter(vcpu, host_ctxt);
> > +	/* And we're baaack! */
> > +
> > +	if (fixup_guest_exit(vcpu, &exit_code))
> > +		goto again;
> > +
> > +	__sysreg_save_guest_state(guest_ctxt);
> > +	__sysreg32_save_state(vcpu);
> > +	__timer_disable_traps(vcpu);
> > +	__vgic_save_state(vcpu);
> > +
> > +	__deactivate_traps(vcpu);
> > +	__deactivate_vm(vcpu);
> > +
> > +	__sysreg_restore_host_state(host_ctxt);
> > +
> > +	/*
> > +	 * This must come after restoring the host sysregs, since a non-VHE
> > +	 * system may enable SPE here and make use of the TTBRs.
> > +	 */
> > +	__debug_switch_to_host(vcpu);
> > +
> > +	return exit_code;
> > +}
> > +
> > +/* Switch to the guest for legacy non-VHE systems */
> >  int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> >  	struct kvm_cpu_context *host_ctxt;
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index cf121b2..b11647a 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -706,7 +706,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		trace_kvm_entry(*vcpu_pc(vcpu));
> >  		guest_enter_irqoff();
> >  
> > -		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
> > +		if (has_vhe())
> > +			ret = kvm_vcpu_run(vcpu);
> > +		else
> > +			ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
> 
> So kvm_vcpu_run() is going to be VHE only, but the only way for people
> stepping through the code to know that is by seeing this callsite or by
> reading the comment above it. Everywhere else we make it much more clear
> with the _vhe and _nvhe suffixes. I wonder if we should keep that pattern
> by adding
> 
>  static int kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>     if (has_vhe())
>         ret = kvm_vcpu_run_vhe(vcpu);
>     else
>         ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);
>  }
> 
> to virt/kvm/arm/arm.c and then calling that from here.
> 
> I'm afraid the __ prefix is too ambiguous in the kernel to interpret
> __foo() as the hyp mode non-VHE version of foo(), the hyp mode VHE
> version.
> 
Sure.

Thanks,
-Christoffer
