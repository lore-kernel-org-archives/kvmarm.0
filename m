From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 5/9] arm/arm64: KVM: Use appropriate define in VGIC reset
 code
Date: Fri, 4 Sep 2015 18:08:30 +0200
Message-ID: <55E9C1FE.6030809@linaro.org>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
 <1440942866-23802-6-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-6-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/30/2015 03:54 PM, Christoffer Dall wrote:
> We currently initialize the SGIs to be enabled in the VGIC code, but we
> use the VGIC_NR_PPIS define for this purpose, instead of the the more
s/the//

Eric
> natural VGIC_NR_SGIS.  Change this slightly confusing use of the
> defines.
> 
> Note: This should have no functional change, as both names are defined
> to the number 16.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 0ba92d3..8299c24 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -2099,7 +2099,7 @@ int vgic_init(struct kvm *kvm)
>  		}
>  
>  		for (i = 0; i < dist->nr_irqs; i++) {
> -			if (i < VGIC_NR_PPIS)
> +			if (i < VGIC_NR_SGIS)
>  				vgic_bitmap_set_irq_val(&dist->irq_enabled,
>  							vcpu->vcpu_id, i, 1);
>  			if (i < VGIC_NR_PRIVATE_IRQS)
> 

