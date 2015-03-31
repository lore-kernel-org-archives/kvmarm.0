From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 01/25] arm: Use bool function return values of true/false
 not 1/0
Date: Tue, 31 Mar 2015 08:54:26 -0700
Message-ID: <20150331155426.GP10805@atomide.com>
References: <cover.1427759009.git.joe@perches.com>
 <912ed0ebae3c6a16f58b1452d5ce9226681bc8df.1427759009.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <912ed0ebae3c6a16f58b1452d5ce9226681bc8df.1427759009.git.joe@perches.com>
Sender: kvm-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-omap@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

* Joe Perches <joe@perches.com> [150330 16:47]:
> Use the normal return values for bool functions
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/include/asm/dma-mapping.h |  8 ++++----
>  arch/arm/include/asm/kvm_emulate.h |  2 +-
>  arch/arm/mach-omap2/powerdomain.c  | 14 +++++++-------
>  3 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index b52101d..166e1e1 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -151,18 +151,18 @@ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
>  	u64 limit, mask;
>  
>  	if (!dev->dma_mask)
> -		return 0;
> +		return false;
>  
>  	mask = *dev->dma_mask;
>  
>  	limit = (mask + 1) & ~mask;
>  	if (limit && size > limit)
> -		return 0;
> +		return false;
>  
>  	if ((addr | (addr + size - 1)) & ~mask)
> -		return 0;
> +		return false;
>  
> -	return 1;
> +	return true;
>  }
>  
>  static inline void dma_mark_clean(void *addr, size_t size) { }
> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> index a9c80a2..ad200a0 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -51,7 +51,7 @@ static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
>  
>  static inline bool vcpu_mode_is_32bit(struct kvm_vcpu *vcpu)
>  {
> -	return 1;
> +	return true;
>  }
>  
>  static inline unsigned long *vcpu_pc(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
> index 78af6d8..897f9fb 100644
> --- a/arch/arm/mach-omap2/powerdomain.c
> +++ b/arch/arm/mach-omap2/powerdomain.c
> @@ -950,7 +950,7 @@ int pwrdm_disable_hdwr_sar(struct powerdomain *pwrdm)
>   */
>  bool pwrdm_has_hdwr_sar(struct powerdomain *pwrdm)
>  {
> -	return (pwrdm && pwrdm->flags & PWRDM_HAS_HDWR_SAR) ? 1 : 0;
> +	return pwrdm && (pwrdm->flags & PWRDM_HAS_HDWR_SAR);
>  }
>  
>  int pwrdm_state_switch_nolock(struct powerdomain *pwrdm)
> @@ -1185,24 +1185,24 @@ bool pwrdm_can_ever_lose_context(struct powerdomain *pwrdm)
>  	if (!pwrdm) {
>  		pr_debug("powerdomain: %s: invalid powerdomain pointer\n",
>  			 __func__);
> -		return 1;
> +		return true;
>  	}
>  
>  	if (pwrdm->pwrsts & PWRSTS_OFF)
> -		return 1;
> +		return true;
>  
>  	if (pwrdm->pwrsts & PWRSTS_RET) {
>  		if (pwrdm->pwrsts_logic_ret & PWRSTS_OFF)
> -			return 1;
> +			return true;
>  
>  		for (i = 0; i < pwrdm->banks; i++)
>  			if (pwrdm->pwrsts_mem_ret[i] & PWRSTS_OFF)
> -				return 1;
> +				return true;
>  	}
>  
>  	for (i = 0; i < pwrdm->banks; i++)
>  		if (pwrdm->pwrsts_mem_on[i] & PWRSTS_OFF)
> -			return 1;
> +			return true;
>  
> -	return 0;
> +	return false;
>  }
> -- 
> 2.1.2
> 
