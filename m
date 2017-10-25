From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 12/26] KVM: arm/arm64: GICv4: Propagate affinity
 changes to the physical ITS
Date: Wed, 25 Oct 2017 18:22:12 +0200
Message-ID: <20171025162212.GM91785@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69A54406D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 12:20:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UV8WVdySaczU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Oct 2017 12:20:56 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C1EF406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 12:20:56 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id r68so3052378wmr.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 09:22:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-13-marc.zyngier@arm.com>
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

On Fri, Oct 06, 2017 at 04:33:47PM +0100, Marc Zyngier wrote:
> When the guest issues an affinity change, we need to tell the physical
> ITS that we're now targetting a new vcpu.  This is done by extracting
> the current mapping, updating the target, and reapplying the mapping.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index c9b1c0967426..42ffb9084bb7 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -337,11 +337,25 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
>  
>  static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
>  {
> +	int ret = 0;
> +
>  	spin_lock(&irq->irq_lock);
>  	irq->target_vcpu = vcpu;
>  	spin_unlock(&irq->irq_lock);
>  
> -	return 0;
> +	if (irq->hw) {
> +		struct its_vlpi_map map;
> +
> +		ret = its_get_vlpi(irq->host_irq, &map);
> +		if (ret)
> +			return ret;
> +
> +		map.vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
> +
> +		ret = its_map_vlpi(irq->host_irq, &map);
> +	}
> +
> +	return ret;
>  }
>  
>  /*
> -- 
> 2.14.1
> 
