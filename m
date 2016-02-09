From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 14/28] ARM: KVM: Add guest entry code
Date: Tue, 9 Feb 2016 19:44:45 +0100
Message-ID: <20160209184445.GR5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-15-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-15-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:31AM +0000, Marc Zyngier wrote:
> Add the very minimal piece of code that is now required to jump
> into the guest (and return from it). This code is only concerned
> with save/restoring the USR registers (r0-r12+lr for the guest,
> r4-r12+lr for the host), as everything else is dealt with in C
> (VFP is another matter though).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/hyp/Makefile |  1 +
>  arch/arm/kvm/hyp/entry.S  | 70 +++++++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kvm/hyp/hyp.h    |  2 ++
>  3 files changed, 73 insertions(+)
>  create mode 100644 arch/arm/kvm/hyp/entry.S
> 
> diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
> index 173bd1d..c779690 100644
> --- a/arch/arm/kvm/hyp/Makefile
> +++ b/arch/arm/kvm/hyp/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
>  obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
> +obj-$(CONFIG_KVM_ARM_HOST) += entry.o
> diff --git a/arch/arm/kvm/hyp/entry.S b/arch/arm/kvm/hyp/entry.S
> new file mode 100644
> index 0000000..32f79b0
> --- /dev/null
> +++ b/arch/arm/kvm/hyp/entry.S
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (C) 2016 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>
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
> +*/
> +
> +#include <linux/linkage.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/kvm_arm.h>
> +
> +	.arch_extension     virt
> +
> +	.text
> +	.pushsection	.hyp.text, "ax"
> +
> +#define USR_REGS_OFFSET		(CPU_CTXT_GP_REGS + GP_REGS_USR)
> +
> +/* int __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host) */
> +ENTRY(__guest_enter)
> +	@ Save host registers
> +	add	r1, r1, #(USR_REGS_OFFSET + S_R4)
> +	stm	r1!, {r4-r12}
> +	str	lr, [r1, #4]	@ Skip SP_usr (already saved)
> +
> +	@ Restore guest registers
> +	add	r0, r0,  #(VCPU_GUEST_CTXT + USR_REGS_OFFSET + S_R0)

this really relies on offsetof(struct pt_regs, ARM_r0) == 0, which I
guess will likely never change, but given there's both a kernel and uapi
version of struct pt_regs, are we sure about this?

> +	ldr	lr, [r0, #S_LR]
> +	ldm	r0, {r0-r12}
> +
> +	clrex
> +	eret
> +ENDPROC(__guest_enter)
> +
> +ENTRY(__guest_exit)
> +	/*
> +	 * return convention:
> +	 * guest r0, r1, r2 saved on the stack
> +	 * r0: vcpu pointer
> +	 * r1: exception code
> +	 */
> +
> +	add	r2, r0, #(VCPU_GUEST_CTXT + USR_REGS_OFFSET + S_R3)
> +	stm	r2!, {r3-r12}
> +	str	lr, [r2, #4]
> +	add	r2, r0, #(VCPU_GUEST_CTXT + USR_REGS_OFFSET + S_R0)
> +	pop	{r3, r4, r5}		@ r0, r1, r2
> +	stm	r2, {r3-r5}
> +
> +	ldr	r0, [r0, #VCPU_HOST_CTXT]
> +	add	r0, r0, #(USR_REGS_OFFSET + S_R4)
> +	ldm	r0!, {r4-r12}
> +	ldr	lr, [r0, #4]
> +
> +	mov	r0, r1
> +	bx	lr
> +ENDPROC(__guest_exit)
> +
> +	.popsection
> +
> diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
> index 278eb1f..b3f6ed2 100644
> --- a/arch/arm/kvm/hyp/hyp.h
> +++ b/arch/arm/kvm/hyp/hyp.h
> @@ -110,4 +110,6 @@ static inline bool __vfp_enabled(void)
>  void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt);
>  void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt);
>  
> +int asmlinkage __guest_enter(struct kvm_vcpu *vcpu,
> +			     struct kvm_cpu_context *host);
>  #endif /* __ARM_KVM_HYP_H__ */
> -- 
> 2.1.4
> 

Otherwise:
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
