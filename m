From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 08/28] ARM: KVM: Add TLB invalidation code
Date: Tue, 9 Feb 2016 19:42:28 +0100
Message-ID: <20160209184228.GL5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-9-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-9-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:25AM +0000, Marc Zyngier wrote:
> Convert the TLB invalidation code to C, hooking it into the
> build system whilst we're at it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/Makefile     |  1 +
>  arch/arm/kvm/hyp/Makefile |  5 ++++
>  arch/arm/kvm/hyp/hyp.h    |  5 ++++
>  arch/arm/kvm/hyp/tlb.c    | 71 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 82 insertions(+)
>  create mode 100644 arch/arm/kvm/hyp/Makefile
>  create mode 100644 arch/arm/kvm/hyp/tlb.c
> 
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index c5eef02c..eb1bf43 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -17,6 +17,7 @@ AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
>  KVM := ../../../virt/kvm
>  kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
>  
> +obj-$(CONFIG_KVM_ARM_HOST) += hyp/
>  obj-y += kvm-arm.o init.o interrupts.o
>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
>  obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
> diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
> new file mode 100644
> index 0000000..36c760d
> --- /dev/null
> +++ b/arch/arm/kvm/hyp/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for Kernel-based Virtual Machine module, HYP part
> +#
> +
> +obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
> diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
> index 727089f..5808bbd 100644
> --- a/arch/arm/kvm/hyp/hyp.h
> +++ b/arch/arm/kvm/hyp/hyp.h
> @@ -42,4 +42,9 @@
>  })
>  #define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
>  
> +#define VTTBR		__ACCESS_CP15_64(6, c2)
> +#define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
> +#define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
> +#define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
> +
>  #endif /* __ARM_KVM_HYP_H__ */
> diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
> new file mode 100644
> index 0000000..993fe89
> --- /dev/null
> +++ b/arch/arm/kvm/hyp/tlb.c
> @@ -0,0 +1,71 @@
> +/*
> + * Original code:
> + * Copyright (C) 2012 - Virtual Open Systems and Columbia University
> + * Author: Christoffer Dall <c.dall@virtualopensystems.com>
> + *
> + * Mostly rewritten in C by Marc Zyngier <marc.zyngier@arm.com>
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
> +#include "hyp.h"
> +
> +/**
> + * Flush per-VMID TLBs
> + *
> + * __kvm_tlb_flush_vmid(struct kvm *kvm);
> + *
> + * We rely on the hardware to broadcast the TLB invalidation to all CPUs
> + * inside the inner-shareable domain (which is the case for all v7
> + * implementations).  If we come across a non-IS SMP implementation, we'll
> + * have to use an IPI based mechanism. Until then, we stick to the simple
> + * hardware assisted version.
> + *
> + * As v7 does not support flushing per IPA, just nuke the whole TLB
> + * instead, ignoring the ipa value.
> + */
> +static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
> +{
> +	dsb(ishst);
> +
> +	/* Switch to requested VMID */
> +	kvm = kern_hyp_va(kvm);
> +	write_sysreg(kvm->arch.vttbr, VTTBR);
> +	isb();
> +
> +	write_sysreg(0, TLBIALLIS);
> +	dsb(ish);
> +	isb();
> +
> +	write_sysreg(0, VTTBR);
> +}
> +
> +__alias(__tlb_flush_vmid) void __weak __kvm_tlb_flush_vmid(struct kvm *kvm);
> +
> +static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
> +{
> +	__tlb_flush_vmid(kvm);
> +}
> +
> +__alias(__tlb_flush_vmid_ipa) void __weak __kvm_tlb_flush_vmid_ipa(struct kvm *kvm,
> +							    phys_addr_t ipa);
> +
> +static void __hyp_text __tlb_flush_vm_context(void)
> +{
> +	dsb(ishst);

do we need this initial dsb?

> +	write_sysreg(0, TLBIALLNSNHIS);
> +	write_sysreg(0, ICIALLUIS);
> +	dsb(ish);

we used to have an isb here, but we got rid of this because it's always
followed by eret?

> +}
> +
> +__alias(__tlb_flush_vm_context) void __weak __kvm_flush_vm_context(void);
> -- 
> 2.1.4
> 
