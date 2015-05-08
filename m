From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 12/12] KVM: arm64: add trace points for guest_debug
 debug
Date: Fri, 8 May 2015 19:25:03 +0200
Message-ID: <20150508172503.GM24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430989647-22501-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2318250EAA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 13:16:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wIWYb9OhpxwN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2015 13:16:10 -0400 (EDT)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
 [209.85.217.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D09BA50EA9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 13:16:09 -0400 (EDT)
Received: by lbbzk7 with SMTP id zk7so57870295lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 May 2015 10:25:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1430989647-22501-5-git-send-email-alex.bennee@linaro.org>
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

On Thu, May 07, 2015 at 10:07:15AM +0100, Alex Benn=E9e wrote:
> This includes trace points for:
>   kvm_arch_setup_guest_debug
>   kvm_arch_clear_guest_debug
>   kvm_handle_guest_debug
> =

> I've also added some generic register setting trace events and also a
> trace point to dump the array of hardware registers.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v3
>   - add trace event for debug access.
>   - remove short trace #define, rename trace events
>   - use __print_array with fixed array instead of own func
>   - rationalise trace points (only one per register changed)
>   - add vcpu ptr to the debug_setup trace
>   - remove :: in prints
> =

> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index dc8bca8..08e1b83 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -24,6 +24,8 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_emulate.h>
>  =

> +#include "trace.h"
> +
>  /* These are the bits of MDSCR_EL1 we may manipulate */
>  #define MDSCR_EL1_DEBUG_MASK	(DBG_MDSCR_SS | \
>  				DBG_MDSCR_KDE | \
> @@ -44,6 +46,11 @@ static void save_guest_debug_regs(struct kvm_vcpu *vcp=
u)
>  {
>  	vcpu->arch.guest_debug_state.pstate =3D *vcpu_cpsr(vcpu);
>  	vcpu->arch.guest_debug_state.mdscr_el1 =3D vcpu_sys_reg(vcpu, MDSCR_EL1=
);
> +
> +	trace_kvm_arm_set_dreg32("Saved PSTATE",
> +				vcpu->arch.guest_debug_state.pstate);
> +	trace_kvm_arm_set_dreg32("Saved MDSCR_EL1",
> +				vcpu->arch.guest_debug_state.mdscr_el1);

wouldn't it make sense to turn these into a single tracepoint with two
parameters?

>  }
>  =

>  static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
> @@ -51,6 +58,10 @@ static void restore_guest_debug_regs(struct kvm_vcpu *=
vcpu)
>  	*vcpu_cpsr(vcpu) |=3D
>  		(vcpu->arch.guest_debug_state.pstate & SPSR_DEBUG_MASK);
>  	vcpu_sys_reg(vcpu, MDSCR_EL1) =3D vcpu->arch.guest_debug_state.mdscr_el=
1;
> +
> +	trace_kvm_arm_set_dreg32("Restored PSTATE", *vcpu_cpsr(vcpu));
> +	trace_kvm_arm_set_dreg32("Restored MDSCR_EL1",
> +				vcpu_sys_reg(vcpu, MDSCR_EL1));

ditto

>  }
>  =

>  /**
> @@ -92,6 +103,8 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  {
>  	bool trap_debug =3D !(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY);
>  =

> +	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
> +
>  	vcpu->arch.mdcr_el2 =3D __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM |
>  				MDCR_EL2_TPMCR |
> @@ -121,6 +134,8 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
>  		}
>  =

> +		trace_kvm_arm_set_dreg32("SPSR_EL2", *vcpu_cpsr(vcpu));
> +
>  		/*
>  		 * HW Break/Watch points
>  		 *
> @@ -138,6 +153,14 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  			vcpu->arch.debug_ptr =3D &vcpu->arch.external_debug_state;
>  			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
>  			trap_debug =3D true;
> +
> +			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
> +						&vcpu->arch.debug_ptr->dbg_bcr[0],
> +						&vcpu->arch.debug_ptr->dbg_bvr[0]);
> +
> +			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
> +						&vcpu->arch.debug_ptr->dbg_wcr[0],
> +						&vcpu->arch.debug_ptr->dbg_wvr[0]);

feels like this should also be a single tracepoint

>  		}
>  =

>  	} else {
> @@ -155,10 +178,15 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
>  	else
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
> +
> +	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> +	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_sys_reg(vcpu, MDSCR_EL1));
>  }
>  =

>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  {
> +	trace_kvm_arm_clear_debug(vcpu->guest_debug);
> +
>  	if (vcpu->guest_debug) {
>  		restore_guest_debug_regs(vcpu);
>  =

> @@ -169,6 +197,14 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
>  			vcpu->arch.debug_ptr =3D (struct kvm_guest_debug_arch *)
>  				&vcpu_sys_reg(vcpu, DBGBCR0_EL1);
> +
> +			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
> +						&vcpu->arch.debug_ptr->dbg_bcr[0],
> +						&vcpu->arch.debug_ptr->dbg_bvr[0]);
> +
> +			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
> +						&vcpu->arch.debug_ptr->dbg_wcr[0],
> +						&vcpu->arch.debug_ptr->dbg_wvr[0]);

ditto

>  		}
>  	}
>  }
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 68a0759..c93b95e 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -99,6 +99,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
>  	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
>  	int ret =3D 0;
>  =

> +	trace_kvm_handle_guest_debug(*vcpu_pc(vcpu), hsr);
> +

does this provide anything beyond the generic handle_exit tracepoint?

>  	run->exit_reason =3D KVM_EXIT_DEBUG;
>  	run->debug.arch.hsr =3D hsr;
>  =

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 95f422f..ec803ad 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -38,6 +38,8 @@
>  =

>  #include "sys_regs.h"
>  =

> +#include "trace.h"
> +
>  /*
>   * All of this file is extremly similar to the ARM coproc.c, but the
>   * types are different. My gut feeling is that it should be pretty
> @@ -227,6 +229,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> +	trace_trap_debug_regs(r->reg, p->is_write,
> +			p->is_write?*vcpu_reg(vcpu, p->Rt):0);
> +
>  	if (vcpu->guest_debug && shadow_debug_reg(vcpu, p, r))
>  		return true;
>  =

> diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
> index 157416e9..62e6b76 100644
> --- a/arch/arm64/kvm/trace.h
> +++ b/arch/arm64/kvm/trace.h
> @@ -44,6 +44,113 @@ TRACE_EVENT(kvm_hvc_arm64,
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
> +TRACE_EVENT(kvm_arm_setup_debug,
> +	TP_PROTO(struct kvm_vcpu *vcpu, __u32 guest_debug),
> +	TP_ARGS(vcpu, guest_debug),
> +
> +	TP_STRUCT__entry(
> +		__field(struct kvm_vcpu *, vcpu)
> +		__field(__u32, guest_debug)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu =3D vcpu;
> +		__entry->guest_debug =3D guest_debug;
> +	),
> +
> +	TP_printk("vcpu: %p, flags: 0x%08x", __entry->vcpu, __entry->guest_debu=
g)
> +);
> +
> +TRACE_EVENT(kvm_arm_clear_debug,
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
> +TRACE_EVENT(kvm_arm_set_dreg32,
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
> +	TP_printk("%s: 0x%08x", __entry->name, __entry->value)
> +);
> +
> +TRACE_EVENT(kvm_arm_set_regset,
> +	TP_PROTO(const char *type, int len, __u64 *control, __u64 *value),
> +	TP_ARGS(type, len, control, value),
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(int, len)
> +		__array(u64, ctrls, 16)
> +		__array(u64, values, 16)
> +	),
> +	TP_fast_assign(
> +		__entry->name =3D type;
> +		__entry->len =3D len;
> +		memcpy(__entry->ctrls, control, len << 3);
> +		memcpy(__entry->values, value, len << 3);
> +	),
> +	TP_printk("%d %s CTRL:%s VALUE:%s", __entry->len, __entry->name,
> +		__print_array(__entry->ctrls, __entry->len, sizeof(__u64)),
> +		__print_array(__entry->values, __entry->len, sizeof(__u64)))
> +);
> +
> +TRACE_EVENT(trap_debug_regs,
> +	TP_PROTO(int reg, bool is_write, u64 write_value),
> +	TP_ARGS(reg, is_write, write_value),
> +
> +	TP_STRUCT__entry(
> +		__field(int, reg)
> +		__field(bool, is_write)
> +		__field(u64, write_value)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->reg =3D reg;
> +		__entry->is_write =3D is_write;
> +		__entry->write_value =3D write_value;
> +	),
> +
> +	TP_printk("%s reg %d (0x%08llx)", __entry->is_write?"write to":"read fr=
om", __entry->reg, __entry->write_value)
> +);
> +
>  #endif /* _TRACE_ARM64_KVM_H */
>  =

>  #undef TRACE_INCLUDE_PATH
> -- =

> 2.3.5
> =


Thanks,
-Christoffer
