From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 52/59] KVM: arm/arm64: GICv4: Use the doorbell
 interrupt as an unblocking source
Date: Mon, 28 Aug 2017 20:19:02 +0200
Message-ID: <20170828181902.GN24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-53-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-53-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:30PM +0100, Marc Zyngier wrote:
> The doorbell interrupt is only useful if the vcpu is blocked on WFI.
> In all other cases, recieving a doorbell interrupt is just a waste
> of cycles.
> 
> So let's only enable the doorbell if a vcpu is getting blocked,
> and disable it when it is unblocked. This is very similar to
> what we're doing for the background timer.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_vgic.h      |  3 +++
>  virt/kvm/arm/arm.c          |  2 ++
>  virt/kvm/arm/vgic/vgic-v4.c | 32 +++++++++++++++++++++++++++++++-
>  3 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 050f78d4fb42..7b1cc7ff5b42 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -375,4 +375,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
>  int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>  				 struct kvm_kernel_irq_routing_entry *irq_entry);
>  
> +void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
> +void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
> +
>  #endif /* __KVM_ARM_VGIC_H */
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 6803ea27c47d..5dbc8dc8fbf4 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -316,11 +316,13 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>  {
>  	kvm_timer_schedule(vcpu);
> +	kvm_vgic_v4_enable_doorbell(vcpu);
>  }
>  
>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  {
>  	kvm_timer_unschedule(vcpu);
> +	kvm_vgic_v4_disable_doorbell(vcpu);
>  }
>  
>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index 6af3cde6d7d4..50721c4e3da5 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -16,6 +16,7 @@
>   */
>  
>  #include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/irqdomain.h>
>  #include <linux/kvm_host.h>
>  
> @@ -73,6 +74,14 @@ int vgic_v4_init(struct kvm *kvm)
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		int irq = dist->its_vm.vpes[i]->irq;
>  
> +		/*
> +		 * Don't automatically enable the doorbell, as we're
> +		 * flipping it back and forth when the vcpu gets
> +		 * blocked. Also disable the lazy disabling, as the
> +		 * doorbell could kick us out of the guest too
> +		 * early...
> +		 */
> +		irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
>  		ret = request_irq(irq, vgic_v4_doorbell_handler,
>  				  0, "vcpu", vcpu);
>  		if (ret) {
> @@ -98,7 +107,10 @@ void vgic_v4_teardown(struct kvm *kvm)
>  
>  	for (i = 0; i < its_vm->nr_vpes; i++) {
>  		struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
> -		free_irq(its_vm->vpes[i]->irq, vcpu);
> +		int irq = its_vm->vpes[i]->irq;
> +
> +		irq_clear_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
> +		free_irq(irq, vcpu);
>  	}
>  
>  	its_free_vcpu_irqs(its_vm);
> @@ -211,3 +223,21 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
>  	mutex_unlock(&its->its_lock);
>  	return ret;
>  }
> +
> +void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu)
> +{
> +	if (vgic_is_v4_capable(vcpu->kvm)) {
> +		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> +		if (irq)
> +			enable_irq(irq);
> +	}
> +}
> +
> +void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu)
> +{
> +	if (vgic_is_v4_capable(vcpu->kvm)) {
> +		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> +		if (irq)
> +			disable_irq(irq);
> +	}
> +}
> -- 
> 2.11.0
> 
Reviewed-by: Christoffer Dall <cdall@linaro.org>
