From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 11/17] arm64: KVM: vgic-v2: Only wipe LRs on vcpu exit
Date: Fri, 4 Mar 2016 12:36:20 +0100
Message-ID: <20160304113620.GA24725@cbox>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-12-git-send-email-marc.zyngier@arm.com>
 <20160302230819.GE9634@cbox> <56D85F10.1030602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EDF54130B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2016 06:29:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sKEiRkLmuogT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Mar 2016 06:29:02 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B81A8412ED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2016 06:29:02 -0500 (EST)
Received: by mail-wm0-f42.google.com with SMTP id p65so25928969wmp.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Mar 2016 03:36:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <56D85F10.1030602@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 03, 2016 at 03:58:08PM +0000, Marc Zyngier wrote:
> On 02/03/16 23:08, Christoffer Dall wrote:
> > On Wed, Feb 17, 2016 at 04:40:43PM +0000, Marc Zyngier wrote:
> >> So far, we're always writing all possible LRs, setting the empty
> >> ones with a zero value. This is obvious doing a low of work for
> > 
> > s/low/lot/
> > 
> >> nothing, and we're better off clearing those we've actually
> >> dirtied on the exit path (it is very rare to inject more than one
> >> interrupt at a time anyway).
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/kvm/hyp/vgic-v2-sr.c | 10 +++++-----
> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> >> index 3dbbc6b..e53f131 100644
> >> --- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
> >> +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> >> @@ -101,6 +101,7 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
> >>  		}
> >>  
> >>  		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
> >> +		writel_relaxed(0, base + GICH_LR0 + (i * 4));
> >>  	}
> >>  }
> >>  
> >> @@ -158,12 +159,11 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
> >>  		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
> >>  		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
> >>  		for (i = 0; i < nr_lr; i++) {
> >> -			u32 val = 0;
> >> -
> >> -			if (live_lrs & (1UL << i))
> >> -				val = cpu_if->vgic_lr[i];
> >> +			if (!(live_lrs & (1UL << i)))
> >> +				continue;
> > 
> > how can we be sure that the LRs are clear when we launch our first VM on
> > a given physical CPU?  Don't we need to flush the LRs during VGIC init
> > time?
> > 
> >>  
> >> -			writel_relaxed(val, base + GICH_LR0 + (i * 4));
> >> +			writel_relaxed(cpu_if->vgic_lr[i],
> >> +				       base + GICH_LR0 + (i * 4));
> >>  		}
> >>  	}
> >>  
> >> -- 
> >> 2.1.4
> >>
> > 
> > otherwie LGTM.
> 
> So how about this, just before this patch (I'll obviously do something similar for GICv3):
> 
> From d9a80c4c406450190a68abee302c7d9a0034c62a Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <marc.zyngier@arm.com>
> Date: Thu, 3 Mar 2016 15:43:58 +0000
> Subject: [PATCH] KVM: arm/arm64: vgic-v2: Reset LRs at boot time
> 
> In order to let make the GICv2 code more lazy in the way it
> accesses the LRs, it is necessary to start with a clean slate.

The first sentence need some love I think :)

> 
> Let's reset the LRs on each CPU when the vgic is probed.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic-v2.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
> index ff02f08..67ec334 100644
> --- a/virt/kvm/arm/vgic-v2.c
> +++ b/virt/kvm/arm/vgic-v2.c
> @@ -176,6 +176,15 @@ static const struct vgic_ops vgic_v2_ops = {
>  
>  static struct vgic_params vgic_v2_params;
>  
> +static void vgic_cpu_init_lrs(void *params)
> +{
> +	struct vgic_params *vgic = params;
> +	int i;
> +
> +	for (i = 0; i < vgic->nr_lr; i++)
> +		writel_relaxed(0, vgic->vctrl_base + GICH_LR0 + (i * 4));
> +}
> +
>  /**
>   * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
>   * @node:	pointer to the DT node
> @@ -257,6 +266,9 @@ int vgic_v2_probe(struct device_node *vgic_node,
>  
>  	vgic->type = VGIC_V2;
>  	vgic->max_gic_vcpus = VGIC_V2_MAX_CPUS;
> +
> +	on_each_cpu(vgic_cpu_init_lrs, vgic, 1);
> +
>  	*ops = &vgic_v2_ops;
>  	*params = vgic;
>  	goto out;
> 
> 
> Thanks,
> 
> 	M.

This looks good to me.  Only concern is that we're now accessing the
control interface from EL1 for the first time (I think), but that should
work just fine though.

-Christoffer
