From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 33/38] KVM: arm64: Emulate appropriate VM control
 system registers
Date: Mon, 31 Jul 2017 14:09:26 +0200
Message-ID: <20170731120926.GT5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-34-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500397144-16232-34-git-send-email-jintack.lim@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:59AM -0500, Jintack Lim wrote:
> Now that the virtual EL2 can access EL2 register states via EL1
> registers, we need to consider it when selecting the register to
> emulate.

I don't really understand what this patch does from the commit message.

>From looking at the code, is trying to cater for the case where the
guest hypervisor configures the virtual hardware to trap on memory
control register accesses (for example during VM boot to solve the cache
issues) and we correspondingly set the VM control register trap bits,
and when actually handling the trap we need to take special care in the
VHE guest hypervisor case, because we'll have to redirect the register
access to the vitual EL2 registers instead of the virtual EL1 registers?

> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 79980be..910b50d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -110,6 +110,31 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +struct el1_el2_map {
> +	int	el1;
> +	int	el2;
> +};
> +
> +static const struct el1_el2_map vm_map[] = {
> +	{SCTLR_EL1, SCTLR_EL2},
> +	{TTBR0_EL1, TTBR0_EL2},
> +	{TTBR1_EL1, TTBR1_EL2},
> +	{TCR_EL1, TCR_EL2},
> +	{ESR_EL1, ESR_EL2},
> +	{FAR_EL1, FAR_EL2},
> +	{AFSR0_EL1, AFSR0_EL2},
> +	{AFSR1_EL1, AFSR1_EL2},
> +	{MAIR_EL1, MAIR_EL2},
> +	{AMAIR_EL1, AMAIR_EL2},
> +	{CONTEXTIDR_EL1, CONTEXTIDR_EL2},
> +};
> +
> +static inline bool el12_reg(struct sys_reg_params *p)

let's call this is_el12_instr

> +{
> +	/* All *_EL12 registers have Op1=5. */

s/registers/access instructions/

> +	return (p->Op1 == 5);
> +}
> +
>  /*
>   * Generic accessor for VM registers. Only called as long as HCR_TVM
>   * is set. If the guest enables the MMU, we stop trapping the VM
> @@ -120,16 +145,33 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  			  const struct sys_reg_desc *r)
>  {
>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
> +	u64 *sysreg = &vcpu_sys_reg(vcpu, r->reg);
> +	int i;
> +	const struct el1_el2_map *map;
> +
> +	/*
> +	 * Redirect EL1 register accesses to the corresponding EL2 registers if
> +	 * they are meant to access EL2 registers.
> +	 */
> +	if (vcpu_el2_e2h_is_set(vcpu) && !el12_reg(p)) {
> +		for (i = 0; i < ARRAY_SIZE(vm_map); i++) {
> +			map = &vm_map[i];
> +			if (map->el1 == r->reg) {
> +				sysreg = &vcpu_sys_reg(vcpu, map->el2);
> +				break;
> +			}
> +		}
> +	}
>  
>  	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
>  
>  	if (!p->is_write) {
> -		p->regval = vcpu_sys_reg(vcpu, r->reg);
> +		p->regval = *sysreg;
>  		return true;
>  	}
>  
>  	if (!p->is_aarch32) {
> -		vcpu_sys_reg(vcpu, r->reg) = p->regval;
> +		*sysreg = p->regval;
>  	} else {
>  		if (!p->is_32bit)
>  			vcpu_cp15_64_high(vcpu, r->reg) = upper_32_bits(p->regval);
> -- 
> 1.9.1
> 

Thanks,
-Christoffer
