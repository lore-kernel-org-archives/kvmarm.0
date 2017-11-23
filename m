From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v1 1/2] kvm: arm64: handle single-step during SError
 exceptions
Date: Thu, 23 Nov 2017 13:33:27 +0100
Message-ID: <20171123123327.GY28855@cbox>
References: <20171123121134.11050-1-alex.bennee@linaro.org>
 <20171123121134.11050-2-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171123121134.11050-2-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 23, 2017 at 12:11:33PM +0000, Alex Bennée wrote:
> When an SError arrives during single-step it may be delivered before
> the step completes. 

nit: this is not entirely accurate wording comparing with the ARM ARM,
which says that the step would be completed, but you'll now have both a
pending debug exception and a pending SError interrupt at the same time,
and the architecture doesn't prevent the SError from being taken first.

I can fix this up on commit though.

> In that case the DBG_SPSR_SS bit will have flipped
> as the instruction executed. After handling the abort in handle_exit()
> we test to see if the bit is clear and we were single-stepping before
> deciding if we need to exit to user space.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

Thanks!

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm64/kvm/handle_exit.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 3e645ec9e751..3ba8c4a3bcff 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -28,6 +28,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_psci.h>
> +#include <asm/debug-monitors.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> @@ -250,7 +251,12 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		return 1;
>  	case ARM_EXCEPTION_EL1_SERROR:
>  		kvm_inject_vabt(vcpu);
> -		return 1;
> +		/* We may still need to return for single-step */
> +		if (!(*vcpu_cpsr(vcpu) & DBG_SPSR_SS)
> +			&& kvm_arm_handle_step_debug(vcpu, run))
> +			return 0;
> +		else
> +			return 1;
>  	case ARM_EXCEPTION_TRAP:
>  		return handle_trap_exceptions(vcpu, run);
>  	case ARM_EXCEPTION_HYP_GONE:
> -- 
> 2.15.0
> 
