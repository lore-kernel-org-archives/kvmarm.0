From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 24/26] KVM: arm/arm64: GICv4: Prevent userspace from
 changing doorbell affinity
Date: Tue, 7 Nov 2017 23:17:51 +0100
Message-ID: <27d2f799-c2de-27a9-8e92-21bbdd583307@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-25-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-25-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/10/2017 16:28, Marc Zyngier wrote:
> We so far allocate the doorbell interrupts without taking any
> special measure regarding the affinity of these interrupts. We
> simply move them around as required when the vcpu gets scheduled
> on a different CPU.
> 
> But that's counting without userspace (and the evil irqbalance) that
> can try and move the VPE interrupt around, causing the ITS code
> to emit VMOVP commands and remap the doorbell to another redistributor.
> Worse, this can happen while the vcpu is running, causing all kind
> of trouble if the VPE is already resident, and we end-up in UNPRED
> territory.
> 
> So let's take a definitive action and prevent userspace from messing
> with us. This is just a matter of adding IRQ_NO_BALANCING to the
> set of flags we already have, letting the kernel in sole control
> of the affinity.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  virt/kvm/arm/vgic/vgic-v4.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index d7fe610bb1f5..d10e18eabd3b 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -23,6 +23,8 @@
>  
>  #include "vgic.h"
>  
> +#define DB_IRQ_FLAGS	(IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY | IRQ_NO_BALANCING)
> +
>  static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
>  {
>  	struct kvm_vcpu *vcpu = info;
> @@ -83,7 +85,7 @@ int vgic_v4_init(struct kvm *kvm)
>  		 * doorbell could kick us out of the guest too
>  		 * early...
>  		 */
> -		irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
> +		irq_set_status_flags(irq, DB_IRQ_FLAGS);
>  		ret = request_irq(irq, vgic_v4_doorbell_handler,
>  				  0, "vcpu", vcpu);
>  		if (ret) {
> @@ -121,7 +123,7 @@ void vgic_v4_teardown(struct kvm *kvm)
>  		struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
>  		int irq = its_vm->vpes[i]->irq;
>  
> -		irq_clear_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
> +		irq_clear_status_flags(irq, DB_IRQ_FLAGS);
>  		free_irq(irq, vcpu);
>  	}
>  
> 
