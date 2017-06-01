From: Bandan Das <bsd@redhat.com>
Subject: Re: [RFC 07/55] KVM: arm/arm64: Add virtual EL2 state emulation framework
Date: Thu, 01 Jun 2017 16:05:49 -0400
Message-ID: <jpg37bj1nj6.fsf@linux.bootlegged.copy>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
        <1483943091-1364-8-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483943091-1364-8-git-send-email-jintack@cs.columbia.edu>
        (Jintack Lim's message of "Mon, 9 Jan 2017 01:24:03 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Jintack Lim <jintack@cs.columbia.edu> writes:
...
> +/**
> + * kvm_arm_setup_shadow_state -- prepare shadow state based on emulated mode
> + * @vcpu: The VCPU pointer
> + */
> +void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> +
> +	ctxt->hw_pstate = *vcpu_cpsr(vcpu);
> +	ctxt->hw_sys_regs = ctxt->sys_regs;
> +	ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
> +}
> +
> +/**
> + * kvm_arm_restore_shadow_state -- write back shadow state from guest
> + * @vcpu: The VCPU pointer
> + */
> +void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> +
> +	*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
> +	ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
> +}
> +
> +void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt)
> +{
> +	cpu_ctxt->hw_sys_regs = &cpu_ctxt->sys_regs[0];
> +}


IIUC, the *_shadow_state() functions will set hw_* pointers to
either point to the "real" state or the shadow state to manage L2 ?
Maybe, it might make sense to make these function names a little more
generic since they are not dealing with setting the shadow state
alone.

> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 9341376..f2a1b32 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -19,6 +19,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  
>  /* Yes, this does nothing, on purpose */
> @@ -33,37 +34,41 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
>  
>  static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
>  {
> -	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
> -	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
> -	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
> -	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
> -	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
> +	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
> +
> +	sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
> +	sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
> +	sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
> +	sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
> +	sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
>  	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
>  	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
> -	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
> +	ctxt->hw_pstate			= read_sysreg_el2(spsr);
>  }
>  
>  static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
>  {
> -	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
> -	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
> -	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
> -	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
> -	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
> -	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
> -	ctxt->sys_regs[TCR_EL1]		= read_sysreg_el1(tcr);
> -	ctxt->sys_regs[ESR_EL1]		= read_sysreg_el1(esr);
> -	ctxt->sys_regs[AFSR0_EL1]	= read_sysreg_el1(afsr0);
> -	ctxt->sys_regs[AFSR1_EL1]	= read_sysreg_el1(afsr1);
> -	ctxt->sys_regs[FAR_EL1]		= read_sysreg_el1(far);
> -	ctxt->sys_regs[MAIR_EL1]	= read_sysreg_el1(mair);
> -	ctxt->sys_regs[VBAR_EL1]	= read_sysreg_el1(vbar);
> -	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(contextidr);
> -	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
> -	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
> -	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
> -
> -	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
> +	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
> +
> +	sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
> +	sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
> +	sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
> +	sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
> +	sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
> +	sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
> +	sys_regs[TCR_EL1]	= read_sysreg_el1(tcr);
> +	sys_regs[ESR_EL1]	= read_sysreg_el1(esr);
> +	sys_regs[AFSR0_EL1]	= read_sysreg_el1(afsr0);
> +	sys_regs[AFSR1_EL1]	= read_sysreg_el1(afsr1);
> +	sys_regs[FAR_EL1]	= read_sysreg_el1(far);
> +	sys_regs[MAIR_EL1]	= read_sysreg_el1(mair);
> +	sys_regs[VBAR_EL1]	= read_sysreg_el1(vbar);
> +	sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(contextidr);
> +	sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
> +	sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
> +	sys_regs[PAR_EL1]		= read_sysreg(par_el1);
> +
> +	ctxt->hw_sp_el1			= read_sysreg(sp_el1);
>  	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
>  	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
>  }
> @@ -86,37 +91,41 @@ void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
>  
>  static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
>  {
> -	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
> -	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
> -	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
> -	write_sysreg(ctxt->sys_regs[TPIDR_EL1],	  tpidr_el1);
> -	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
> +	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
> +
> +	write_sysreg(sys_regs[ACTLR_EL1],	  actlr_el1);
> +	write_sysreg(sys_regs[TPIDR_EL0],	  tpidr_el0);
> +	write_sysreg(sys_regs[TPIDRRO_EL0],	tpidrro_el0);
> +	write_sysreg(sys_regs[TPIDR_EL1],	  tpidr_el1);
> +	write_sysreg(sys_regs[MDSCR_EL1],	  mdscr_el1);
>  	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
>  	write_sysreg_el2(ctxt->gp_regs.regs.pc,	  elr);
> -	write_sysreg_el2(ctxt->gp_regs.regs.pstate, spsr);
> +	write_sysreg_el2(ctxt->hw_pstate,	  spsr);
>  }
>  
>  static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
>  {
> -	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
> -	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
> -	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	sctlr);
> -	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	cpacr);
> -	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	ttbr0);
> -	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	ttbr1);
> -	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	tcr);
> -	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	esr);
> -	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	afsr0);
> -	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	afsr1);
> -	write_sysreg_el1(ctxt->sys_regs[FAR_EL1],	far);
> -	write_sysreg_el1(ctxt->sys_regs[MAIR_EL1],	mair);
> -	write_sysreg_el1(ctxt->sys_regs[VBAR_EL1],	vbar);
> -	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL1],contextidr);
> -	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	amair);
> -	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1], 	cntkctl);
> -	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
> -
> -	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
> +	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
> +
> +	write_sysreg(sys_regs[MPIDR_EL1],	vmpidr_el2);
> +	write_sysreg(sys_regs[CSSELR_EL1],	csselr_el1);
> +	write_sysreg_el1(sys_regs[SCTLR_EL1],	sctlr);
> +	write_sysreg_el1(sys_regs[CPACR_EL1],	cpacr);
> +	write_sysreg_el1(sys_regs[TTBR0_EL1],	ttbr0);
> +	write_sysreg_el1(sys_regs[TTBR1_EL1],	ttbr1);
> +	write_sysreg_el1(sys_regs[TCR_EL1],	tcr);
> +	write_sysreg_el1(sys_regs[ESR_EL1],	esr);
> +	write_sysreg_el1(sys_regs[AFSR0_EL1],	afsr0);
> +	write_sysreg_el1(sys_regs[AFSR1_EL1],	afsr1);
> +	write_sysreg_el1(sys_regs[FAR_EL1],	far);
> +	write_sysreg_el1(sys_regs[MAIR_EL1],	mair);
> +	write_sysreg_el1(sys_regs[VBAR_EL1],	vbar);
> +	write_sysreg_el1(sys_regs[CONTEXTIDR_EL1], contextidr);
> +	write_sysreg_el1(sys_regs[AMAIR_EL1],	amair);
> +	write_sysreg_el1(sys_regs[CNTKCTL_EL1], cntkctl);
> +	write_sysreg(sys_regs[PAR_EL1],		par_el1);
> +
> +	write_sysreg(ctxt->hw_sp_el1,			sp_el1);
>  	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
>  	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
>  }
