From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 10/22] arm64: KVM: Implement guest entry
Date: Mon, 14 Dec 2015 12:06:48 +0100
Message-ID: <20151214110648.GB4120@cbox>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-11-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449485618-9443-11-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 07, 2015 at 10:53:26AM +0000, Marc Zyngier wrote:
> Contrary to the previous patch, the guest entry is fairly different
> from its assembly counterpart, mostly because it is only concerned
> with saving/restoring the GP registers, and nothing else.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/Makefile |   1 +
>  arch/arm64/kvm/hyp/entry.S  | 131 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/hyp.h    |   2 +
>  3 files changed, 134 insertions(+)
>  create mode 100644 arch/arm64/kvm/hyp/entry.S
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index ec14cac..1e1ff06 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
> +obj-$(CONFIG_KVM_ARM_HOST) += entry.o
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> new file mode 100644
> index 0000000..47f3c69
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -0,0 +1,131 @@
> +/*
> + * Copyright (C) 2015 - ARM Ltd
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
> + */
> +
> +#include <linux/linkage.h>
> +
> +#include <asm/asm-offsets.h>
> +#include <asm/assembler.h>
> +#include <asm/fpsimdmacros.h>
> +#include <asm/kvm.h>
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_mmu.h>
> +
> +#define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
> +#define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
> +
> +	.text
> +	.pushsection	.hyp.text, "ax"
> +
> +.macro save_callee_saved_regs ctxt
> +	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
> +	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
> +	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
> +	stp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
> +	stp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
> +	stp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
> +.endm
> +
> +.macro restore_callee_saved_regs ctxt
> +	ldp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
> +	ldp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
> +	ldp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
> +	ldp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
> +	ldp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
> +	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
> +.endm
> +
> +/*
> + * u64 __guest_enter(struct kvm_vcpu *vcpu,
> + *		     struct kvm_cpu_context *host_ctxt);
> + */
> +ENTRY(__guest_enter)
> +	// x0: vcpu
> +	// x1: host/guest context
> +	// x2-x18: clobbered by macros
> +
> +	// Store the host regs
> +	save_callee_saved_regs x1
> +
> +	// Preserve vcpu & host_ctxt for use at exit time
> +	stp	x0, x1, [sp, #-16]!
> +
> +	add	x1, x0, #VCPU_CONTEXT
> +
> +	// Prepare x0-x1 for later restore by pushing them onto the stack
> +	ldp	x2, x3, [x1, #CPU_XREG_OFFSET(0)]
> +	stp	x2, x3, [sp, #-16]!
> +
> +	// x2-x18
> +	ldp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
> +	ldp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
> +	ldp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
> +	ldp	x8, x9,   [x1, #CPU_XREG_OFFSET(8)]
> +	ldp	x10, x11, [x1, #CPU_XREG_OFFSET(10)]
> +	ldp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
> +	ldp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
> +	ldp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
> +	ldr	x18,      [x1, #CPU_XREG_OFFSET(18)]
> +
> +	// x19-x29, lr
> +	restore_callee_saved_regs x1
> +
> +	// Last bits of the 64bit state
> +	ldp	x0, x1, [sp], #16
> +
> +	// Do not touch any register after this!
> +	eret
> +ENDPROC(__guest_enter)
> +
> +ENTRY(__guest_exit)
> +	// x0: vcpu
> +	// x1: return code
> +	// x2-x3: free
> +	// x4-x29,lr: vcpu regs
> +	// vcpu x0-x3 on the stack
> +
> +	add	x2, x0, #VCPU_CONTEXT
> +
> +	// Compute base to save registers

misleading comment again?  Or misplaced at least?

> +	stp	x4, x5,   [x2, #CPU_XREG_OFFSET(4)]
> +	stp	x6, x7,   [x2, #CPU_XREG_OFFSET(6)]
> +	stp	x8, x9,   [x2, #CPU_XREG_OFFSET(8)]
> +	stp	x10, x11, [x2, #CPU_XREG_OFFSET(10)]
> +	stp	x12, x13, [x2, #CPU_XREG_OFFSET(12)]
> +	stp	x14, x15, [x2, #CPU_XREG_OFFSET(14)]
> +	stp	x16, x17, [x2, #CPU_XREG_OFFSET(16)]
> +	str	x18,      [x2, #CPU_XREG_OFFSET(18)]
> +
> +	ldp	x6, x7, [sp], #16	// x2, x3
> +	ldp	x4, x5, [sp], #16	// x0, x1
> +
> +	stp	x4, x5, [x2, #CPU_XREG_OFFSET(0)]
> +	stp	x6, x7, [x2, #CPU_XREG_OFFSET(2)]
> +
> +	save_callee_saved_regs x2
> +
> +	// Restore vcpu & host_ctxt from the stack
> +	// (preserving return code in x1)
> +	ldp	x0, x2, [sp], #16
> +	// Now restore the host regs
> +	restore_callee_saved_regs x2
> +
> +	mov	x0, x1
> +	ret
> +ENDPROC(__guest_exit)
> +
> +	/* Insert fault handling here */
> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> index 454e46f..0809653 100644
> --- a/arch/arm64/kvm/hyp/hyp.h
> +++ b/arch/arm64/kvm/hyp/hyp.h
> @@ -52,5 +52,7 @@ void __debug_restore_state(struct kvm_vcpu *vcpu,
>  void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
>  void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
>  
> +u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
> +
>  #endif /* __ARM64_KVM_HYP_H__ */
>  
> -- 
> 2.1.4
> 

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
