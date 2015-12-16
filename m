From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] ARM: KVM: Cleanup exception injection
Date: Wed, 16 Dec 2015 21:40:18 +0100
Message-ID: <20151216204018.GF24889@cbox>
References: <1450116396-11718-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B53DF496F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 15:37:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6-aHz+n20pA6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2015 15:37:55 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE859410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 15:37:54 -0500 (EST)
Received: by mail-wm0-f51.google.com with SMTP id l126so55583654wml.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 12:40:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1450116396-11718-1-git-send-email-marc.zyngier@arm.com>
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
Cc: David Binderman <dcb314@hotmail.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 14, 2015 at 06:06:36PM +0000, Marc Zyngier wrote:
> David Binderman reported that the exception injection code had a
> couple of unused variables lingering around.
> 
> Upon examination, it looked like this code could do with an
> anticipated spring cleaning, which amounts to deduplicating
> the CPSR/SPSR update.
> 
> The spurious variables are removed in the process.
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/emulate.c | 59 ++++++++++++++++++++------------------------------
>  1 file changed, 23 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
> index d6c0052..245106e 100644
> --- a/arch/arm/kvm/emulate.c
> +++ b/arch/arm/kvm/emulate.c
> @@ -275,6 +275,25 @@ static u32 exc_vector_base(struct kvm_vcpu *vcpu)
>  		return vbar;
>  }
>  
> +/* Switch to an exception mode, updating both CPSR and SPSR */
> +static void kvm_update_psr(struct kvm_vcpu *vcpu, unsigned long mode)
> +{
> +	unsigned long cpsr = *vcpu_cpsr(vcpu);
> +	u32 sctlr = vcpu->arch.cp15[c1_SCTLR];
> +
> +	*vcpu_cpsr(vcpu) = (cpsr & ~MODE_MASK) | mode;
> +	*vcpu_cpsr(vcpu) |= PSR_I_BIT;
> +	*vcpu_cpsr(vcpu) &= ~(PSR_IT_MASK | PSR_J_BIT | PSR_E_BIT | PSR_T_BIT);
> +
> +	if (sctlr & SCTLR_TE)
> +		*vcpu_cpsr(vcpu) |= PSR_T_BIT;
> +	if (sctlr & SCTLR_EE)
> +		*vcpu_cpsr(vcpu) |= PSR_E_BIT;
> +
> +	/* Note: These now point to the mode banked copies */
> +	*vcpu_spsr(vcpu) = cpsr;
> +}
> +
>  /**
>   * kvm_inject_undefined - inject an undefined exception into the guest
>   * @vcpu: The VCPU to receive the undefined exception
> @@ -286,29 +305,13 @@ static u32 exc_vector_base(struct kvm_vcpu *vcpu)
>   */
>  void kvm_inject_undefined(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long new_lr_value;
> -	unsigned long new_spsr_value;
>  	unsigned long cpsr = *vcpu_cpsr(vcpu);
> -	u32 sctlr = vcpu->arch.cp15[c1_SCTLR];
>  	bool is_thumb = (cpsr & PSR_T_BIT);
>  	u32 vect_offset = 4;
>  	u32 return_offset = (is_thumb) ? 2 : 4;
>  
> -	new_spsr_value = cpsr;
> -	new_lr_value = *vcpu_pc(vcpu) - return_offset;
> -
> -	*vcpu_cpsr(vcpu) = (cpsr & ~MODE_MASK) | UND_MODE;
> -	*vcpu_cpsr(vcpu) |= PSR_I_BIT;
> -	*vcpu_cpsr(vcpu) &= ~(PSR_IT_MASK | PSR_J_BIT | PSR_E_BIT | PSR_T_BIT);
> -
> -	if (sctlr & SCTLR_TE)
> -		*vcpu_cpsr(vcpu) |= PSR_T_BIT;
> -	if (sctlr & SCTLR_EE)
> -		*vcpu_cpsr(vcpu) |= PSR_E_BIT;
> -
> -	/* Note: These now point to UND banked copies */
> -	*vcpu_spsr(vcpu) = cpsr;
> -	*vcpu_reg(vcpu, 14) = new_lr_value;
> +	kvm_update_psr(vcpu, UND_MODE);
> +	*vcpu_reg(vcpu, 14) = *vcpu_pc(vcpu) - return_offset;
>  
>  	/* Branch to exception vector */
>  	*vcpu_pc(vcpu) = exc_vector_base(vcpu) + vect_offset;
> @@ -320,30 +323,14 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
>   */
>  static void inject_abt(struct kvm_vcpu *vcpu, bool is_pabt, unsigned long addr)
>  {
> -	unsigned long new_lr_value;
> -	unsigned long new_spsr_value;
>  	unsigned long cpsr = *vcpu_cpsr(vcpu);
> -	u32 sctlr = vcpu->arch.cp15[c1_SCTLR];
>  	bool is_thumb = (cpsr & PSR_T_BIT);
>  	u32 vect_offset;
>  	u32 return_offset = (is_thumb) ? 4 : 0;
>  	bool is_lpae;
>  
> -	new_spsr_value = cpsr;
> -	new_lr_value = *vcpu_pc(vcpu) + return_offset;
> -
> -	*vcpu_cpsr(vcpu) = (cpsr & ~MODE_MASK) | ABT_MODE;
> -	*vcpu_cpsr(vcpu) |= PSR_I_BIT | PSR_A_BIT;

seems like you're losing the PSR_A_BIT in kvm_update_psr() now?

> -	*vcpu_cpsr(vcpu) &= ~(PSR_IT_MASK | PSR_J_BIT | PSR_E_BIT | PSR_T_BIT);
> -
> -	if (sctlr & SCTLR_TE)
> -		*vcpu_cpsr(vcpu) |= PSR_T_BIT;
> -	if (sctlr & SCTLR_EE)
> -		*vcpu_cpsr(vcpu) |= PSR_E_BIT;
> -
> -	/* Note: These now point to ABT banked copies */
> -	*vcpu_spsr(vcpu) = cpsr;
> -	*vcpu_reg(vcpu, 14) = new_lr_value;
> +	kvm_update_psr(vcpu, ABT_MODE);
> +	*vcpu_reg(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
>  
>  	if (is_pabt)
>  		vect_offset = 12;
> -- 
> 2.1.4
> 

Otherwise looks like a welcome cleanup!

Thanks,
-Christoffer
