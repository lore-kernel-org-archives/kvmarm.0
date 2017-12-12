From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 8/8] KVM: arm/arm64: Avoid work when userspace iqchips
 are not used
Date: Tue, 12 Dec 2017 10:24:11 +0100
Message-ID: <c3eeaae7-89b3-171d-7d69-c893034f0252@redhat.com>
References: <20171207105418.22428-1-christoffer.dall@linaro.org>
 <20171207105418.22428-9-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207105418.22428-9-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 07/12/17 11:54, Christoffer Dall wrote:
> We currently check if the VM has a userspace irqchip on every exit from
> the VCPU, and if so, we do some work to ensure correct timer behavior.
> This is unfortunate, as we could avoid doing any work entirely, if we
> didn't have to support irqchip in userspace.
> 
> Realizing the userspace irqchip on ARM is mostly a developer or hobby
> feature, and is unlikely to be used in servers or other scenarios where
> performance is a priority, we can use a refcounted static key to only
> check the irqchip configuration when we have at least one VM that uses
> an irqchip in userspace.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/arch_timer.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 82d4963f63b8..df21451e7654 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -51,6 +51,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>  				 struct arch_timer_context *timer_ctx);
>  static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
>  
> +static DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> +
>  u64 kvm_phys_timer_read(void)
>  {
>  	return timecounter->cc->read(timecounter->cc);
> @@ -569,7 +571,8 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
>   */
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
> -	unmask_vtimer_irq_user(vcpu);
> +	if (static_branch_unlikely(&userspace_irqchip_in_use))
> +		unmask_vtimer_irq_user(vcpu);
>  }
>  
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
> @@ -774,6 +777,8 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
>  	soft_timer_cancel(&timer->bg_timer, &timer->expired);
>  	soft_timer_cancel(&timer->phys_timer, NULL);
>  	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
> +	if (timer->enabled && !irqchip_in_kernel(vcpu->kvm))
> +		static_branch_dec(&userspace_irqchip_in_use);
>  }
>  
>  static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
> @@ -826,8 +831,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  		return 0;
>  
>  	/* Without a VGIC we do not map virtual IRQs to physical IRQs */
> -	if (!irqchip_in_kernel(vcpu->kvm))
> +	if (!irqchip_in_kernel(vcpu->kvm)) {
> +		static_branch_inc(&userspace_irqchip_in_use);
>  		goto no_vgic;
> +	}
>  
>  	if (!vgic_initialized(vcpu->kvm))
>  		return -ENODEV;
> 
