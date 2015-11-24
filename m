From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 11/21] arm64: KVM: Implement the core world switch
Date: Tue, 24 Nov 2015 17:29:14 +0000
Message-ID: <87poyze26t.fsf@linaro.org>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com> <1447679519-17888-12-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1447679519-17888-12-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <marc.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Marc Zyngier <marc.zyngier@arm.com> writes:

> Implement the core of the world switch in C. Not everything is there
> yet, and there is nothing to re-enter the world switch either.
>
> But this already outlines the code structure well enough.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/Makefile |   1 +
>  arch/arm64/kvm/hyp/switch.c | 134 ++++++++++++++++++++++++++++++++++=
++++++++++
>  2 files changed, 135 insertions(+)
>  create mode 100644 arch/arm64/kvm/hyp/switch.c
>
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefil=
e
> index 1e1ff06..9c11b0f 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_KVM_ARM_HOST) +=3D timer-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) +=3D sysreg-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) +=3D debug-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) +=3D entry.o
> +obj-$(CONFIG_KVM_ARM_HOST) +=3D switch.o
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.=
c
> new file mode 100644
> index 0000000..a3af81a
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -0,0 +1,134 @@
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
> +#include "hyp.h"
> +
> +static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> +{
> +	u64 val;
> +
> +	/*
> +	 * We are about to set CPTR_EL2.TFP to trap all floating point
> +	 * register accesses to EL2, however, the ARM ARM clearly states th=
at
> +	 * traps are only taken to EL2 if the operation would not otherwise
> +	 * trap to EL1.  Therefore, always make sure that for 32-bit guests=
,
> +	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bi=
t.
> +	 */
> +	val =3D vcpu->arch.hcr_el2;
> +	if (val & HCR_RW) {
> +		write_sysreg(1 << 30, fpexc32_el2);
> +		isb();
> +	}
> +	write_sysreg(val, hcr_el2);
> +	write_sysreg(1 << 15, hstr_el2);
> +	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
> +	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> +}
> +
> +static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
> +{
> +	write_sysreg(HCR_RW, hcr_el2);
> +	write_sysreg(0, hstr_el2);
> +	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
> +	write_sysreg(0, cptr_el2);
> +}
> +
> +static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm =3D kern_hyp_va(vcpu->kvm);
> +	write_sysreg(kvm->arch.vttbr, vttbr_el2);
> +}
> +
> +static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
> +{
> +	write_sysreg(0, vttbr_el2);
> +}
> +
> +static hyp_alternate_select(__vgic_call_save_state,
> +			    __vgic_v2_save_state, __vgic_v3_save_state,
> +			    ARM64_HAS_SYSREG_GIC_CPUIF);
> +
> +static hyp_alternate_select(__vgic_call_restore_state,
> +			    __vgic_v2_restore_state, __vgic_v3_restore_state,
> +			    ARM64_HAS_SYSREG_GIC_CPUIF);
> +
> +static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
> +{
> +	__vgic_call_save_state()(vcpu);
> +	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
> +}
> +
> +static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	u64 val;
> +
> +	val =3D read_sysreg(hcr_el2);
> +	val |=3D 	HCR_INT_OVERRIDE;
> +	val |=3D vcpu->arch.irq_lines;
> +	write_sysreg(val, hcr_el2);
> +
> +	__vgic_call_restore_state()(vcpu);
> +}
> +
> +int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *host_ctxt;
> +	struct kvm_cpu_context *guest_ctxt;
> +	u64 exit_code;
> +
> +	vcpu =3D kern_hyp_va(vcpu);
> +	write_sysreg(vcpu, tpidr_el2);
> +
> +	host_ctxt =3D kern_hyp_va(vcpu->arch.host_cpu_context);
> +	guest_ctxt =3D &vcpu->arch.ctxt;
> +
> +	__sysreg_save_state(host_ctxt);
> +	__debug_cond_save_state(vcpu, &vcpu->arch.host_debug_state, host_ct=
xt);
> +
> +	__activate_traps(vcpu);
> +	__activate_vm(vcpu);
> +
> +	__vgic_restore_state(vcpu);
> +	__timer_restore_state(vcpu);
> +
> +	/*
> +	 * We must restore the 32-bit state before the sysregs, thanks
> +	 * to Cortex-A57 erratum #852523.
> +	 */
> +	__sysreg32_restore_state(vcpu);
> +	__sysreg_restore_state(guest_ctxt);
> +	__debug_restore_state(vcpu, &vcpu->arch.vcpu_debug_state,
> guest_ctxt);

Did you right this before guest debug was merged? Now
vcpu.debug_ptr/VCPU_DEBUG_PTR selects which set of debug registers we
are going to use before entering the guest.


> +
> +	/* Jump in the fire! */
> +	exit_code =3D __guest_enter(vcpu, host_ctxt);
> +	/* And we're baaack! */
> +
> +	__sysreg_save_state(guest_ctxt);
> +	__sysreg32_save_state(vcpu);
> +	__timer_save_state(vcpu);
> +	__vgic_save_state(vcpu);
> +
> +	__deactivate_traps(vcpu);
> +	__deactivate_vm(vcpu);
> +
> +	__sysreg_restore_state(host_ctxt);
> +
> +	__debug_save_state(vcpu, &vcpu->arch.vcpu_debug_state, guest_ctxt);
> +	__debug_clear_restore_state(vcpu, &vcpu->arch.host_debug_state, hos=
t_ctxt);
> +
> +	return exit_code;
> +}


--=20
Alex Benn=C3=A9e
