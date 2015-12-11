From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Fix kvm_vgic_map_is_active's dist
 check
Date: Fri, 11 Dec 2015 09:16:47 +0000
Message-ID: <566A947F.8090804@arm.com>
References: <1449784010-21761-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449784010-21761-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/12/15 21:46, Christoffer Dall wrote:
> External inputs to the vgic from time to time need to poke into the
> state of a virtual interrupt, the prime example is the architected timer
> code.
> 
> Since the IRQ's active state can be represented in two places; the LR or
> the distributor, we first loop over the LRs but if not active in the LRs
> we just return if *any* IRQ is active on the VCPU in question.
> 
> This is of course bogus, as we should check if the specific IRQ in
> quesiton is active on the distributor instead.
> 
> Reported-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 65461f8..7a2f449 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1114,7 +1114,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
>  			return true;
>  	}
>  
> -	return dist_active_irq(vcpu);
> +	return vgic_irq_is_active(vcpu, map->virt_irq);
>  }
>  
>  /*
> 

Damn!

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
