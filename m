From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 08/31] arm64: Add a facility to turn an ESR syndrome into
 a sysreg encoding
Date: Wed, 3 May 2017 16:35:01 +0100
Message-ID: <20170503153500.GD4951@leverpostej>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 009DA405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 11:32:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QutPeQf3Jgo2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 11:32:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D903940064
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 11:32:27 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170503104606.19342-9-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 03, 2017 at 11:45:43AM +0100, Marc Zyngier wrote:
> It is often useful to compare an ESR syndrome reporting the trapping
> of a system register with a value matching that system register.
> 
> Since encoding both the sysreg and the ESR version seem to be a bit
> overkill, let's add a set of macros that convert an ESR value into
> the corresponding sysreg encoding.
> 
> We handle both AArch32 and AArch64, taking advantage of identical
> encodings between system registers and CP15 accessors.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Nice!

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/include/asm/esr.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index ad42e79a5d4d..db8f13137443 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -19,6 +19,7 @@
>  #define __ASM_ESR_H
>  
>  #include <asm/memory.h>
> +#include <asm/sysreg.h>
>  
>  #define ESR_ELx_EC_UNKNOWN	(0x00)
>  #define ESR_ELx_EC_WFx		(0x01)
> @@ -177,6 +178,30 @@
>  
>  #define ESR_ELx_SYS64_ISS_SYS_CNTVCT	(ESR_ELx_SYS64_ISS_SYS_VAL(3, 3, 2, 14, 0) | \
>  					 ESR_ELx_SYS64_ISS_DIR_READ)
> +
> +#define esr_sys64_to_sysreg(e)					\
> +	sys_reg((((e) & ESR_ELx_SYS64_ISS_OP0_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_OP0_SHIFT),			\
> +		(((e) & ESR_ELx_SYS64_ISS_OP1_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_OP1_SHIFT),			\
> +		(((e) & ESR_ELx_SYS64_ISS_CRN_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_CRN_SHIFT),			\
> +		(((e) & ESR_ELx_SYS64_ISS_CRM_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_CRM_SHIFT),			\
> +		(((e) & ESR_ELx_SYS64_ISS_OP2_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
> +
> +#define esr_cp15_to_sysreg(e)					\
> +	sys_reg(3,						\
> +		(((e) & ESR_ELx_SYS64_ISS_OP1_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_OP1_SHIFT),			\
> +		(((e) & ESR_ELx_SYS64_ISS_CRN_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_CRN_SHIFT),			\
> +		(((e) & ESR_ELx_SYS64_ISS_CRM_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_CRM_SHIFT),			\
> +		(((e) & ESR_ELx_SYS64_ISS_OP2_MASK) >>		\
> +		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
> +
>  #ifndef __ASSEMBLY__
>  #include <asm/types.h>
>  
> -- 
> 2.11.0
> 
