From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 19/26] KVM: arm/arm64: GICv4: Add doorbell interrupt
 handling
Date: Thu, 26 Oct 2017 17:25:25 +0200
Message-ID: <20171026152525.GC2166@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-20-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-20-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:33:54PM +0100, Marc Zyngier wrote:
> When a vPE is not running, a VLPI being made pending results in a
> doorbell interrupt being delivered. Let's handle this interrupt
> and update the pending_last flag that indicates that VLPIs are
> pending. The corresponding vcpu is also kicked into action.
> 
> Special care is taken care of not allowing the doorbell to be
> enabled at request time (this is controlled separately), and

super nit: this first sentence is pretty hard to understand...

> to make the disabling on the interrupt non-lazy.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v4.c | 48 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index b79a0450bb1c..2c250ee37878 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -16,11 +16,23 @@
>   */
>  
>  #include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/irqdomain.h>
>  #include <linux/kvm_host.h>
>  
>  #include "vgic.h"
>  
> +static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
> +{
> +	struct kvm_vcpu *vcpu = info;
> +
> +	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +	kvm_vcpu_kick(vcpu);
> +
> +	return IRQ_HANDLED;
> +}
> +
>  /**
>   * vgic_v4_init - Initialize the GICv4 data structures
>   * @kvm:	Pointer to the VM being initialized
> @@ -60,6 +72,33 @@ int vgic_v4_init(struct kvm *kvm)
>  		return ret;
>  	}
>  
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		int irq = dist->its_vm.vpes[i]->irq;
> +
> +		/*
> +		 * Don't automatically enable the doorbell, as we're
> +		 * flipping it back and forth when the vcpu gets
> +		 * blocked. Also disable the lazy disabling, as the
> +		 * doorbell could kick us out of the guest too
> +		 * early...
> +		 */
> +		irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
> +		ret = request_irq(irq, vgic_v4_doorbell_handler,
> +				  0, "vcpu", vcpu);
> +		if (ret) {
> +			kvm_err("failed to allocate vcpu IRQ%d\n", irq);
> +			/*
> +			 * Trick: adjust the number of vpes so we know
> +			 * how many to nuke on teardown...
> +			 */
> +			dist->its_vm.nr_vpes = i;
> +			break;
> +		}
> +	}
> +
> +	if (ret)
> +		vgic_v4_teardown(kvm);
> +
>  	return ret;
>  }
>  
> @@ -72,10 +111,19 @@ int vgic_v4_init(struct kvm *kvm)
>  void vgic_v4_teardown(struct kvm *kvm)
>  {
>  	struct its_vm *its_vm = &kvm->arch.vgic.its_vm;
> +	int i;
>  
>  	if (!its_vm->vpes)
>  		return;
>  
> +	for (i = 0; i < its_vm->nr_vpes; i++) {
> +		struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
> +		int irq = its_vm->vpes[i]->irq;
> +
> +		irq_clear_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
> +		free_irq(irq, vcpu);
> +	}
> +
>  	its_free_vcpu_irqs(its_vm);
>  	kfree(its_vm->vpes);
>  	its_vm->nr_vpes = 0;
> -- 
> 2.14.1
> 
