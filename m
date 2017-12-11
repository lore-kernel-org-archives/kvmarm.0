From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: timer: Don't set irq as forwarded if no
 usable GIC
Date: Mon, 11 Dec 2017 10:17:19 +0100
Message-ID: <20171211091719.GD910@cbox>
References: <20171207114615.23950-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171207114615.23950-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 07, 2017 at 11:46:15AM +0000, Marc Zyngier wrote:
> If we don't have a usable GIC, do not try to set the vcpu affinity
> as this is guaranteed to fail.


Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
... and applied.

Thanks for fixing my broken code,
-Christoffer

> 
> Reported-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_arch_timer.h |  2 +-
>  virt/kvm/arm/arch_timer.c    | 13 ++++++++-----
>  virt/kvm/arm/arm.c           |  2 +-
>  3 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 01ee473517e2..5fa4fef257a4 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -62,7 +62,7 @@ struct arch_timer_cpu {
>  	bool			enabled;
>  };
>  
> -int kvm_timer_hyp_init(void);
> +int kvm_timer_hyp_init(bool);
>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4151250ce8da..4804b5608013 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -726,7 +726,7 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> -int kvm_timer_hyp_init(void)
> +int kvm_timer_hyp_init(bool has_gic)
>  {
>  	struct arch_timer_kvm_info *info;
>  	int err;
> @@ -762,10 +762,13 @@ int kvm_timer_hyp_init(void)
>  		return err;
>  	}
>  
> -	err = irq_set_vcpu_affinity(host_vtimer_irq, kvm_get_running_vcpus());
> -	if (err) {
> -		kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> -		goto out_free_irq;
> +	if (has_gic) {
> +		err = irq_set_vcpu_affinity(host_vtimer_irq,
> +					    kvm_get_running_vcpus());
> +		if (err) {
> +			kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> +			goto out_free_irq;
> +		}
>  	}
>  
>  	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index a67c106d73f5..d9df6d0731e6 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1323,7 +1323,7 @@ static int init_subsystems(void)
>  	/*
>  	 * Init HYP architected timer support
>  	 */
> -	err = kvm_timer_hyp_init();
> +	err = kvm_timer_hyp_init(vgic_present);
>  	if (err)
>  		goto out;
>  
> -- 
> 2.14.2
> 
