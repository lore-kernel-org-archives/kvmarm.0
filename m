From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] Fix NULL pointer dereferences if KVM is used without
 in-kernel irqchip
Date: Thu, 9 Jul 2015 13:11:13 +0200
Message-ID: <20150709111113.GI13530@cbox>
References: <cover.1436264839.git.p.fedin@samsung.com>
 <46c62639f325ef935c4ca24c5fc9d5eb2b4a0979.1436264839.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D11D05831F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 06:59:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aSlpKEOh-CJe for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 06:59:33 -0400 (EDT)
Received: from mail-lb0-f169.google.com (mail-lb0-f169.google.com
 [209.85.217.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54C3658319
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 06:59:33 -0400 (EDT)
Received: by lblf12 with SMTP id f12so3459031lbl.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 04:11:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <46c62639f325ef935c4ca24c5fc9d5eb2b4a0979.1436264839.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, KVM-ARM mailing list <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 07, 2015 at 01:38:48PM +0300, Pavel Fedin wrote:
> Makes qemu working again with kernel-irqchip=off option
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  virt/kvm/arm/vgic.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 78fb820..3420657 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -100,6 +100,9 @@ static bool queue_sgi(struct kvm_vcpu *vcpu, int irq)
>  
>  int kvm_vgic_map_resources(struct kvm *kvm)
>  {
> +	if (!kvm->arch.vgic.vm_ops.map_resources)
> +		return 0;
> +
>  	return kvm->arch.vgic.vm_ops.map_resources(kvm, vgic);
>  }
>  
> @@ -1637,7 +1640,7 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
>   */
>  int kvm_vgic_get_max_vcpus(void)
>  {
> -	return vgic->max_gic_vcpus;
> +	return vgic ? vgic->max_gic_vcpus : KVM_MAX_VCPUS;
>  }
>  
>  void kvm_vgic_destroy(struct kvm *kvm)
> -- 
> 2.4.4
> 

This feels like defensive programming and it's a bit weird to return
something from kvm_vgic_get_max_vcpus when there is no vgic...

I would probably guard the callers with irqchip_in_kernel instead.

-Christoffer
