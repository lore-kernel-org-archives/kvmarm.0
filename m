From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 14/36] KVM: arm64: Remove noop calls to timer
 save/restore from VHE switch
Date: Mon, 11 Dec 2017 10:02:58 +0000
Message-ID: <76009e9a-0518-6b0c-c1f4-9fc5ce6a1138@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-15-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27D0849D6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 04:59:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aNFgjmUgAqM5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 04:59:36 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE50249D66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 04:59:35 -0500 (EST)
In-Reply-To: <20171207170630.592-15-christoffer.dall@linaro.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> The VHE switch function calls __timer_enable_traps and
> __timer_disable_traps which don't do anything on VHE systems.
> Therefore, simply remove these calls from the VHE switch function and
> make the functions non-conditional as they are now only called from the
> non-VHE switch path.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c |  2 --
>  virt/kvm/arm/hyp/timer-sr.c | 36 ++++++++++++++----------------------
>  2 files changed, 14 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index e783e2371b7c..09aafa0470f7 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -358,7 +358,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	__activate_vm(vcpu->kvm);
>  
>  	__vgic_restore_state(vcpu);
> -	__timer_enable_traps(vcpu);
>  
>  	/*
>  	 * We must restore the 32-bit state before the sysregs, thanks
> @@ -377,7 +376,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  
>  	__sysreg_save_guest_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
> -	__timer_disable_traps(vcpu);
>  	__vgic_save_state(vcpu);
>  
>  	__deactivate_traps(vcpu);
> diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
> index f24404b3c8df..752b37f9133c 100644
> --- a/virt/kvm/arm/hyp/timer-sr.c
> +++ b/virt/kvm/arm/hyp/timer-sr.c
> @@ -29,32 +29,24 @@ void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
>  
>  void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
>  {
> -	/*
> -	 * We don't need to do this for VHE since the host kernel runs in EL2
> -	 * with HCR_EL2.TGE ==1, which makes those bits have no impact.
> -	 */
> -	if (!has_vhe()) {
> -		u64 val;
> +	u64 val;
>  
> -		/* Allow physical timer/counter access for the host */
> -		val = read_sysreg(cnthctl_el2);
> -		val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> -		write_sysreg(val, cnthctl_el2);
> -	}
> +	/* Allow physical timer/counter access for the host */
> +	val = read_sysreg(cnthctl_el2);
> +	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> +	write_sysreg(val, cnthctl_el2);
>  }
>  
>  void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
>  {
> -	if (!has_vhe()) {
> -		u64 val;
> +	u64 val;
>  
> -		/*
> -		 * Disallow physical timer access for the guest
> -		 * Physical counter access is allowed
> -		 */
> -		val = read_sysreg(cnthctl_el2);
> -		val &= ~CNTHCTL_EL1PCEN;
> -		val |= CNTHCTL_EL1PCTEN;
> -		write_sysreg(val, cnthctl_el2);
> -	}
> +	/*
> +	 * Disallow physical timer access for the guest
> +	 * Physical counter access is allowed
> +	 */
> +	val = read_sysreg(cnthctl_el2);
> +	val &= ~CNTHCTL_EL1PCEN;
> +	val |= CNTHCTL_EL1PCTEN;
> +	write_sysreg(val, cnthctl_el2);
>  }
> 

Since we're not testing for !VHE anymore, can you add a small comment
saying that these two function are for the benefit of !VHE only and
shouldn't be called on VHE?

Otherwise,

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
