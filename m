From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 21/23] arm64: hw_breakpoint: Allow EL2 breakpoints if
 running in HYP
Date: Mon, 15 Feb 2016 17:46:56 +0000
Message-ID: <20160215174656.GN6298@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
 <1455216004-19499-22-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455216004-19499-22-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 11, 2016 at 06:40:02PM +0000, Marc Zyngier wrote:
> With VHE, we place kernel {watch,break}-points at EL2 to get things
> like kgdb and "perf -e mem:..." working.
> 
> This requires a bit of repainting in the low-level encore/decode,
> but is otherwise pretty simple.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/hw_breakpoint.h | 49 +++++++++++++++++++++-------------
>  1 file changed, 31 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
> index 9732908..4d8d5a8 100644
> --- a/arch/arm64/include/asm/hw_breakpoint.h
> +++ b/arch/arm64/include/asm/hw_breakpoint.h
> @@ -18,6 +18,7 @@
>  
>  #include <asm/cputype.h>
>  #include <asm/cpufeature.h>
> +#include <asm/virt.h>
>  
>  #ifdef __KERNEL__
>  
> @@ -35,24 +36,6 @@ struct arch_hw_breakpoint {
>  	struct arch_hw_breakpoint_ctrl ctrl;
>  };
>  
> -static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
> -{
> -	return (ctrl.len << 5) | (ctrl.type << 3) | (ctrl.privilege << 1) |
> -		ctrl.enabled;
> -}
> -
> -static inline void decode_ctrl_reg(u32 reg,
> -				   struct arch_hw_breakpoint_ctrl *ctrl)
> -{
> -	ctrl->enabled	= reg & 0x1;
> -	reg >>= 1;
> -	ctrl->privilege	= reg & 0x3;
> -	reg >>= 2;
> -	ctrl->type	= reg & 0x3;
> -	reg >>= 2;
> -	ctrl->len	= reg & 0xff;
> -}
> -
>  /* Breakpoint */
>  #define ARM_BREAKPOINT_EXECUTE	0
>  
> @@ -62,6 +45,7 @@ static inline void decode_ctrl_reg(u32 reg,
>  #define AARCH64_ESR_ACCESS_MASK	(1 << 6)
>  
>  /* Privilege Levels */
> +#define AARCH64_BREAKPOINT_EL2	0
>  #define AARCH64_BREAKPOINT_EL1	1
>  #define AARCH64_BREAKPOINT_EL0	2
>  
> @@ -76,6 +60,35 @@ static inline void decode_ctrl_reg(u32 reg,
>  #define ARM_KERNEL_STEP_ACTIVE	1
>  #define ARM_KERNEL_STEP_SUSPEND	2
>  
> +#define DBG_HMC_HYP		(1 << 13)
> +#define DBG_SSC_HYP		(3 << 14)

Why do we need to touch the SSC field at all?

> +
> +static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
> +{
> +	u32 val = (ctrl.len << 5) | (ctrl.type << 3) | ctrl.enabled;
> +
> +	if (is_kernel_in_hyp_mode() && ctrl.privilege == AARCH64_BREAKPOINT_EL1)
> +		val |= DBG_HMC_HYP | DBG_SSC_HYP | (AARCH64_BREAKPOINT_EL2 << 1);

I don't think this is correct. We want to allow, for example, a userspace
watchpoint to fire thanks to something like put_user, so the encoding
really needs to build up the PMC field (like we do already), then orr in
the HMC field.

The "gotcha", which is similar to the PMU stuff, is that you can't have
HMC==1 (EL2) and PMC==2 (i.e. EL2 and EL0, but not EL1).

I *think* the conclusion is that you need AARCH64_BREAKPOINT_EL2 to look
like DBG_HMC_HYP | AARCH64_BREAKPOINT_EL1.

Will
