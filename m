From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 10/10] KVM: arm64: add trace points for guest_debug
 debug
Date: Fri, 10 Apr 2015 14:54:16 +0200
Message-ID: <20150410125415.GC3227@hawk.usersys.redhat.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-11-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427814488-28467-11-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


$SUBJECT | sed s/guest_debug debug/guest debug/ ?

On Tue, Mar 31, 2015 at 04:08:08PM +0100, Alex Benn=E9e wrote:
> This includes trace points for:
>   kvm_arch_setup_guest_debug
>   kvm_arch_clear_guest_debug
>   kvm_handle_guest_debug
>=20
> I've also added some generic register setting trace events so I can
> watch the register values being built up over time. The local
> dump_dbg_regs() function dumps all the HW BKPT and WPT registers.
>=20
> I've also added a #define trace_dreg to shorten some lines.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 638c111..7c96288 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -25,12 +25,37 @@
>  #include <asm/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> =20
> +#include "trace.h"
> +
> +#define trace_dreg(name, value) trace_kvm_arch_setup_debug_reg32(nam=
e, value)

I don't think this name shortener should be necessary

> +
>  /* These are the bits of MDSCR_EL1 we may mess with */
>  #define MDSCR_EL1_DEBUG_BITS	(DBG_MDSCR_SS | \
>  				DBG_MDSCR_KDE | \
>  				DBG_MDSCR_MDE)
> =20
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
> =20
> +	trace_kvm_arch_setup_debug(vcpu->guest_debug);
> +
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM | MDCR_EL2_TPMCR);
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TDRA | MDCR_EL2_TDOSA);
> =20
> +	trace_kvm_arch_setup_debug_reg32("MDCR_EL2", vcpu->arch.mdcr_el2);

Not using your trace_dreg here? I guess you didn't think it was
necessary either.

> +
>  	/*
>  	 * If we are not treating debug registers are dirty we need
>  	 * to trap if the guest starts accessing them.
> @@ -66,6 +95,8 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  	if (vcpu->guest_debug) {
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
> =20
> +		trace_dreg("MDCR_EL2", vcpu->arch.mdcr_el2);
> +
>  		/* Save pstate/mdscr */
>  		vcpu_debug_saved_reg(vcpu, pstate_ss_bit) =3D
>  			*vcpu_cpsr(vcpu) & DBG_SPSR_SS;
> @@ -73,6 +104,11 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  		vcpu_debug_saved_reg(vcpu, mdscr_el1) =3D
>  			vcpu_sys_reg(vcpu, MDSCR_EL1);
> =20
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
> =20
>  		/*
>  		 * HW Break/Watch points
> @@ -136,6 +174,9 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  			       &host->dbg_wvr,
>  			       sizeof(__u64)*nw);
> =20
> +			if (trace_kvm_arch_setup_debug_reg32_enabled())
> +				dump_dbg_regs(vcpu, nb, nw);
> +
>  			/* Make sure hyp.S copies them in/out */
>  			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
>  			/* Also track guest changes */
> @@ -147,15 +188,24 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu=
)
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;
>  	}
> =20
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
> =20
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
> =20
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
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exi=
t.c
> index 460a1aa..c6cc69a 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -97,6 +97,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *=
vcpu, struct kvm_run *run)
>  {
>  	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
> =20
> +	trace_kvm_handle_guest_debug(*vcpu_pc(vcpu), hsr);
> +
>  	run->exit_reason =3D KVM_EXIT_DEBUG;
>  	run->debug.arch.hsr =3D hsr;
> =20
> diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
> index 157416e9..dffdb49 100644
> --- a/arch/arm64/kvm/trace.h
> +++ b/arch/arm64/kvm/trace.h
> @@ -44,6 +44,72 @@ TRACE_EVENT(kvm_hvc_arm64,
>  		  __entry->vcpu_pc, __entry->r0, __entry->imm)
>  );
> =20
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
> =20
>  #undef TRACE_INCLUDE_PATH
> --=20
> 2.3.4
>=20

This looks like it would be super noisy. I'm sure that's nice for
developing/debugging, but can't we reduce the, now debugged, version
down to just one trace point per unique, and interesting, path? If you
have several variables you want to see, then maybe they can all be
on the same line.

Also, I'm not sure about the necessity of the dump_dbg_regs function,
but I think you should be able to embed it in the trace event code
using __print_array

drew
