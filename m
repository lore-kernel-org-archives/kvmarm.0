From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 05/10] KVM: arm: introduce kvm_arch_setup/clear_debug()
Date: Mon, 13 Apr 2015 16:36:23 +0200
Message-ID: <20150413143623.GP6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427814488-28467-6-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:03PM +0100, Alex Benn=E9e wrote:
> This is a precursor for later patches which will need to do more to
> setup debug state before entering the hyp.S switch code. The existing
> functionality for setting mdcr_el2 has been moved out of hyp.S and no=
w
> uses the value kept in vcpu->arch.mdcr_el2.
>=20
> This also moves the conditional setting of the TDA bit from the hyp c=
ode
> into the C code.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
>  create mode 100644 arch/arm64/kvm/debug.c
>=20
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/k=
vm_host.h
> index 41008cd..8c01c97 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -242,5 +242,7 @@ static inline void kvm_arch_hardware_unsetup(void=
) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)=
 {}
> +static inline void kvm_arch_setup_debug(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_clear_debug(struct kvm_vcpu *vcpu) {}
> =20
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 445933d..7ea8b0e 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -523,6 +523,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
> =20
>  		kvm_vgic_flush_hwstate(vcpu);
>  		kvm_timer_flush_hwstate(vcpu);
> +		kvm_arch_setup_debug(vcpu);
> =20
>  		local_irq_disable();
> =20
> @@ -569,6 +570,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
>  		 * Back from guest
>  		 *************************************************************/
> =20
> +		kvm_arch_clear_debug(vcpu);
>  		kvm_timer_sync_hwstate(vcpu);
>  		kvm_vgic_sync_hwstate(vcpu);
> =20
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> index 8ac3c70..0631840 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -101,6 +101,7 @@ struct kvm_vcpu_arch {
> =20
>  	/* HYP configuration */
>  	u64 hcr_el2;
> +	u32 mdcr_el2;
> =20
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
> @@ -257,4 +258,7 @@ static inline void kvm_arch_sync_events(struct kv=
m *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)=
 {}
> =20
> +void kvm_arch_setup_debug(struct kvm_vcpu *vcpu);
> +void kvm_arch_clear_debug(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-=
offsets.c
> index f7fa65d..cd06209 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -122,6 +122,7 @@ int main(void)
>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_=
el2));
>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flag=
s));
>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
> +  DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_=
context));
>    DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_c=
pu.cntv_ctl));
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 4e6e09e..6796d4a 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -17,7 +17,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(ARM)/psci.o $(ARM=
)/perf.o
> =20
>  kvm-$(CONFIG_KVM_ARM_HOST) +=3D emulate.o inject_fault.o regmap.o
>  kvm-$(CONFIG_KVM_ARM_HOST) +=3D hyp.o hyp-init.o handle_exit.o
> -kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o reset.o sys_regs.o sys_regs_=
generic_v8.o
> +kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o debug.o reset.o sys_regs.o s=
ys_regs_generic_v8.o
> =20
>  kvm-$(CONFIG_KVM_ARM_VGIC) +=3D $(KVM)/arm/vgic.o
>  kvm-$(CONFIG_KVM_ARM_VGIC) +=3D $(KVM)/arm/vgic-v2.o
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> new file mode 100644
> index 0000000..8a29d0b
> --- /dev/null
> +++ b/arch/arm64/kvm/debug.c
> @@ -0,0 +1,58 @@
> +/*
> + * Debug and Guest Debug support
> + *
> + * Copyright (C) 2015 - Linaro Ltd
> + * Author: Alex Benn=E9e <alex.bennee@linaro.org>
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
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_host.h>
> +
> +/**
> + * kvm_arch_setup_debug - set-up debug related stuff

nit: I think you want "set up" when it's a verb.

> + *
> + * @vcpu:	the vcpu pointer
> + *
> + * This is called before each entry in to the hypervisor to setup an=
y

s/in to/into/
s/setup/set up/

> + * debug related registers. Currently this just ensures we will trap
> + * access to:

guest accesses to:

> + *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
> + *  - Debug ROM Address (MDCR_EL2_TDRA)
> + *  - Power down debug registers (MDCR_EL2_TDOSA)
> + *
> + * Additionally the hypervisor lazily saves/restores the debug
> + * register state. If it is not currently doing so (arch.debug_flags=
)
> + * then we also need to ensure we trap if the guest messes with them
> + * so we know we need to save them.

This paragraph is a little hard to make sense of.  If I understand it
correctly, the point is that when debugging the guest we need to make
sure guest accesses to the debug registers traps?  If so, I would
suggest something like:

  Additionally, KVM only traps guest accesses to the debug registers if
  the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
  flag on vcpu->arch.debug_flags).  Since the guest must not interfere
  with the hardware state when debugging the guest, we must ensure that
  trapping is enabled whenever we are debugging the guest.

> + */
> +
> +void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM | MDCR_EL2_TPMCR);
> +	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TDRA | MDCR_EL2_TDOSA);
> +
> +	if (!vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
> +		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
> +	else
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
> +
> +}
> +
> +void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
> +{
> +	/* Nothing to do yet */
> +}
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 5befd01..be92bfe1 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -768,17 +768,8 @@
>  	mov	x2, #(1 << 15)	// Trap CP15 Cr=3D15
>  	msr	hstr_el2, x2
> =20
> -	mrs	x2, mdcr_el2
> -	and	x2, x2, #MDCR_EL2_HPMN_MASK
> -	orr	x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
> -	orr	x2, x2, #(MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
> -
> -	// Check for KVM_ARM64_DEBUG_DIRTY, and set debug to trap
> -	// if not dirty.
> -	ldr	x3, [x0, #VCPU_DEBUG_FLAGS]
> -	tbnz	x3, #KVM_ARM64_DEBUG_DIRTY_SHIFT, 1f
> -	orr	x2, x2,  #MDCR_EL2_TDA
> -1:
> +	// Monitor Debug Config - see kvm_arch_setup_debug()
> +	ldr	x2, [x0, #VCPU_MDCR_EL2]
>  	msr	mdcr_el2, x2
>  .endm
> =20

As the other reviewers noted, this is now setting the number of PMU
counters accessible to 0.  I'm fine with always setting mdcr_el2 from
memory, but I think we need to add code in hyp-init.S to read PMCR_EL0.=
N
and store that in a per-cpu (not vcpu) variable and configure mdcr_el2
using that value in kvm_arch_set_debug(), but then you need to call
kvm_arch_set_debug() from a non-preemptible section, which is probably =
a
good idea anyway.  Note that I couldn't see that we are initializing
MDCR_EL2 anywhere, so that should probably be a separate fix.

Thanks,
-Christoffer
