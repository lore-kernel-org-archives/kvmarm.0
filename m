From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 07/13] arm64: KVM: VHE: Patch out use of HVC
Date: Wed, 5 Aug 2015 18:57:53 +0100
Message-ID: <20150805175752.GF24073@e104818-lin.cambridge.arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
 <1436372356-30410-8-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436372356-30410-8-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 05:19:10PM +0100, Marc Zyngier wrote:
> --- /dev/null
> +++ b/arch/arm64/kvm/vhe-macros.h
> @@ -0,0 +1,36 @@
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
> +#ifndef __ARM64_VHE_MACROS_H__
> +#define __ARM64_VHE_MACROS_H__
> +
> +#include <asm/alternative.h>
> +#include <asm/cpufeature.h>
> +
> +#ifdef __ASSEMBLY__
> +
> +/* Hack to allow stringification of macros... */
> +#define __S__(a,args...)	__stringify(a, ##args)
> +#define _S_(a,args...)		__S__(a, args)
> +
> +.macro ifnvhe nonvhe vhe
> +	alternative_insn	"\nonvhe", "\vhe", ARM64_HAS_VIRT_HOST_EXTN
> +.endm

I always found the alternative_insn tricks hard to read but with
Daniel's patch queued in -next it gets slightly better. If you are not
targeting 4.3, could you do something like (untested):

.macro	vhe_if_not
	alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
.endm

.macro	vhe_else
	alternative_else CONFIG_ARM64_VHE
.endm

.macro	vhe_endif
	alternative_endif CONFIG_ARM64_VHE
.endm


The kvm_call_hyp, for example, would become:

ENTRY(kvm_call_hyp)
vhe_if_not
	hvc	#0
	ret
vhe_else
	nop
	push	lr, xzr
vhe_endif


Or you can even ignore defining new vhe_* macros altogether and just use
"alternative_if_not ARM64_HAS_VIRT_HOST_EXTN" directly (more to type)
but you may be able to avoid a vhe-macros.h file.

-- 
Catalin
