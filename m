From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 06/12] KVM: arm/arm64: vgic-v2: Only wipe LRs on vcpu
 exit
Date: Tue, 8 Mar 2016 19:09:53 -0800
Message-ID: <20160309030953.GB26583@lvm>
References: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
 <1457343214-19547-7-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457343214-19547-7-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 07, 2016 at 09:33:28AM +0000, Marc Zyngier wrote:
> So far, we're always writing all possible LRs, setting the empty
> ones with a zero value. This is obvious doing a lot of work for
> nothing, and we're better off clearing those we've actually
> dirtied on the exit path (it is very rare to inject more than one
> interrupt at a time anyway).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  virt/kvm/arm/hyp/vgic-v2-sr.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
> index 6d4dd78..674bdf8 100644
> --- a/virt/kvm/arm/hyp/vgic-v2-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
> @@ -99,6 +99,7 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
>  		}
>  
>  		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
> +		writel_relaxed(0, base + GICH_LR0 + (i * 4));
>  	}
>  }
>  
> @@ -156,12 +157,11 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
>  		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
>  		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
>  		for (i = 0; i < nr_lr; i++) {
> -			u32 val = 0;
> -
> -			if (live_lrs & (1UL << i))
> -				val = cpu_if->vgic_lr[i];
> +			if (!(live_lrs & (1UL << i)))
> +				continue;
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
