From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 01/14] arm/arm64: smccc: Add SMCCC-specific return codes
Date: Thu, 24 May 2018 11:55:30 +0100
Message-ID: <20180524105530.ekgrv3asefqowjty@lakrids.cambridge.arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180522150648.28297-2-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 22, 2018 at 04:06:35PM +0100, Marc Zyngier wrote:
> We've so far used the PSCI return codes for SMCCC because they
> were extremely similar. But with the new ARM DEN 0070A specification,
> "NOT_REQUIRED" (-2) is clashing with PSCI's "PSCI_RET_INVALID_PARAMS".
> 
> Let's bite the bullet and add SMCCC specific return codes. Users
> can be repainted as and when required.
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  include/linux/arm-smccc.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index a031897fca76..c89da86de99f 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -291,5 +291,10 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>   */
>  #define arm_smccc_1_1_hvc(...)	__arm_smccc_1_1(SMCCC_HVC_INST, __VA_ARGS__)
>  
> +/* Return codes defined in ARM DEN 0070A */
> +#define SMCCC_RET_SUCCESS			0
> +#define SMCCC_RET_NOT_SUPPORTED			-1
> +#define SMCCC_RET_NOT_REQUIRED			-2
> +
>  #endif /*__ASSEMBLY__*/
>  #endif /*__LINUX_ARM_SMCCC_H*/
> -- 
> 2.14.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
