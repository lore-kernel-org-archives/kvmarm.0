From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC 7/9] arm64: expose PAC bit positions via ptrace
Date: Tue, 25 Jul 2017 13:11:48 +0100
Message-ID: <20170725121145.GB6321@e103592.cambridge.arm.com>
References: <1491232765-32501-1-git-send-email-mark.rutland@arm.com>
 <1491232765-32501-8-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491232765-32501-8-git-send-email-mark.rutland@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 03, 2017 at 04:19:23PM +0100, Mark Rutland wrote:
> When pointer authentication is in use, data/instruction pointers have a
> number of PAC bits inserted into them. The number and position of these
> bits depends on the configured TCR_ELx.TxSZ and whether tagging is
> enabled. ARMv8.3 allows tagging to differ for instruction and data
> pointers.
> 
> For userspace debuggers to unwind the stack and/or to follow pointer
> chains, they need to be able to remove the PAC bits before attempting to
> use a pointer.
> 
> This patch adds a new structure with masks describing the location of
> PAC bits in instruction and data pointers, which userspace can query via
> PTRACE_GETREGSET. By clearing these bits from pointers, userspace can
> acquire the PAC-less versions.
> 
> This new regset is exposed when the kernel is built with (user) pointer
> authentication support, and the feature is enabled.  Otherwise, it is
> hidden.
> 
> Note that even if the feature is available and enabled, we cannot
> determine whether userspace is making use of the feature, so debuggers
> need to cope with this case regardless.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Jiong Wang <jiong.wang@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/pointer_auth.h |  8 +++++++
>  arch/arm64/include/uapi/asm/ptrace.h  |  5 +++++
>  arch/arm64/kernel/ptrace.c            | 39 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/elf.h              |  1 +
>  4 files changed, 53 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
> index 345df24..ed505fe 100644
> --- a/arch/arm64/include/asm/pointer_auth.h
> +++ b/arch/arm64/include/asm/pointer_auth.h
> @@ -16,9 +16,11 @@
>  #ifndef __ASM_POINTER_AUTH_H
>  #define __ASM_POINTER_AUTH_H
>  
> +#include <linux/bitops.h>
>  #include <linux/random.h>
>  
>  #include <asm/cpufeature.h>
> +#include <asm/memory.h>
>  #include <asm/sysreg.h>
>  
>  #ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
> @@ -70,6 +72,12 @@ static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
>  	*new = *old;
>  }
>  
> +/*
> + * The pointer bits used by a pointer authentication code.
> + * If we were to use tagged pointers, bits 63:56 would also apply.
> + */
> +#define ptrauth_pac_mask() 	GENMASK(54, VA_BITS)

Tagged pointers _are_ enabled for userspace by default, no?

[...]

> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index b59ee07..cae3d1e 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -414,6 +414,7 @@
>  #define NT_ARM_HW_BREAK	0x402		/* ARM hardware breakpoint registers */
>  #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
>  #define NT_ARM_SYSTEM_CALL	0x404	/* ARM system call number */
> +#define NT_ARM_PAC_MASK		0x405	/* ARM pointer authentication code masks */

The is the value tentatively assigned to NT_ARM_SVE.

Cheers
---Dave
