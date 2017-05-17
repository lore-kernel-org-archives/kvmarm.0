From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 08/31] arm64: Add a facility to turn an ESR syndrome into
 a sysreg encoding
Date: Wed, 17 May 2017 11:54:33 +0200
Message-ID: <9a81564d-8bb3-36ea-f0f8-a61cbc7fb345@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF6540B8C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 May 2017 05:51:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IbobagD+Xq0J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 May 2017 05:51:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3A0640A66
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 May 2017 05:51:08 -0400 (EDT)
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
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 03/05/2017 12:45, Marc Zyngier wrote:
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

Needs a rebase on top
9842119  arm64: Add CNTFRQ_EL0 trap handler

Otherwise
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

>  
> 
