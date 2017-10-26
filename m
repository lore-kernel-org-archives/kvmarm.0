From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 19/26] KVM: arm/arm64: GICv4: Add doorbell interrupt
 handling
Date: Thu, 26 Oct 2017 16:28:10 +0200
Message-ID: <20171026142810.GA2166@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-20-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FA5C40638
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 10:26:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2wMNl6w6QqXV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Oct 2017 10:26:51 -0400 (EDT)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41A2D405F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 10:26:51 -0400 (EDT)
Received: by mail-wr0-f194.google.com with SMTP id y9so3365871wrb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 07:28:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-20-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:33:54PM +0100, Marc Zyngier wrote:
> When a vPE is not running, a VLPI being made pending results in a
> doorbell interrupt being delivered. Let's handle this interrupt
> and update the pending_last flag that indicates that VLPIs are
> pending. The corresponding vcpu is also kicked into action.
> 
> Special care is taken care of not allowing the doorbell to be
> enabled at request time (this is controlled separately), and
> to make the disabling on the interrupt non-lazy.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

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
