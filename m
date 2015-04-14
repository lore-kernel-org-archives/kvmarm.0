From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 10/10] KVM: arm64: add trace points for guest_debug
 debug
Date: Tue, 14 Apr 2015 12:32:26 +0200
Message-ID: <20150414103226.GY6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-11-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D62CE4D019
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:24:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K8c1MF6NFI-h for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2015 06:24:31 -0400 (EDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 685394D003
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:24:31 -0400 (EDT)
Received: by lbbqq2 with SMTP id qq2so4436121lbb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 03:32:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1427814488-28467-11-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:08PM +0100, Alex Benn=E9e wrote:
> This includes trace points for:
>   kvm_arch_setup_guest_debug
>   kvm_arch_clear_guest_debug
>   kvm_handle_guest_debug
> =

> I've also added some generic register setting trace events so I can
> watch the register values being built up over time. The local
> dump_dbg_regs() function dumps all the HW BKPT and WPT registers.
> =

> I've also added a #define trace_dreg to shorten some lines.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 638c111..7c96288 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -25,12 +25,37 @@
>  #include <asm/kvm_host.h>
>  #include <asm/kvm_emulate.h>
>  =

> +#include "trace.h"
> +
> +#define trace_dreg(name, value) trace_kvm_arch_setup_debug_reg32(name, v=
alue)
> +
>  /* These are the bits of MDSCR_EL1 we may mess with */
>  #define MDSCR_EL1_DEBUG_BITS	(DBG_MDSCR_SS | \
>  				DBG_MDSCR_KDE | \
>  				DBG_MDSCR_MDE)
>  =

>  /**
> + * dump_dbg_regs - simple debug helper
> + *
> + * This provides a simple helper to dump the HW debug registers
> + */
> +static void dump_dbg_regs(struct kvm_vcpu *vcpu, int nb, int nw)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < nb; i++) {
> +		trace_printk("bkpt%d: 0x%08x:0x%llx\n", i,
> +			(u32) vcpu_sys_reg(vcpu, DBGBCR0_EL1 + i),
> +			vcpu_sys_reg(vcpu, DBGBVR0_EL1 + i));
> +	}
> +	for (i =3D 0; i < nb; i++) {
> +		trace_printk("wtpt%d: 0x%08x:0x%llx\n", i,
> +			(u32) vcpu_sys_reg(vcpu, DBGWCR0_EL1 + i),
> +			vcpu_sys_reg(vcpu, DBGWVR0_EL1 + i));
> +	}
> +}
> +
> +/**
>   * kvm_arch_setup_debug - set-up debug related stuff
>   *
>   * @vcpu:	the vcpu pointer
> @@ -52,9 +77,13 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  {
>  	bool trap_debug =3D false;
>  =

> +	trace_kvm_arch_setup_debug(vcpu->guest_debug);
> +
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM | MDCR_EL2_TPMCR);
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TDRA | MDCR_EL2_TDOSA);
>  =

> +	trace_kvm_arch_setup_debug_reg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> +
>  	/*
>  	 * If we are not treating debug registers are dirty we need
>  	 * to trap if the guest starts accessing them.
> @@ -66,6 +95,8 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  	if (vcpu->guest_debug) {
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
>  =

> +		trace_dreg("MDCR_EL2", vcpu->arch.mdcr_el2);
> +
>  		/* Save pstate/mdscr */
>  		vcpu_debug_saved_reg(vcpu, pstate_ss_bit) =3D
>  			*vcpu_cpsr(vcpu) & DBG_SPSR_SS;
> @@ -73,6 +104,11 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  		vcpu_debug_saved_reg(vcpu, mdscr_el1) =3D
>  			vcpu_sys_reg(vcpu, MDSCR_EL1);
>  =

> +		trace_dreg("Save: PSTATE.SS",
> +			vcpu_debug_saved_reg(vcpu, pstate_ss_bit));
> +		trace_dreg("Save: MDSCR",
> +			vcpu_debug_saved_reg(vcpu, mdscr_el1));
> +
>  		/*
>  		 * Single Step (ARM ARM D2.12.3 The software step state
>  		 * machine)
> @@ -88,6 +124,8 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  			*vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;
>  			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
>  		}
> +		trace_dreg("SPSR_EL2", *vcpu_cpsr(vcpu));
> +		trace_dreg("MDSCR_EL1", vcpu_sys_reg(vcpu, MDSCR_EL1));
>  =

>  		/*
>  		 * HW Break/Watch points
> @@ -136,6 +174,9 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  			       &host->dbg_wvr,
>  			       sizeof(__u64)*nw);
>  =

> +			if (trace_kvm_arch_setup_debug_reg32_enabled())
> +				dump_dbg_regs(vcpu, nb, nw);
> +
>  			/* Make sure hyp.S copies them in/out */
>  			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
>  			/* Also track guest changes */
> @@ -147,15 +188,24 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;
>  	}
>  =

> +	trace_kvm_arch_setup_debug_reg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> +	trace_kvm_arch_setup_debug_reg32("MDSCR_EL1",
> +					vcpu_sys_reg(vcpu, MDSCR_EL1));
> +
> +
>  	/* Trap debug register access? */
>  	if (trap_debug)
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
>  	else
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
> +
> +	trace_kvm_arch_setup_debug_reg32("MDCR_EL2", vcpu->arch.mdcr_el2);
>  }
>  =

>  void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
>  {
> +	trace_kvm_arch_clear_debug(vcpu->guest_debug);
> +
>  	if (vcpu->guest_debug) {
>  		/* Restore pstate/mdscr bits we may have messed with */
>  		*vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;
> @@ -164,6 +214,8 @@ void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
>  		vcpu_sys_reg(vcpu, MDSCR_EL1) =3D
>  			vcpu_debug_saved_reg(vcpu, mdscr_el1);
>  =

> +		trace_dreg("SPSR_EL2", *vcpu_cpsr(vcpu));
> +		trace_dreg("MDSCR_EL1", vcpu_sys_reg(vcpu, MDSCR_EL1));
>  		/*
>  		 * If we were using HW debug we need to restore the
>  		 * values the guest had set them up with
> @@ -188,6 +240,10 @@ void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
>  			memcpy(&vcpu_sys_reg(vcpu, DBGWVR0_EL1),
>  			       &regs->dbg_wvr,
>  			       sizeof(__u64)*nw);
> +
> +			if (trace_kvm_arch_setup_debug_reg32_enabled())
> +				dump_dbg_regs(vcpu, nb, nw);
> +
>  		}
>  	}
>  }
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 460a1aa..c6cc69a 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -97,6 +97,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
>  {
>  	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
>  =

> +	trace_kvm_handle_guest_debug(*vcpu_pc(vcpu), hsr);
> +
>  	run->exit_reason =3D KVM_EXIT_DEBUG;
>  	run->debug.arch.hsr =3D hsr;
>  =

> diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
> index 157416e9..dffdb49 100644
> --- a/arch/arm64/kvm/trace.h
> +++ b/arch/arm64/kvm/trace.h
> @@ -44,6 +44,72 @@ TRACE_EVENT(kvm_hvc_arm64,
>  		  __entry->vcpu_pc, __entry->r0, __entry->imm)
>  );
>  =

> +TRACE_EVENT(kvm_handle_guest_debug,
> +	TP_PROTO(unsigned long vcpu_pc, u32 hsr),
> +	TP_ARGS(vcpu_pc, hsr),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long,	vcpu_pc)
> +		__field(u32,		hsr)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_pc =3D vcpu_pc;
> +		__entry->hsr =3D hsr;
> +	),
> +
> +	TP_printk("debug exception at 0x%08lx (HSR: 0x%08x)",
> +		__entry->vcpu_pc, __entry->hsr)
> +);
> +
> +
> +TRACE_EVENT(kvm_arch_setup_debug,
> +	TP_PROTO(__u32 guest_debug),
> +	TP_ARGS(guest_debug),
> +
> +	TP_STRUCT__entry(
> +		__field(__u32, guest_debug)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->guest_debug =3D guest_debug;
> +	),
> +
> +	TP_printk("flags: 0x%08x", __entry->guest_debug)
> +);
> +
> +TRACE_EVENT(kvm_arch_clear_debug,
> +	TP_PROTO(__u32 guest_debug),
> +	TP_ARGS(guest_debug),
> +
> +	TP_STRUCT__entry(
> +		__field(__u32, guest_debug)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->guest_debug =3D guest_debug;
> +	),
> +
> +	TP_printk("flags: 0x%08x", __entry->guest_debug)
> +);
> +
> +TRACE_EVENT(kvm_arch_setup_debug_reg32,
> +	TP_PROTO(const char *name, __u32 value),
> +	TP_ARGS(name, value),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(__u32, value)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name =3D name;
> +		__entry->value =3D value;
> +	),
> +
> +	TP_printk("%s now 0x%08x", __entry->name, __entry->value)
> +);
> +
>  #endif /* _TRACE_ARM64_KVM_H */
>  =

>  #undef TRACE_INCLUDE_PATH
> -- =

> 2.3.4
> =


I would guess that as far as merging any of this upstream keeping the
kvm_arch_set_debug() and kvm_handle_guest_debug() are worth keeping, but
only if the kvm_arch_set_debug() is only called when the guest is
actually being debugged from userspace.

Thanks,
-Christoffer
