From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 44/59] KVM: arm/arm64: GICv4: Handle MOVI applied to a
 VLPI
Date: Mon, 28 Aug 2017 20:18:17 +0200
Message-ID: <20170828181817.GE24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-45-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3202A40D17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uT6ccULk75Ai for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Aug 2017 14:16:12 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DFEF49C34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:12 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id u26so8598595wma.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 11:18:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-45-marc.zyngier@arm.com>
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

On Mon, Jul 31, 2017 at 06:26:22PM +0100, Marc Zyngier wrote:
> When the guest issues a MOVI, we need to tell the physical ITS
> that we're now targetting a new vcpu. This is done by extracting
> the current mapping, updating the target, and reapplying the
> mapping. The core ITS code should do the right thing.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 79bac93d3e7d..aaad577ce328 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -706,6 +706,19 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>  	ite->irq->target_vcpu = vcpu;
>  	spin_unlock(&ite->irq->irq_lock);
>  
> +	if (ite->irq->hw) {
> +		struct its_vlpi_map map;
> +		int ret;
> +
> +		ret = its_get_vlpi(ite->irq->host_irq, &map);
> +		if (ret)
> +			return ret;
> +
> +		map.vpe_idx = vcpu->vcpu_id;
> +
> +		return its_map_vlpi(ite->irq->host_irq, &map);

Since you're not holding the irq_lock across these two calls, would it
be possible that the forwarding was removed through some other call path
here, and could you end up passing an invalid host_irq to its_map_vlpi?

Thanks,
-Christoffer

> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.11.0
> 
