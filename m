From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/7] KVM: arm/arm64: remove unneeded map parameter for
 vgic_update_irq_pending()
Date: Thu, 21 Apr 2016 19:08:29 +0200
Message-ID: <5719090D.8010408@linaro.org>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
 <1460729047-6346-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82DF049B3F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 13:07:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rNEGY3Q7VVVi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2016 13:07:43 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CE5449B37
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 13:07:43 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id v188so253200620wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 10:09:46 -0700 (PDT)
In-Reply-To: <1460729047-6346-2-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Eric Auger <eric.auger@linaro.org>

Eric
On 04/15/2016 04:04 PM, Andre Przywara wrote:
> We actually don't use the irq_phys_map parameter in
> vgic_update_irq_pending(), so let's just remove it.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 00429b3..7282881 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1522,7 +1522,6 @@ static int vgic_validate_injection(struct kvm_vcpu *vcpu, int irq, int level)
>  }
>  
>  static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
> -				   struct irq_phys_map *map,
>  				   unsigned int irq_num, bool level)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> @@ -1661,7 +1660,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>  	if (map)
>  		return -EINVAL;
>  
> -	return vgic_update_irq_pending(kvm, cpuid, NULL, irq_num, level);
> +	return vgic_update_irq_pending(kvm, cpuid, irq_num, level);
>  }
>  
>  /**
> @@ -1687,7 +1686,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
>  	if (ret)
>  		return ret;
>  
> -	return vgic_update_irq_pending(kvm, cpuid, map, map->virt_irq, level);
> +	return vgic_update_irq_pending(kvm, cpuid, map->virt_irq, level);
>  }
>  
>  static irqreturn_t vgic_maintenance_handler(int irq, void *data)
> 
