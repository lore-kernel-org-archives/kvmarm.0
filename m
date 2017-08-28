From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 51/59] KVM: arm/arm64: GICv4: Add doorbell interrupt
 handling
Date: Mon, 28 Aug 2017 20:18:55 +0200
Message-ID: <20170828181855.GM24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-52-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8B1F40D8B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P6XtBdMwGfs3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Aug 2017 14:16:50 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC0FF40D17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:49 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id b82so7878655wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 11:18:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-52-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:29PM +0100, Marc Zyngier wrote:
> When a vPE is not running, a VLPI being made pending results in a
> doorbell interrupt being delivered. Let's handle this interrupt
> and update the pending_last flag that indicates that VLPIs are
> pending. The corresponding vcpu is also kicked into action.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v4.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index 534d3051a078..6af3cde6d7d4 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -21,6 +21,19 @@
>  
>  #include "vgic.h"
>  
> +static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
> +{
> +	struct kvm_vcpu *vcpu = info;
> +
> +	if (!kvm_vgic_vcpu_pending_irq(vcpu)) {
> +		vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
> +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +		kvm_vcpu_kick(vcpu);
> +	}

Can this ever fire while vgic_v4_init() is running and before te rest of
the system has been properly initialized with some entertaining results
to follow?  (I'm not sure if spurious doorbell non-resident vPE
interrupts is a thing or not).

> +
> +	return IRQ_HANDLED;
> +}
> +
>  int vgic_v4_init(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> @@ -57,16 +70,37 @@ int vgic_v4_init(struct kvm *kvm)
>  		return ret;
>  	}
>  
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		int irq = dist->its_vm.vpes[i]->irq;
> +
> +		ret = request_irq(irq, vgic_v4_doorbell_handler,
> +				  0, "vcpu", vcpu);
> +		if (ret) {
> +			kvm_err("failed to allocate vcpu IRQ%d\n", irq);
> +			dist->its_vm.nr_vpes = i;

That's a neat trick for the error handling.  Might deserve a tiny
comment.

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
> +		free_irq(its_vm->vpes[i]->irq, vcpu);
> +	}
> +
>  	its_free_vcpu_irqs(its_vm);
>  	kfree(its_vm->vpes);
>  	its_vm->nr_vpes = 0;
> -- 
> 2.11.0
> 

Thanks,
-Christoffer
