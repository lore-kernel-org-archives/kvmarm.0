From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 5/7] KVM: arm/arm64: vgic-v4: Only perform an unmap for
 valid vLPIs
Date: Mon, 20 Nov 2017 16:10:00 +0100
Message-ID: <20171120151000.GN28855@cbox>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
 <20171116175821.26544-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171116175821.26544-6-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 16, 2017 at 05:58:19PM +0000, Marc Zyngier wrote:
> Before performing an unmap, let's check that what we have was
> really mapped the first place.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-v4.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index 53c324aa44ef..4a37292855bc 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -337,8 +337,10 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
>  		goto out;
>  
>  	WARN_ON(!(irq->hw && irq->host_irq == virq));
> -	irq->hw = false;
> -	ret = its_unmap_vlpi(virq);
> +	if (irq->hw) {
> +		irq->hw = false;
> +		ret = its_unmap_vlpi(virq);
> +	}
>  
>  out:
>  	mutex_unlock(&its->its_lock);
> -- 
> 2.14.2
> 
