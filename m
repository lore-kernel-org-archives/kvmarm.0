From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 05/10] KVM: arm: introduce kvm_arch_setup/clear_debug()
Date: Thu, 9 Apr 2015 14:55:12 +0200
Message-ID: <20150409125511.GC3212@hawk.usersys.redhat.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51A204BE41
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 08:48:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4UwwtyqGwef3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 08:48:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD3D04BE40
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 08:48:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1427814488-28467-6-git-send-email-alex.bennee@linaro.org>
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
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:03PM +0100, Alex Benn=E9e wrote:
> This is a precursor for later patches which will need to do more to
> setup debug state before entering the hyp.S switch code. The existing
> functionality for setting mdcr_el2 has been moved out of hyp.S and now
> uses the value kept in vcpu->arch.mdcr_el2.
> =

> This also moves the conditional setting of the TDA bit from the hyp code
> into the C code.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

>  create mode 100644 arch/arm64/kvm/debug.c
> =

> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_h=
ost.h
> index 41008cd..8c01c97 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -242,5 +242,7 @@ static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> +static inline void kvm_arch_setup_debug(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_clear_debug(struct kvm_vcpu *vcpu) {}
>  =

>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 445933d..7ea8b0e 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -523,6 +523,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
>  =

>  		kvm_vgic_flush_hwstate(vcpu);
>  		kvm_timer_flush_hwstate(vcpu);
> +		kvm_arch_setup_debug(vcpu);
>  =

>  		local_irq_disable();
>  =

> @@ -569,6 +570,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
>  		 * Back from guest
>  		 *************************************************************/
>  =

> +		kvm_arch_clear_debug(vcpu);
>  		kvm_timer_sync_hwstate(vcpu);
>  		kvm_vgic_sync_hwstate(vcpu);
>  =

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 8ac3c70..0631840 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -101,6 +101,7 @@ struct kvm_vcpu_arch {
>  =

>  	/* HYP configuration */
>  	u64 hcr_el2;
> +	u32 mdcr_el2;
>  =

>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
> @@ -257,4 +258,7 @@ static inline void kvm_arch_sync_events(struct kvm *k=
vm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  =

> +void kvm_arch_setup_debug(struct kvm_vcpu *vcpu);
> +void kvm_arch_clear_debug(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offs=
ets.c
> index f7fa65d..cd06209 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -122,6 +122,7 @@ int main(void)
>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el2)=
);
>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags));
>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
> +  DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_cont=
ext));
>    DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.c=
ntv_ctl));
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 4e6e09e..6796d4a 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -17,7 +17,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(ARM)/psci.o $(ARM)/pe=
rf.o
>  =

>  kvm-$(CONFIG_KVM_ARM_HOST) +=3D emulate.o inject_fault.o regmap.o
>  kvm-$(CONFIG_KVM_ARM_HOST) +=3D hyp.o hyp-init.o handle_exit.o
> -kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o reset.o sys_regs.o sys_regs_gene=
ric_v8.o
> +kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o debug.o reset.o sys_regs.o sys_r=
egs_generic_v8.o
>  =

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
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_host.h>

linux/kvm_host.h added above includes this asm/kvm_host already

> +
> +/**
> + * kvm_arch_setup_debug - set-up debug related stuff
> + *
> + * @vcpu:	the vcpu pointer
> + *
> + * This is called before each entry in to the hypervisor to setup any

into

> + * debug related registers. Currently this just ensures we will trap
> + * access to:
> + *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
> + *  - Debug ROM Address (MDCR_EL2_TDRA)
> + *  - Power down debug registers (MDCR_EL2_TDOSA)
> + *
> + * Additionally the hypervisor lazily saves/restores the debug
> + * register state. If it is not currently doing so (arch.debug_flags)
> + * then we also need to ensure we trap if the guest messes with them
> + * so we know we need to save them.
> + */
> +
> +void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM | MDCR_EL2_TPMCR);
> +	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TDRA | MDCR_EL2_TDOSA);
> +
> +	if (!vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)

missing () in the if (!(x & y)) condition

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
>  =

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

We lose the preservation of HPMN, as I see David points out as well.
Based on the ARM ARM setting it to zero is most likely wrong, as
that results in constrained unpredictable behavior.

drew
