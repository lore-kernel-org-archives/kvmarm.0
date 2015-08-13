From: Steve Capper <steve.capper@linaro.org>
Subject: Re: [PATCH 12/14] arm64: Check for selected granule support
Date: Thu, 13 Aug 2015 13:28:28 +0100
Message-ID: <CAPvkgC3=S1BxdzZM4uUOmyXLjii48SMpCof6i6HdNeTG_fydfg@mail.gmail.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
 <1439465645-22584-13-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA7065AEDC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2015 08:15:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WuJrKvvqhQFq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Aug 2015 08:15:19 -0400 (EDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com
 [209.85.223.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C51A25AEDB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2015 08:15:19 -0400 (EDT)
Received: by iodt126 with SMTP id t126so50199254iod.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2015 05:28:28 -0700 (PDT)
In-Reply-To: <1439465645-22584-13-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 August 2015 at 12:34, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>
> Ensure that the selected page size is supported by the
> CPU(s).
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h |    6 ++++++
>  arch/arm64/kernel/head.S        |   24 +++++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index a7f3d4b..e01d323 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -87,4 +87,10 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
>  }
>  #endif
>
> +#define ID_AA64MMFR0_TGran4_SHIFT      28
> +#define ID_AA64MMFR0_TGran64_SHIFT     24
> +
> +#define ID_AA64MMFR0_TGran4_ENABLED    0x0
> +#define ID_AA64MMFR0_TGran64_ENABLED   0x0
> +
>  #endif /* __ASM_SYSREG_H */
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 01b8e58..0cb04db 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -31,10 +31,11 @@
>  #include <asm/cputype.h>
>  #include <asm/kernel-pgtable.h>
>  #include <asm/memory.h>
> -#include <asm/thread_info.h>
>  #include <asm/pgtable-hwdef.h>
>  #include <asm/pgtable.h>
>  #include <asm/page.h>
> +#include <asm/sysreg.h>
> +#include <asm/thread_info.h>
>  #include <asm/virt.h>
>
>  #define __PHYS_OFFSET  (KERNEL_START - TEXT_OFFSET)
> @@ -606,9 +607,25 @@ ENDPROC(__secondary_switched)
>   *  x27 = *virtual* address to jump to upon completion
>   *
>   * other registers depend on the function called upon completion
> + * Checks if the selected granule size is supported by the CPU.
>   */
> +#if    defined(CONFIG_ARM64_64K_PAGES)
> +
> +#define ID_AA64MMFR0_TGran_SHIFT       ID_AA64MMFR0_TGran64_SHIFT
> +#define ID_AA64MMFR0_TGran_ENABLED     ID_AA64MMFR0_TGran64_ENABLED
> +
> +#else
> +
> +#define ID_AA64MMFR0_TGran_SHIFT       ID_AA64MMFR0_TGran4_SHIFT
> +#define ID_AA64MMFR0_TGran_ENABLED     ID_AA64MMFR0_TGran4_ENABLED
> +
> +#endif
>         .section        ".idmap.text", "ax"
>  __enable_mmu:
> +       mrs     x1, ID_AA64MMFR0_EL1
> +       ubfx    x2, x1, #ID_AA64MMFR0_TGran_SHIFT, 4
> +       cmp     x2, #ID_AA64MMFR0_TGran_ENABLED
> +       b.ne    __no_granule_support
>         ldr     x5, =vectors
>         msr     vbar_el1, x5
>         msr     ttbr0_el1, x25                  // load TTBR0
> @@ -626,3 +643,8 @@ __enable_mmu:
>         isb
>         br      x27
>  ENDPROC(__enable_mmu)
> +
> +__no_granule_support:
> +       wfe
> +       b __no_granule_support
> +ENDPROC(__no_granule_support)
> --
> 1.7.9.5
>

Hi Suzuki,
Is is possible to tell the user that the kernel has failed to boot due
to the kernel granule being unsupported?

Cheers,
--
Steve
