From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 08/21] arm64: KVM: Implement debug save/restore
Date: Mon, 30 Nov 2015 12:00:24 +0000
Message-ID: <87d1urbstj.fsf@linaro.org>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <1448650215-15218-9-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1448650215-15218-9-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Marc Zyngier <marc.zyngier@arm.com> writes:

> Implement the debug save restore as a direct translation of
> the assembly code version.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/Makefile   |   1 +
>  arch/arm64/kvm/hyp/debug-sr.c | 130 ++++++++++++++++++++++++++++++++=
++++++++++
>  arch/arm64/kvm/hyp/hyp.h      |   9 +++
>  3 files changed, 140 insertions(+)
>  create mode 100644 arch/arm64/kvm/hyp/debug-sr.c
>
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefil=
e
> index ec94200..ec14cac 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_KVM_ARM_HOST) +=3D vgic-v2-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) +=3D vgic-v3-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) +=3D timer-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) +=3D sysreg-sr.o
> +obj-$(CONFIG_KVM_ARM_HOST) +=3D debug-sr.o
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug=
-sr.c
> new file mode 100644
> index 0000000..a0b2b99
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -0,0 +1,130 @@
> +/*
> + * Copyright (C) 2015 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/license=
s/>.
> + */
> +
> +#include <linux/compiler.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_mmu.h>
> +
> +#include "hyp.h"
> +
> +#define read_debug(r,n)		read_sysreg(r##n##_el1)
> +#define write_debug(v,r,n)	write_sysreg(v, r##n##_el1)
> +
> +#define save_debug(ptr,reg,nr)						\
> +	switch (nr) {							\
> +	case 15:	ptr[15] =3D read_debug(reg, 15);			\
> +	case 14:	ptr[14] =3D read_debug(reg, 14);			\
> +	case 13:	ptr[13] =3D read_debug(reg, 13);			\
> +	case 12:	ptr[12] =3D read_debug(reg, 12);			\
> +	case 11:	ptr[11] =3D read_debug(reg, 11);			\
> +	case 10:	ptr[10] =3D read_debug(reg, 10);			\
> +	case 9:		ptr[9] =3D read_debug(reg, 9);			\
> +	case 8:		ptr[8] =3D read_debug(reg, 8);			\
> +	case 7:		ptr[7] =3D read_debug(reg, 7);			\
> +	case 6:		ptr[6] =3D read_debug(reg, 6);			\
> +	case 5:		ptr[5] =3D read_debug(reg, 5);			\
> +	case 4:		ptr[4] =3D read_debug(reg, 4);			\
> +	case 3:		ptr[3] =3D read_debug(reg, 3);			\
> +	case 2:		ptr[2] =3D read_debug(reg, 2);			\
> +	case 1:		ptr[1] =3D read_debug(reg, 1);			\
> +	default:	ptr[0] =3D read_debug(reg, 0);			\
> +	}
> +
> +#define restore_debug(ptr,reg,nr)					\
> +	switch (nr) {							\
> +	case 15:	write_debug(ptr[15], reg, 15);			\
> +	case 14:	write_debug(ptr[14], reg, 14);			\
> +	case 13:	write_debug(ptr[13], reg, 13);			\
> +	case 12:	write_debug(ptr[12], reg, 12);			\
> +	case 11:	write_debug(ptr[11], reg, 11);			\
> +	case 10:	write_debug(ptr[10], reg, 10);			\
> +	case 9:		write_debug(ptr[9], reg, 9);			\
> +	case 8:		write_debug(ptr[8], reg, 8);			\
> +	case 7:		write_debug(ptr[7], reg, 7);			\
> +	case 6:		write_debug(ptr[6], reg, 6);			\
> +	case 5:		write_debug(ptr[5], reg, 5);			\
> +	case 4:		write_debug(ptr[4], reg, 4);			\
> +	case 3:		write_debug(ptr[3], reg, 3);			\
> +	case 2:		write_debug(ptr[2], reg, 2);			\
> +	case 1:		write_debug(ptr[1], reg, 1);			\
> +	default:	write_debug(ptr[0], reg, 0);			\
> +	}
> +
> +void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
> +				   struct kvm_guest_debug_arch *dbg,
> +				   struct kvm_cpu_context *ctxt)
> +{
> +	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY) {
> +		u64 aa64dfr0 =3D read_sysreg(id_aa64dfr0_el1);
> +		int brps, wrps;
> +
> +		brps =3D (aa64dfr0 >> 12) & 0xf;
> +		wrps =3D (aa64dfr0 >> 20) & 0xf;

I'm sure we have that defined - get_num_brps/wrps() - but I don't know
if the compiler would do a better job with it.

> +
> +		save_debug(dbg->dbg_bcr, dbgbcr, brps);
> +		save_debug(dbg->dbg_bvr, dbgbvr, brps);
> +		save_debug(dbg->dbg_wcr, dbgwcr, wrps);
> +		save_debug(dbg->dbg_wvr, dbgwvr, wrps);
> +
> +		ctxt->sys_regs[MDCCINT_EL1] =3D read_sysreg(mdccint_el1);
> +	}
> +}
> +
> +void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
> +				      struct kvm_guest_debug_arch *dbg,
> +				      struct kvm_cpu_context *ctxt)
> +{
> +	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY) {
> +		u64 aa64dfr0 =3D read_sysreg(id_aa64dfr0_el1);
> +		int brps, wrps;
> +
> +		brps =3D (aa64dfr0 >> 12) & 0xf;
> +		wrps =3D (aa64dfr0 >> 20) & 0xf;
> +
> +		restore_debug(dbg->dbg_bcr, dbgbcr, brps);
> +		restore_debug(dbg->dbg_bvr, dbgbvr, brps);
> +		restore_debug(dbg->dbg_wcr, dbgwcr, wrps);
> +		restore_debug(dbg->dbg_wvr, dbgwvr, wrps);
> +
> +		write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
> +	}
> +}
> +
> +void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
> +{
> +	if ((vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_KDE) ||
> +	    (vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_KDE))
> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +
> +	__debug_save_state(vcpu, &vcpu->arch.host_debug_state,
> +			   kern_hyp_va(vcpu->arch.host_cpu_context));
> +}
> +
> +void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcp=
u)
> +{
> +	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY) {
> +		__debug_restore_state(vcpu, &vcpu->arch.host_debug_state,
> +				      kern_hyp_va(vcpu->arch.host_cpu_context));
> +		vcpu->arch.debug_flags &=3D ~KVM_ARM64_DEBUG_DIRTY;
> +	}
> +}
> +
> +u32 __hyp_text __debug_read_mdcr_el2(void)
> +{
> +	return read_sysreg(mdcr_el2);
> +}
> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> index 4639330..2581232 100644
> --- a/arch/arm64/kvm/hyp/hyp.h
> +++ b/arch/arm64/kvm/hyp/hyp.h
> @@ -41,5 +41,14 @@ void __sysreg_restore_state(struct kvm_cpu_context=
 *ctxt);
>  void __sysreg32_save_state(struct kvm_vcpu *vcpu);
>  void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
>
> +void __debug_save_state(struct kvm_vcpu *vcpu,
> +			struct kvm_guest_debug_arch *dbg,
> +			struct kvm_cpu_context *ctxt);
> +void __debug_restore_state(struct kvm_vcpu *vcpu,
> +			   struct kvm_guest_debug_arch *dbg,
> +			   struct kvm_cpu_context *ctxt);
> +void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
> +void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARM64_KVM_HYP_H__ */

I spun it up against my KVM debug tests and everything was fine. Have a=
:

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>


--
Alex Benn=C3=A9e
