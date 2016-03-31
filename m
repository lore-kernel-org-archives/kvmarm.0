From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 11/45] KVM: arm/arm64: vgic-new: Implement
 kvm_vgic_vcpu_pending_irq
Date: Thu, 31 Mar 2016 10:54:32 +0200
Message-ID: <20160331085432.GQ4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-12-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 306D1407A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 04:53:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U902boUWfcKX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2016 04:53:28 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07E3A40FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 04:53:27 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id 20so104222894wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 01:54:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458871508-17279-12-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:04:34AM +0000, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> Tell KVM whether a particular VCPU has an IRQ that needs handling
> in the guest. This is used to decide whether a VCPU is runnable.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h  |  2 ++
>  virt/kvm/arm/vgic/vgic.c | 22 ++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 986f23f..2ce9b4a 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -181,6 +181,8 @@ struct vgic_cpu {
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level);
>  
> +int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> +
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	(false)
>  #define vgic_ready(k)		((k)->arch.vgic.ready)
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 9eb031e8..d6c8c92 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -477,3 +477,25 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  	vgic_populate_lrs(vcpu);
>  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
>  }
> +
> +int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_irq *irq;
> +	bool pending = false;
> +
> +	spin_lock(&vgic_cpu->ap_list_lock);
> +
> +	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> +		spin_lock(&irq->irq_lock);
> +		pending = irq->pending && irq->enabled;
> +		spin_unlock(&irq->irq_lock);
> +
> +		if (pending)
> +			break;
> +	}
> +
> +	spin_unlock(&vgic_cpu->ap_list_lock);
> +
> +	return pending;
> +}

as long as we only call this in the wfi/wfe path, then it's fine.  If we
start calling this in the critical path, I think we should check the
common case of list_empty(&vgic_cpu->ap_list) first.


Thanks,
-Christoffer
