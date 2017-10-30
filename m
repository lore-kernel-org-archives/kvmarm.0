From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 24/26] KVM: arm/arm64: GICv4: Prevent userspace from
 changing doorbell affinity
Date: Mon, 30 Oct 2017 07:51:39 +0100
Message-ID: <20171030065139.GP2166@lvm>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-25-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AF9249D19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 02:50:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id liQCp7lHbN2e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Oct 2017 02:50:17 -0400 (EDT)
Received: from mail-lf0-f66.google.com (mail-lf0-f66.google.com
 [209.85.215.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 411E9406BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 02:50:17 -0400 (EDT)
Received: by mail-lf0-f66.google.com with SMTP id e143so1560361lfg.12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 23:51:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171027142855.21584-25-marc.zyngier@arm.com>
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
Cc: linux-kernel@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 03:28:53PM +0100, Marc Zyngier wrote:
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

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
> -- 
> 2.11.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
