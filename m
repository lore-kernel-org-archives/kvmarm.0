From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 21/23] arm64: hw_breakpoint: Allow EL2 breakpoints if
 running in HYP
Date: Mon, 8 Feb 2016 16:52:15 +0000
Message-ID: <20160208165214.GV6076@e104818-lin.cambridge.arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-22-git-send-email-marc.zyngier@arm.com>
 <20160208155625.GQ6076@e104818-lin.cambridge.arm.com>
 <56B8C638.2010402@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B8C638.2010402@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 08, 2016 at 04:45:44PM +0000, Marc Zyngier wrote:
> I was being overzealous, and your solution is clearly better. I ended up with the following:
> 
> diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
> index 9732908..c872b2f 100644
> --- a/arch/arm64/include/asm/hw_breakpoint.h
> +++ b/arch/arm64/include/asm/hw_breakpoint.h
[...]
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
> +
> +static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
> +{
> +	u32 val = (ctrl.len << 5) | (ctrl.type << 3) | ctrl.enabled;
> +
> +	if (is_kernel_in_hyp_mode() && ctrl.privilege == AARCH64_BREAKPOINT_EL1)
> +		val |= DBG_HMC_HYP | DBG_SSC_HYP;

Nitpick, for completeness:

		val |= DBG_HMC_HYP | DBG_SSC_HYP | (AARCH64_BREAKPOINT_EL2 << 1);

> +	else
> +		val |= ctrl.privilege << 1;
> +
> +	return val;
> +}
> +
> +static inline void decode_ctrl_reg(u32 reg,
> +				   struct arch_hw_breakpoint_ctrl *ctrl)
> +{
> +	ctrl->enabled	= reg & 0x1;
> +	reg >>= 1;
> +	ctrl->privilege	= reg & 0x3;
> +	if (ctrl->privilege == AARCH64_BREAKPOINT_EL2)
> +		ctrl->privilege	= AARCH64_BREAKPOINT_EL1;
> +	reg >>= 2;
> +	ctrl->type	= reg & 0x3;
> +	reg >>= 2;
> +	ctrl->len	= reg & 0xff;
> +}
> +
>  /*
>   * Limits.
>   * Changing these will require modifications to the register accessors.
> 
> Was that what you had in mind?

Looks fine:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
