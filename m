From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 11/17] arm64: KVM: vgic-v2: Only wipe LRs on vcpu exit
Date: Thu, 3 Mar 2016 00:08:19 +0100
Message-ID: <20160302230819.GE9634@cbox>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-12-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455727249-24752-12-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 04:40:43PM +0000, Marc Zyngier wrote:
> So far, we're always writing all possible LRs, setting the empty
> ones with a zero value. This is obvious doing a low of work for

s/low/lot/

> nothing, and we're better off clearing those we've actually
> dirtied on the exit path (it is very rare to inject more than one
> interrupt at a time anyway).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/vgic-v2-sr.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> index 3dbbc6b..e53f131 100644
> --- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> @@ -101,6 +101,7 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
>  		}
>  
>  		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
> +		writel_relaxed(0, base + GICH_LR0 + (i * 4));
>  	}
>  }
>  
> @@ -158,12 +159,11 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
>  		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
>  		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
>  		for (i = 0; i < nr_lr; i++) {
> -			u32 val = 0;
> -
> -			if (live_lrs & (1UL << i))
> -				val = cpu_if->vgic_lr[i];
> +			if (!(live_lrs & (1UL << i)))
> +				continue;

how can we be sure that the LRs are clear when we launch our first VM on
a given physical CPU?  Don't we need to flush the LRs during VGIC init
time?

>  
> -			writel_relaxed(val, base + GICH_LR0 + (i * 4));
> +			writel_relaxed(cpu_if->vgic_lr[i],
> +				       base + GICH_LR0 + (i * 4));
>  		}
>  	}
>  
> -- 
> 2.1.4
> 

otherwie LGTM.

Thanks,
-Christoffer
