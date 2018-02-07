From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 02/17] arm: KVM: Fix SMCCC handling of unimplemented
 SMC/HVC calls
Date: Wed, 7 Feb 2018 09:32:51 +0100
Message-ID: <20180207083251.GB29286@cbox>
References: <20180206175621.929-1-marc.zyngier@arm.com>
 <20180206175621.929-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206175621.929-3-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 06, 2018 at 05:56:06PM +0000, Marc Zyngier wrote:
> KVM doesn't follow the SMCCC when it comes to unimplemented calls,
> and inject an UNDEF instead of returning an error. Since firmware
> calls are now used for security mitigation, they are becoming more
> common, and the undef is counter productive.
> 
> Instead, let's follow the SMCCC which states that -1 must be returned
> to the caller when getting an unknown function number.

Apparently I forgot to review this:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Cc: <stable@vger.kernel.org>
> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/handle_exit.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index cf8bf6bf87c4..a4bf0f6f024a 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -38,7 +38,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	ret = kvm_psci_call(vcpu);
>  	if (ret < 0) {
> -		kvm_inject_undefined(vcpu);
> +		vcpu_set_reg(vcpu, 0, ~0UL);
>  		return 1;
>  	}
>  
> @@ -47,7 +47,16 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	kvm_inject_undefined(vcpu);
> +	/*
> +	 * "If an SMC instruction executed at Non-secure EL1 is
> +	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
> +	 * Trap exception, not a Secure Monitor Call exception [...]"
> +	 *
> +	 * We need to advance the PC after the trap, as it would
> +	 * otherwise return to the same address...
> +	 */
> +	vcpu_set_reg(vcpu, 0, ~0UL);
> +	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
>  	return 1;
>  }
>  
> -- 
> 2.14.2
> 
